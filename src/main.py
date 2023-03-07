#!/usr/bin/env python
import json
import os
import boto3

import hvac

VAULT_ADDR = os.getenv('VAULT_ADDR')
SECRET_NAME = os.getenv('SECRET_NAME')

if __name__ == '__main__':
    client = hvac.Client(url=VAULT_ADDR)
    if client.sys.is_initialized():
        print("Vault is already initialized.")
    else:
        # Initialize Vault
        result = client.sys.initialize(recovery_shares=1, recovery_threshold=1, secret_threshold=None, secret_shares=None)
        root_token = result['root_token']
        # Store root token in AWS secret manager
        session = boto3.session.Session()
        client = session.client(service_name='secretsmanager')
        client.put_secret_value(SecretId=SECRET_NAME, SecretString=json.dumps({"token": root_token}))
