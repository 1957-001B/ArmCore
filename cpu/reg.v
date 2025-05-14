// registers.v

module reg(
  input clk,
  input [63:0] data_in,
  input [4:0] addr_write,
  input [9:5] addr_read
  input wire RegWrite
);
reg [63:0] X [30:0]; // 64 bit registers 32  


endmodule



