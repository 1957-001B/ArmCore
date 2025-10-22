#include "Vcpu.h"
#include "verilated.h"

int main(int argc, char** argv){
    VerilatedContext* contextp = new VerilatedContext;
    contextp->commandArgs(argc, argv);
    Vcpu* top = new Vcpu{contextp};
    while (!contextp->gotFinish()) { top->eval(); }
    delete top;
    delete contextp;
    return 0;
}}