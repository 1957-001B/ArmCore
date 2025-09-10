// control.v
`timescale 10ns/1ns
`include "params.vh"

module control (
  input [31:0] instruction,  

  // Control Bits
  output reg Reg2Loc,
  output reg UncondBranch,
  output reg FlagBranch,
  output reg ZeroBranch,
  output reg MemRead,
  output reg MemToReg,
  output reg MemWrite,
  output reg FlagWrite,
  output reg ALUSrc,
  output reg [1:0] ALUOp, 
  output reg RegWrite,
  output reg UseSP
);

// On init
always @(*) begin 

  Reg2Loc = 1'b0;
  UncondBranch = 1'b0;
  FlagBranch = 1'b0;
  ZeroBranch = 1'b0;
  MemRead = 1'b0;
  MemToReg = 1'b0;
  MemWrite = 1'b0;
  FlagWrite = 1'b0;
  ALUSrc = 1'b0;
  ALUOp = 2'b00;
  RegWrite = 1'b0;
  UseSP = 1'b0;

  if (instruction[31:24] == CBZ_OP) begin // CBZ CBZ <Xt>, <label>
    Reg2Loc = 1'b1;
    ZeroBranch=1'b1;
    ALUOp = 2'b01;
  end else if (instruction[31:26] == B_OP) begin //B <label>
    UncondBranch = 1'b1;
  end else if (instruction[31:23] == MOVZ_OP) begin //MOVZ <Xd>, #<imm>{, LSL #<shift>}
    RegWrite = 1'b1;
  end else if (instruction[31:21] == CMP_OP) begin //CMP <Xn>, <Xm>{, <shift> #<amount>}
    ALUOp = 2'b01;
  end else if (instruction[31:23] == SUB_OP) begin //SUBI <Xd|SP>, <Xn|SP>, #<imm>{, <shift>}
    ALUOp = 2'b10;
    UseSP = 1'b1;
  end else if (instruction[31:23] == ADD_OP) begin //ADD <Xd|SP>, <Xn|SP>, #<imm>{, <shift>}
    ALUOp = 2'b10;
    UseSP = 1'b1;

  end
end

endmodule
