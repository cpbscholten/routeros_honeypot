import io
import os
import sys
import json
from pathlib import Path

# script to merge the fatt files into a csv file per honeypot per day
def main(argv):
   honeypots = ["australia", "brazil", "china-hk", "india", "netherlands", "us-central"]
   days = argv
   main_dir = "/media/collector/"
   fatt_dir = main_dir + "fatt/"
   fattionary_path = fatt_dir + 'fattionary.json'

   # create file if does not exist
   if os.path.isfile(fattionary_path) and os.access(fattionary_path, os.R_OK):
       # checks if file exists
       print("fattionary exists and is readable")
   else:
       print("Either fattionary is missing or is not readable, creating file...")
       with io.open(Path(fattionary_path), 'w') as db_file:
           db_file.write(json.dumps({}))

   # read fattionary as json
   with open(fattionary_path) as json_data:
       fattionary = json.load(json_data)

   # read fatt per honeypot per day and write add to the fattionary
   for honeypot in honeypots:
       for day in days:
           # read the daily fatt file for honeypot for day as json
           daily_fatt = []
           print("Read: " + fatt_dir + honeypot + "/daily_fatt_" + honeypot + "_" + day + ".log")
           with open(fatt_dir + honeypot + "/daily_fatt_" + honeypot + "_" + day + ".log") as f:
               for line in f:
                   daily_fatt.append(json.loads(line))
           print("The file contains " + str(len(daily_fatt)) + " entries!")

           # process each json entry from the file
           for json_entry in daily_fatt:
               src_ip = json_entry.get('sourceIp')
               if src_ip.startswith('10.'):
                   continue
               dest_port = json_entry.get('destinationPort')
               protocol = json_entry.get('protocol')

               # retrieve the fingerprint hash
               if type(json_entry.get('http')) is dict:
                   fp = json_entry.get('http')
                   if 'clientHeaderHash' in fp:
                       fp_hash = fp.get('clientHeaderHash')
                   elif 'serverHeaderHash' in fp:
                       fp_hash = fp.get('serverHeaderHash')
                   else:
                       print(fp)
                       fp_hash = ''
               elif type(json_entry.get('ssh')) is dict:
                   fp = json_entry.get('ssh')
                   if 'hassh' in fp:
                       fp_hash = fp.get('hassh')
                   else:
                       print(fp)
                       fp_hash = 'hash'
               else:
                   fp = json_entry.get('tls')
                   if 'ja3' in json_entry.get('tls'):
                       fp_hash = fp.get('ja3')
                   elif 'ja3s' in json_entry.get('tls'):
                       fp_hash = fp.get('ja3s')
                   else:
                       print(fp)
                       fp_hash = ''

               # add the entry to the fattionary if it does not exist otherwise check if the entry contains the honeypot
               fattionary_entry = {
                       'countries': [honeypot],
                       'hash': fp_hash,
                       'dest_port': [dest_port]
               }

               if src_ip in fattionary:
                   if protocol in fattionary.get(src_ip):
                       if honeypot not in fattionary.get(src_ip).get(protocol).get('countries'):
                           fattionary.get(src_ip).get(protocol).get('countries').append(honeypot)
                       if dest_port not in fattionary_entry.get('dest_port'):
                           fattionary.get(src_ip).get(protocol).get('dest_port').append(dest_port)
                   else:
                       fattionary[src_ip][protocol] = fattionary_entry
               else:
                   fattionary[src_ip] = {protocol: fattionary_entry}

   # save the fattionary to the file
   with open(fattionary_path, 'w') as outfile:
       json.dump(fattionary, outfile, indent=2, sort_keys=True)


if __name__ == "__main__":
   main(sys.argv[1:])
