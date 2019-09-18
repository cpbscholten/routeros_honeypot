# routeros_honeypot Honeypot scripts
This directory contains all scripts and config files for a honeypot with RouterOS

## requirements
- cron
- python3
- pip3
- iptables
- iptables-persistent
- wondershaper
- virtualbox

## create a honeypot vm
- download CHR 6.39.3 from https://mikrotik.com/download/archive
- create a host only adapter in virtualbox
- create a vm with the downloaded image
- choose the host only adapter as the adapter of the vm
- set up everything for the api Snooper from the included readme
- create a Snapshot

## set up the iptables rules
- Update the ip addresses in the iptables-save.v4 file
- make rules persistent with: `iptables-save > /home/honeypot/iptables-save.v4`

## set up wondershaper to limit incoming traffic on the honeypot
- copy wondershaper file to `/etc/conf.c/wondershaper`
- run:
```
sudo systemctl enable wondershaper.service
sudo systemctl start wondershaper.service
```

## other steps
- update the crontab
- configure the vmreset.sh script
- configure the tcpdump.sh script
- add the ssh key of the collector to the authorized hosts
