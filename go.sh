#!/bin/bash
# Helper file for running the simulator

iverilog -o cpu_sim cpu.v cpu_tb.v

./cpu_sim

if [[ "$VIZ" -eq 1 ]]; then
    surfer wave.vcd
    fi
