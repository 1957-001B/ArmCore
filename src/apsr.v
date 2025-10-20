// apsr.v
`timescale 10ns/1ns
`include "params.vh"

module apsr (

    input [63:0] result,
    input flagWrite,
    output reg N, Z, C,V
);

// always @(*) begin 
//     N = 0; Z = 0; C = 0; V = 0;
// end
endmodule
