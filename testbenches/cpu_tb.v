`timescale 1ns/1ps
`include "params.vh"

module cpu_tb;
    // Testbench signals
    logic clk;
    logic reset;
    logic [63:0] pc;
    logic halted;
    logic test_halt;

    // Internal signals for monitoring
    // wire [31:0] instruction;
    // wire [63:0] alu_result;
    // wire [63:0] read_data_1;
    // wire [63:0] read_data_2;
    // wire [63:0] padded_imm;
    // wire alu_zero;

    // Instantiate CPU
    cpu cpu_inst (
        .clk(clk),
        .reset(reset),
        .pc(pc),
        .halted(halted),
        .test_halt(test_halt)
    );

    // Clock generation: 100MHz (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test stimulus
    initial begin
        // Initialize waveform dump
        $dumpfile("sim/waveform.vcd");
        $dumpvars(0, cpu_tb);

        // Reset sequence
        reset = 1;
        #20 reset = 0;
        test_halt = 0;

        // Run simulation for 200 cycles
        repeat (200) @(posedge clk);

        // Check if halted
        if (halted)
            $display("CPU halted at time %t, PC: %h", $time, pc);
        else
            $display("Simulation ended at time %t, PC: %h", $time, pc);

        // End simulation
        $finish;
    end

    // Monitor key signals
    // always @(posedge clk) begin
    //     if (!reset) begin
    //         $display("Time: %t, PC: %h, Instruction: %h, ALU Result: %h, Read Data 1: %h, Read Data 2: %h, Zero: %b",
    //                  $time, pc, cpu_inst.instruction, cpu_inst.alu_result, 
    //                  cpu_inst.read_data_1, cpu_inst.read_data_2, cpu_inst.alu_zero);
    //     end
    // end

    // Assertion to check x0 is always zero (ARMv8-A requirement)
    // always @(posedge clk) begin
    //     assert(cpu_inst.registers.read_data_1 == 64'h0 || cpu_inst.read_register_1 != 5'h0)
    //     else $error("x0 is not zero when read_register_1 is 0 at time %t!", $time);
    // end
endmodule
