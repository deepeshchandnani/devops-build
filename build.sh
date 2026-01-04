#!/bin/bash

set -e

IMAGE_NAME="deepesh/dev"
TAG="latest"

echo "Building Docker image..."
docker build -t $IMAGE_NAME:$TAG .

echo "Pushing image to Docker Hub..."
docker push $IMAGE_NAME:$TAG

echo "Build & Push completed successfully!"
