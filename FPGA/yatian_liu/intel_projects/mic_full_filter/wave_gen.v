module wave_gen(
    input clk,
    input wire rst,
    output wire dout,
    output wire [7:0] dout_temp,
    output wire [7:0] error
);


reg [9:0] address;

initial begin
    address = 10'd0;
end


always @(posedge clk) begin
    address <= address + 10'd1;
end


wavetable wavetable_inst(
    .address(address),
    .clock(clk),
    .q(dout_temp)
);


pdm pdm_inst(
    .clk(clk),
    .din(dout_temp),
    .rst(rst),
    .dout(dout),
    .error(error)
);

endmodule


//TESTBENCH
`timescale 1 ps / 1 ps

module wave_gen_tb();
reg clk;
reg rst;
wire dout;
wire [7:0] dout_temp;
wire [7:0] error;

wave_gen wave_gen_inst(
    .clk(clk),
    .rst(rst),
    .dout(dout),
    .dout_temp(dout_temp),
    .error(error)
);

always #50 clk = ~clk;

initial begin
    clk = 0;
    rst = 1;
    #100;
    rst = 0;
    #1245000
    $stop;
end

endmodule
