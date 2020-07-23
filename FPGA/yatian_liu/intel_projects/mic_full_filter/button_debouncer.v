// Debounce the input push button. Changes in the input are ignored until they
// have been consistent for 2^16 clocks. For the 100 MHz clock we use, it
// means about 0.66 ms.
module button_debouncer(
    input wire clk,
    input wire pb_in,
    output reg pb_out
);

reg [15:0] pb_cnt; // 16-bit counter
reg [2:0] sync_reg; // registers for synchronization

always @(posedge clk) begin
    sync_reg[2:0] <= {sync_reg[1:0], pb_in};
end

wire pb_idle = (pb_out == sync_reg[2]); // Indicate whether the input has changed
wire pb_cnt_max = &pb_cnt; // True iff all the bits of pb_cnt is 1

// Initialization of pb_out for simulation. In the real hardware, all
// registers are set to value 0 at power-up, so this will not cause different
// behaviors between simulation and implementation.
initial begin
    pb_out = 0; 
    pb_cnt <= 16'd0;
end

always @(posedge clk) begin
    if (pb_idle) begin // No input change
        pb_cnt <= 16'd0;
    end
    else begin
        pb_cnt <= pb_cnt + 16'd1;
        // Flip the output when the different input lasts for enough time.
        if (pb_cnt_max) begin
            pb_out <= ~pb_out;
        end
    end
end

endmodule

