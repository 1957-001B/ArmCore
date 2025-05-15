// alu.v
module alu (
    output wire zero,
    input [63:0] input1
    input [63:0] input2
    input [3:0] alu_op
    output result [31:0]

);

case alu_op

endcase
assign zero = 0;

endmodule