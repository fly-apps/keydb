#!/bin/sh
sysctl vm.overcommit_memory=1
sysctl net.core.somaxconn=1024
keydb-server --requirepass $KEYDB_PASSWORD --dir /data/ --protected-mode no --appendonly yes