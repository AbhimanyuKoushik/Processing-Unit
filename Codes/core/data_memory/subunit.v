module mem_subunit(input wire [16:0] address,
                   input wire [7:0] byte_data,
                   input wire write_enable,
                   input wire clk,
                   output wire [7:0] result);

reg [7:0] registers [131071:0];

always @(posedge clk) begin
    if(write_enable) registers[address] <= byte_data;
end

assign result = registers[address];

endmodule





