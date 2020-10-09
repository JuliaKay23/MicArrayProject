create_clock -name {ENET0_RX_CLK} -period 20 [get_ports ENET0_RX_CLK]
create_clock -period 20 [get_ports CLOCK_50]
derive_pll_clocks
derive_clock_uncertainty
set_clock_groups -exclusive -group {my_pll_inst|my_pll_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk} -group {my_pll_inst|my_pll_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk} -group {my_pll_inst|my_pll_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk} -group {my_pll_inst|my_pll_inst|altera_pll_i|general[3].gpll~PLL_OUTPUT_COUNTER|divclk}