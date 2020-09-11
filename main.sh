#!/bin/bash

# Define e-mail alert behaviour.

trap 'echo Finished...; shutdown' EXIT
trap 'echo Killed...; forced_shutdown' SIGKILL SIGTERM SIGINT SIGHUP

forced_shutdown() {
 $(echo "$(date)" | mail -s "Nesh log cycle aborted" user@host); wait $!
 PGID=$$; setsid kill -9 -$PGID
}

shutdown() {
 $(echo "$(date)" | mail -s "Nesh log cycle finished" user@host); wait $!
}

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

mkdir -p host_logs/
mkdir -p request_logs/

target_sec=$(date -d "+91 days" +%s) # Total output period
salt_value=$(uuidgen -r) # Random UUID as salt value

while [ $[$target_sec-$(date +%s)] -gt 0 ]; do
 now=$(date +"%Y-%m-%d-%H-%M-%S")
 qstat -E -F fcpu,fmem1,fswap1,ucpu,umem1,uswap1,cpuavg1,ldavg1,ehost,quenm > host_logs/${now}.log
 ./qstatall.py ${salt_value} request_logs/${now}.csv
 sleep 10m # Output interval
done

# Log file grouped compression.

cd host_logs
first=`ls *.log | head -1`
tar czf cycle_${first:0:19}.tar.gz *.log && rm *.log

cd ../request_logs
first=`ls *.csv | head -1`
tar czf cycle_${first:0:19}.tar.gz *.csv && rm *.csv

