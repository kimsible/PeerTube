#!/bin/sh
set -e

# generate opendkim private key if not existing
private_key="/etc/opendkim/keys/$POSTFIX_HOSTNAME.private"
if [ ! -f $private_key ]; then
    openssl genrsa -out $private_key 1024
fi

# generate opendkim public key DNS TXT record if not existing
public_key="/etc/opendkim/keys/$POSTFIX_HOSTNAME.txt"
if [ ! -f $public_key ]; then
    echo "mail._domainkey 14400 IN TXT \"v=DKIM1; k=rsa; p=`openssl rsa -in $private_key -pubout | sed '1,1d' | sed '$ d' | awk '{print}' ORS=''`\"" > $public_key
fi

# make sure opendkim is owner of the keys directory
chown -R opendkim:opendkim /etc/opendkim/keys



