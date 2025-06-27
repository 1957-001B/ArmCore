// cpu_tb.v
// example testbed
`timescale 1ns/1ps
module cpu_tb;
    // Inputs to CPU
    reg clk;
    reg reset;
    // Outputs from CPU
    wire [63:0] pc;
    wire [9:0] opcode;
    wire halted;
    assign halted = 0;
    // Instantiate CPU
    cpu uut (
        .clk(clk),
        .reset(reset),
        .pc(pc),
        .halted(halted)
    );

    // Clock generation
    always #5 clk = ~clk; // 100 MHz clock (10ns period)

    // Test stimulus

    reset = 1;
    initial begin
        $dumpfile("./debug/cpu.vcd");
        $dumpvars(0, cpu_tb);

        clk = 0;

        reset = 0;

        // Run for a few cycles
        #50;

        // Finish simulation
        $finish;
    end

    // Monitor outputs
    initial
        $monitor("Time=%0t clk=%b reset=%b pc=%h ", $time, clk, reset, pc);
endmodule