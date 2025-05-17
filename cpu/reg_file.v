// registers.v
module reg_file(
  input clk,
  input wire RegWrite,
  input [3:0] Read_register_1,
  input [3:0] Read_register_2,
  input [4:0] Write_register,
  input [63:0] Write_d,
  output [4:0] Read_data_1,
  output [4:0] Read_data_2
);

reg [63:0] X [31:0]; // 64 bit registers * 32 (X0-X31)

case (Read_register_1)
    4'b0000: X0
endcase
// if RegWrite begin
//   case (Write_r)
//   0'b0001:  // X0
//   0'b0010:  // X1
//   0'b0011:  // X2
//   endcase
// end

endmodule