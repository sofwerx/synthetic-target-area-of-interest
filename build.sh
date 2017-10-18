#!/bin/bash
set -e
if [ -n "$DM" ]; then
  eval $(dmport --import "$DM")
fi
docker-compose build
docker-compose stop || true
docker-compose rm -f || true
docker-compose up -d
