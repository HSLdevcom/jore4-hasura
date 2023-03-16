#!/bin/bash

# start up test database and hasura for migrations
docker-compose -f ./docker/docker-compose.yml -f ./docker/docker-compose.custom.yml down
