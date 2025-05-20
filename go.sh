#!/bin/bash
# Helper file for running the simulator
file=$1
go=0

  iverilog -g2005-sv -o ./cpu_sim ./sim/cpu_tb.v cpu/* && vvp ./cpu_sim && go=1


if [[ "$VIZ" -eq 1 && "$go" -eq 1 ]]; then
    surfer wave.vcd
    fi
