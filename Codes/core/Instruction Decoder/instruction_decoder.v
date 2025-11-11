module instruction_decoder (
    input wire [31:0] instruction,
    output wire [5:0] readreg_addr1,
    output wire [5:0] readreg_addr2,
    output wire [5:0] writereg_addr,
    output wire [6:0] funct7,
    output wire [2:0] funct3,
    output wire [6:0] opcode,
);
