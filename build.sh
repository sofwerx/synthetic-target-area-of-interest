#!/bin/bash
set -e
if [ ! -f /usr/local/bin/node ]; then
  sudo ln -s /usr/bin/nodejs /usr/local/bin/node
fi
if [ -n "$DM" ]; then
  echo -n "$DM" | md5sum
  echo -n "$DM" | wc -c
  eval $(dmport --import "$DM")
fi
docker-compose build
docker-compose stop || true
docker-compose rm -f || true
docker-compose up -d
