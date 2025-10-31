// pad.v
`timescale 1ns/1ps
`include "params.vh"

module pad (
  input wire [31:0] instruction,
  output reg [63:0] padded_imm
);
// Figure out what bitfield needs to be padded. e.g mov instruction the mov_imm field needs to be padded before entering ALU mux
always @(*) begin 
  if (instruction[31:23] == 9'b110100101) begin // MOVZ <Xd>, #<imm>{, LSL #<shift>}
    padded_imm = {48'b0, instruction[20:5]};
  end else if (instruction[31:23] == 9'b110100010) begin // SUBI <Xd|SP>, <Xn|SP>, #<imm>{, <shift>}
    padded_imm = {48'b0, instruction[20:5]};
  end else if (instruction[31:23] == 9'b100100001) begin // ADDI <Xd|SP>, <Xn|SP>, #<imm>{, <shift>}
    padded_imm = {48'b0, instruction[20:5]};
  end else begin
    padded_imm = 64'b0;
  end
end

endmodule
