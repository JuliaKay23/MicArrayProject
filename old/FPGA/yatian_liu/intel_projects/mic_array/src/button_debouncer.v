// Debounce the input push button. Changes in the input are ignored until they
// have been consistent for 2^18 clocks. For the 50 MHz clock we use, it
// means about 5.24 ms.
module button_debouncer(
    input wire clk,
    input wire pb_in,
    output reg pb_out
);

reg [17:0] pb_cnt; // 18-bit counter
wire pb_cnt_max = &pb_cnt; // True iff all the bits of pb_cnt is 1

wire pb_in_sync;
synchronizer sync_inst(
    .clk(clk),
    .sig_in(pb_in),
    .sig_out_sync(pb_in_sync)
);

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

