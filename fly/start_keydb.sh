#!/bin/sh

set -e
sysctl vm.overcommit_memory=1
sysctl net.core.somaxconn=1024

/fly/detect_peers.sh

exec keydb-server /etc/keydb.conf --requirepass $KEYDB_PASSWORD --masterauth $KEYDB_PASSWORD