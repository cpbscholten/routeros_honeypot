#!/bin/bash
# script to create a filtered csv file per honeypot for yesterday
yesterdate=$(eval "date -d \"yesterday 13:00\" '+%Y-%m-%d'")
dir="/home/collector"
eval "python3 ${dir}/merge_logs.py ${yesterdate}"
