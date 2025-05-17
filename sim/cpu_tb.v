// cpu_tb.v
// example testbed
`timescale 1ns/1ps
module cpu_tb;
    // Inputs to CPU
    reg clk;
    reg reset;
    // Outputs from CPU
    wire [63:0] pc;
    wire [63:0] sp;
    wire [9:0] opcode;

    // Instantiate CPU
    cpu uut (
        .clk(clk),
        .reset(reset),
        .pc(pc)
    );

    // Clock generation
    always #5 clk = ~clk; // 100 MHz clock (10ns period)

    // Test stimulus
    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;

        // Dump waveform for debugging
        $dumpfile("wave.vcd");
        $dumpvars(0, cpu_tb);

        // Apply reset
        #20 reset = 0; // Release reset after 20ns

        // Run for a few cycles
        #100;

        // Finish simulation
        $finish;
    end

    // Monitor outputs
    initial
        $monitor("Time=%0t clk=%b reset=%b pc=%h sp=%h", $time, clk, reset, pc, sp);
endmodule
