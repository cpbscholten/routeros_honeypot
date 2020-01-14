#!/bin/bash
# script to create a csvfile for containing decrypted winbox packets for each honeypot
yesterdate=$(eval "date -d \"yesterday 13:00\" '+%Y-%m-%d'")
honeypots=(australia brazil india china-hk netherlands us-central)
# the location of the compiled winbox parser
winbox_parser_dir="/home/ubuntu/routeros/pcap_parsers/winbox_pcap_parser/build/"
# the directory containing the tcpdump captures
pcap_dir="/home/collector/tcpdump/"
# the directory to output the parsed csv files to
dest_dir="/home/collector/parsed_winbox/"
for honeypot in ${honeypots[*]}
do
        echo "daily_winbox_csv ${country} ${yesterdate}"
        eval "${winbox_parser_dir}winbox_pcap_decrypt -f ${pcap_dir}${honeypot}/daily_merge_filtered/daily_merge_filtered_${honeypot}_${yesterdate}.pcap > ${dest_dir}${honeypot}/daily_winbox_csv_${honeypot}_${yesterdate}.csv"
done
