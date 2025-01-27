#!/bin/bash
set -e

# Pull the Docker image from Docker Hub
docker pull akshaybharadwaj98/aws-cicd:demo-version

# Run the Docker image as a container
docker run -d -p 8000:8000 akshaybharadwaj98/aws-cicd:demo-version
