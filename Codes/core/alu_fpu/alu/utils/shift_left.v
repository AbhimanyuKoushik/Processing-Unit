module shift_left(input wire [63:0] in1,
                  input wire [63:0] in2,
                  output reg [63:0] out);

always @(*) begin
    wire excessive_shift = |in2[63:6];
    case (excessive_shift)
        1'b1: out = 0x0000000000000000;
        default: out = in1 << in2;
    endcase
end

endmodule
