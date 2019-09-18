#!/bin/bash
# retrieve the logs from a honeypot and store them on the collector
honeypot_name=$1
ip=$2
dest_dir=/home/collector/logs/${honeypot_name}/
source_dir=/home/honeypot/logs/
echo "Copying new logs to local:"
eval "rsync -auvv honeypot@${ip}:${source_dir} ${dest_dir} --remove-source-files"
