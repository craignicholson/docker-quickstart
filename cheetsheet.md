# Cheetsheet

A collection of commands and notes to memorize.

docker version
docker --version

ps aux | grep docker

--everything is here ...on nix
/etc/var/lib/docker/containers
/etc/var/lib/docker/devicemapper
/etc/var/lib/docker/image
/etc/var/lib/docker/network
/etc/var/lib/docker/swarm
/etc/var/lib/docker/tmp
/etc/var/lib/docker/trust
/etc/var/lib/docker/volumes

/etc/docker/daemon.json
.
..
daemon.json
key.json

/etc/var/run/docker.sock
/etc/var/run/docker.pid
/etc/var/run/docker.sock
/etc/var/run/docker/containerd
/etc/var/run/docker/libnetwork
/etc/var/run/docker/metrics.sock
/etc/var/run/docker/netns
/etc/var/run/docker/plugins
/etc/var/run/docker/runtime-runc
/etc/var/run/docker/swarm

-- check of diskspace
df -h

## namespaces

https://en.wikipedia.org/wiki/Linux_namespaces

mount (mnt)
process id (pid)
network (net)
interprocess communication (ipc)
UTS
User ID (user)
Control Group (cgroups)

## cgroups

https://en.wikipedia.org/wiki/Cgroups

memory - resource limiting
cpu & IO - prioritzation
accounting 
control - freezing of groups of processing, checkpointing and restarrting
libcgroup

docker service create --name myservice --p 80:80 --env MYVAR=CRAIG --workdir /user/home/crap
docker rm $(docker ps -a -q)
docker rm `docker ps -a -q`
docker network rm mynet

Dockerfile  EXPOSE - containers will listen on the indicated port at lauch.

docker ps
docker build -tmyimage:v1' .

docker pull httpd:latest

RUN - stick your apt-gets and yums here to install packages

docker prune
--all (-a)
--force (-f)
--volumes, unsued volumes

Setup Logging driver Info Setup
daemon.json
{
  "log-driver" : "syslog",
  "log-opts" : {
    "labels" : "production_log",
    "env" " "os,customer"
  }

}

--print the logs of the last 25 records in a container
docker logs --tail 25 myweb_container

docker swarm init --advertise-addr IPADDRESS

docker service scale myservice=5

docker login
docker push new httpd:new

Run a default command at launch time in a container, that
can be overidded.

ENTRYPOINT

docker images

https://docs.docker.com/engine/reference/commandline/tag/
--remember this pattern, container referenced is last ...
docker -tag http:new http:old

docker swarm unlock
--give me your key

--Remove a manager from the swarm
docker node demote NODEID

docker service rm SERVICENAME

docker network create
  --driver=overlay
  --subnet=192.168.0.1/16
  --gateway=192.168.0.1
  --ip-range=192.168.0.1/16 
    to further subdived the network
     --attachable           Enable manual container attachment
      --aux-address map      Auxiliary IPv4 or IPv6 addresses used by Network driver (default map[])
      --config-from string   The network from which copying the configuration
      --config-only          Create a configuration only network
  -d, --driver string        Driver to manage the Network (default "bridge")
      --gateway strings      IPv4 or IPv6 Gateway for the master subnet
      --ingress              Create swarm routing-mesh network
      --internal             Restrict external access to the network
      --ip-range strings     Allocate container ip from a sub-range
      --ipam-driver string   IP Address Management Driver (default "default")
      --ipam-opt map         Set IPAM driver specific options (default map[])
      --ipv6                 Enable IPv6 networking
      --label list           Set metadata on a network
  -o, --opt map              Set driver specific options (default map[])
      --scope string         Control the network's scope
      --subnet strings       Subnet in CIDR format that represents a network segment

docker network ls

docker swarm leave

docker swarm join-token manager

-- Logs for your service
docker service logs SERVICENAME
docker logs --tail 25 SERVICENAME

why do we have 2 ways here??? 

--list all running swarms
docker swarm ls

-- stop a container
docker stop myweb

docker service create --name myexample --replicas 4 IMAGENAME

--if your swarm manager has lost majority
--you need to force a new cluster
docker swarm init --force-new-cluster --advertise-addre IPADDRESS

-- re-init swarm to keep it from connecting to old nodes
docker swarm init --force-new-cluster 

-- make a work node also a manager in a swarm
docker node promote NODEID

docker run -d --name myweb httpd:latest

-- commands to remove image even if
-- containers are based on the container
docker rmi -f mistake:v1

docker container inspect CONTAINER | grep $VAR
docker container inspect CONTAINER | grep IPAddress
docker container inspect CONTAINER | grep Ports
docker container inspect --format="{{.NetworkSettings.Networks.[yournetworkdriver].IPaddress}}" CONTAINER
docker container inspect --format="{{.NetworkSettings.Ports}}" CONTAINER

--import a saved image tar file
docker load -i httpd-latest.tar 

docker pull registry
-- runs on port 5000, uses TLS to help u setup private registry

docker service ls

docker node rm NODEID
- only works on a manager

what performs a docker service create
- no volume available, when -v or --volume is used
- --mount[source/path], target=[path] is used

--draining... a cluster node to prevent services
--from running on it in the future
--when we are geting ready to remove the node
docker node update --availability drain NODEID
--from the manager

--how do you update a privously draining / removed node 
-from the cluster
docker node update --availablity active NODEID
--from the manager

export an image to a tar file
docker save -o http-latest.tar httpd:latest

docker swarm join TOKEN:IP

--review a node, with formatted output
docker node inspect --pretty NODEID

docker swarm init --force-new-cluster

docker swarm ls
--list all running swarms

docker service create
  -dns
  -dns-search
  -dns-list
  -p
  -env
  --workdir

Information about global service.
 - runs on each active node in the swarm
 --mode [global]
 - the repicate is a default when not idicated OR when replica number is provided

command to create/init one replica

-- initialize single replica.
-- init, not deploy!!!!
docker service create IMAGENAME

docker swarm create --name --replica 1

docker exec -it IMAGENAME \bin\bash

--login with specific username
docker login --username=COMPANY_ACCOUNT

Export/Save
docker save -o httpd-latest.tar httpd:latest
Import/Load
docker load -i http.latest.tar

docker node update --availability active

Dockerfile - create a mount point
VOLUME

docker node inspect --pretty NODEID

docker service create IMAGENAME

how to you create a swarm to make it ready for new nodes
docker swarm init --advertise-addr IPADRESS

--lock a swarm
docker swarm init --autolock --advertise-add IPADDRESS
--ouputs the key which you need to keep

--create a network
docker network create --subnet[RANGE] myNetworkName

-- stop a stuck / frozen container
docker kill myweb

****
-- stop a container 10 seconds after execution of a request
docker stop -t 10 myweb
****

docker --tag httpd:latest http:old

List processes running in SWARM cluster
docker service ps SERVICENAME

--list the nodes in a swarm
docker node ls

docker volume ls
- list the volumes
- will propogate on ... something

--status of a swarm cluster
docker node ls

--options to create and update a service
docker service create
docker service update

--name
--publish
--env
--workdir

docker network create --subnet=[0.0.0.0/16] mynet

docker stop -t 10 myweb

--change dns
daemon.json
{
  "log-driver" : "syslog",
  "log-opts" : {
    "labels" : "production_log",
    "env" " "os,customer"
  }

  "dns" : ["8.8.8.8", "8.8.4.4"]
}

READ UP ON

docker volume ls
docker volume inspect myvolume

docker create volume myvolume

docker info

-create a volume to be shared by a cluster.
docker service create --name testweb -p 80:80 --mount myvolume, target=/insterval-mount --detach=false --replicas 3 httpd

--privledged

--save an image after we make additional changes to it.
docker commit -m "Notes made here" myweb httpd:v2

--which is correct???
docker run -d --name myweb -v /local/dir:/my/data/volume httpd:latest
docker run -d --name myweb --volumes /local/dir:/my/data/volume httpd:latest
_NIETHER>>>>

You need to launch a detached web container based on the 'httpd' image on your system. That container should bind to a host directory called /my/webfiles to the /usr/local/apache2/htdocs directory on the container, to serve content from. Which of the following container instantiation commands would accomplish that goal?

docker run -d --mount type=bind,src=/my/webfiles,target=/usr/local/apache2/htdocs httpd

You have received a 'docker inspect' report that
 appears to be formatted as one long line. 
 What option can you instruct your staff to 
 use next time in order to clean up the format 
 into something more readable?

Correct answer
--format="{{.Structure.To.Review}}" [objectid/name]

If you want an instantiated container named 'myweb' to have a path inside of it called '/my/data/volume', which command would accomplish this?

Which of the following commands will recreate the Dockerfile from an existing image?
NONE OF THE ABOVE

You need a container running Apache to be launched from an image called 'http:latest'. 
This container should be named 'myweb' and mount the underlying hosts's '/var/www/html' 
directory in the container's '/usr/local/apache2/htdocs' directory. 
Which command will accomplish this?

Correct answer
docker run -d --name myweb -v /var/www/html:/usr/local/apache2/htdocs httpd:latest

Explanation
The '-v [path on host]:[path in container]' format is used to mount a host's path and contents, making it available inside the indicated path in the container.

Cool Stuff

--web farm
docker run -d -p 8080:80 httpd:myapp
docker run -d -p 8081:80 httpd:myapp
docker run -d -p 8082:80 httpd:myapp

-- setup load balance with haproxy
docker run -d -p 80:80 haproxy