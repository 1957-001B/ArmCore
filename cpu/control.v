// control.v
module control (
  input [31:0] instuction,

  output wire UncondBranch,
  output wire FlagBranch,
  output wire ZeroBranch,
  output wire MemRead,
  output wire MemToReg,
  output wire MemWrite,
  output wire FlagWrite,
  output wire ALUSrc,
  output wire ALUOp,
  output wire RegWrite

);

  wire [10:0] opcode_r_d = instruction[31:21]; // R-type, D-type, SVC
  wire [9:0]  opcode_i = instruction[31:22];   // I-type
  wire [8:0]  opcode_mov = instruction[31:23]; // MOVZ, MOVK
  wire [7:0]  opcode_cb = instruction[31:24];  // CB-type
  wire [5:0]  opcode_b = instruction[31:26];   // B-type

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

  case (opcode_mov)
    7'b1101001: begin //movz 
        RegWrite = 1'b1

  end

end

endmodule
