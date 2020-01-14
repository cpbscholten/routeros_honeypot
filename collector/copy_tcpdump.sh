#!/bin/bash
# copy the latest tcpdump files from the honeypot
dest_dir=/home/collector/tcpdump/${honeypot_name}/
source_dir=/home/honeypot/tcpdump/
# arguments used when calling script
# name of honeypot, the ip address of the honeypot
honeypot_name=$1
ip=$2
echo "Copying new logs to local:"
# the --remove-source-files argument is used to ensure that the honeypot will not run out of space.
eval "rsync -auvv honeypot@${ip}:${source_dir} ${dest_dir} --remove-source-files"
