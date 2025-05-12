Goal: 
- Create a core that runs something in between armV7 and armv8 to work with this [assembler](https://www.github.com/1957-001B/armasm) I wrote in rust.
- Learn how cpu works and DSP works using DSP slices for MUL on the cpu.
- Sythesize, program, and run the program on [real hardware](https://digilent.com/shop/arty-a7-100t-artix-7-fpga-development-board/) 

Inputs:

MOVZ X8, #0x4 => d2800088
MOVZ X0, #0x1 => d2800020
LDR X1, =message => 58000081
MOVZ X2, #0xD => d28001a2
SVC #0x0 => d4000001
MOVZ X8, #0x1 => d2800028
MOVZ X0, #0x0 =>  d2800000
SVC #0x0 =>  d4000001