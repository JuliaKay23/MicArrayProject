	component combined_filter is
		port (
			av_st_in_error  : in  std_logic_vector(1 downto 0)  := (others => 'X'); -- error
			av_st_in_valid  : in  std_logic                     := 'X';             -- valid
			av_st_in_ready  : out std_logic;                                        -- ready
			av_st_in_data   : in  std_logic_vector(1 downto 0)  := (others => 'X'); -- data
			av_st_out_data  : out std_logic_vector(15 downto 0);                    -- data
			av_st_out_valid : out std_logic;                                        -- valid
			av_st_out_error : out std_logic_vector(1 downto 0);                     -- error
			clk_clk         : in  std_logic                     := 'X';             -- clk
			reset_reset_n   : in  std_logic                     := 'X'              -- reset_n
		);
	end component combined_filter;

	u0 : component combined_filter
		port map (
			av_st_in_error  => CONNECTED_TO_av_st_in_error,  --  av_st_in.error
			av_st_in_valid  => CONNECTED_TO_av_st_in_valid,  --          .valid
			av_st_in_ready  => CONNECTED_TO_av_st_in_ready,  --          .ready
			av_st_in_data   => CONNECTED_TO_av_st_in_data,   --          .data
			av_st_out_data  => CONNECTED_TO_av_st_out_data,  -- av_st_out.data
			av_st_out_valid => CONNECTED_TO_av_st_out_valid, --          .valid
			av_st_out_error => CONNECTED_TO_av_st_out_error, --          .error
			clk_clk         => CONNECTED_TO_clk_clk,         --       clk.clk
			reset_reset_n   => CONNECTED_TO_reset_reset_n    --     reset.reset_n
		);

