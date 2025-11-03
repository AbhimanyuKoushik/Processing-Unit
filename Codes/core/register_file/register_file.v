module register_file(input wire [31:0] instruction,
                     input wire [63:0] write_data,
                     input wire RegWrite,
                     input wire clk,
                     output wire [63:0] read_data1,
                     output wire [63:0] read_data2);

reg  [63:0] registers [63:0];

wire [5:0] reg_addr1;
wire [5:0] reg_addr2;
wire [5:0] write_addr;

assign reg_addr1[4:0] = instruction[19:15];
assign reg_addr2[4:0] = instruction[24:20];
assign write_addr[4:0] = instruction[11:7];

assign reg_addr1[5] = (instruction[6:0] == 7'b1010011);
assign reg_addr2[5] = (instruction[6:0] == 7'b1010011);
assign write_addr[5] = (instruction[6:0] == 7'b1010011);

assign read_data1 = registers[reg_addr1];
assign read_data2 = registers[reg_addr2];

always @(posedge clk) begin
        if(RegWrite) registers[write_addr] = write_data;
end

endmodule
