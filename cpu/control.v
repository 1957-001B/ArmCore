// control.v
module control (
  input [31:0] instruction,  

  // Control Bits
  output wire UncondBranch,
  output wire FlagBranch,
  output wire ZeroBranch,
  output wire MemRead,
  output wire MemToReg,
  output wire MemWrite,
  output wire FlagWrite,
  output wire ALUSrc,
  output wire [1:0] ALUOp, // this is wide not one bit
  output wire RegWrite
);

// On start
always @(*) begin 

  Reg2Loc = 1'b0
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

  if (instruction[31:24] == 8'b10110100) begin // CBZ CBZ <Xt>, <label>
    Reg2Loc = 1'b1;
    ZeroBranch=1'b1;
    ALUOp = 2'b01;
  end else if (instruction[31:26] == 6'b000101) begin //B B <label>
    UncondBranch = 1'b1;
  end else if (instruction[31:21] == 9'b110100101) begin //MOVZ MOVZ <Xd>, #<imm>{, LSL #<shift>}
    RegWrite = 1'b1;
  end else if (instruction[31:24] == 8'b11101011) begin //CMP CMP <Xn>, <Xm>{, <shift> #<amount>}
    ALUOp = 2'b01;
  end else if (instruction[31:23] == 9'b110100010) begin // SUBI <Xd|SP>, <Xn|SP>, #<imm>{, <shift>}
    ALUOp = 2'b10;
  end

end

endmodule
