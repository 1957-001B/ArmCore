module pad (
  input [31:0] instruction,
  output [63:0] padded_inst
)
always @(*) begin
  if instruction[31:0]


case (ALUOp)

  2'b01: begin // branch operations 
    if (instruction[31:24] == 8'b10110100) begin // CBZ CBZ <Xt>, <label>
      alu_op = 4'b0111;
    end
  end

  2'b10: begin 
  if (instruction[31:21] == 9'b110100101) begin //MOVZ MOVZ <Xd>, #<imm>{, LSL #<shift>}
    alu_op = 4'b0001;
  end else if (instruction[31:24] == 8'b11101011) begin //CMP CMP <Xn>, <Xm>{, <shift> #<amount>}
  end else if (instruction[31:23] == 9'b110100010) begin // SUBI <Xd|SP>, <Xn|SP>, #<imm>{, <shift>}
  end

  end
  default: 2'b00;

endcase
end
endmodule