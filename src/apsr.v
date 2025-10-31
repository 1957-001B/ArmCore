// apsr.v
`timescale 10ns/1ns
`include "params.vh"

module apsr (

    input [63:0] result,
    input FlagWrite,
    output reg N, Z, C,V
);
/* Chanings the N Z C V flags requires implementing System registers 
and using MRS for read and MSR for writing instrutions to system registers
*/

// always @(*) begin 
//     N = 0; Z = 0; C = 0; V = 0;
// end
endmodule
