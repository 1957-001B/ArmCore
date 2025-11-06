#!/bin/bash
set -euo pipefail  

verilator --cc --Wall ./testbenches/sim_main.cpp \
--exe  \
--build \
--trace \
--trace-vcd \
-I./src testbenches/cpu_tb.v src/cpu.v \
--top-module cpu_tb \
-o sim_cpu \
--timing \
&& ./obj_dir/sim_cpu +trace

if [[ "${VIZ}" = "1" ]]; then
  gtkwave waveform.vcd
fi

