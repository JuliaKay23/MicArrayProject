`timescale 1 ns / 1 ns
module ext_irq_adapter(
    output reg   interrupt_sender_irq, // interrupt_sender.irq
    input  wire  irq_input,            // conduit_end.new_signal
    input  wire  clk,                  // clock_sink.clk
    input  wire  reset                 // reset_sink.reset
);

// TODO: Auto-generated HDL template
always @(posedge clk) begin
    if (reset) begin
        interrupt_sender_irq <= 1'b0;
    end
    else begin
        interrupt_sender_irq <= irq_input;
    end
end

endmodule

