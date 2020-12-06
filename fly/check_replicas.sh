#!/bin/sh
set -e

export REDISCLI_AUTH=$(echo $KEYDB_PASSWORD)

ips=$(grep fly-local-6pn /etc/hosts | awk '{print $1}') # extract local ip
others=$( (dig aaaa global.$FLY_APP_NAME.internal @fdaa::3 +short | grep -v "$ips") || echo "") # get other keydb ips

# write to config for restarts
for i in $others; do
    if ! (grep -q $i /etc/keydb.conf); then
        echo "adding master to conf"
        echo "\nreplicaof $i 6379" >> /etc/keydb.conf
    fi
done

if ( ps aux | grep -v grep | grep -q keydb-server ); then
    info=$(keydb-cli info replication)
    membercount=$(echo "$info" | grep "_host:" | wc -l)
    # add to keydb
    for i in $ips; do
        if ! (echo $info | grep -q "_host:$i"); then # check masters
            echo "adding master: $i"
            echo "replicaof $i 6379" | keydb-cli
        fi
    done
fi