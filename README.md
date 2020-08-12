# docker-swarm-cluster

Combines some tooling for creating a good Docker Swarm Cluster.

## Overview

### HTTP(S) Ingress

* Caddy

### Cluster Management

* Swarm Dashboard
* Portainer
* Docker Janitor

### Metrics Monitoring

* Prometheus
* Unsee Alert Manager
* Grafana with some pre-configured made dashboards
* Heavily inspired on https://github.com/stefanprodan/swarmprom

## Installation

* Install Ubuntu on all VMs you're mean't to use in your Swarm Cluster

* Install the latest Docker package on all VMs (https://docs.docker.com/engine/install/ubuntu/)

* Configure Docker to use jornald for logging on all VMs (defaults to max usage of 10% of disk)

```sh
echo '{"log-driver": "journald"}' > /etc/docker/daemon.json
service docker restart
```

* On one of the VMs:
  * Execute ```docker swarm init```
  * Copy the provided command/token

* On the other machines, run the provided command so they will join the Swarm Cluster

* ```git clone https://github.com/flaviostutz/docker-swarm-cluster.git```

* Setup .env parameters

* Run ```create.sh```

* Open http://portainer.[yourdomain] and point it to "Local Daemon"

* Look into docker-compose-* files for understanding the cluster topology

* Run `curl -kLv --user whoami:whoami123 localhost` and verify if the request was successful

## Tricks

* Caddy has a "development" mode where it uses a self signed certificate while not in production. Just add `- caddy.tls=internal` label to your service.


## Customizations

1. Change the desired compose file for specific cluster configurations
2. Run ```create.sh``` for updating modified services

## docker-compose files

* Swarm stack doesn't support .env automatically (yet). You have to run ```export $(cat .env) && docker stack...``` so that those parameters work
* docker-compose-ingress.yml
  * ```export $(cat .env) && docker stack deploy --compose-file docker-compose-ingress.yml ingress```
  * Traefik Dashboard: [http://traefik.mycluster.org:6060]()
* docker-compose-admin.yml
  * ```export $(cat .env) && docker stack deploy --compose-file docker-compose-admin.yml admin```
  * Swarm Dashboard: [http://swarm-dasboard.mycluster.org]()
  * Portainer: [http://portainer.mycluster.org]()
  * Janitor: will perform system prune from time to time to release unused resources
* docker-compose-metrics.yml
  * ```export $(cat .env) && docker stack deploy --compose-file docker-compose-metrics.yml metrics```
  * Prometheus: [http://prometheus.mycluster.org]()
  * Grafana: [http://grafana.mycluster.org]()
  * Unsee: [http://unsee.mycluster.org]()
* docker-compose-devtools.yml
  * ```export $(cat .env) && docker stack deploy --compose-file docker-compose-devtools.yml devtools```

### TODO

#### Volume management

* AWS/DigitalOcean BS

#### Logs aggregation

* FluentBit
* Kafka
* Graylog

#### Metrics Monitoring

* Telegrambot

