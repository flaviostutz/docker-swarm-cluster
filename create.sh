#!/bin/bash

docker network create caddy --scope swarm -d overlay
docker network create caddy_controller --scope swarm -d overlay --subnet=10.200.200.0/24
docker network create admin --scope swarm -d overlay
docker network create metrics --scope swarm -d overlay

echo "CREATING INGRESS SERVICES STACK..."
export $(cat .env) && docker stack deploy --compose-file docker-compose-ingress.yml ingress

echo "CREATING ADMINISTRATION SERVICES STACK..."
export $(cat .env) && docker stack deploy --compose-file docker-compose-admin.yml admin

echo "CREATING METRICS SERVICES STACK..."
export $(cat .env) && docker stack deploy --compose-file docker-compose-metrics.yml metrics

