# docker-swarm-cluster
Combines some tooling for creating a good Docker Swarm Cluster.

#### HTTP(S) Ingress
- Traefik

#### Cluster Management
- Swarm Dashboard
- Portainer
- Docker Janitor

#### Metrics Monitoring
- Heavily inspired on https://github.com/stefanprodan/swarmprom
- Prometheus
- Unsee Alert Manager
- Grafana

### TODO
#### Logs aggregation
- FluentBit
- Graylog

#### Volume management
- Ceph


## Installation
1. Install Ubuntu on all VMs you're mean't to use in your Swarm Cluster
2. Install the latest Docker package on all VMs
3. On one of the VMs:
   1. Execute ````docker swarm init````
   2. Copy the provided command/token
4. On the other machines, run the provided command so they will join the Swarm Cluster
5. ```git clone https://github.com/flaviostutz/docker-swarm-cluster.git```
6. Setup .env parameters
7. Run ```initialize-services.sh```
8. Open http://portainer.mycluster.org and point it to "Local Daemon"
9. Look into docker-compose-* files for understanding the cluster topology

## Customizations
1. Change the desired compose file for specific cluster configurations
6. Run ```initialize-all.sh``` for updating modified services

## docker-compose files
- Swarm stack doesn't support .env automatically (yet). You have to run ```export $(cat .env) && docker stack...``` so that those parameters work
- docker-compose-ingress.yml
  - ```export $(cat .env) && docker stack deploy --compose-file docker-compose-ingress.yml ingress```
  - Traefik Dashboard: [http://traefik.mycluster.org:6060]()
- docker-compose-admin.yml
  - ```export $(cat .env) && docker stack deploy --compose-file docker-compose-admin.yml admin```
  - Swarm Dashboard: [http://swarm-dasboard.mycluster.org]()
  - Portainer: [http://portainer.mycluster.org]()
  - Janitor: will perform system prune from time to time to release unused resources
- docker-compose-metrics.yml
  - ```export $(cat .env) && docker stack deploy --compose-file docker-compose-metrics.yml metrics```
  - Prometheus: [http://prometheus.mycluster.org]()
  - Grafana: [http://grafana.mycluster.org]()
  - Unsee: [http://unsee.mycluster.org]()
- docker-compose-logs.yml
  - ```export $(cat .env) && docker stack deploy --compose-file docker-compose-logs.yml logs```
  - Graylog: [http://graylog.mycluster.org]()
- docker-compose-volumes.yml
  - ```export $(cat .env) && docker stack deploy --compose-file docker-compose-volumes.yml logs```
  - Ceph UI: [http://ceph.mycluster.org]()
