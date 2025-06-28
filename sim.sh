# Iverilog for initial design
iverilog \
-g 2005-sv \
-o ./bin/cpu \
./sim/iverilog/cpu_tb.v \
cpu/* 

vvp ./bin/cpu

# Verilator for getting working on real hardware.
