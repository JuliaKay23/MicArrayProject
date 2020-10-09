// (C) 2001-2019 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License Subscription 
// Agreement, Intel FPGA IP License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Intel and sold by 
// Intel or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


// console messaging level
 import avalon_utilities_pkg::*;
 import verbosity_pkg::*;

`define VERBOSITY VERBOSITY_NONE

//BFM hierachy
`define CLK tb.cic_ii_0_example_design_inst_core_clock_bfm
`define RST tb.cic_ii_0_example_design_inst_core_reset_bfm
`define SRC tb.cic_ii_0_example_design_inst_core_av_st_in_bfm
`define SNK tb.cic_ii_0_example_design_inst_core_av_st_out_bfm
//Rate BFM name can only be defined for a multi-rate system

//Test parameters
`define DATA_GENERATION "RANDOM" //currently only random is supported
`define BACK_PRESSURE "TRUE"
`define FORWARD_PRESSURE "TRUE"
`define INPUT_DATA_FILE "cic_ii_0_example_design_tb_input.txt"
`define OUTPUT_DATA_FILE "cic_ii_0_example_design_tb_output.txt"
//CIC parameters
`define B_IN 2
`define B_OUT 16
`define FILTER_TYPE "decimator"
`define CH_PER_INT 1
`define INTERFACES 1
`define MAX_RATE 40
`define MIN_RATE 40

`timescale 1ns/1ps





module test_program();

//instantiate the testbench system
cic_ii_0_example_design_tb tb();


//BFM related parameters
localparam SRC_D_W   = (`FILTER_TYPE == "interpolator") ? `B_IN : `INTERFACES*`B_IN;

localparam SNK_D_W = (`FILTER_TYPE == "decimator") ? `B_OUT : `INTERFACES*`B_OUT;


localparam SRC_DATA_W = SRC_D_W;
localparam SRC_SYMBOL_W = SRC_DATA_W;
localparam SRC_NUM_SYMBOLS = 1;
localparam SRC_CHANNEL_W = 0;
localparam SRC_ERROR_W = 2;
localparam SRC_EMPTY_W = 0;
localparam SRC_READ_LATENCY = 0;
localparam SRC_MAX_CHANNELS = 1;
localparam SRC_RESP_TIMEOUT = 32000;

localparam SNK_DATA_W = SNK_D_W;
localparam SNK_SYMBOL_W = SNK_DATA_W;
localparam SNK_NUM_SYMBOLS = 1;
localparam SNK_CHANNEL_W = 0;
localparam SNK_ERROR_W = 2;
localparam SNK_EMPTY_W = 0;
localparam SNK_READ_LATENCY = 0;
localparam SNK_MAX_CHANNELS = 1;
localparam SNK_RESP_TIMEOUT = 32000;
localparam LATENCY_COUNT = 150;
localparam TOTAL_CHANNELS = `CH_PER_INT * `INTERFACES;
localparam INTERFACES_IN  = (`FILTER_TYPE=="decimator")  ?    `INTERFACES : 1  ;
localparam INTERFACES_OUT = (`FILTER_TYPE=="interpolator")  ?    `INTERFACES : 1  ;
localparam CHANNEL_SIZE_OUT = (`FILTER_TYPE=="interpolator") ? `CH_PER_INT : TOTAL_CHANNELS ;
localparam CHANNEL_SIZE_IN = (`FILTER_TYPE=="decimator") ?  `CH_PER_INT : TOTAL_CHANNELS;
IdleOutputValue_t avalon_settings = RANDOM;
static int data_counted_in = 0;
static int data_counted_out = 0;
static int source_finished = 0;
static int snk_queue = 0;
static int src_queue = 0;
static int out_data_file;
static int current_rate = 0;


typedef logic signed [SRC_DATA_W -1   :0]  Src_Data_t;
typedef logic        [SRC_ERROR_W-1   :0]   Src_Error_t;


typedef logic signed [SNK_DATA_W-1    :0]  Snk_Data_t;
typedef logic        [SNK_CHANNEL_W-1 :0]  Snk_Channel_t;
typedef logic        [SNK_ERROR_W-1   :0]  Snk_Error_t;
int in_data_file;


  //the ST transaction is defined using SystemVerilog structure data type
  class src_transaction_class;
    int          idles;
    bit               startofpacket;
    bit               endofpacket;
    logic signed   [SRC_DATA_W-1    :0]          data;
    Src_Error_t       error;
    int packet_size;
    int channel_count;
    int frame_size;
    string message;
    int input_rate;

    static int valid = 0;



    function void send_data ();
        if(source_finished == 0) begin
            data_counted_in++;
            $sformat(message, "%m: Sent Packet");
            print(VERBOSITY_DEBUG, message);
            `SRC.set_transaction_idles   (idles);
            `SRC.set_transaction_sop     (startofpacket);
            `SRC.set_transaction_eop     (endofpacket);
            `SRC.set_transaction_data    (data);
            `SRC.set_transaction_error   (error);
            `SRC.push_transaction();
        end
        src_queue = `SRC.get_transaction_queue_size();
    endfunction


    function void pack_data (int data_in,int interface_index);
    begin

        logic signed [`B_IN -1 :0 ] data_temp;
        logic signed [SRC_DATA_W -1 :0 ] data_temp_extended;
        logic signed [SRC_DATA_W -1 :0 ] data_mask;
        if(INTERFACES_IN > 1) begin
            data_temp = data_in;
            data_temp_extended = {{(SRC_DATA_W - `B_IN){1'b0}},data_temp} << (interface_index*`B_IN);
            data_mask =~( {{(SRC_DATA_W - `B_IN){1'b0}},{`B_IN{1'b1}}} << (interface_index*`B_IN));
            data = (data & data_mask) | data_temp_extended;
        end else begin
            data = data_in;
        end
    end
    endfunction






    function void open_input_files ();
        $sformat(message, "%m: Opening input files");
        print(VERBOSITY_DEBUG, message);
        channel_count = 0;
        in_data_file = $fopen(`INPUT_DATA_FILE, "r");
        if (!in_data_file) begin
            print(VERBOSITY_ERROR,"Failed to open data file");
        end
    endfunction

    function void close_input_files ();
        $sformat(message, "%m: Closing input files");
        print(VERBOSITY_DEBUG, message);
        channel_count = 0;
        $fclose(in_data_file);
    endfunction


endclass

class snk_transaction_class;
    int               idles;
    bit               startofpacket;
    bit               endofpacket;
    Snk_Data_t        data;
    Snk_Error_t       error;


    function logic [`B_OUT-1:0] unpack_data  (int interface_index);
        Snk_Data_t data_temp;
        data_temp =  data >> interface_index*`B_OUT;
        return data_temp[`B_OUT-1:0];
    endfunction

    function void write_out_result ();
        logic [`B_OUT-1:0] data_out;
        for (int i = INTERFACES_OUT-1; i >= 0; i = i-1)
        begin
            data_out = unpack_data(i);
            if(i == 0) begin
                if(`B_OUT > 32) begin
                    $fwrite(out_data_file, "%b\n", $signed(data_out));
                end else begin
                    $fwrite(out_data_file, "%d\n", $signed(data_out));
                end
            end else begin
                if(`B_OUT > 32) begin
                    $fwrite(out_data_file, "%b,", $signed(data_out));
                end else begin
                    $fwrite(out_data_file, "%d,", $signed(data_out));
                end
            end
        end
        $sformat(message, "%m: Result has been written out");
        print(VERBOSITY_DEBUG, message);
    endfunction



    //pop the transaction from Sink BFM queue and get the decriptors
    function void snk_pop_transaction();
        data_counted_out++;
        `SNK.pop_transaction();
        idles         = `SNK.get_transaction_idles();
        startofpacket = `SNK.get_transaction_sop();
        endofpacket   = `SNK.get_transaction_eop();
        data          = `SNK.get_transaction_data();
        error         = `SNK.get_transaction_error();
        snk_queue = `SNK.get_transaction_queue_size();
    endfunction

    function void open_output_files ();
        print(VERBOSITY_DEBUG,"Opening the output files");
        out_data_file = $fopen(`OUTPUT_DATA_FILE, "w");
    endfunction
    function void close_output_files ();
        print(VERBOSITY_DEBUG,"Closing the output files");
        $fclose(out_data_file);
    endfunction
endclass


integer data_file_in, data_file_out;
integer i,j,k,l,m,rate_test;
integer reset_length;

string message;
int flag;
src_transaction_class src_transaction;
snk_transaction_class snk_transaction;
integer src_q_size, snk_q_size;



task  read_input_data_files;
    begin
        int success;
        int data_in_int;
        int new_rate;
        src_transaction.valid = 1;
        $sformat(message, "%m: Reading from file line");
        print(VERBOSITY_DEBUG, message);
        src_transaction.startofpacket = 1'b0;
        src_transaction.endofpacket   = 1'b0;
        src_transaction.error = 2'b0;
        print(VERBOSITY_DEBUG,"Reading the input files");
        if($feof(in_data_file) && source_finished == 0)
        begin
            print(VERBOSITY_INFO,"End of Data file");
            for (int i = 0; i < LATENCY_COUNT; ++i)
            begin
                @(posedge `CLK.clk);
            end
            $finish();
            end else begin
            for (int i = INTERFACES_IN-1; i >=  0; i = i-1)
            begin
                success = $fscanf(in_data_file,"%d,",data_in_int);
                src_transaction.pack_data(data_in_int, i);
                $sformat(message, "%m: Read data %d \n", data_in_int);
                print(VERBOSITY_DEBUG,message);
                if(success == -1 && source_finished == 0)
                begin
                    print(VERBOSITY_WARNING,"End of Data file");
                    source_finished = 1;
                    for (int i = 0; i < LATENCY_COUNT; ++i)
                    begin
                        @(posedge `CLK.clk);
                    end
                    $finish();
                end
            end
            success = $fscanf(in_data_file,"%d\n",new_rate);
        end
        $sformat(message, "%m: Count %d/%d", src_transaction.channel_count+1, src_transaction.packet_size);
        print(VERBOSITY_INFO, message);

        if(src_transaction.channel_count == 0) begin
            src_transaction.startofpacket = 1'b1;
            src_transaction.packet_size = CHANNEL_SIZE_IN;
        end
        if(src_transaction.channel_count == src_transaction.packet_size-1) begin
            src_transaction.endofpacket = 1'b1;
        end
        src_transaction.channel_count++;
        if(src_transaction.channel_count == src_transaction.packet_size) begin
            src_transaction.channel_count = 0;
        end
    end
endtask



initial
begin
    set_verbosity(`VERBOSITY);
    `SRC.set_response_timeout(SRC_RESP_TIMEOUT);
    `SRC.set_response_timeout(SNK_RESP_TIMEOUT);
    `SRC.init();
    `SNK.init();
    `SRC.set_idle_state_output_configuration(avalon_settings);
    `SRC.set_min_transaction_queue_size(5);
    src_transaction = new();
    snk_transaction = new();
    src_transaction.open_input_files();
    snk_transaction.open_output_files();
    //wait for reset to de-assert and trigger start_test event
    wait(`RST.reset == 1);
    `RST.reset_assert();
    @(negedge `CLK.clk);
    `RST.reset_deassert();
    @(posedge `CLK.clk);
    fork
        begin
            while(1) begin
                read_input_data_files();
                if(`FORWARD_PRESSURE=="TRUE")
                  begin
                   src_transaction.idles =  ($unsigned($random()) % 10);
                  end else begin
                   src_transaction.idles =  0;
                end
                src_transaction.send_data();
                if(source_finished == 0) begin
                    @(`SRC.signal_min_transaction_queue_size);
                end
            end
      end // source_data_thread
        begin
            while (1)
            begin
                `SNK.set_ready(1);
                @`SNK.signal_transaction_received;
                snk_transaction.snk_pop_transaction();
                snk_transaction.write_out_result();
                if(`BACK_PRESSURE=="TRUE")
                begin
                    snk_transaction.idles = ($unsigned($random()) % 10);
                    `SNK.set_ready(0);
                    for(l = 0; l < snk_transaction.idles; l++)
                    begin
                        @(posedge `CLK.clk);
                    end
                end
            end
        end // sink_thread
    join_any
    src_transaction.close_input_files();
    snk_transaction.close_output_files();
    $sformat(message, "%m: Test Finished");
    print(VERBOSITY_INFO, message);
    `CLK.clock_stop();
    $finish();
end




endmodule

