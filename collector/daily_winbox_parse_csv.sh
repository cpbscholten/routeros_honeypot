#!/bin/bash
# script to create a csvfile for containing decrypted winbox packets for each honeypot
yesterdate=$(eval "date -d \"yesterday 13:00\" '+%Y-%m-%d'")
honeypots=(australia brazil india china-hk netherlands us-central)
winbox_parser_dir=/home/ubuntu/routeros/pcap_parsers/winbox_pcap_parser/build/
dest_dir=/home/collector/tcpdump/
for honeypot in ${honeypots[*]}
do
        echo "daily_winbox_csv ${country} ${yesterdate}"
        eval "${winbox_parser_dir}winbox_pcap_decrypt -f ${dest_dir}${honeypot}/daily_merge_filtered/daily_merge_filtered_${honeypot}_${yesterdate}.pcap > ${shodan_depot_dir}${honeypot}/daily_winbox_csv/daily_winbox_csv_${honeypot}_${yesterdate}.csv"
done
