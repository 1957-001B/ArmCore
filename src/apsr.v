// apsr.v
`timescale 10ns/1ns
`include "params.vh"

module apsr (
    input FlagWrite,
    input [63:0] Result
    output reg N, Z, C,V
);

always @(*) begin 
    N = 0; Z = 0; C = 0; V = 0;
end
endmodule