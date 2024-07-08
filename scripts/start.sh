#!/bin/bash
#cd ..

# Build the Rasa and Action server Docker images
docker build -t rasa_custom:2.0 -f ./docker/DockerfileRasa .
docker build -t rasa_action:2.0 -f ./dpcker/DockerfileAction .

# Start the Docker containers using docker-compose
docker-compose -f ./docker/docker-compose.yml up -d
