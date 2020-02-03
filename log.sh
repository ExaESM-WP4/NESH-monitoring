#!/bin/bash

# Log CPU, memory and swap usage, and CPU and load averages for Nesh execution hosts.

target_sec=$(date -d "+91 days" +%s) # Total output period

while [ $[$target_sec-$(date +%s)] -gt 0 ]; do
 now=$(date +"%Y-%m-%d-%H-%M-%S")
 qstat -E -F fcpu,fmem1,fswap1,ucpu,umem1,uswap1,cpuavg1,ldavg1,ehost,quenm -o fcpu > log_files/${now}.log
 sleep 10m # Output interval
done

