#!/bin/bash
# merge the tcpdump captures for the each honeypot for the dates passed as arguments
dates=("$@") # passed as arguments
honeypots=(china-hk india netherlands brazil us-central australia)
dir="/home/collector/tcpdump/"
for honeypot in ${honeypots[*]}
do
        upperhoneypot=$(echo ${honeypot} | tr [a-z] [A-Z])
        for date in ${dates[*]}
        do
                echo "daily merge ${honeypot} ${date}"
                eval "mergecap ${dir}${honeypot}/TCPDUMP*${upperhoneypot}${date}*.pcap -w ${dir}${honeypot}}/daily_merge/daily_merge_${honeypot}_${date}.pcap"
        done
done
