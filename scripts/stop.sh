#!/bin/bash
#cd ..
# Stop Docker containers
docker-compose -f ./docker/docker-compose.yml stop

# Remove Docker containers
#docker-compose -f ./docker/docker-compose.yml rm -f

# Clean up unused Docker resources
#docker system prune --volumes
