import datetime
import json
import ssl
from typing import Tuple

from librouteros import connect
from librouteros.login import login_plain, login_token
import tablib

# config
# change these values before running the script
routeros_6_43_or_higher = False
username = 'admin'
password = ''
host = '192.168.0.1' # ip of the routeros router
port = 8729 # port of the api-ssl service
log_dir = "/home/honeypot/logs/" # location of where to store the captured data

# ssl context
ctx = ssl.create_default_context()
ctx.check_hostname = False
ctx.verify_mode = ssl.CERT_NONE

# for new (plain text password)
if routeros_6_43_or_higher:
    method = (login_plain, )
else:
    # for old (with token)
    method = (login_token, )

# connect with the api
api = connect(
    username=username,
    password=password,
    host=host,
    ssl_wrapper=ctx.wrap_socket,
    login_methods=method,
    port=port
)


def tuple_to_dataset(input_tuple: Tuple, title: str, db):
    """
    Transforms a list of json of a table to a sheet of an excel file
    :param input_tuple: json input list
    :param title: title of the sheet
    :param db: the databook excel file
    """
    # skip empty tables
    if len(input_tuple) != 0:
        # ugly hack to fix invalid dimensions error for the files sheet
        if title == 'files':
            for dict_item in input_tuple:
                if 'size' not in dict_item:
                    dict_item['size'] = ' '
                if 'contents' not in dict_item:
                    dict_item['contents'] = ' '
        # ugly hack to fix invalid dimensions for the users sheet
        if title == 'users':
            for dict_item in input_tuple:
                if 'comment' not in dict_item:
                    dict_item['comment'] = ' '
        # read input string as json
        json_string = json.dumps(list(input_tuple))
        # transform json into excel dataset
        dataset = tablib.Dataset(title=title)
        dataset.json = json_string
        # add excel dataset as a sheet in the xlsx
        db.add_sheet(dataset)


try:
    # retrieve data from the api
    logs = api(cmd='/log/print')
    dns_cache = api(cmd='/ip/dns/cache/print')
    dns_static = api(cmd='/ip/dns/static/print')
    dhcp_server = api(cmd='/ip/dhcp-server/print')
    dhcp_relay = api(cmd="/ip/dhcp-relay/print")
    dhcp_client = api(cmd='/ip/dhcp-client/print')
    users = api(cmd='/user/print')
    arp = api(cmd='/ip/arp/print')
    files = api(cmd='/file/print')
    ip_route = api(cmd='/ip/route/print')
    bgp_ads = api(cmd="/routing/bgp/advertisements/print")

    # create an excel databook document
    db = tablib.Databook()

    # transform each entry as a sheet in the databook
    tuple_to_dataset(logs, 'logs', db)
    tuple_to_dataset(dns_cache, 'dns_cache', db)
    tuple_to_dataset(dhcp_client, 'dhcp_client', db)
    tuple_to_dataset(dhcp_relay, 'dhcp_relay', db)
    tuple_to_dataset(dhcp_server, 'dhcp_server', db)
    tuple_to_dataset(users, 'users', db)
    tuple_to_dataset(arp, 'arp', db)
    tuple_to_dataset(files, 'files', db)
    tuple_to_dataset(ip_route, 'ip_route', db)
    tuple_to_dataset(bgp_ads, 'bgp_advertisements', db)

    # retrieve the current date for the filename
    date = str(datetime.datetime.now())
    # store as logs-**datetime**.xlsx in the logs folder
    open(log_dir + 'logs-' + date + '.xlsx', 'wb').write(db.xlsx)
except Exception as e:
    # print the stacktrace
    print(e)
