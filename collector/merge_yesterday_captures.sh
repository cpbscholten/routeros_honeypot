#!/bin/bash
# script combining to other tcpdump scripts to
# merging the pcaps for yesterday
# filtering the capture for yesterday
# and creating a merged file for ech honeypot with all captures as a pcap
yesterdate=$(eval "date -d \"yesterday 13:00\" '+%Y-%m-%d'")
dir="/home/ubuntu"
eval "${dir}/daily_merge.sh ${yesterdate}"
eval "${dir}/daily_filter.sh ${yesterdate}"
eval "${dir}/filtered_merge.sh"
