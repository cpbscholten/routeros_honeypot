# RouterOS Honeypot Setup Scripts
This repository contains all necessary files to create multiple honeypots running RouterOS 6.39.3.

Each honeypot runs a virtual machine with RouterOS 6.39.3. The central system contains a network packet collecting tools and a script to extract API messages from RouterOS. IPTables rules are used to forward all external traffic to the virtual machine. Only allowed IP adresses can enter the rest of the system.

All collected data is synchronized every hour to a central machine to collect the data and analyze it.

## Setup
This repository contains two directories, honeypot and collector. The honeypot directory contains all code to set up a complete honeypot and the collector directory contains all code necessary to collect, filter and analyze the traffic collected by each honeypot.

It is recommended to first create a working honeypot and then set up a collector machine next. Both the collector and honeypot directories contain a Readme file with more instructions to set up a honeypot.
