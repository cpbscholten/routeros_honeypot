# RouterOS API Snooper
The api snooper script can be used to extract all data from a RouterOS router as a tabbed .xlsx file. Requires API-SSL access with a certificate

# Setup
- Clone this repositor
- Create the virtual environment: `python3 -m venv /path/to/cloned/repository`
- Install requirements: `pip3 install -r requirements.txt`

# router set up
- Set up a certificate: https://wiki.mikrotik.com/wiki/Manual:Create_Certificates
- enable api on port 8729:
```
/ip service enable api
/ip service set api-ssl certificate=**ssl_cert_name**
```
- fill in credentials in script and change the configuration
