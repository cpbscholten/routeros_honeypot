#!/bin/sh
for i in `find /home/christian/gcloud-mount/tcpdump/australia/daily_merge_filtered/ -iname  *.pcap`;
do
#        echo $i
        ./jsproxy_pcap_parser -u admin -p Auo7xmBJ8DgoWFH7 -f $i
#       ./winbox_pcap_decrypt -f $i
done
