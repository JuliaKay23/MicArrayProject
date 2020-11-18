module tse_tutorial #(parameter mic_n = 2)(
        // Clock
        input         CLOCK_50,
        
        // button keys
        input  [2: 0] KEY,
        
        input wire [mic_n-1:0] pdm_mic_input, // Stereo mic input arrays
        output wire pdm_mic_clk, // Clock to drive the microphones
        
        // Ethernet 0
        output        ENET0_MDC,
        inout         ENET0_MDIO,
        output        ENET0_RESET_N,
        output        ENET0_GTX_CLK,
        input         ENET0_RX_CLK,
        input  [3: 0] ENET0_RX_DATA,
        input         ENET0_RX_DV,
        output [3: 0] ENET0_TX_DATA,
        output        ENET0_TX_EN,

        // Output for debug purposes
        output        in_valid_led,  // Active low LED for in_valid
        output        irq_gpio_out   // Output irq signal to GPIO
);

        wire sys_clk, clk_125, clk_25, clk_2p5, clk_2, tx_clk;
        wire core_reset_n;
        wire mdc, mdio_in, mdio_oen, mdio_out;
        wire eth_mode, ena_10;

        assign mdio_in   = ENET0_MDIO;
        assign ENET0_MDC  = mdc;
        assign ENET0_MDIO = mdio_oen ? 1'bz : mdio_out;
        
        assign ENET0_RESET_N = core_reset_n;
        
        my_pll my_pll_inst (
                .refclk   (CLOCK_50),   //  refclk.clk
                .rst      (~KEY[0]),      //   reset.reset
                .outclk_0 (sys_clk), // outclk0.clk
                .outclk_1 (clk_125), // outclk1.clk
                .outclk_2 (clk_25), // outclk2.clk
                .outclk_3 (clk_2p5), // outclk3.clk
                .outclk_4 (clk_2),
                .locked   (core_reset_n)    //  locked.export
        );

        assign pdm_mic_clk = clk_2;
        
        assign tx_clk = eth_mode ? clk_125 :       // GbE Mode   = 125MHz clock
                        ena_10   ? clk_2p5 :       // 10Mb Mode  = 2.5MHz clock
                                   clk_25;         // 100Mb Mode = 25 MHz clock
        
        my_ddio_out ddio_out_inst(
                .datain_h(1'b1),
                .datain_l(1'b0),
                .outclock(tx_clk),
                .dataout(ENET0_GTX_CLK)
        );
        
        // MODIFIED

        // Use KEY[2] to trigger the SignalTap logic analyzer.
        wire logic_analyzer_trig;
        button_debouncer #(.clk_freq(2)) db0(
                .clk(clk_2),
                .pb_in(KEY[2]),
                .pb_out(logic_analyzer_trig)
        );

        wire in_ready[mic_n]; // for backpressure, unused
        wire [15:0] filter_out_data[mic_n];
        wire filter_out_valid[mic_n];
        wire [1:0] filter_out_error[mic_n];
        
        reg [1:0] pdm_mic_input_2bit[mic_n];
        integer i;
        always @(posedge clk_2) begin
                for (i = 0; i < mic_n; i = i + 1) begin
                        if (pdm_mic_input[i] == 1'b0) begin
                                pdm_mic_input_2bit[i] <= 2'b11; // -1
                        end
                        else begin
                                pdm_mic_input_2bit[i] <= 2'b01; // +1
                        end
                end
        end

        // Logic for in_valid.
        // First debounce the input signal. KEY[1] is the button for flipping
        // in_valid. The button is active low so the output has "_n".
        wire in_valid_flip_n_db;
        button_debouncer #(.clk_freq(2)) db1(
                .clk(clk_2),
                .pb_in(KEY[1]),
                .pb_out(in_valid_flip_n_db)
        );
        reg in_valid;
        initial in_valid = 0;
        reg [1:0] in_valid_flip_hist;
        always @(posedge clk_2) begin
                in_valid_flip_hist[1] <= in_valid_flip_hist[0];
                in_valid_flip_hist[0] <= ~in_valid_flip_n_db; // Negate active low
                if (~core_reset_n) begin
                        in_valid = 1'b0;
                end
                else if (~in_valid_flip_hist[1] && in_valid_flip_hist[0]) begin
                        in_valid <= ~in_valid;
                end
                else begin
                        in_valid <= in_valid;
                end
        end
        
        generate
                genvar j;
                for(j=0; j < mic_n; j=j+1) begin : mic_filter_gen
                        combined_filter combined_filter_inst(
                                .av_st_in_error(2'b00), // av_st_in.error
                                .av_st_in_valid(in_valid), // .valid
                                .av_st_in_ready(in_ready[j]), // .ready
                                .av_st_in_data(pdm_mic_input_2bit[j]), // .data
                                .av_st_out_data(filter_out_data[j]), // av_st_out.data
                                .av_st_out_valid(filter_out_valid[j]), // .valid
                                .av_st_out_error(filter_out_error[j]), // .error
                                .clk_clk(clk_2), // clk.clk
                                .reset_reset_n(core_reset_n) // reset.reset_n
                        );
                end  
        endgenerate
        
        // Save the output valid state of the microphones.
        reg out_valid_flag;
        wire out_valid_flag_clear; // Combinational logic, will be controlled by FSM.
        reg [2:0] out_valid_hist;
        initial begin
                out_valid_flag = 1'b0;
                out_valid_hist = 3'd0;
        end
        always @(posedge sys_clk) begin
                // Since the out_valid signals from each microphone should be
                // synchronous, we only save the signal from the first mic.
                out_valid_hist[2:0] <= {out_valid_hist[1:0], filter_out_valid[0]};
                if (~core_reset_n || out_valid_flag_clear) begin
                        out_valid_flag <= 0;
                end
                else if (~out_valid_hist[2] && out_valid_hist[1]) begin
                        // out_valid changed from 0 to 1.
                        out_valid_flag <= 1;
                end
                else begin
                        out_valid_flag <= out_valid_flag;
                end
        end

        // RAM-module related nets.
        wire [3:0] byteenable = 4'b1111;
        wire chipselect;
        wire write;
        wire clken = 1'b1;
        reg [8:0] address;
        reg [31:0] writedata;
        wire [31:0] readdata;
        localparam addr_last = 9'h1ff; // last address
        
        initial begin
                address = 7'd0;
                writedata = 32'd0;
        end

        // Wire for outputing IRQ to Nios core.
        wire irq_line;

        // Logic for the FSM to write output of the filters to memory.
        // State encodings.
        localparam S_init = 4'd0,
                   S_wait = 4'd1,
                   S_write1 = 4'd2,
                   S_write_wait = 4'd3,
                   S_write2 = 4'd4,
                   S_irq_raise = 4'd5,
                   S_irq_raise_wait = 4'd6,
                   S_irq_wait1 = 4'd7,
                   S_irq_wait2 = 4'd8,
                   S_irq_wait3 = 4'd9,
                   S_irq_release = 4'd10;

        reg [3:0] curr_state;
        reg [3:0] next_state;
        initial begin
                curr_state = S_init;
        end

        // State transition logic.
        always @(posedge sys_clk) begin
                if (~core_reset_n) begin
                        curr_state <= S_init;
                end
                else begin
                        curr_state <= next_state;
                end
        end
        always @(*) begin
                next_state = curr_state; // Default case
                case (curr_state)
                        S_init: begin
                                next_state = S_wait;
                        end
                        S_wait: begin
                                if (out_valid_flag) begin
                                        next_state = S_write1;
                                end
                        end
                        S_write1: begin
                                next_state = S_write_wait;
                        end
                        S_write_wait: begin
                                // One mic output uses 2 bytes, and
                                // address is in words.
                                if (address*4+4 == mic_n*2) begin
                                        next_state = S_irq_raise;
                                end
                                else begin
                                        next_state = S_write2;
                                end
                        end
                        S_write2: begin
                                next_state = S_write1;
                        end
                        S_irq_raise: begin
                                next_state = S_irq_raise_wait;
                        end
                        S_irq_raise_wait: begin
                                next_state = S_irq_wait1;
                        end
                        S_irq_wait1: begin
                                next_state = S_irq_wait2;
                        end
                        S_irq_wait2: begin
                                next_state = S_irq_wait3;
                        end
                        S_irq_wait3: begin
                                if (readdata == 32'd0) begin
                                        next_state = S_irq_release;
                                end
                                else begin
                                        next_state = S_irq_wait1;
                                end
                        end
                        S_irq_release: begin
                                next_state = S_init;
                        end
                endcase
        end

        // Sequential output logic.
        always @(posedge sys_clk) begin
                // Logic for address.
                case (curr_state)
                        S_init: address <= 10'd0;
                        S_write2: address <= address + 10'd1;
                        S_irq_raise: address <= addr_last;
                        default: address <= address;
                endcase
                // Logic for writedata.
                case (curr_state)
                        S_init: writedata <= 32'd0;
                        S_write1: writedata <=
                                {filter_out_data[address*2+1], filter_out_data[address*2]};
                        S_irq_raise: writedata <= 32'd1;
                        default: writedata <= writedata;
                endcase
        end

        // Combinational output logic.
        assign out_valid_flag_clear = (curr_state == S_init);
        assign irq_line = (curr_state == S_irq_wait1)
                       || (curr_state == S_irq_wait2)
                       || (curr_state == S_irq_wait3);
        assign chipselect = (curr_state == S_write_wait)
                         || (curr_state == S_irq_raise_wait)
                         || (curr_state == S_irq_wait2);
        assign write = (curr_state == S_write_wait)
                    || (curr_state == S_irq_raise_wait);

        // END MODIFIED
        

        nios_system system_inst (
                .clk_clk                                   (sys_clk),           // clk.clk
                .reset_reset_n                             (core_reset_n),      // reset.reset_n
                .tse_pcs_mac_tx_clock_connection_clk       (tx_clk),            // eth_tse_0_pcs_mac_tx_clock_connection.clk
                .tse_pcs_mac_rx_clock_connection_clk       (ENET0_RX_CLK),      // eth_tse_0_pcs_mac_rx_clock_connection.clk
                .tse_mac_mdio_connection_mdc               (mdc),               // tse_mac_mdio_connection.mdc
                .tse_mac_mdio_connection_mdio_in           (mdio_in),           //                        .mdio_in
                .tse_mac_mdio_connection_mdio_out          (mdio_out),          //                        .mdio_out
                .tse_mac_mdio_connection_mdio_oen          (mdio_oen),          //                        .mdio_oen
                .tse_mac_rgmii_connection_rgmii_in         (ENET0_RX_DATA),     // tse_mac_rgmii_connection.rgmii_in
                .tse_mac_rgmii_connection_rgmii_out        (ENET0_TX_DATA),     //                         .rgmii_out
                .tse_mac_rgmii_connection_rx_control       (ENET0_RX_DV),       //                         .rx_control
                .tse_mac_rgmii_connection_tx_control       (ENET0_TX_EN),       //                         .tx_control

                .tse_mac_status_connection_eth_mode        (eth_mode),          //                         .eth_mode
                .tse_mac_status_connection_ena_10          (ena_10),            //                         .ena_10   
                // MODIFIED
                .ram_block_s2_address                (address),                 // ram_block_s2.address
                .ram_block_s2_chipselect             (chipselect),              //             .chipselect
                .ram_block_s2_clken                  (clken),                   //             .clken
                .ram_block_s2_write                  (write),                   //             .write
                .ram_block_s2_writedata              (writedata),               //             .writedata
                .ram_block_s2_readdata               (readdata),                //             .readdata
                .ram_block_s2_byteenable             (byteenable),              //             .byteenable
                .ext_irq_adapter_new_signal          (irq_line)                 // external interrupt adapter input
                // END MODIFIED
        );      

        // Debug outputs.
        assign in_valid_led = ~in_valid;
        assign irq_gpio_out = irq_line;
endmodule 

