# Movement Ops
MOVZ X0, #0x1
MOVZ X1, #0x0
MOVZ X29, #0x15
MOVZ SP, #0x15
MOVZ SP, PC

# Arithmetic Ops
ADDI X3, #0x1


# Compare and Branch Ops
CMP X0,X1,X4
CBZ X4, #<address>

B #<address>