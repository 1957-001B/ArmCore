// registers.v
`timescale 1ns/1ps
module reg_file(
  input clk,
  input reset,
  input wire RegWrite,
  input [4:0] Read_register_1,
  input [4:0] Read_register_2,
  input [4:0] Write_register,
  input [63:0] Write_d,
  input wire UseSP,
  output reg [63:0] Read_data_1,
  output reg [63:0] Read_data_2
);
reg [63:0] X [31:0]; // 64 bit registers * 32 (X0-X31)

always @(*) begin
  if (Read_register_1 == 5'd31) begin
    if (UseSP)
      Read_data_1 = X[31];   // Use SP if instruction specifies it
    else
      Read_data_1 = 64'b0; // Otherwise, XZR (0)
  end else
    Read_data_1 = X[Read_register_1];
end

always @(*) begin
  if (Read_register_2 == 5'd31) begin
    if (UseSP)
      Read_data_2 = X[31];   // Use SP if instruction specifies it
    else
      Read_data_2 = 64'b0; // Otherwise, XZR (0)
  end else
    Read_data_2 = X[Read_register_2];
end

always @(posedge clk) begin 
  if (reset) begin 
    X <= '{default: 64'b0};
  end else if (RegWrite) begin
    // Weird GTKWave bugs causing the register to not update at the right time nothing to do with my logic
    $display(Write_d);
    $display("Time %t | Writing X[%d] <= %h (current X[%d]=%h)",$time, Write_register, Write_d, Write_register, X[Write_register]);
    X[Write_register] <= Write_d;
    /* verilator lint_off BLKSEQ */
    #0.001 X[Write_register] = Write_d;  // tiny blocking delay, doesn't affect logic
end

end

endmodule
