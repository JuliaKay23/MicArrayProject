	component pll_clock_generator is
		port (
			clk_clk        : in  std_logic := 'X'; -- clk
			clk_400khz_clk : out std_logic;        -- clk
			clk_20mhz_clk  : out std_logic;        -- clk
			clk_2mhz_clk   : out std_logic;        -- clk
			reset_reset_n  : in  std_logic := 'X'  -- reset_n
		);
	end component pll_clock_generator;

	u0 : component pll_clock_generator
		port map (
			clk_clk        => CONNECTED_TO_clk_clk,        --        clk.clk
			clk_400khz_clk => CONNECTED_TO_clk_400khz_clk, -- clk_400khz.clk
			clk_20mhz_clk  => CONNECTED_TO_clk_20mhz_clk,  --  clk_20mhz.clk
			clk_2mhz_clk   => CONNECTED_TO_clk_2mhz_clk,   --   clk_2mhz.clk
			reset_reset_n  => CONNECTED_TO_reset_reset_n   --      reset.reset_n
		);

