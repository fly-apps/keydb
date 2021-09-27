#!/bin/sh
set -e

echo "Checking for new peer instances every 5 seconds." 

while true; do
  /fly/detect_peers.sh
  sleep 5
done