// alu.v
`timescale 1ns/1ps
`include "params.vh"
module alu (
  output wire zero,
  input [63:0] A,
  input [63:0] B,
  input [3:0] alu_op,
  output reg [63:0] result 
);

localparam OP_AND    = 4'b0000;
localparam OP_ORR    = 4'b0001; // Note: A | XZR = A - therefore OR and Bypass alu do the same thing if XZR is read as B
localparam OP_ADD    = 4'b0010;
localparam OP_SUB    = 4'b0110;
localparam OP_CPZ    = 4'b0111; // for CBZ.

always @(*) begin
case (alu_op) 
    OP_AND: result = A & B;
    OP_ORR: result = 0 | B;
    OP_ADD: result = A+B;
    OP_SUB: result = A-B;
    OP_CPZ: result = B | 64'b0; // compare with B rather than A so we can cmp to a imm or a register rather than just a register
    default: result = 64'b0;
endcase
end

// If result = zero 0=true so ZeroBranch (1) & 1 = 1 so pc mux 
assign zero = (result == 64'b0) ? 1'b1 : 1'b0;

endmodule
