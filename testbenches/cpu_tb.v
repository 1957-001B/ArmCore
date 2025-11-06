`timescale 1ns/1ps
`include "../src/params.vh"

module cpu_tb;
    logic clk, reset, halted, test_halt;
    logic [63:0] pc;

    cpu cpu_inst (
        .clk(clk),
        .reset(reset),
        .pc(pc),
        .halted(halted),
        .test_halt(test_halt)
    );

    // 100 MHz clock
    initial begin
        clk = 1;
        forever #5 clk = ~clk;
    end

    // Stimulus + auto-halt
    initial begin
        reset = 1;
        #20 reset = 0;
        test_halt = 0;
    end

    // Auto-stop on halt
    always @(posedge clk) begin
        if (halted) begin
            $display("CPU halted at time %t, PC = 0x%h", $time, pc);
            #10 $finish;
        end
    end

    // Optional: timeout
    initial begin
        #10000 $display("Timeout: no halt after 10us");
        $finish;
    end

endmodule
