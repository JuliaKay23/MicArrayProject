	pll_clock_generator u0 (
		.clk_clk        (<connected-to-clk_clk>),        //        clk.clk
		.clk_400khz_clk (<connected-to-clk_400khz_clk>), // clk_400khz.clk
		.clk_20mhz_clk  (<connected-to-clk_20mhz_clk>),  //  clk_20mhz.clk
		.clk_2mhz_clk   (<connected-to-clk_2mhz_clk>),   //   clk_2mhz.clk
		.reset_reset_n  (<connected-to-reset_reset_n>)   //      reset.reset_n
	);

