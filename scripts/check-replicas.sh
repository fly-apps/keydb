#!/bin/sh
set -e

export REDISCLI_AUTH=$(echo $KEYDB_PASSWORD)
 
ips=$(grep fly-local-6pn /etc/hosts | awk '{print $1}') # extract local ip
others=$(dig aaaa global.$FLY_APP_NAME.internal @fdaa::3 +short | grep -v $ips) # get other keydb ips
cmds=""
info=$(keydb-cli info replication)
membercount=$(echo "$info" | grep "_host:" | wc -l)

for i in $ips; do
    if ! (echo $info | grep -q "_host:$i"); then # check masters
        echo "adding master: $i"
        cmds="$cmds\nreplicaof $i 6379" # push to replication commands
    fi
done

if [ ! -z "$cmds" ]; then
    echo "$cmds" | keydb-cli | grep OK
fi