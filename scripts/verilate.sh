#!/bin/bash
verilator --cc --Wall ./testbenches/sim_main.cpp --exe --build --trace -I./src testbenches/cpu_tb.v src/cpu.v --top-module cpu_tb -o sim_cpu --timing
