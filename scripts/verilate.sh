#!/bin/bash

verilator --cc --exe --build --trace \
    -I./src \
    testbenches/cpu_tb.v src/cpu.v \
    --top-module cpu_tb\
    -o sim_cpu\
    --timing \
    --Wall

