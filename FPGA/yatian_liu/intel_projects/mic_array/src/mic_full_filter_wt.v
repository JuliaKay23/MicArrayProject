module mic_full_filter_wt(
    input wire reset_n, // Active-low reset for other devices
    input wire clk_reset_n, // Separate active-low reset for clock divider
    input wire in_valid,
    output wire [15:0] dout
);

// We use the internal oscillator as clk. Its frequency is 100 MHz.
wire clk;
oscillator osc(
    .oscena(1'b1),
    .clkout(clk)
);

// Divide clk by 25 to get a 2 MHz low frequency clock.
wire lf_clk; 
clk_divider_N #(50) clk_divider_N_inst(
    .reset(~clk_reset_n),
    .clk_in(clk),
    .clk_out(lf_clk)
);

wire dout_pdm_temp;
// Registers are used to synchronize the wavetable's output to lf_clk instead
// of clk.
reg dout_pdm, dout_pdm_temp2;
reg [1:0] dout_pdm_2bit;

wave_gen wave_gen_inst(
    .addr_clk(lf_clk),
    .wt_clk(clk),
    .reset(~reset_n),
    .dout(dout_pdm_temp)
);
always @(posedge lf_clk) begin
    dout_pdm_temp2 <= dout_pdm_temp;
    dout_pdm <= dout_pdm_temp2;
    if (dout_pdm == 1'b0) begin
        dout_pdm_2bit <= 2'b11;
    end
    else begin
        dout_pdm_2bit <= 2'b01;
    end
end

wire cic_in_ready;
wire cic_out_valid;
wire [1:0] cic_out_error;
wire [15:0] cic_out_data;

cic_dec_filter cic_inst(
    .clk(lf_clk),
    .reset_n(reset_n),
    .in_error(2'b00),
    .in_valid(in_valid),
    .in_ready(cic_in_ready),
    .in_data(dout_pdm_2bit),
    .out_data(cic_out_data),
    .out_error(cic_out_error),
    .out_valid(cic_out_valid),
    .out_ready(1'b1)
);

wire fir_out_valid;
wire [1:0] fir_out_error;
wire [15:0] fir_out_data;

fir_comp_filter fir_inst(
    .clk(lf_clk),
    .reset_n(reset_n),
    .ast_sink_data(cic_out_data),
    .ast_sink_valid(cic_out_valid),
    .ast_sink_error(cic_out_error),
    .ast_source_data(fir_out_data),
    .ast_source_valid(fir_out_valid),
    .ast_source_error(fir_out_error)
);

assign dout = fir_out_data;

endmodule


// Testbench

`timescale 1 us / 1 ns
module mic_full_filter_wt_tb();

reg reset_n;
reg clk_reset_n;
reg in_valid;
wire [15:0] dout;

mic_full_filter_wt mic_full_filter_wt_inst(
    .reset_n(reset_n),
    .clk_reset_n(clk_reset_n),
    .in_valid(in_valid),
    .dout(dout)
);

localparam period = 0.01;
localparam lf_period = 0.5;
localparam wt_size = 1000;

initial begin
    reset_n = 0;
    clk_reset_n = 0;
    in_valid = 0;
    #(period*2);
    clk_reset_n = 1;
    #(lf_period*2);
    reset_n = 1;
    #(lf_period*3);
    in_valid = 1;
    #(50*lf_period); // Add some extra delay
    #(wt_size*8*lf_period); // Wait for the wavetable's output
    $stop;
end

endmodule

