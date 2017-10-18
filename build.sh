#!/bin/bash
set -e
if [ ! -f /usr/local/bin/node ]; then
  sudo ln -s /usr/bin/nodejs /usr/local/bin/node
fi
if [ -f .dm ]; then
  eval $(dmport --import "$(cat .dm)")
fi
docker-compose build
docker-compose stop || true
docker-compose rm -f || true
docker-compose up -d
