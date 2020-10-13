// Debounce the input push button. Changes in the input are ignored until they
// have been consistent for about 5 ms. The unit of clk_freq is MHz.
module button_debouncer #(parameter clk_freq = 50)(
    input wire clk,
    input wire pb_in,
    output reg pb_out
);

reg [$clog2(clk_freq*5000):0] pb_cnt;
wire pb_cnt_max = (pb_cnt == clk_freq*5000); // True iff pb_cnt reaches 5 ms

// Synchronize the external input.
wire pb_in_sync;
reg [2:0] sync_reg;

always @(posedge clk) begin
    sync_reg[2:0] <= {sync_reg[1:0], pb_in};
end
assign pb_in_sync = sync_reg[2];

// Initialization of pb_out for simulation. In the real hardware, all
// registers are set to value 0 at power-up, so this will not cause different
// behaviors between simulation and implementation.
initial begin
    pb_out = 0; 
    pb_cnt = 0;
end

always @(posedge clk) begin
    if (pb_out == pb_in_sync) begin // No input change
        pb_cnt <= 0;
    end
    else begin
        pb_cnt <= pb_cnt + 1;
        // Flip the output when the different input lasts for enough time.
        if (pb_cnt_max) begin
            pb_out <= pb_in_sync;
        end
    end
end

endmodule

