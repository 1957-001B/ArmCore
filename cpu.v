// cpu.v
// Minimal Armv8 cpu
// Initially single cycle and then a basic pipeline 

module cpu (
    input clk,
    input reset,

    output reg [63:0] pc,
    output reg [63:0] sp
);

  wire [31:0] instruction;
    // Basic ARMv8 PC incrementer (placeholder)
    always @(posedge clk or posedge reset) begin
        if (reset)
            pc <= 0;
            sp <= 0;
        else
            pc <= pc + 4; // Increment PC by 4 (ARMv8 instruction size)
            sp <= pc + 4; 
    end

    // control_unit control_unit_instance (
    //   // UncondBranch()
    //   // FlagBranch()
    //   // ZeroBranch()
    //   // MemRead()
    //   // MemToReg()
    //   // MemWrite()
    //   // FlagWrite()
    //   // ALUSrc
    //   // ALUOp(alu)
    //   // RegWrite(registers)
    // )

endmodule
