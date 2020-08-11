#!/bin/bash

echo "DELETING INGRESS SERVICES STACK..."
docker stack rm ingress

echo "DELETING ADMINISTRATION SERVICES STACK..."
docker stack rm admin

echo "DELETING METRICS SERVICES STACK..."
docker stack rm metrics

docker network rm caddy
docker network rm caddy_controller
docker network rm admin
docker network rm metrics
