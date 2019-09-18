#!/bin/bash
# script to use fatt to crete a fatt fingerprint file for each honeypot for yesterday using the fatt.py script fattionary.py will be used to create a csv per day from this output
dates=("$@")
honeypots=(australia brazil india china-hk netherlands us-central)
# download this from https://github.com/0x4D31/fatt
fatt_dir="/home/collector/fatt-master/"
dir="/home/collector/"
for honeypot in ${honeypots[*]}
do
        for date in ${dates[*]}
        do
                echo "daily_fatt ${honeypot} ${date}"
                eval "python3 ${fatt_dir}fatt.py -r ${dir}/tcpdump/${honeypot}/daily_merge_filtered/daily_merge_filtered_${honeypot}_${date}.pcap -j -o ${dir}fatt/${honeypot}/daily_fatt_${honeypot}_${date}.log"
        done
done
