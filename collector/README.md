# Collector scripts
This directory contains all scripts and configuration files for the collector computer. This computer is used to collect all data from the honeypots. It also filters and merges to collected data.

## Requirements
- cron
- python3
- pip3
- tcpdump
- fatt (`https://github.com/0x4D31/fatt`)
- tshark

## Set up collecting, merging and filtering tcpdump captures
### Copy tcpdump captures to collector
Similarly, `copy_tcpdump.sh` is used to copy the tcpdump captures from the honeypot to the collector machine. The first argument when running the script is the name of the honeypot and the second is the ip address of the honeypot. After copying with rsync, the files will be removed from the honeypot to ensure that enough space remains on the honeypot device.

Change the following lines in the file:
- Update the `source_dir` to the directory on the honeypot containing the captured tcpdump files.
- Update the `dest_dir` to the general directory containing all tcpdump .pcap files on the collector (with the name of the honeypot at the end as subdirectory)

### Set up the script to merge all captures of the day after the day ended
The `merge_yesterday_captures`.sh File is used to call a few other script to merge all capture files of yesterday for each honeypot, then it calls another script to filter the created file and finally a script is called to combine all filtered daily files into a large combined and filtered .pcap file with all captures.

Change the following:
- The `dir` variable in line 7 to point to the directory containing these scripts.

### Daily merge
The `merge_yesterday_captures.sh` calls the daily_merge.sh script and merges all captures for each honeypot for the previous day into a single .pcap file per honeypot. These captures are stored in the `daily_merge` directory in each honeypot directory (`${dir}/${honeypot_name}/daily_merge`).

Update the following:
- Change the `honeypots` variable to contain the names of all honeypots, similar to the directories of each honeypot in the `tcpdump` directory.
- Update the `dir` variable to point to the directory containing all .pcap files.

### Daily filters
The daily_filter.sh will open the last created merged file from the `${dir}/${honeypot_name}/daily_merge` directory for each honeypot and filter these files for unnecessary information. This will be outputted to the `${dir}/${honeypot_name}/daily_filtered` directory

Change the following:
- Update the `filter` to exclude the allowed ip range
- Add other filters if necessary
- Update the `dir` variable to point to the general directory
- Add all names of the honeypots to the `honeypot` variable. These need to be the same as the subdirectories in the `dir` directory.

### Filtered merge
The filtered_merge.sh will create a unified file containing all captured data for each honeypot. And combine all .pcap files from `${dir}/${honeypot}/` daily_merge_filtered into a single .pcap file outputted to `${dir}/${honeypot}/merged_filtered/`

Change the following:
- The variable `honeypots` to names of the honeypots, similar to the files above
- The directory pointing to the `dir` variable, similar to the files above.

## Fatt
Fatt is used as a tool to fingerprint unique devices from a .pcap file. We use this tool to create a dictionary or 'fattionary' containing all fingerprints from all devices that tried to connect to that honeypot that day.

Change the following in `fattionary.py`:
- The variable `honeypots` to the name of the honeypots, same as the subdirectories for the .pcap files
- The `main_dir` variable to the directory below the `fatt` and `log` directories.

Change the following in the `daily_fatt.sh` file:
- the name of the honeypots, same as the subdirectories for the .pcap files
- The directory containing fatt
- The directory containing the daily fatt entries. This directory needs to contain subdirectories for all honeypots to work.
- and the directory containing the tcpdump captures.

## Set up collecting merging, filtering logs
## Copy log files to collector
The `copy_logs.sh` file is used to copy the collected log files to the collector machine. The first argument when running the script is the name of the honeypot and the second is the ip address of the honeypot. After copying with rsync, the files will be removed from the honeypot to ensure that enough space remains on the honeypot device.

Change the following lines in the file:
- Update the `source_dir` to the directory on the honeypot containing the captured log files.
- Update the `dest_dir` varable to the general directory containing all log files on the collector (with the name of the honeypot at the end as subdirectory)

## Merge logs per honeypot daily
The `daily_merge_logs.sh` file is called each day and calls the `merge_logs.py` script to merge all logs of the previous day. After merging, the log files are moved to a new directory in `${logs_dir}/${honeypot_name}/${log_captures}/${date}/`. The merged file is added as a csv file to the `${logs_dir}/${honeypot_name}/daily_logs/` folder

Update in daily_merge_logs.sh:
- the directory pointing to the `merge_logs.py` script

Update in the merge_logs.py file:
- The variable `honeypots` to the names of the honeypots.
- the `dir` variable for the directory containing all log files.
- the `logs_dir` variable containing the logs directory.

## Parse JSproxy and Winbox files
We also modified the JSproxsy and WInbox pcap parsers from Tenable to include a more detailed output and used that to decrypt the .pcaps for Winbox traffic. The JSproxy parser is the same but then for HTTP traffic. This one sometimes outputs gibberish and therefore needs some modifications before being useful.

### Winbox parser
The `daily_winbox_parse_csv.sh` script is called daily and reads the filtered pcap of the day before, decrypts the winbox traffic and outputs the pakets to a .csv file.

Update in the script:
- The variable `honeypots` to the names of the honeypots
- The variable `winbox_parser_dir` to the location of the compiled winbox_pcap_parser build. This parser is included in the winbox_pcap_parser directory, but still needs to be compiled.
- Update the `dest_dir` variable to point to destination directory to output the parsed .csv files to.
- Update the `pcap_dir` to point to the directory containing the tcpdump .pcap files.

## Crontab
In order to automatically run all scripts, some modifications need to be made to the crontab.

Copy line 7 and 8 for each extra honeypot you might want to add, update the ip adress and the name of the honeypot. Ensure that a subdirectory exists in the tcpdump and logs directory with the name of the honeypot (This name should be the same as use in the honeypot).

And finally update the locations to the scripts.

## Other steps
- Create an SSH key: `ssh-keygen -t rsa -b 4096 -C "your_email@example.com"`
