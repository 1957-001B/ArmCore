#include "Vcpu_tb.h"
#include "verilated.h"
#include "verilated_vcd_c.h"    // for vcd tracing

int main(int argc, char** argv) {
    // Parse command-line args
    Verilated::commandArgs(argc, argv);

    // Create context
    VerilatedContext* contextp = new VerilatedContext;
    contextp->commandArgs(argc, argv);

    // Enable tracing
    Verilated::traceEverOn(true);

    // Instantiate DUT
    Vcpu_tb* top = new Vcpu_tb{contextp};

    // --- TRACING SETUP ---
    VerilatedVcdC* tfp = new VerilatedVcdC;           // VCD object
    top->trace(tfp, 99);                              // Trace all signals (99 levels deep)
    tfp->open("waveform.vcd");                        // Open file
    // ---------------------

    // Simulation loop
    while (!contextp->gotFinish()) {
        top->eval();           // Evaluate model
        tfp->dump(contextp->time());  // Dump current time
        contextp->timeInc(1);  // Advance time by 1 (unit depends on timescale)
    }

    // Close VCD
    tfp->close();
    delete tfp;

    // Cleanup
    delete top;
    delete contextp;
    return 0;
}