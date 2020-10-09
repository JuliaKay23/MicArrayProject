
module combined_filter (
	av_st_in_error,
	av_st_in_valid,
	av_st_in_ready,
	av_st_in_data,
	av_st_out_data,
	av_st_out_valid,
	av_st_out_error,
	clk_clk,
	reset_reset_n);	

	input	[1:0]	av_st_in_error;
	input		av_st_in_valid;
	output		av_st_in_ready;
	input	[1:0]	av_st_in_data;
	output	[15:0]	av_st_out_data;
	output		av_st_out_valid;
	output	[1:0]	av_st_out_error;
	input		clk_clk;
	input		reset_reset_n;
endmodule
