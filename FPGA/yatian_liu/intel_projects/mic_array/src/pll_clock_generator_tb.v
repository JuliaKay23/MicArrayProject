`timescale 1 us / 1 ps
module pll_clock_generator_tb();

wire clk_400khz;
wire clk_2mhz;
wire clk_20mhz;
reg reset_n;
reg clk;

pll_clock_generator pll_clock_generator_inst(
    .clk_clk(clk),
    .reset_reset_n(reset_n),
    .clk_400khz_clk(clk_400khz),
    .clk_2mhz_clk(clk_2mhz),
    .clk_20mhz_clk(clk_20mhz)
);

localparam period = 0.01; // 100 MHz clock
always #(period/2) clk = ~clk;

initial begin
    clk = 1;
    reset_n = 1;
    #(5*period);
    reset_n = 0;
    #(1 - 5*period);
    reset_n = 1;
    #50; // Wait for 50 us.
    $stop;
end

endmodule

