#!bin/bash
# script to restart the vm with the honeypot to a snapshot
#configuration
honeypot_vm_name="routeros"
honeypot_snapshot_name="Snapshot"

eval "VBoxManage controlvm ${honeypot_vm_name} poweroff soft"
eval "VBoxManage snapshot routeros restore ${honeypot_snapshot_name}"
eval "VBoxHeadless -startvm ${honeypot_vm_name}"
