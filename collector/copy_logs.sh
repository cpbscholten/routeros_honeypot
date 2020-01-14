#!/bin/bash
# retrieve the logs from a honeypot and store them on the collector 
source_dir=/home/honeypot/logs/
dest_dir=/home/collector/logs/
# arguments used when calling script
# name of honeypot, the ip address of the honeypot
honeypot_name=$1
ip=$2
echo "Copying new logs to local:"
# the --remove-source-files argument is used to ensure that the honeypot will not run out of space.
eval "rsync -auvv honeypot@${ip}:${source_dir} ${dest_dir}${honeypot_name}/ --remove-source-files"
