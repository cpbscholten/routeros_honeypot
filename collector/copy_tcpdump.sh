#!/bin/bash
# copy the latest tcpdump files from the honeypot
honeypot_name=$1
ip=$2
dest_dir=/home/collector/tcpdump/${honeypot_name}/
source_dir=/home/honeypot/tcpdump/
echo "Copying new logs to local:"
eval "rsync -auvv honeypot@${ip}:${source_dir} ${dest_dir} --remove-source-files"
