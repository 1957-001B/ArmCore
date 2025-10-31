//dmem.v
`timescale 1ns/1ps
`include "params.vh"
module dmem (
    input clk,
    input [63:0] address,
    input wire MemWrite,
    input wire MemRead,
    input [63:0] Write_d,
    output reg [63:0] Read_d
);

localparam MEMSIZE = 1024;
reg [63:0] d_mem [0:MEMSIZE-1];

always @(posedge clk) begin
  if (MemWrite) begin
    d_mem[address[11:2]] <= Write_d;
  end
end

always @(posedge clk) begin 
  if (MemRead) begin 
    Read_d <= d_mem[address[11:2]];
  end else begin
    Read_d <= 64'b0;
  end

end
endmodule
