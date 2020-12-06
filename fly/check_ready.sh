#! /bin/sh
set -e
log()
{
    echo "ready_check: $@"
}

export REDISCLI_AUTH=$(echo $KEYDB_PASSWORD)

info=$( keydb-cli info replication )

if ( echo "$info" | grep -q "master_sync_in_progress:1" ); then
    log "$info" | grep -q "master_sync_perc"
    exit 1
fi

if ( echo "$info" | grep -q "master_sync_in_progress:0" ); then
    log "OK"
    exit 0
fi

log "no master sync found, standalone"
exit 2