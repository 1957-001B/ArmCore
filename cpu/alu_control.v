module alu_control (
    input [31:0] instruction,
    input [1:0] ALUOp, // ALU control will only send a signal when the ALUOp flag is set 
    output reg [3:0] alu_op
)

// decode opcode and send a signal to the alu if ALUOp singal is enabled
always @(*) begin
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
    alu_op = 4'b0110;
  end else if (instruction[31:23] == 9'b110100010) begin // SUBI <Xd|SP>, <Xn|SP>, #<imm>{, <shift>}
    alu_op = 4'b0110;
  end else if (instruction[31:23] == 9'b100100001) begin // ADDI <Xd|SP>, <Xn|SP>, #<imm>{, <shift>}
    alu_op = 4'b0010;
  end
  end
  default: 4'b0000;

endcase

end

endmodule