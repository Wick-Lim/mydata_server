#!/usr/bin/env python
# -*- coding: utf-8 -*-


import sys
import json
import datetime
import argparse

import db

# オプション解析
arg_parser = argparse.ArgumentParser(description='register S3/MinIO')
arg_parser.add_argument('--id', help='ID', required=True)
arg_parser.add_argument('--name', help='name', required=True)
arg_parser.add_argument('--address', help='server address(hostname or IP address)', default="127.0.0.1")
arg_parser.add_argument('--port', help='port nuber', type=int, default=9000)
arg_parser.add_argument('--access_key_id', help='Access Key ID', required=True)
arg_parser.add_argument('--secret_access_key', help='Secret Access Key', required=True)
args = arg_parser.parse_args()
print(args)

id = args.id
name = args.name
address = args.address
port = args.port
access_key_id = args.access_key_id
secret_access_key = args.secret_access_key

s = db.DB()
r = db.DsStorage(id=id, name=name, address=address, port=port, access_key_id=access_key_id, secret_access_key=secret_access_key)
print(r)
s.insert(r)
print(s)

s.db_disconnect()

