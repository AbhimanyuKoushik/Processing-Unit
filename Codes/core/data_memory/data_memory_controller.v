module data_memory_controller(input wire [63:0] address,
                              input wire [63:0] data,
                              input wire write_enable,
                              input wire [2:0] load_type,
                              input wire [1:0] store_type,
                              input wire clk,
                              output wire [63:0] read_data);

wire [63:0] raw_data;
data_memory memory(.address(address[19:0]),
            .data(data),
            .write_enable(write_enable),
            .store_type(store_type),
            .clk(clk),
            .read_data(raw_data));

reg [63:0] processed_data;

always @(*) begin
    case (load_type)
        3'b001: processed_data = {{56{1'b0}},raw_data[7:0]};          // lbu
        3'b010: processed_data = {{56{raw_data[7]}},raw_data[7:0]};   // lb
        3'b011: processed_data = {{48{1'b0}},raw_data[15:0]};         // lhu
        3'b100: processed_data = {{48{raw_data[15]}},raw_data[15:0]}; // lh
        3'b101: processed_data = {{32{1'b0}},raw_data[31:0]};         // lwu
        3'b110: processed_data = {{32{raw_data[31]}},raw_data[31:0]}; // lw
        3'b111: processed_data = raw_data;                          // ld
        default: processed_data = {64{1'b0}};
    endcase
end

assign read_data = processed_data;

endmodule
