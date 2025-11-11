module branch_predictor(
    input wire [31:0] next_instruction,
    input wire [63:0] correct_pc,
    input wire [63:0] current_pc,
    input wire clk,
    input wire reset,
    output wire [63:0] predicted_pc,  // Make this an output
    output wire prediction_failed
);

wire [63:0] pc_plus_imm;
wire [63:0] pc_plus_4;
wire next_prediction;
wire prediction_correct;

immediate_adder imm_add(
    .pc(current_pc),
    .instruction(next_instruction),
    .pc_plus_imm(pc_plus_imm),
    .pc_plus_4(pc_plus_4)
);

predictor predict(
    .instruction(next_instruction),
    .truth(correct_pc != (current_pc + 4)),
    .clk(clk),
    .reset(reset),
    .next_prediction(next_prediction)
);

assign predicted_pc = next_prediction ? pc_plus_imm : pc_plus_4;
assign prediction_correct = (correct_pc == predicted_pc);
assign prediction_failed = ~prediction_correct;

endmodule
