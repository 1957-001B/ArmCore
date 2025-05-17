`timescale 100ps / 1ps
module alu_tb;
    // Testbench signals
    reg [63:0] A, B;          // Inputs
    reg [3:0] alu_op;         // ALU operation
    wire [63:0] result;       // Output result
    wire zero;                // Zero flag

    // Instantiate the ALU
    alu uut (
        .A(A),
        .B(B),
        .alu_op(alu_op),
        .result(result),
        .zero(zero)
    );

    // Clock generation (optional for combinational ALU)
    reg clk;
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns period
    end

    // Test stimulus
    initial begin
        // Initialize inputs
        A = 64'b0;
        B = 64'b0;
        alu_op = 4'b0;

        // Open VCD file for waveform viewing
        $dumpfile("alu_tb.vcd");
        $dumpvars(0, alu_tb);

        // Test cases
        #1; // Wait for initial stabilization
        // Test AND: 0xF0F0 & 0x0F0F = 0x0000
        A = 64'hF0F0; B = 64'h0F0F; alu_op = 4'b0000;
        #1;
        // Test ORR: 0xF0F0 | 0x0F0F = 0xFFFF
        A = 64'hF0F0; B = 64'h0F0F; alu_op = 4'b0001;
        #1;
        // Test ADD: 5 + 3 = 8
        A = 64'd5; B = 64'd3; alu_op = 4'b0010;
        #1;
        // Test ADD: 0 + 0 = 0 (check zero flag)
        A = 64'd0; B = 64'd0; alu_op = 4'b0010;
        #1;
        // Test SUB: 5 - 5 = 0 (check zero flag)
        A = 64'd5; B = 64'd5; alu_op = 4'b0110;
        #1;
        // Test SUB: 3 - 5 = -2
        A = 64'd3; B = 64'd5; alu_op = 4'b0110;
        #1;
        // Test MOV: MOV X0, X1 (A = 42, B = 0, ORR) -> result = 42
        A = 64'd42; B = 64'd0; alu_op = 4'b0001;
        #1;
        // Test MOVZ: MOVZ X0, #1 -> result = 1
        A = 64'd0; B = 64'd1; alu_op = 4'b0001;
        #1;
        // Test invalid op (default case)
        A = 64'd10; B = 64'd20; alu_op = 4'b1111;
        #1;
        // should do A | 0 and return non zero thus not enabling the zero flag from the ALU
        A = 64'd10; B = 64'd0; alu_op = 4'b0111;         
        #1;
        //test CBZ branch works in the alu
        A = 64'd0; B = 64'd0; alu_op = 4'b0111;        
        #1;

        // End simulation
        $display("Test completed");
        $finish;
    end

    // Monitor outputs
    initial begin
        $monitor("Time=%0t A=%h B=%h alu_op=%b result=%h zero=%b",
                 $time, A, B, alu_op, result, zero);
    end
endmodule
