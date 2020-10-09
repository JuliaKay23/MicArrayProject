	combined_filter u0 (
		.av_st_in_error  (<connected-to-av_st_in_error>),  //  av_st_in.error
		.av_st_in_valid  (<connected-to-av_st_in_valid>),  //          .valid
		.av_st_in_ready  (<connected-to-av_st_in_ready>),  //          .ready
		.av_st_in_data   (<connected-to-av_st_in_data>),   //          .data
		.av_st_out_data  (<connected-to-av_st_out_data>),  // av_st_out.data
		.av_st_out_valid (<connected-to-av_st_out_valid>), //          .valid
		.av_st_out_error (<connected-to-av_st_out_error>), //          .error
		.clk_clk         (<connected-to-clk_clk>),         //       clk.clk
		.reset_reset_n   (<connected-to-reset_reset_n>)    //     reset.reset_n
	);

