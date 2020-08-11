
module pll_clock_generator (
	clk_clk,
	clk_400khz_clk,
	clk_20mhz_clk,
	clk_2mhz_clk,
	reset_reset_n);	

	input		clk_clk;
	output		clk_400khz_clk;
	output		clk_20mhz_clk;
	output		clk_2mhz_clk;
	input		reset_reset_n;
endmodule
