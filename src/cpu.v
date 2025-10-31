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
// wire FlagWrite;
wire ALUSrc;
wire [1:0] ALUOp;
wire RegWrite;
wire UseSP;
reg req_halt;

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
// wire N, Z, C, V;
// Alu
wire alu_zero;
wire zero;

wire [63:0] address;
wire [63:0] A;
wire [63:0] B;
wire [63:0] result;

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
    // .FlagWrite       (FlagWrite),
    .ALUSrc          (ALUSrc),
    .ALUOp           (ALUOp),
    .RegWrite        (RegWrite),
    .UseSP           (UseSP),
    .req_halt        (req_halt)
);
imem u_imem (
    .pc             (pc),
    // reads from PC
    .instruction    (instruction),
    // reads from memory the instruction 
    .reset          (reset)
);

dmem u_dmem (
    .clk         (clk),
    .address     (address),
    .MemWrite    (MemWrite),
    .MemRead     (MemRead),
    .Write_d     (Write_mem_d),
    .Read_d      (Read_mem_d)
);

// probably outside the current scope of the project
// apsr u_apsr (
//     .result       (result),
//     .FlagWrite    (FlagWrite),
//     .N            (N),
//     .Z            (Z),
//     .C            (C),
//     .V            (V)
// );

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
    .padded_imm (padded_imm)
);

reg_file u_reg_file (
    .clk                (clk),
    .reset              (reset),
    .RegWrite           (RegWrite),
    .Read_register_1    (Read_register_1),
    .Read_register_2    (Read_register_2),
    .Write_register     (Write_register),
    .Write_d            (Write_d),
    .UseSP              (UseSP),
    .Read_data_1        (Read_data_1),
    .Read_data_2        (Read_data_2)
);



//  PC logic
wire [63:0] pc_norm, pc_jump, pc_mux;
wire pc_select;

assign pc_norm = pc + 4;
assign pc_jump = pc + (padded_imm << 2); // padded_imm LSL 2
assign pc_select = UncondBranch | FlagBranch | (ZeroBranch & alu_zero); // If any branches then pc_mux is set to jump
assign pc_mux = pc_select ? pc_jump : pc_norm;

always @(posedge clk or posedge reset) begin
    if (reset) begin
      // Reset signal driven by tb 
      pc <= INITPC;
      halted <= 1'b0;
    end else if (halted) begin  
      pc <= pc;
    end else if (test_halt) begin
    // Halt when test_halted is high this is a temporary hold triggered by the tb
      pc <= pc;
    end else if (req_halt) begin 
      halted <= 1'b1;
      pc <= pc;
    end else begin
      // Normal Operation
      pc <= pc_mux;
    end
  end

endmodule
