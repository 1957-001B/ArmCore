#!/bin/bash
# Helper file for running the simulator
file=$1
go=0

  iverilog -o ./sim/cpu_tb cpu/* && vvp ./cpu_sim && go=1


if [[ "$VIZ" -eq 1 && "$go" -eq 1 ]]; then
    surfer wave.vcd
    fi
