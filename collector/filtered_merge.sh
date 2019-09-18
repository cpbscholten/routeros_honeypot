#!/bin/bash
# creates a new merged file combining all daily filtered pcaps for each honeypot
honeypots=(brazil india china-hk netherlands australia us-central)
dir="/home/collector/tcpdump/"
for honeypot in ${honeypots[*]}
do
        echo "merge ${honeypot}"
        eval "mergecap ${dir}${honeypot}/daily_merge_filtered/*.pcap -w ${dir}${honeypot}/merged_filtered/merged_filtered_${honeypot}.pcap"
done
