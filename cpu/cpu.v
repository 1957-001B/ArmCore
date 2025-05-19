// cpu.v

module cpu (
    input clk,
    input reset,
    output reg [63:0] pc,
    output wire halted
  );

localparam INITSP =  1000; // set by the bootloader
localparam INITPC =  64'h0000000000000000;
// Wires definitions
wire [31:0] instruction;
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
//Alu
wire alu_zero;
wire [3:0] alu_op;
wire [63:0] pc_norm, pc_jump;
wire mod_flags; //not sure if I will input flag branches

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

alu alu(
  .zero(alu_zero)
  .input1(Read_data_1)
  .input2(alu_mux)
);

//  PC logic
wire [63:0] pc_norm, pc_jump;
assign pc_select = UncondBranch | FlagBranch | (ZeroBranch && alu_zero)
assign pc_mux = pc_select ? pc_norm : pc_jump

always @(posedge clk or posedge reset) begin
    if (reset) begin
      // Initialize 
      pc <= INITPC;
      X[31] <= INITSP;

      end else if (!halted) begin  
        pc_mux;
      end
    end 

endmodule