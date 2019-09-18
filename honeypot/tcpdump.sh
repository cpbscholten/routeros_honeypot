#!/bin/bash
# script to start a tcppdump capture

# config: Update these values
# duration of the capture (10 minutes)
timespan=600
# name of the honeypot
honeypot_name="HONEYPOT"
# capture destination directory
filename="/home/honeypot/tcpdump/"
# host of the processor vm, to exclude this traffic
proc_ip="10.0.0.0"

# create the filename
datetime=$(date -Iminutes)
filename="${location}TCPDUMP-${honeypot_name}${datetime}.pcap"
# run tcpdump
command="timeout $timespan tcpdump -i eth0 host not ${proc_ip} -w $filename"
echo TCPDUMP
eval $command
