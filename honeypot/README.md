# RouterOS Honeypot scripts
This directory contains all scripts and config files for a honeypot with RouterOS.

## requirements
- cron
- python3
- pip3
- iptables
- iptables-persistent
- wondershaper
- virtualbox
- rsync

## create a honeypot vm
- download CHR 6.39.3 from https://mikrotik.com/download/archive
- create a host only adapter in VirtualBox
- create a Virtual Machine with the downloaded image
- choose the host only adapter as the adapter of the virtual machine
- Add users and a password if preferred (We used a unique api user to easily remove all logs when accessing the logs)
- create a Snapshot after setup, so the honeypot can be restored to the current state.
- Write down the name of the Virtual Machine and the snapshot

## API_Snooper
The API_snooper script is used to collect the logs from the honeypot virtual machine and stored as easy to use .xlsx files. The collector machine will later filter and unify these files per day as a .csv file this script is called every 5 minutes from the crontab.

Set up from the included Readme and update the following settings:
- Username (preferably a different user than admin, we used api)
- password
- honeypot name (uppercase)
- IP (probably 192.168.56.101)
- port of the API-service (8729)
- the directory to store the logs

# TCPDUMP
TCPDUMP is configured in the `tcpdump.sh` to create capture files of 10 minutes. This script is called every ten minutes from the crontab.
- change the name of the honeypot in the filename (uppercase)
- Change the destination folder of the capture
- Change the hostname of the virtual machine. This ensures that all traffic from collecting the .pcap files is not captured as well. This reduces the file size significantly.
- optionally change the duration of each capture

## set up the iptables rules
The included `iptables-save.v4` file contains example iptables rules that redirect all TCP and UDP traffic to the honeypot except for, in the example the IP range of the University of Twente for port 21 and 5901 (SSH and VNC). These are redirected to the management interface of the honeypot.

There are also some ports redirected, such as 2323, 23023 to 23 2121 to 21 and 3128 to 8080. This is done to make commonly different ports accessible. These redirected ports can be changed if necessary.
- look up ip address of honeypot (usually 192.169.56.101:23)
- Update the ip addresses of the honeypot (192.168.56.101) in the iptables-save.v4 file
- Update the allowed IP range (130.89.0.0/16) to another ip or range
- make rules persistent with: `iptables-save > /home/honeypot/iptables-save.v4` (so they survive a reboot)

## Make the honeypot restart every day
The `vmreset.sh` file is called from the crontab and is used to reset the honeypot to its original state from the snapshot.
- Update the name of the virtual machine
- Update the name of the snapshot

## set up wondershaper to limit incoming traffic on the honeypot
To limit the damage an attacker can do to other devices if the honeypot is compromised, we limited the incoming and outgoing traffic to 1mbps with wondershaper. This is done by adding wondershaper as a system service.
- copy the `wondershaper` file to `/etc/conf.c/wondershaper`
- run these commands to start wondershaper as a system service:
```
sudo systemctl enable wondershaper.service
sudo systemctl start wondershaper.service
```

## Crontab
The contab is used to call all scripts at the correct time. The crontab also outputs log files to the `/tmp/` directory to allow for more easy debugging.
- Update the location to the API_snooper at line 7
- Update the location to the `tcpdump.sh` script in line 10
- Update the location to the `vmreset.sh` script in line 13 and 14

# Other steps
add the ssh key of the collector to the authorized keys to allow access to the virtual machine:
- Copy the contents of the generated public key to ~/.ssh/authorized_keys
