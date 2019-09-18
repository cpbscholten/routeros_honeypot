#!/bin/bash
# filter the daily captures for each honeypot oer day provided as argument
dates=("$@") # arguments passed when calling method
honeypots=(australia brazil india china-hk netherlands us-central)
filter="not ip.addr==130.89.0.0/16" # update this filter
dir="/home/collector/tcpdump/"
for honeypot in ${honeypots[*]}
do
        for date in ${dates[*]}
        do
                echo "filter ${honeypot} ${date}"
                eval "tshark -r ${dir}${honeypot}/daily_merge/daily_merge_${honeypot}_${date}.pcap -Y \"${filter}\" -w ${dir}${honeypot}/daily_merge_filtered/daily_merge_filtered_${honeypot}_${date}.pcap"
        done
done
