#!/bin/sh
set -e
sysctl vm.overcommit_memory=1
sysctl net.core.somaxconn=1024

ip=$(grep fly-local-6pn /etc/hosts | awk '{print $1}')
sed -i "s/replicaof $ip 6379//" /etc/keydb.conf

exec keydb-server /etc/keydb.conf --requirepass $KEYDB_PASSWORD --masterauth $KEYDB_PASSWORD