#!/bin/bash

set -e

IMAGE_NAME="deepesh79/dev"
TAG="latest"
CONTAINER_NAME="react-app"

echo "Pulling latest image..."
docker pull $IMAGE_NAME:$TAG

echo "Stopping old container (if exists)..."
docker stop $CONTAINER_NAME || true

echo "Removing old container (if exists)..."
docker rm $CONTAINER_NAME || true

echo "Starting new container..."
docker run -d \
  --name $CONTAINER_NAME \
  -p 80:80 \
  --restart always \
  $IMAGE_NAME:$TAG

echo "Deployment completed successfully!"
