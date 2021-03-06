#include <altera_avalon_sgdma.h>
#include <altera_avalon_sgdma_descriptor.h>
#include <altera_avalon_sgdma_regs.h>

#include "sys/alt_stdio.h"
#include "sys/alt_irq.h"
#include "system.h"
#include <unistd.h>
#include <string.h>

// Function Prototypes
void rx_ethernet_isr (void *context);
void mic_filter_isr (void *context);
void fill_ipv4_checksum (unsigned char *header_start, int header_len);
// word_len is the number of words, and the copy is done using alt_u32 *.
void volatile_memcpy (volatile void *dst, volatile void *src, int word_len);

// Global Variables
unsigned int text_length;
volatile unsigned long mic_isr_cnt = 0;  // counter for number of mic filter isrs fired
#define MIC_NUM 2  // number of mics
volatile alt_u32 *ram_block = (alt_u32 *) 0x00101800;  // RAM_block base address
const unsigned int ram_block_size = 512;  // 512 * u32 (4 bytes) = 2048 bytes

#define CHUNK_SAMPLE 10  // Number of sample points per chunk.
// Num of bytes for CHUNK_SAMPLE sample points. one mic sample is 16 bits.
#define DATA_CHUNK_SIZE  (MIC_NUM*2 * CHUNK_SAMPLE)
// We set the data buffer size to be twice the data chunk size. The reason is explained in
// the main function.
#define DATA_BUFFER_SIZE (2 * DATA_CHUNK_SIZE)
volatile unsigned char data_buffer[DATA_BUFFER_SIZE];

// Math summary for the numbers: One sample point of 1 mic has 16 bits of data; one sample
// point of MIC_NUM mics has (16*MIC_NUM) bits of data, which is (MIC_NUM*2) bytes and
// (MIC_NUM/2) 32-bit words. All the memory pointers are u32 pointers so address is count
// in 32-bit words. One data chunk has CHUNK_SAMPLE sample points of MIC_NUM mics, which
// is (MIC_NUM*2 * CHUNK_SAMPLE) 32-bit words. The length of the data buffer is twice the
// length of a data chunk. Only one data chunk is copied to tx_frame and send using
// Ethernet at a time.

// Create a transmit frame
#define ETH_MAX_FRAME_LEN   1518    // IP MTU: 1500; Ethernet frame overhead: 18
unsigned char tx_frame[ETH_MAX_FRAME_LEN] = {    
    0x00,0x00,                      // for 32-bit alignment
    0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,  // destination address (broadcast)
    0x01,0x60,0x6E,0x11,0x02,0x0F,  // source address
    0x08,0x00,                      // payload type: IPv4
    0x45,0x00,0x00,0x00,            // Start of IPv4 header (total length not filled)
    0x12,0x34,                      // Identification label
    0x00,0x00,                      // Fragment bits not set
    0x80,0x11,                      // TTL: 128; IP payload type: UDP
    0x00,0x00,                      // Header checksum (to be filled in main())
    192,168,137,10,                 // Source IP address: 10.0.0.1
    //0xFF,0xFF,0xFF,0xFF,            // Dest IP address: 255.255.255.255 (local
    //broadcast)
    192,168,137,1,                  // Hard-coded computer IP
    0x10,0x00,0x20,0x00,            // UDP header, source port: 4096; dest port: 8192
    0x00,0x00,0x00,0x00             // Length to be filled in main(), no checksum
};

// The lengths and offsets are all expressed in bytes.
#define ETH_HEADER_LEN  16  // Length of Ethernet header
#define IP_HEADER_LEN   20  // Length of IPv4 header
#define UDP_HEADER_LEN  8   // Length of UDP header
#define HEADER_LEN      (ETH_HEADER_LEN + IP_HEADER_LEN + UDP_HEADER_LEN)
#define IP_LEN_OFFSET   2   // Offset for IPv4 *total* length field (including header)
#define UDP_LEN_OFFSET  4   // Offset for UDP *total* length field (including header)

// Create a receive frame
unsigned char rx_frame[ETH_MAX_FRAME_LEN] = { 0 };

// Create sgdma transmit and receive devices
alt_sgdma_dev * sgdma_tx_dev;
alt_sgdma_dev * sgdma_rx_dev;

// Allocate descriptors in the descriptor_memory (onchip memory)
alt_sgdma_descriptor tx_descriptor      __attribute__ (( section ( ".descriptor_memory" )));
alt_sgdma_descriptor tx_descriptor_end  __attribute__ (( section ( ".descriptor_memory" )));

alt_sgdma_descriptor rx_descriptor      __attribute__ (( section ( ".descriptor_memory" )));
alt_sgdma_descriptor rx_descriptor_end  __attribute__ (( section ( ".descriptor_memory" )));


/********************************************************************************
 * This program demonstrates use of the Ethernet in the DE2-115 board.
 *
 * It performs the following: 
 *  1. Records input text and transmits the text via Ethernet after Enter is 
 *     pressed
 *  2. Displays text received via Ethernet frame on the JTAG UART
********************************************************************************/
int main(void)
{
    // Open the sgdma transmit device
    sgdma_tx_dev = alt_avalon_sgdma_open ("/dev/sgdma_tx");
    if (sgdma_tx_dev == NULL) {
        alt_printf ("Error: could not open scatter-gather dma transmit device\n");
        return -1;
    } else alt_printf ("Opened scatter-gather dma transmit device\n");
        
    // Open the sgdma receive device
    sgdma_rx_dev = alt_avalon_sgdma_open ("/dev/sgdma_rx");
    if (sgdma_rx_dev == NULL) {
        alt_printf ("Error: could not open scatter-gather dma receive device\n");
        return -1;
    } else alt_printf ("Opened scatter-gather dma receive device\n");

    // Set interrupts for the sgdma receive device
    alt_printf("Setting up callback...\n");
    alt_avalon_sgdma_register_callback( sgdma_rx_dev, (alt_avalon_sgdma_callback) rx_ethernet_isr, 0x00000014, NULL );
    
    // Create sgdma receive descriptor
    alt_printf("Create receive descriptor...\n");
    alt_avalon_sgdma_construct_stream_to_mem_desc( &rx_descriptor, &rx_descriptor_end, (alt_u32 *)rx_frame, 0, 0 );
    
    // Set up non-blocking transfer of sgdma receive descriptor
    alt_printf("Send non-blocking transfer...\n");
    alt_avalon_sgdma_do_async_transfer( sgdma_rx_dev, &rx_descriptor );

    // Triple-speed Ethernet MegaCore base address
    volatile int * tse = (int *) 0x00102800;
    
    // Initialize the MAC address 
    *(tse + 3) = 0x116E6001;
    *(tse + 4) = 0x00000F02; 

    // Specify the addresses of the PHY devices to be accessed through MDIO interface
    *(tse + 0x0F) = 0x00; //was 0x10
    *(tse + 0x10) = 0x00; //was 0x11
    
    // Write to register 20 of the PHY chip for Ethernet port 0 to set up line loopback
    *(tse + 0x94) = 0x0000; //was 0x4000
    
    // Write to register 16 of the PHY chip for Ethernet port 1 to enable automatic crossover for all modes
    *(tse + 0xB0) = *(tse + 0xB0) | 0x0060;
    
    // Write to register 20 of the PHY chip for Ethernet port 2 to set up delay for input/output clk
    *(tse + 0xB4) = *(tse + 0xB4) | 0x0082;
    
    // Software reset the second PHY chip and wait
    *(tse + 0xA0) = *(tse + 0xA0) | 0x8000;
    while ( *(tse + 0xA0) & 0x8000 )
        ;
     
    // Enable read and write transfers, gigabit Ethernet operation, and CRC forwarding
    *(tse + 2) = *(tse + 2) | 0x0000004B;
    
    // Set up IPv4 checksum and length field.
    alt_u16 ip_total_len = IP_HEADER_LEN + UDP_HEADER_LEN + DATA_CHUNK_SIZE;
    tx_frame[ETH_HEADER_LEN+IP_LEN_OFFSET] = ip_total_len >> 8;  // Big endian
    tx_frame[ETH_HEADER_LEN+IP_LEN_OFFSET+1] = ip_total_len & 0x00ff;
    fill_ipv4_checksum(tx_frame+ETH_HEADER_LEN, IP_HEADER_LEN);

    // Set up UDP length field.
    alt_u16 udp_total_len = UDP_HEADER_LEN + DATA_CHUNK_SIZE;
    tx_frame[ETH_HEADER_LEN+IP_HEADER_LEN+UDP_LEN_OFFSET] = udp_total_len >> 8;
    tx_frame[ETH_HEADER_LEN+IP_HEADER_LEN+UDP_LEN_OFFSET+1] = udp_total_len & 0x00ff;
    
    // Set interrupts for the mic filter interrupt
    alt_printf ("Setting up interrupt...\n");
    alt_ic_isr_register ( 0, 2, mic_filter_isr, NULL, NULL );
    alt_ic_irq_enable ( 0, 2 );
    alt_printf ("Mic filter IRQ enabled\n");

    // alt_printf( "send> " );
    // text_length = 0;
    
    while (1) {
        
        /*
        // ORIGINAL
        char new_char;
        tx_frame[16] = '\0';
        
        // Add new typed characters to the transmit frame until the user types the return character
        while ( (new_char = alt_getchar()) != '\n'  ) {
        
            if (new_char == 0x08 && text_length > 0) {  // Check if character is a backspace and if there is anything to delete

                alt_printf( "%c", new_char );
                text_length--;

                // Maintain the terminal character after the text
                tx_frame[16 + text_length] = '\0';

            } else if (text_length < 45) {              // Check if there is still room in the frame for another character
                alt_printf( "%c", new_char );
                
                // Add the new character to the output text
                tx_frame[16 + text_length] = new_char;
                text_length++;

                // Maintain the terminal character after the text
                tx_frame[16 + text_length] = '\0';
            }
            
        }

        alt_printf( "\nsend> " );
        text_length = 0;
        
        // Create transmit sgdma descriptor
        alt_avalon_sgdma_construct_mem_to_stream_desc( &tx_descriptor, &tx_descriptor_end, (alt_u32 *)tx_frame, 62, 0, 1, 1, 0 );
        
        // Set up non-blocking transfer of sgdma transmit descriptor
        alt_avalon_sgdma_do_async_transfer( sgdma_tx_dev, &tx_descriptor );
        
        // Wait until transmit descriptor transfer is complete
        while (alt_avalon_sgdma_check_descriptor_status(&tx_descriptor) != 0)
            ;
        */

        // NEW MODIFIED
        if (mic_isr_cnt % CHUNK_SAMPLE == 0) {
            // We only copy and send half of the data buffer at a time, so the isr will
            // only update the other half of data buffer and we will not read and write
            // the same half of data buffer concurrently.

            // First copy the volatile int to a local variable.
            unsigned long isr_cnt_backup = mic_isr_cnt;
            // Account for the potential problem that isr_cnt increases between the if
            // statement check and the assignment.
            isr_cnt_backup = (isr_cnt_backup / CHUNK_SAMPLE) * CHUNK_SAMPLE;
            // Copy the half of the data buffer which is not currently being updated.
            unsigned long chunk_start_addr =
                MIC_NUM*2 * ((isr_cnt_backup == 0) ? CHUNK_SAMPLE : 0);
            // Copy one data chunk from data buffer to the tx frame.
            volatile_memcpy(
                tx_frame+HEADER_LEN, data_buffer+chunk_start_addr, DATA_CHUNK_SIZE / 4);
            // Create transmit sgdma descriptor
            alt_avalon_sgdma_construct_mem_to_stream_desc(
                &tx_descriptor, &tx_descriptor_end, (alt_u32 *)tx_frame,
                HEADER_LEN+DATA_CHUNK_SIZE, 0, 1, 1, 0);
            // Set up non-blocking transfer of sgdma transmit descriptor
            alt_avalon_sgdma_do_async_transfer( sgdma_tx_dev, &tx_descriptor );
        }
        // END MODIFIED
        
    }
    
    return 0;
}

/****************************************************************************************
 * Subroutine to read incoming Ethernet frames
****************************************************************************************/
void rx_ethernet_isr (void *context)
{
    int i;

    // Wait until receive descriptor transfer is complete
    while (alt_avalon_sgdma_check_descriptor_status(&rx_descriptor) != 0)
        ;
    
    /*
     * Comment out printing stuff in the rx isr.
    // Clear input line before writing
    for (i = 0; i < (6 + text_length); i++) {
        alt_printf( "%c", 0x08 );        // 0x08 --> backspace  
    }
    
    // Output received text     
    alt_printf( "receive> %s\n", rx_frame + 16 );
    
    // Reprint current input line after the output
    alt_printf( "send> %s", tx_frame + 16 );
     */
    
    // Create new receive sgdma descriptor
    alt_avalon_sgdma_construct_stream_to_mem_desc( &rx_descriptor, &rx_descriptor_end, (alt_u32 *)rx_frame, 0, 0 );
    
    // Set up non-blocking transfer of sgdma receive descriptor
    alt_avalon_sgdma_do_async_transfer( sgdma_rx_dev, &rx_descriptor );
}

// ISR for sending mic filters' data from the ram block.
void mic_filter_isr (void *context)
{
    // Copy mic data from ram_block to tx_frame
    volatile_memcpy(data_buffer + mic_isr_cnt * (MIC_NUM * 2), ram_block, MIC_NUM / 2);
    // Increment isr_cnt with modulus.
    mic_isr_cnt = (mic_isr_cnt+1) % (2*CHUNK_SAMPLE);
    // Clear the last word of ram_block
    *(ram_block+ram_block_size-1) = 0;
}

void fill_ipv4_checksum (unsigned char *header_start, int header_len)
{
    alt_u16 *header_u16 = (alt_u16 *)header_start;
    header_len >>= 1;  // Assume header_len is even
    alt_u32 sum = 0;
    alt_u16 reverse_temp;  // Need to reverse byte order before addition
    while (header_len > 0) {
        reverse_temp = *(header_u16++);
        reverse_temp = (reverse_temp >> 8) + ((reverse_temp & 0x00ff) << 8);
        sum += reverse_temp;
        --header_len;
    }
    alt_u32 carry;
    while ((carry = sum >> 16) != 0) {
        sum = (sum & 0x0000ffffUL) + carry;
    }
    alt_u16 sum_u16 = ~(alt_u16)sum;
    header_start[10] = sum_u16 >> 8;
    header_start[11] = sum_u16 & 0x00ffUL;
}

void volatile_memcpy (volatile void *dst, volatile void *src, int word_len)
{
    volatile alt_u32 *dst_u32 = (volatile alt_u32 *)dst;
    volatile alt_u32 *src_u32 = (volatile alt_u32 *)src;
    for (int i = 0; i < word_len; ++i) {
        *(dst_u32++) = *(src_u32++);
    }
}
