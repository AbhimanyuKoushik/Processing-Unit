module data_memory(input wire [63:0] address,
                   input wire [63:0] write_data,
                   input wire mem_read,
                   input wire [1:0] mem_write,
                   input wire clk,
                   output reg [63:0] result);

wire [23:0] byte_address;

reg [20:0] mem_block_1 [7:0];
reg [20:0] mem_block_2 [7:0];
reg [20:0] mem_block_3 [7:0];
reg [20:0] mem_block_4 [7:0];
reg [20:0] mem_block_5 [7:0];
reg [20:0] mem_block_6 [7:0];
reg [20:0] mem_block_7 [7:0];
reg [20:0] mem_block_8 [7:0];

assign byte_address = address[23:0];

always @(posedge clk) begin
    case (byte_address[2:0])
        3'b000: begin
            mem_block_1[7:0] = write_data[7:0];
            case (mem_write)
                2'b01, 2'b10, 2'b11: mem_block_2 = write_data[7:0]; // half word >=
                2'b10, 2'b11: begin 
                    mem_block_3 = write_data[23:16]; // word >=
                    mem_block_4 = write_data[31:24];
                    end
                            
                2'b11: begin 
                    mem_block_5 = write_data[39:32]; // double word
                    mem_block_6 = write_data[47:40];
                    mem_block_7 = write_data[55:48];
                    mem_block_8 = write_data[63:56];
                    end
            endcase

        3'b001: begin
            mem_block_2[7:0] = write_data[7:0];
            case (mem_write)
                2'b01, 2'b10, 2'b11: mem_block_3 = write_data[7:0]; // half word >=
                2'b10, 2'b11: begin 
                    mem_block_4 = write_data[23:16]; // word >=
                    mem_block_5 = write_data[31:24];
                    end
                            
                2'b11: begin 
                    mem_block_6 = write_data[39:32]; // double word
                    mem_block_7 = write_data[47:40];
                    mem_block_8 = write_data[55:48];
                    mem_block_1 = write_data[63:56];
                    end
            endcase


