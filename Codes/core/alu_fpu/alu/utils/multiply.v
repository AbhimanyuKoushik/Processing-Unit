module multiply(input wire [63:0] in1,
           input wire [63:0] in2,
           input wire [1:0] flag,
           output reg [63:0] out);

wire [127:0] CompleteMultiply;
wire [127:0] CompleteMultiplyU;
wire [127:0] CompleteMultiplySU;

assign CompleteMultiply = $signed(in1) * $signed(in2);
assign CompleteMultiplyU = $unsigned(in1) * $unsigned(in2);
assign CompleteMultiplySU = $signed(in1) * $unsigned(in2);

always @(*) begin
    case(flag)
        2'b00: out = CompleteMultiply[63:0];
        2'b01: out = CompleteMultiply[127:64];
        2'b10: out = CompleteMultiplySU[127:64];
        default: out = CompleteMultiplyU[127:64];
    endcase
end

endmodule

