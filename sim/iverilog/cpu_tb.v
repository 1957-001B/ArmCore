// cpu_tb.v
// example testbed
`timescale 1ns/1ps
module cpu_tb;
    // Inputs to CPU
    reg clk;
    reg reset;
    // Outputs from CPU
    wire [63:0] pc;
    wire halted; // No assign=0; here—let CPU drive it if it's an output

    // Instantiate CPU
    cpu uut (
        .clk(clk),
        .reset(reset),
        .pc(pc),
        .halted(halted)
    );

    // Clock generation
    always #5 clk = ~clk; // 100 MHz clock (10ns period)

    initial begin
        $dumpfile("./debug/cpu.vcd");
        $dumpvars(0, cpu_tb); // Dumps all signals—use GTKWave to inspect internals

        clk = 0;
        reset = 1; // Assert reset high to initialize PC and other state
        $display("Simulation start: Asserting reset");

        #15; // Hold reset for >1 clock cycle (covers a posedge clk)
        reset = 0;
        $display("Reset deasserted—CPU should start fetching from PC=0");

        // Run for more cycles to observe execution
        #200; // 20 clock cycles—adjust as needed

        // Finish simulation
        $display("Simulation end: PC final value = %h, halted = %b", pc, halted);
        $finish;
    end

    // Monitor outputs (added halted and fetched instruction for better visibility)
    initial
        $monitor("Time=%0t clk=%b reset=%b pc=%h halted=%b ",
                 $time, clk, reset, pc, halted); // Adjust path to imem if different

endmodule