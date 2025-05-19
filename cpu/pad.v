module pad (
  input [31:0] instruction,
  output [63:0] padded_inst
)
always @(*) begin // here we hardcode for each instruction where to look for the imm because we have I, R instrucions of variable format.
  if (instruction[31:24] == 8'b10110100) begin // CBZ CBZ <Xt>, <label>

  end else if (instruction[31:26] == 6'b000101) begin //B B <label>

  end else if (instruction[31:21] == 9'b110100101) begin //MOVZ MOVZ <Xd>, #<imm>{, LSL #<shift>}

  end else if (instruction[31:24] == 8'b11101011) begin //CMP CMP <Xn>, <Xm>{, <shift> #<amount>}

  end else if (instruction[31:23] == 9'b110100010) begin // SUBI <Xd|SP>, <Xn|SP>, #<imm>{, <shift>}
    ALUOp = 2'b10;
  end


  case (instruction())

end
endmodule