module immediate_gen(input wire [31:0] instruction,
                     output reg [63:0] immediate);

wire [6:0] opcode;
assign opcode = instruction[6:0];

always @(*) begin
    case (opcode)
        // I type
        7'b0010011: begin
                        immediate[11:0] = instruction[31:20];
                        immediate[63:12] = {52{instruction[31]}};
                    end

        7'b0000011: begin
                        immediate[11:0] = instruction[31:20];
                        immediate[63:12] = {52{instruction[31]}};
                    end

        7'b1100111: begin
                        immediate[11:0] = instruction[31:20];
                        immediate[63:12] = {52{instruction[31]}};
                    end
       

        // S type
        7'b0100011: begin
                        immediate[11:5] = instruction[31:25];
                        immediate[4:0]  = instruction[11:7];
                        immediate[63:12] = {52{instruction[31]}};
                    end

        // B type
        7'b1100011: begin
                        immediate[12] = instruction[31];
                        immediate[10:5] = instruction[30:25];
                        immediate[4:1] = instruction[11:8];
                        immediate[11] = instruction[7];
                        immediate[0] = 1'b0;
                        immediate[63:13] = {51{instruction[31]}};
                    end


        // J type
        7'b1101111: begin
                        immediate[20] = instruction[31];
                        immediate[10:1] = instruction[30:21];
                        immediate[11] = instruction[20];
                        immediate[19:12] = instruction[19:12];
                        immediate[0] = 1'b0;
                        immediate[63:21] = {43{instruction[31]}};
                    end


        // U type
        7'b0110111: begin
                        immediate[31:12] = instruction[31:12];
                        immediate[11:0] = 12'b0;
                        immediate[63:32] = {32{instruction[31]}};
                    end

        7'b0010111: begin
                        immediate[31:12] = instruction[31:12];
                        immediate[11:0] = 12'b0;
                        immediate[63:32] = {32{instruction[31]}};
                    end
        default: immediate = 64'b0;
    endcase
end
endmodule


