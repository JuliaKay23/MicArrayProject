// Time multiplex the input signal from two microphones.
module multiplexer(
    input wire clk,
    input wire [15:0] in_data[2],
    output reg [4:0] out_data
);

reg [2:0] counter;
initial counter = 0;

reg [15:0] in_data_reg[2];
initial begin
    in_data_reg[0] = 0;
    in_data_reg[1] = 0;
end

always @(posedge clk) begin
    counter <= counter + 1;
    if (counter == 7) begin
        in_data_reg <= in_data;
    end
    case (counter)
        3'd0: out_data <= {in_data_reg[0][15:12], 1'b0};
        3'd1: out_data <= {in_data_reg[0][11:8], 1'b0};
        3'd2: out_data <= {in_data_reg[0][7:4], 1'b0};
        3'd3: out_data <= {in_data_reg[0][3:0], 1'b0};
        3'd4: out_data <= {in_data_reg[1][15:12], 1'b1};
        3'd5: out_data <= {in_data_reg[1][11:8], 1'b1};
        3'd6: out_data <= {in_data_reg[1][7:4], 1'b1};
        3'd7: out_data <= {in_data_reg[1][3:0], 1'b1};
        default: out_data <= 5'd0;
    endcase
end

endmodule

