#!/bin/bash

# stop the dependencies
docker-compose -f ./docker/docker-compose.yml -f ./docker/docker-compose.custom.yml down
