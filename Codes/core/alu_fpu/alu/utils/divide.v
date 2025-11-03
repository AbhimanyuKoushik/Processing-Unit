module divide(input wire [63:0] in1,
              input wire [63:0] in2,
              input wire [1:0] flag,
              output reg [63:0] out);

always @(*) begin
    case (flag)
        2'b00: out = in1 / in2;
        2'b01: out = $unsigned(in1) / $unsigned(in2);
        2'b10: out = in1 % in2;
        default: out = $unsigned(in1) % $unsigned(in2);
    endcase
end

endmodule
