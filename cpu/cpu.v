// cpu.v

module cpu (
    input clk,
    input reset,
    input wire [31:0] instruction,
    output reg [63:0] pc,
    output reg [63:0] sp,
    output wire halted
  );
  localparam INITSP =  1000; // set by the bootloader

  wire [9:0] opcode = instruction[31:21];
  // Ctrl
  

  // Basic ARMv8 PC incrementer (placeholder)
  always @(posedge clk or posedge reset) begin
      if (reset)begin

        pc <= 0;
        sp <= INITSP;

        end
      else if (!halted) begin

        pc <= pc + 4; // Increment PC by 4 (ARMv8 instruction size)

        end
    end

control ctrl (
    .opcode(opcode),
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


endmodule
