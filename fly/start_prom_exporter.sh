#! /bin/sh
set -e
/fly/redis_exporter --redis.addr=127.0.0.1 --redis.password=$KEYDB_PASSWORD