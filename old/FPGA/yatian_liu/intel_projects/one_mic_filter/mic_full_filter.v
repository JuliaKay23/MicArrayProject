module mic_full_filter(
    input wire reset_btn, // Input reset button, active low
    input wire in_valid_flip_btn, // Input button to flip in_valid, active low
    input wire pdm_mic_input,
    output wire [15:0] dout,
    output wire lf_clk_out, // Output lf_clk to drive the PDM mic
    // The following outputs are for debugging.
    output wire in_valid_led,
    output wire hsmc_rx_led,
    output wire hsmc_tx_led,
    output wire cic_input,
    output wire cic_output_present
);

// We use the internal oscillator as clk. Its frequency is 100 MHz.
wire clk;
oscillator osc(
    .oscena(1'b1),
    .clkout(clk)
);

localparam clk_factor = 50;

// Setting up the reset signals.
wire clk_reset_n; // Separate active-low reset for clock divider
button_debouncer reset_btn_db(
    .clk(clk),
    .pb_in(reset_btn), // The button is also active-low
    .pb_out(clk_reset_n)
);
wire reset_n; // Active-low reset for other devices
// Shift register to add delay between reset_n and clk_reset_n.
reg [2*clk_factor-1:0] reset_n_shift;
always @(posedge clk) begin
    reset_n_shift[2*clk_factor-1:1] <= reset_n_shift[2*clk_factor-2:0];
    reset_n_shift[0] <= clk_reset_n;
end
assign reset_n = reset_n_shift[2*clk_factor-1];

// Divide clk by 50 to get a 2 MHz low frequency clock.
wire lf_clk; 
clk_divider_N #(clk_factor) clk_divider_N_inst(
    .reset(~clk_reset_n),
    .clk_in(clk),
    .clk_out(lf_clk)
);

assign lf_clk_out = lf_clk;

// Setting up the in_valid signal.
reg in_valid;
wire in_valid_flip;
button_debouncer in_valid_flip_btn_db(
    .clk(clk),
    .pb_in(in_valid_flip_btn), // The button is also active-low
    .pb_out(in_valid_flip)
);
reg [1:0] in_valid_flip_hist;
always @(posedge lf_clk) begin
    in_valid_flip_hist[1:0] <= {in_valid_flip_hist[0], in_valid_flip};
    if (~reset_n) begin
        in_valid <= 0;
    end
    else begin
        if (in_valid_flip_hist[1] && ~in_valid_flip_hist[0]) begin
            in_valid <= ~in_valid;
        end
        else begin
            in_valid <= in_valid;
        end
    end
end

reg [1:0] pdm_input_2bit;

always @(posedge lf_clk) begin
    // The pdm_mic_input signal is synchronous so it does not need
    // a synchronizer.
    if (pdm_mic_input == 1'b0) begin
        pdm_input_2bit <= 2'b11; // -1
    end
    else begin
        pdm_input_2bit <= 2'b01; // 1
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
    .in_data(pdm_input_2bit),
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

// The LEDs are all active low.
assign in_valid_led = ~in_valid;
assign hsmc_rx_led = ~pdm_mic_input;
assign hsmc_tx_led = ~(|fir_out_data);
assign cic_input = ~pdm_input_2bit[1];
assign cic_output_present = ~(|cic_out_data);

endmodule


// Testbench.
`timescale 1 us / 1 ns
module mic_full_filter_tb();

reg reset_btn;
reg in_valid_flip_btn;
reg pdm_mic_input;
wire [15:0] dout;
wire lf_clk_out;
wire in_valid_led;
wire hsmc_rx_led;
wire hsmc_tx_led;

mic_full_filter mic_full_filter_inst(
    .reset_btn(reset_btn),
    .in_valid_flip_btn(in_valid_flip_btn),
    .pdm_mic_input(pdm_mic_input),
    .dout(dout),
    .lf_clk_out(lf_clk_out),
    .in_valid_led(in_valid_led),
    .hsmc_rx_led(hsmc_rx_led),
    .hsmc_tx_led(hsmc_tx_led)
);

initial pdm_mic_input = 0;
always @(posedge lf_clk_out) begin
    pdm_mic_input = ~pdm_mic_input;
end

initial begin
    reset_btn = 1;
    in_valid_flip_btn = 1;
    #1500; // Wait for 1.5 ms
    reset_btn = 0;
    #1500; // Push the reset button for 1.5 ms
    reset_btn = 1;
    #1500; // Wait for 1 ms
    in_valid_flip_btn = 0;
    #1500; // Push the in_valid flip button for 1.5 ms
    in_valid_flip_btn = 1;
    #2000;
    $stop;
end

endmodule

