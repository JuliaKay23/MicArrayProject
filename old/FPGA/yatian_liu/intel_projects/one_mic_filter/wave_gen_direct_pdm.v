module wave_gen(
    input addr_clk,
    input wt_clk,
    input wire reset,
    output wire dout
);

reg [13:0] address;
reg [2:0] bit_address; // We need to output each bit in a word one by one
localparam max_address = 1000-1; // Size of the wavetable (1000) - 1

wire [7:0] wt_out;

always @(posedge addr_clk) begin
    if (reset) begin
        address <= 14'd0;
        bit_address <= 3'd7;
    end
    else begin
        bit_address <= bit_address - 3'd1;
        if (bit_address == 3'd0) begin
            if (address == max_address) begin
                address <= 14'd0;
            end
            else begin
                address <= address + 14'd1;
            end
        end
    end
end

// The wavetable directly stores PDM data with 8-bit words and big-endian
// encoding.
wavetable wavetable_inst(
    .address(address),
    .clock(wt_clk),
    .q(wt_out)
);

assign dout = wt_out[bit_address];

endmodule


//TESTBENCH
`timescale 1 us / 1 ns

module wave_gen_tb();
reg addr_clk;
reg wt_clk;
reg reset;
wire dout;

wave_gen wave_gen_inst(
    .addr_clk(addr_clk),
    .wt_clk(wt_clk),
    .reset(reset),
    .dout(dout)
);

// The addr_clock is 2 MHz and the wavetable_clk is 100 MHz.
localparam addr_period = 0.5;
localparam wt_period = 0.01;
localparam wt_size = 1000;
always #(addr_period/2) addr_clk = ~addr_clk;
always #(wt_period/2) wt_clk = ~wt_clk;

initial begin
    addr_clk = 0;
    wt_clk = 0;
    reset = 1;
    #(addr_period*2); // Wait for 2 clock periods
    reset = 0;
    #(wt_size*8*addr_period); // Wait for the wavetable's output
    $stop;
end

endmodule
