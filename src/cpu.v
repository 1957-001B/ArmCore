// cpu.v 
`timescale 10ns/1ns
`include "params.vh"

module cpu (
    input wire clk,
    input wire reset,
    input wire test_halt,
    output reg [63:0] pc,
    output reg halted
  );

// Will be set by the bootloader
localparam INITPC =  64'h0;
// localparam INITSP = 1000;

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
wire [63:0] Read_mem_d;
wire [63:0] Write_mem_d;

// Register File 
wire [4:0] Read_register_1;
wire [4:0] Read_register_2;

assign Read_register_1 = instruction[9:5];
assign Read_register_2 = Reg2Loc ? instruction[20:16] : instruction[4:0];

wire [4:0] Write_register;

assign Write_register = instruction[4:0];

wire [63:0] Write_d;
wire [63:0] alu_result;

assign Write_d = MemToReg ? alu_result : Read_mem_d;

wire [63:0] Read_data_1;
wire [63:0] Read_data_2;

// APSR
wire N, Z, C, V;
// Alu
wire alu_zero;
wire mod_flags; //not sure if I will input flag branches
wire [63:0] alu_mux;
assign alu_mux = ALUSrc ? Read_data_2 : padded_imm;

// Alu Control
wire [3:0] alu_op;

// Module Instantiation
control u_control (
    .instruction     (instruction),
    // Control flags
    .Reg2Loc         (Reg2Loc),
    .UncondBranch    (UncondBranch),
    .FlagBranch      (FlagBranch),
    .ZeroBranch      (ZeroBranch),
    .MemRead         (MemRead),
    .MemToReg        (MemToReg),
    .MemWrite        (MemWrite),
    .FlagWrite       (FlagWrite),
    .ALUSrc          (ALUSrc),
    .ALUOp           (ALUOp),
    .RegWrite        (RegWrite),
    .UseSP           (UseSP)
);

apsr u_apsr (
    .result       (result),
    .flagWrite    (flagWrite),
    .N            (N),
    .Z            (Z),
    .C            (C),
    .V            (V)
);

alu u_alu (
    .zero      (zero),
    .A         (A),
    .B         (B),
    .alu_op    (alu_op),
    .result    (result)
);

alu_control u_alu_control (
    .instruction    (instruction), // Instruction [31:22]
    .ALUOp          (ALUOp), //from control unit
    .alu_op         (alu_op) //to alu
);

pad u_pad (
    .instruction    (instruction),
    .padded_inst    (padded_inst)
);


//  PC logic
wire [63:0] pc_norm, pc_jump, pc_mux;
wire pc_select;

assign pc_norm = pc + 4;
assign pc_jump = pc + (padded_imm << 2);
assign pc_select = UncondBranch | FlagBranch | (ZeroBranch & alu_zero);
assign pc_mux = pc_select ? pc_jump : pc_norm;

// PC and halt logic
always @(posedge clk or posedge reset) begin
    if (reset) begin
      // Reset signal driven by tb 
      pc <= INITPC;
      halted <= 1b'0;
    end else if (halted) begin  
      pc <= pc;
    end else if (test_halt) begin
    // Halt when test_halted is high
      pc <= pc;
    end else if (req_halt) begin 
      halted <= 1b'1;
      pc <= pc;
    end else begin
      // Normal Operation
      pc <= pc_mux;
    end
  end

endmodule
