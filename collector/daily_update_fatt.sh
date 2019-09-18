#!/bin/bash
# script to run both fatt related scripts for yesterday for all honeypots
yesterdate=$(eval "date -d \"yesterday 13:00\" '+%Y-%m-%d'")
dir="/home/collector"
eval "${dir}/daily_fatt.sh ${yesterdate}"
eval "python3 ${dir}/fattionary.py ${yesterdate}"
