#!/bin/bash

if [ -f slug.tar.gz ]; then
  rm slug.tar.gz
fi

# Build Image
docker build -t php-with-phalcon .  # Run docker
CONTAINER_ID=$(docker run -d php-with-phalcon /app/package.sh)
docker wait $CONTAINER_ID
docker cp $CONTAINER_ID:/tmp/slug.tar.gz .
docker rm -f $CONTAINER_ID

# Remove image
docker rmi php-with-phalcon
