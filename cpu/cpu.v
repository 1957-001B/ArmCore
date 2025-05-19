// cpu.v

module cpu (
    input clk,
    input reset,
    output reg [63:0] pc,
    output wire halted
  );
//Opcodes defined here unshifted for simplicity 
localparam CBZ_OP  = 8'b10110100;    // CBZ: Bits 31:24
localparam MOVZ_OP = 9'b110100101;   // MOVZ: Bits 31:21 (hw = 00, no shift)
localparam CMP_OP  = 11'b11101011001; // CMP (SUBS reg): Bits 31:21 (sh = 0)
localparam SUB_OP  = 9'b110100010;   // SUB (imm): Bits 31:23 (sf = 1, S = 0)
localparam ADD_OP  = 9'b100100010;   // ADD (imm): Bits 31:23 (sf = 1, S = 0)
localparam B_OP    = 6'b000101;      // B: Bits 31:26
// set by the bootloader
localparam INITPC =  64'h0;
// Wires definitions
wire [31:0] instruction;
// Sign Extend / Pad
wire [63:0] padded_imm;
//Control Unit
wire Reg2Loc;
wire UncondBranch;
wire FlagBranch;
wire ZeroBranch;
wire MemRead;
wire MemToReg;
wire MemWrite;
wire FlagWrite;
wire ALUSrc;
wire [1:0] ALUOp;
wire RegWrite;
// Register File 
wire [4:0] Read_register_1;
wire [4:0] Read_register_2;
assign Read_register_1 = instruction[9:5];
assign Read_register_2 = Reg2Loc ? instruction[20:16] : instruction[4:0];
wire Write_register;
wire [63:0] Write_d;
wire Read_data_1;
wire Read_data_2;
//Alu
wire alu_zero;
wire [3:0] alu_op;
wire mod_flags; //not sure if I will input flag branches
assign alu_mux = ALUSrc ? Read_data_2 : padded_imm;
// Alu Control
wire [3:0] alu_op;

// Output the current instruction at the PC.
imem instruction_memory(
  .pc(pc),
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
alu_control aluctrl(
  .instruction(instrucion),
  .ALUOp(ALUOp),
  .alu_op(alu_op)
);

alu alu(
  .zero(alu_zero),
  .A(Read_data_1),
  .B(alu_mux),
  .alu_op(alu_op)
);

//  PC logic
wire [63:0] pc_norm, pc_jump;
assign pc_select = UncondBranch | FlagBranch | (ZeroBranch && alu_zero)
assign pc_mux = pc_select ? pc_norm : pc_jump

always @(posedge clk or posedge reset) begin
    if (reset) begin
      pc <= INITPC;
      registers.X[31] <= INITSP;

      end else if (!halted) begin  
        pc <= pc_mux;
      end
    end 

endmodule