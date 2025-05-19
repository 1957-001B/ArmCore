// registers.v
module reg_file(
  input clk,
  input wire RegWrite,
  input [4:0] Read_register_1,
  input [4:0] Read_register_2,
  input [4:0] Write_register,
  input [63:0] Write_d,
  input wire Use_SP
  output [63:0] Read_data_1,
  output [63:0] Read_data_2
);

reg [63:0] X [31:0]; // 64 bit registers * 32 (X0-X31)
always @(*) begin
  if (Read_register_1 == 5'd31) begin
    if (UseSP)
      Read_data_1 = SP;   // Use SP if instruction specifies it
    else
      Read_data_1 = 64'b0; // Otherwise, XZR (0)
  end
  else
    Read_data_1 = X[Read_register_1];
end

always @(*) begin
  if (Read_register_2 == 5'd31) begin
    if (UseSP)
      Read_data_2 = SP;   // Use SP if instruction specifies it
    else
      Read_data_2 = 64'b0; // Otherwise, XZR (0)
  end
  else
    Read_data_2 = X[Read_register_2];
end

// if RegWrite begin
//   case (Write_r)
//   0'b0001:  // X0
//   0'b0010:  // X1
//   0'b0011:  // X2
//   endcase
// end

endmodule