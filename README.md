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
  * See #Cloud provider tips section for details

* Install the latest Docker package on all VMs (https://docs.docker.com/engine/install/ubuntu/)

* On one of the VMs:
  * Execute ```docker swarm init```
  * Copy the provided command/token

* On the other machines
  * Run the provided command from when you run `swarm init` so they will join the Swarm Cluster
    * Don't forget to use `--advertise-addr [localip]` with a local IP that connects those machines if they are local so that you don't use a public IP for that (by using Internet link)
    * Ex.: `docker swarm join --advertise-addr 10.120.0.5 --token ...`

* Make some Docker daemon configurations
  * **This has to be made after joining Swarm so that network 172.18/24 already exists (!)**
  * Use journald for logging on all VMs (defaults to max usage of 10% of disk)
  * Enable native Docker Prometheus Exporter

```sh
echo '{"log-driver": "journald", "metrics-addr" : "172.18.0.1:9323", "experimental" : true}' > /etc/docker/daemon.json
service docker restart
```

* Start basic cluster services

  * ```git clone https://github.com/flaviostutz/docker-swarm-cluster.git```
  * Take a look at docker-compose-* files for understanding the cluster topology
  * Setup .env parameters
  * Run ```create.sh```

* On one of the VMs, run `curl -kLv --user whoami:whoami123 localhost` and verify if the request was successful

## Security

* Protect all your VMs with a SSH key (https://www.cyberciti.biz/faq/ubuntu-18-04-setup-ssh-public-key-authentication/)
  * If you leave then with weak passwords it's a matter of hours for your server to be hacked (ransomwares mainly)
* Disable access to all ports of your server (but :80 and :443) by configuring your provider's firewall (or by using an internal firewall like iptables)

## Service URLs

Services will be accessible by URLs:
    http://portainer.mycluster.org
    http://dashboard.mycluster.org
    http://grafana.mycluster.org
    http://unsee.mycluster.org
    http://alertmanager.mycluster.org
    http://prometheus.mycluster.org

Services which don't have embedded user name protection will use Caddy's basic auth. Change password accordingly. Defaults to admin/admin123

The following services will have published ports on hosts so that you can use swarm network mesh to access admin service directly when Caddy is not accessible
  
* portainer:8181
* grafana: 9191

So point your browser to any public IP of a member VM to this port and access the service


## Production tips

### Optimal Topology

* Have a small VM in your Swarm Cluster to have only basic cluster services. Avoid any other services to run in this server so that if your cluster run out of resources you will still have access to monitoring and admin tools (grafana, portainer etc) so that you can diagnosis what is going on and decide on cluster expansion, for example.

PLACE IMAGE HERE

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

## Cloud provider tips

### Digital Ocean

* For HTTPS certificates, use Let's Encrypt in Load Balancers if you are using a first level domain (something like stutz.com.br). We couldn't manage to make it work with subdomains (like poc.stutz.com.br).

* For subdomains, use certbot and create a wildcard certificate (ex.: *.poc.stutz.com.br) manually and then upload it to Digital Ocean's Load Balancer.

```sh
apt-get install letsencrypt
certbot certonly --manual --preferred-challenges=dns --email=me@me.com --server https://acme-v02.api.letsencrypt.org/directory --agree-tos -d *.poc.me.com
```

#### VMs

* Use image Marketplace -> Docker
* Check "Monitoring" to have native basic VM monitoring from DO panel

