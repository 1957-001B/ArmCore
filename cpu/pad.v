// pad.v
`include "params.vh"

module pad (
  input wire [31:0] instruction,
  output reg [63:0] padded_inst
);

always @(*) begin 
  if (instruction[31:21] == 9'b110100101) begin // MOVZ <Xd>, #<imm>{, LSL #<shift>}
    padded_inst = {48'b0, instruction[20:5]};
  end else if (instruction[31:23] == 9'b110100010) begin // SUBI <Xd|SP>, <Xn|SP>, #<imm>{, <shift>}
    padded_inst = {52'b0, instruction[20:5]};
  end else if (instruction[31:23] == 9'b100100001) begin // ADDI <Xd|SP>, <Xn|SP>, #<imm>{, <shift>}
    padded_inst = {52'b0, instruction[20:5]};
  end else begin
    padded_inst = 64'b0;
  end
end

endmodule