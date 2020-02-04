#!/bin/bash

# Steps to create a clean env
#
# module load python3.7.4
# rm -rf py3venv/
# python3 -m venv py3venv/
# source py3venv/bin/activate
# pip install click pandas
# pip freeze > requirements.txt

# Initialize virtual Python environment.

module load python3.7.4 # Python base version
which python3 &> /dev/null || { echo "python3 not found"; exit 1; }

if [ -d py3venv/ ]; then
 source py3venv/bin/activate
else
 python3 -m venv py3venv/
 source py3venv/bin/activate
 pip install -r requirements.txt
fi

# Log CPU and memory usage for Nesh execution hosts.

mkdir -p log_files/
mkdir -p qstat_logs/

target_sec=$(date -d "+7 days" +%s) # Total output period
salt_value=$(uuidgen -r) # Random UUID as salt value

while [ $[$target_sec-$(date +%s)] -gt 0 ]; do
 now=$(date +"%Y-%m-%d-%H-%M-%S")
 qstat -E -F fcpu,fmem1,fswap1,ucpu,umem1,uswap1,cpuavg1,ldavg1,ehost,quenm -o fcpu > log_files/${now}.log
 capture_qstatall_to_csv.py ${salt_value} qstat_logs/qstatall_${now}.csv.gz
 sleep 10m # Output interval
done
