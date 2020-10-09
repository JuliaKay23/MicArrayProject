// Clock divider with approximately 50% duty cycle.
module clk_divider_N #(parameter N = 100) (
    input wire reset,
    input wire clk_in,
    output wire clk_out
);

reg [$clog2(N):0] cnt;
wire load;

assign load = (cnt == N-1) ? 1'b1 : 1'b0;

always @(posedge clk_in) begin
    if (reset) begin
        cnt <= 0;
    end
    else if (load) begin
        cnt <= 0;
    end
    else begin
        cnt <= cnt + 1;
    end
end

// Use two flip-flops to reduce metastability.
wire [1:0] clk_out_temp;
assign clk_out_temp[0] = (cnt >= N/2) ? 1'b1 : 1'b0;
My_DFF dff0(clk_in, reset, clk_out_temp[0], clk_out_temp[1]);
My_DFF dff1(clk_in, reset, clk_out_temp[1], clk_out);

endmodule

module My_DFF(
    input wire clk,
    input wire reset,
    input wire D,
    output reg Q
);

always @(posedge clk) begin
    if (reset) begin
        Q <= 0;
    end
    else begin
        Q <= D;
    end
end

endmodule

`timescale 1 ns / 1 ps
module clk_divider_N_tb();

reg clk;
reg reset;
wire clk_out;

clk_divider_N #(8) clk_divider_N_inst(
    .reset(reset),
    .clk_in(clk),
    .clk_out(clk_out)
);

localparam period = 100;

always #(period/2) clk = ~clk;

initial begin
    clk = 0;
    reset = 1;
    #(period*2);
    reset = 0;
    #(period*128);
    $stop;
end

endmodule

