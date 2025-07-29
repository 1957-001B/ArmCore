// cpu.v `timescale 10ns/1ns
`include "params.vh"

module cpu (
    input clk,
    input reset,
    output reg [63:0] pc,
    output wire halted
  );

// set by the bootloader
localparam INITPC =  64'h0;
localparam INITSP = 1000;

assign halted = 0;

// Wires definitions
// Instruction Memory
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
wire UseSP;

// Data Memory
wire [63:0] Read_d;

// Register File 
wire [4:0] Read_register_1;
wire [4:0] Read_register_2;
assign Read_register_1 = instruction[9:5];
assign Read_register_2 = Reg2Loc ? instruction[20:16] : instruction[4:0];
wire [4:0] Write_register;
assign Write_register = instruction[4:0];
wire [63:0] Write_d;
wire [63:0] alu_result;
assign Write_d = MemToReg ? alu_result : Read_d;
wire [63:0] Read_data_1;
wire [63:0] Read_data_2;

//Alu
wire alu_zero;
wire mod_flags; //not sure if I will input flag branches
wire [63:0] alu_mux;
assign alu_mux = ALUSrc ? Read_data_2 : padded_imm;

// Alu Control
wire [3:0] alu_op;

// Output the current instruction at the PC.
imem instruction_memory(
  .pc(pc),
  .instruction(instruction),
  .reset(reset)
);

dmem data_memory(
  .clk(clk),
  .address(alu_result),
  .MemWrite(MemWrite),
  .MemRead(MemRead),
  .Read_d(Read_d)
);

control control_unit(
  .instruction(instruction),
  .Reg2Loc(Reg2Loc),
  .UncondBranch(UncondBranch),
  .FlagBranch(FlagBranch),
  .ZeroBranch(ZeroBranch),
  .MemRead(MemRead),
  .MemToReg(MemToReg),
  .MemWrite(MemWrite),
  .FlagWrite(FlagWrite),
  .ALUSrc(ALUSrc),
  .ALUOp(ALUOp),
  .RegWrite(RegWrite),
  .UseSP(UseSP)
);

reg_file registers( 
  .clk(clk),
  .reset(reset),
  .RegWrite(RegWrite),
  .Read_register_1(Read_register_1),
  .Read_register_2(Read_register_2),
  .Write_register(Write_register),
  .Write_d(Write_d),
  .Read_data_1(Read_data_1),
  .Read_data_2(Read_data_2),
  .UseSP(UseSP)
);

pad pad(
  .instruction(instruction),
  .padded_inst(padded_imm)
);

alu_control aluctrl(
  .instruction(instruction),
  .ALUOp(ALUOp),
  .alu_op(alu_op)
);

alu alu(
  .zero(alu_zero),
  .A(Read_data_1),
  .B(alu_mux),
  .alu_op(alu_op),
  .result(alu_result)
);

//  PC logic
wire [63:0] pc_norm, pc_jump, pc_mux;
wire pc_select;

assign pc_norm = pc + 4;
assign pc_jump = pc + (padded_imm << 2);
assign pc_select = UncondBranch | FlagBranch | (ZeroBranch & alu_zero);
assign pc_mux = pc_select ? pc_jump : pc_norm;

always @(posedge clk or posedge reset) begin
    if (reset) begin
      pc <= INITPC;
      end else if (!halted) begin  
        pc <= pc_mux;
      end
    end 

endmodule
