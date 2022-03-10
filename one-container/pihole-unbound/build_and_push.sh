#!/bin/bash
# Run this once: docker buildx create --use --name build --node build --driver-opt network=host
docker buildx build --platform linux/arm64/v8 -t cjmaria/pihole-unbound:latest --push .
