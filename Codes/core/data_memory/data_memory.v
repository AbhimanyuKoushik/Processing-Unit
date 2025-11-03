module data_memory(input wire [19:0] address,
                   input wire [63:0] data,
                   input wire write_enable,
                   input wire [1:0] store_type,
                   input wire clk,
                   output wire [63:0] read_data);

wire [2:0] column;
wire [16:0] row;

assign column = address[2:0];
assign row = address[19:3];

reg [7:0] write_subunits;

always @(*) begin
    case (store_type)
        2'b00: write_subunits = 8'b00000001; // If store_type == byte, write in 1 byte
        2'b01: write_subunits = 8'b00000011; // If it is halfword then 2 bytes
        2'b10: write_subunits = 8'b00001111; // If it is word then in 4
        2'b11: write_subunits = 8'b11111111; // If it is double word then 8
        default: write_subunits = 8'b00000000;
    endcase
end

wire [7:0] rotated_write_subunits;
wire [63:0] rotated_data;

assign rotated_data = (data << (column << 3)) | (data >> (64 - (column << 3)));
assign rotated_write_subunits = (write_subunits << column) | (write_subunits >> (8 - column)); // circular shift by column

wire [63:0] unrotated_load_results;

genvar i;
generate
    for(i = 0; i < 8; i++) begin : subunits
        mem_subunit subunit_inst(.address(row+((i + column) >> 3)),
                    .byte_data(rotated_data[(i << 3) + 7 : (i << 3)]),
                    .write_enable(rotated_write_subunits[i] & write_enable),
                    .clk(clk),
                    .result(unrotated_load_results[(i << 3) + 7 : (i << 3)]));
    end
endgenerate

assign read_data = (unrotated_load_results >> (column << 3)) | (unrotated_load_results << (64 - (column << 3)));

endmodule
