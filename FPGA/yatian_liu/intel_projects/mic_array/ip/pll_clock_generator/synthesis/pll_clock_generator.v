// pll_clock_generator.v

// Generated using ACDS version 19.1 670

`timescale 1 ps / 1 ps
module pll_clock_generator (
		input  wire  clk_clk,        //        clk.clk
		output wire  clk_20mhz_clk,  //  clk_20mhz.clk
		output wire  clk_2mhz_clk,   //   clk_2mhz.clk
		output wire  clk_400khz_clk, // clk_400khz.clk
		input  wire  reset_reset_n   //      reset.reset_n
	);

	pll_clock_generator_pll_0 pll_0 (
		.refclk   (clk_clk),        //  refclk.clk
		.rst      (~reset_reset_n), //   reset.reset
		.outclk_0 (clk_20mhz_clk),  // outclk0.clk
		.outclk_1 (clk_2mhz_clk),   // outclk1.clk
		.outclk_3 (clk_400khz_clk), // outclk3.clk
		.outclk_2 (),               // (terminated)
		.locked   ()                // (terminated)
	);

endmodule
