// Synchronize the input signal to the input clock.
module synchronizer(
    input wire clk,
    input wire sig_in,
    output wire sig_out_sync
);

reg [2:0] sync_reg;

always @(posedge clk) begin
    sync_reg[2:0] <= {sync_reg[1:0], sig_in};
end

assign sig_out_sync = sync_reg[2];

endmodule

