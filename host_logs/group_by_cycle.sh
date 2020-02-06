#!/bin/bash

# group log files by log cycle manually

gunzip 2020-01-{12..19}*.log.gz
first=`ls *.log | head -1`
tar czf cycle_${first:0:19}.tar.gz *.log
rm 2020-01-{12..19}*.log

gunzip 2020-01-{22..31}*.log.gz 2020-02-{01..03}*.log.gz
rm 2020-02-03-11-42-26.log 2020-02-03-11-49-36.log # these were created by manual ./log.sh calls and do not strictly belong to this log cycle
first=`ls *.log | head -1`
tar czf cycle_${first:0:19}.tar.gz *.log
rm 2020-01-{22..31}*.log 2020-02-{01..03}*.log
