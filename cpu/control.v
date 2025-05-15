// control.v
module control (
  input [31:0] instruction, // what we really want is just the opcode buy it is variable length for the different formats for ARM instructions 

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
  // Setting control bits for each instruction 
  case instruction[31:21] // we are going to assume no shift (hw) now for simplicity and that all ops are 64 bit mode.
    11'b11010010100: begin //MOVZ opc without hw
      RegWrite
    end
    11'110101010000: begin // NOP so we just want to do nothing then increment the PC+4

    
    end

  endcase

end

endmodule
