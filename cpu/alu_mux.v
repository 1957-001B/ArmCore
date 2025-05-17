module alu_mux(
  input wire ALUSrc,
  input [63:0] Read_data_2,

  input [63:0] padded_inst,
  output reg [63:0] B
);

always @(*) begin

  if (ALUSrc == 1) begin 
    B = padded_inst;
  end else if (ALUSrc == 0) begin
    B = Read_data_2;
  end

end

endmodule