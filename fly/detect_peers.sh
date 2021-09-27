#!/bin/sh
set -e

export REDISCLI_AUTH=$(echo $KEYDB_PASSWORD)

# Extract local IPV6 address
ips=$(grep fly-local-6pn /etc/hosts | awk '{print $1}')

# Extract peer keydb server IPV6 addresses
others=$( (dig aaaa global.$FLY_APP_NAME.internal @fdaa::3 +short | grep -v "$ips") || echo "")

# Add peers to the config file when the VM first boots

for i in $others; do
    if ! (grep -q $i /etc/keydb.conf); then
        echo "Adding peer $i to /etc/keydb.conf"
        echo "replicaof $i 6379" >> /etc/keydb.conf
    fi
done

# Once booted, add new peers using the CLI to avoid restarting Keydb

if ( ps aux | grep -v grep | grep -q keydb-server ); then
    info=$(keydb-cli info replication)
    membercount=$(echo "$info" | grep "_host:" | wc -l)
    # add to keydb
    for i in $ips; do
        if ! (echo $info | grep -q "_host:$i"); then # check masters
            echo "Adding peer $i with keydb-cli"
            echo "replicaof $i 6379" | keydb-cli
        fi
    done
fi
