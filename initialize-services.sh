#!/bin/bash

docker network create traefik-net --scope swarm -d overlay
docker network create metrics-net --scope swarm -d overlay

echo "CREATING INGRESS SERVICES STACK..."
export $(cat .env) && docker stack deploy --compose-file docker-compose-ingress.yml ingress

echo "CREATING ADMINISTRATION SERVICES STACK..."
export $(cat .env) && docker stack deploy --compose-file docker-compose-admin.yml admin

echo "CREATING METRICS SERVICES STACK..."
export $(cat .env) && docker stack deploy --compose-file docker-compose-metrics.yml metrics

