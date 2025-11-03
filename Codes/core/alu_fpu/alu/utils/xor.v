module xor(input wire [63:0] in1,
           input wire [63:0] in2,
           output reg [63:0] out);

always @(*) begin
    out = in1 ^ in2;
end

endmodule
