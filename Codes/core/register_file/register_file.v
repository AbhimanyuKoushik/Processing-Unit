module register_file #(parameter DataLength = 64) (
    input wire [5:0] readreg_addr1,
    input wire [5:0] readreg_addr2,
    input wire [5:0] writereg_addr,
    input wire [(DataLength - 1):0] write_data,
    input wire RegWrite,
    input wire clk,
    output wire [(DataLength - 1):0] read_data1,
    output wire [(DataLength - 1):0] read_data2
);

reg [(DataLength - 1):0] registers [63:0];

assign read_data1 = registers[readreg_addr1];
assign read_data2 = registers[readreg_addr2];

always @(posedge clk) begin
        if(RegWrite) registers[writereg_addr] <= write_data;
end

endmodule
