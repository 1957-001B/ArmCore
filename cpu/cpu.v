// cpu.v

module cpu (
    input clk,
    input reset,
    output reg [63:0] pc,
    output wire halted
  );

localparam INITSP =  1000; // set by the bootloader
localparam INITPC =  64'h0000000000000000;
wire [31:0] instruction;

imem instruction_memory(
  .address(pc),
  .instruction(instruction)
);

control control_unit(
  .instruction(instruction),
  .UncondBranch(UncondBranch),
  .FlagBranch(FlagBranch),
  .ZeroBranch(ZeroBranch),
  .MemRead(MemRead),
  .MemToReg(MemToReg),
  .MemWrite(MemWrite),
  .FlagWrite(FlagWrite),
  .ALUSrc(ALUSrc),
  .ALUOp(ALUOp),
  .RegWrite(RegWrite)
);

reg_file registers( 
  .RegWrite(RegWrite),
  .Read_register_1(Read_register_1),
  .Read_register_2(Read_register_2),
  .Write_register(Write_register),
  .Write_d(Write_d),
  .Read_data_1(Read_data_1),
  .Read_data_2(Read_data_2)
);

alu alu(
  .zero()
  .input1(Read_data_1)
  .input2()
);


// Basic ARMv8 PC incrementer (placeholder)
always @(posedge clk or posedge reset) begin
    if (reset) begin
      // Initialize cpu
      pc<= INITPC;
      X[31] <= INITSP;

      end
    else if (!halted) begin
      if (!UncondBranch && !FlagBranch && !ZeroBranch)

        pc<= pc + 4; // Increment PC by 4 (ARMv8 instruction size)
      end
      // else begin 
      //   case ({UncondBranch, ZeroBranch, FlagBranch})
          
      // end
  end

endmodule