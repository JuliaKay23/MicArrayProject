module tutorial (
	input clk,
	input wire rst,
	input wire sel, //0 for sinewave, 1 for pdm
	output wire pdm_dout,
	output wire [7:0] sine_dout,
	output wire [7:0] dout_temp,
	output wire [7:0] error
);

wire [15:0] out_freq;
assign out_freq = 16'd1000;

wire [15:0] M;
assign M = out_freq / (16'd15);


reg [9:0] address;
reg [15:0] accumulator;

initial begin
	address = 10'd0;
	accumulator = 16'd0;
end


always @(posedge clk) begin
	accumulator <= accumulator + M;
	if (sel == 0) address <= accumulator[14:6];
	else address <= address + 1;
end


wavetable wavetable_inst (
	.address ( address ),
	.clock ( clk ),
	.q ( dout_temp )
);

reg [7:0] sine;
always @(posedge clk) begin
	if (sel == 0) begin
		if (accumulator[15]) begin
				if (-dout_temp[6:0] == 7'b0000000) sine <= 8'd0;
				else sine <= {1'b1,-dout_temp[6:0]};
			end 
		else sine <= {1'd0,dout_temp[6:0]};
	end
end

assign sine_dout = sine;

pdm pdm_inst (
	.clk(clk),
	.din(dout_temp),
	.rst(rst),
	.dout(pdm_dout),
	.error(error)
);

endmodule


//TESTBENCH
`timescale 1 ps / 1 ps

module tutorial_tb();
reg clk;
reg rst;
reg sel;
wire pdm_dout;
wire [7:0] sine_dout;
wire [7:0] dout_temp;
wire [7:0] error;


tutorial tutorial_inst(
	.clk(clk),
	.rst(rst),
	.sel(sel),
	.pdm_dout(pdm_dout),
	.sine_dout(sine_dout),
	.dout_temp(dout_temp),
	.error(error)
);

always #50 clk = ~clk;

initial begin
 clk = 0;
 sel = 1;
 rst = 1;
 #100;
 rst = 0;
 #1245000
 $stop;
 clk = 0;
 sel = 0;
 #1245000
 $stop;
end

endmodule
