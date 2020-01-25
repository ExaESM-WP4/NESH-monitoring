#!/bin/bash

cd log_files

# Log CPU and memory usage for Nesh execution hosts.

mkdir -p qstat_logs/

target_sec=$(date -d "+7 days" +%s) # Total output period

while [ $[$target_sec-$(date +%s)] -gt 0 ]; do
 now=$(date +"%Y-%m-%d-%H-%M-%S")
 qstat -E -F fcpu,fmem1,ucpu,cpuavg1,umem1,ehost,quenm -o fcpu > ${now}.log
 ../capture_qstatall_to_csv.py qstat_logs/qstatall_${now}.csv.gz
 sleep 10m # Output interval
done
