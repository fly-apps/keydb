#!/bin/sh
set -e
sysctl vm.overcommit_memory=1
sysctl net.core.somaxconn=1024

ips=$(grep fly-local-6pn /etc/hosts | awk '{print $1}') # extract local ip
others=$(dig aaaa global.$FLY_APP_NAME.internal @fdaa::3 +short | grep -v $ips) # get other keydb ips
replicas=""

for i in $others; do
    replicas="${replicas}\nreplicaof $i 6379"
done

echo $replicas >> /etc/keydb.conf

exec keydb-server /etc/keydb.conf --requirepass $KEYDB_PASSWORD --masterauth $KEYDB_PASSWORD