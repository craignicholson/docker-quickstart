# Cheetsheet

## TODO

UCP
docker compose

## Linking containers

Legacy... Skip this.

```bash
docker pull mysql:latest
docker run -d --name mysql-container -e MYSQL_ROOT_PASSWORD=wordpress -d mysql 89c8554d736862ad5dbb8de5a16e338069ba46f3d7bbda9b8bf491813c842532

docker pull wordpress:latest
docker run -e WORDPRESS_DB_PASSWORD=password --name wordpress-container --link mysql-container:mysql -p 8080:80 -d wordpress
189c0f04ce7694b4f9fadd36624f6f818023d8d1f3ed1c56de5a516255f328a9


```

## Skill-set for Operations when deploying containers

This is a TEAM (6-7 people, minimum of 4 people)  On-call needs min of 4 people.

- Need to understand operations
 -- skeletons are buried
 -- snowflakes
 -- apps that are brittle
- Understand deployments
 -- how to weave in containers into the infrastructure
 -- best fit for the containers (stateless apps)
- Tooling
 -- what tooling do we need to push, remove, update
 -- what do we need to build where tooling does not support
- Monitoring
 -- what do we want to monitor
 -- how can we monitor...
 -- what exists that we can buy
- Kernal Understanding
 -- kernal crashes
 -- what is going on upstrem
 -- b/c containers run on the kernal
- Networking
 -- how to setup it up
 -- what integrates with us now
 -- what is best for us now
- Security
 -- understand what is out of the box setup
 -- standards in the community in containers, or just like OWASP
 -- Individual needs to enjoy infosec
- Polictics
 -- Good for Internal Adoption
 -- Manage relationships
 -- helps with migration and early adoption
- Project Manager
 -- Mediator

## Description

A collection of commands and notes to memorize about Docker containers. A container
is a stateless application.  Emphermal.  Disposable.

It's layer in the data processing where we just do something with the data and never
keeps any of the data.

Stateless is good for scaling out your servics.

Easy to iterate and upgrade applications.

Containers - Everything is mush easier to deploy/update.

Get the version installed.

```bash
docker version
docker --version
```

## Performance or Check

```bash

# get the running processes on a container
docker top testweb

PID                 USER                TIME                COMMAND
79060               root                0:00                nginx: master process nginx -g daemon off;
79101               101                 0:00                nginx: worker process

#   -a, --all             Show all containers (default shows just running)
#      --format string   Pretty-print images using a Go template
#      --no-stream       Disable streaming stats and only pull the first result
#      --no-trunc        Do not truncate output
docker stats

CONTAINER ID        NAME                CPU %               MEM USAGE / LIMIT     MEM %               NET I/O             BLOCK I/O           PIDS
b4ab0202e788        testweb             0.00%               1.844MiB / 1.952GiB   0.09%               828B / 0B           0B / 0B             2

# check of diskspace
docker exec -it testweb /bin/bash
df -h

Filesystem      Size  Used Avail Use% Mounted on
overlay          59G  3.9G   52G   7% /
tmpfs            64M     0   64M   0% /dev
tmpfs          1000M     0 1000M   0% /sys/fs/cgroup
/dev/sda1        59G  3.9G   52G   7% /etc/hosts
shm              64M     0   64M   0% /dev/shm
tmpfs          1000M     0 1000M   0% /proc/acpi
tmpfs          1000M     0 1000M   0% /sys/firmware
```

## Events

https://docs.docker.com/engine/reference/commandline/events/

```bash

docker events
docker events --filter event=die --filter event=stop
docker events --since '1h'

2018-08-11T15:49:56.625924300-04:00 network connect a244f93b6f39f1f4c14ec3177785f060d98c64707d9244b82ff98daedebe7873 (container=b4ab0202e788815e0d99c39cfa4a139df428cdb3807969e496f3009e2ebc8d22, name=bridge, type=bridge)
2018-08-11T15:49:57.333300600-04:00 container start b4ab0202e788815e0d99c39cfa4a139df428cdb3807969e496f3009e2ebc8d22 (image=nginx, maintainer=NGINX Docker Maintainers <docker-maint@nginx.com>, name=testweb)
2018-08-11T15:51:44.193250300-04:00 container top b4ab0202e788815e0d99c39cfa4a139df428cdb3807969e496f3009e2ebc8d22 (image=nginx, maintainer=NGINX Docker Maintainers <docker-maint@nginx.com>, name=testweb)
2018-08-11T15:52:31.686973300-04:00 container exec_create: /bin/bash  b4ab0202e788815e0d99c39cfa4a139df428cdb3807969e496f3009e2ebc8d22 (execID=0305aa48edf0154a4b036c143ad151e12c4b2de0ee31684e77fa558765eecf55, image=nginx, maintainer=NGINX Docker Maintainers <docker-maint@nginx.com>, name=testweb)
2018-08-11T15:52:31.695525600-04:00 container exec_start: /bin/bash  b4ab0202e788815e0d99c39cfa4a139df428cdb3807969e496f3009e2ebc8d22 (execID=0305aa48edf0154a4b036c143ad151e12c4b2de0ee31684e77fa558765eecf55, image=nginx, maintainer=NGINX Docker Maintainers <docker-maint@nginx.com>, name=testweb)
2018-08-11T15:53:17.777760500-04:00 container exec_die b4ab0202e788815e0d99c39cfa4a139df428cdb3807969e496f3009e2ebc8d22 (execID=0305aa48edf0154a4b036c143ad151e12c4b2de0ee31684e77fa558765eecf55, exitCode=0, image=nginx, maintainer=NGINX Docker Maintainers <docker-maint@nginx.com>, name=testweb)

ps aux | grep docker

# show me the cha ged files in a container
docker diff testweb

C /root
A /root/.bash_history
C /run
A /run/nginx.pid
C /var
C /var/cache
C /var/cache/nginx
A /var/cache/nginx/client_temp
A /var/cache/nginx/fastcgi_temp
A /var/cache/nginx/proxy_temp
A /var/cache/nginx/scgi_temp
A /var/cache/nginx/uwsgi_temp

```

## Docker Architecture

/etc/var/lib is where the application lives.  All things are stored here.

```bash
/etc/var/lib/docker/builder
/etc/var/lib/docker/buildkit
/etc/var/lib/docker/containerd
/etc/var/lib/docker/containers
/etc/var/lib/docker/devicemapper
/etc/var/lib/docker/image
/etc/var/lib/docker/network
/etc/var/lib/docker/overlay
/etc/var/lib/docker/overlay2
/etc/var/lib/docker/plugins
/etc/var/lib/docker/runtimes
/etc/var/lib/docker/swarm
/etc/var/lib/docker/tmp
/etc/var/lib/docker/trust
/etc/var/lib/docker/volumes
```

Location of the docker daemon.json file.  You can edit the daemon to use specific
loggers and storage drivers.

```bash
sudo ls etc/docker
/etc/docker/daemon.json
.
..
daemon.json
key.json
```

Example daemon.json file with dns and logger settings.

```json
daemon.json
{
  "log-driver" : "syslog",
  "log-opts" : {
    "labels" : "production_log",
    "env" " "os,customer"
  }

  "dns" : ["8.8.8.8", "8.8.4.4"]
}
```

Location of the run files.

docker.sock is what we need permissions to... it's the socket our processes need to talk to to run commands.

```bash
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
```

## What is a container

Containers are processes created from tarballs and anchored to namespaces and controlled by cgroups.

### Strenghts

### Weakness

Bad for applications that maintain state. Just use the cloud.

(reasons to try, faster provision, stabiliy, recovery)

- Databases
- Use a cloud provider and tooling

Attempt to Containerize a Database

Node1 <>  Node2 <> Node3
  |        |         |
STORAGE-STORAGE-STORAGE

Data on a Volume.

Network Bound.

If you do containerize a database, but keep it small data.
Avoid putting the 16TB customer database in a container.
Just use cloud provider.

### namespaces

Determine what a PID (process) can see.

- Data directories. (/data)
- Other processes (PIDs)
- Only see's it's on slice of the universe

[https://en.wikipedia.org/wiki/Linux_namespaces](wiki)

- mount (mnt)
- process id (pid)
- network (net)
- interprocess communication (ipc)
- UTS
- User ID (user)
- Control Group (cgroups)

Docker uses namespaces, network and pid for security

### cgroups

Determin what the PID can **USE**.  5GB Memory, 5 CPU's, etc...

[https://en.wikipedia.org/wiki/Cgroups](wiki)

- memory - resource limiting
- cpu & IO - prioritzation
- accounting
- control - freezing of groups of processing, checkpointing and restarrting
- libcgroup - ?

### Remove containers

```bash
docker rm CONTAINERID
docker rm NAME
docker rm $(docker ps -a -q)
docker rm `docker ps -a -q`
```

## Services - docker sevice create

List the current services

```bash
docker service ls
```

List the **processes** for an individual service.

```bash
docker service ps SERVICENAME
```

### Example for docker service create

Typical flags for services.

docker service create
  -dns
  -dns-search
  -dns-list
  -p
  -env
  --workdir

```bash
# example service
docker service create --name myexample nginx

# example with ports
docker service create --name testweb -p 80:80 httpd

# Create a service with 4 replicats from an image
docker service create --name myexample --replicas 4 IMAGENAME

# --workdir string Working directory inside the container
docker service create --name myservice --p 80:80 --env MYVAR=CRAIG --workdir /user/home/crap

# Create a volume to be shared by a cluster.
docker volume create myvolume
docker service create --name testweb -p 80:80 --mount myvolume, target=/internal-mount --detach=false --replicas 3 httpd
```

### Scaling a service example

```bash
#SCALE A SERVICE - YOU CANNOT SCALE A SWARM.  SWARM is ALL THE SCALLED SERVICES
docker service scale myservice=5
docker service scale myservice=5
docker service scale myservice=5
docker service scale myservice=5
docker service scale myservice=5
docker service scale myservice=5
docker service scale myservice=5
docker service scale myservice=5
```

### Remove a service

```bash
docker service rm SERVICENAME
```

### Get the logs of a service

```bash
docker service logs SERVICENAME
docker logs --tail 25 SERVICENAME
```

### Update a service.  This is another way to scale

```bash
docker service update --replicates 3 testweb
```

Easier to remember this way:

```bash
docker service scale testweb=4
```

Where is this service deployed?  This will give you:

```bash
docker service ps myexample
```

- ID
- Name
- Image
- Node
- Desired State
- Current State
- Error
- Ports

Bonus: What performs a docker service create?

- no volume available, when -v or --volume is used
- --mount[source/path],target=[path] is used

## Dockerfile

EXPOSE - containers will listen on the indicated port at lauch.

RUN - stick your apt-gets and yums here to install packages

## docker system prune

Use docker prune to reset back to a base install.
> docker system prune -a --volumes

--all (-a)
--force (-f)
--volumes, unsued volumes

## Setup Logging driver Info Setup

daemon.json

```json
{
  "log-driver" : "syslog",
  "log-opts" : {
    "labels" : "production_log",
    "env" " "os,customer"
  }
}
```

## Docker Login

> docker login

Another way

> docker login --username=$USERNAME
> docker push new httpd:new

## Run a default command at launch time in a container, that can be overidded

ENTRYPOINT

docker images

https://docs.docker.com/engine/reference/commandline/tag/
--remember this pattern, container referenced is last ...

## Tags

> docker -tag http:newimage http:oldiamge

## Network

### Remove a network

> docker network rm mynet

### Creating a network

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

### List all networks

> docker network ls

## Logging

Show the logs for one container by the container id

Print the logs of the last 25 records in a container.

> docker logs --tail 25 myweb_container

### All logs

> docker logs
> docker logs -f --until=2s
> docker logs --tail 2500 ContainerName/ContainerID
> docker logs --follow ContainerName/ContainerID
> docker logs --timestamps ContainerName/ContainerID
> docker logs --since 2017-05-03 ContainerName/ContainerID

### docker logs [OPTIONS] CONTAINER

> docker container logs CONTAINER_ID | more

### Tail the logs for a service

Retrieve logs until a specific point in time

> docker logs -f --until=2s

### Logs for your service

> docker service logs SERVICENAME

## Swarm: If your swarm manager has lost majority you need to force a new cluster

> docker swarm init --force-new-cluster --advertise-addre IPADDRESS

## Swarm: Re-init swarm to keep it from connecting to old nodes

You only need to call this once, I typed it out many times to memorize the command.

Rebuild a swarm so it does not connect to old nodes

```bash
docker swarm init --force-new-cluster
docker swarm init --force-new-cluster
docker swarm init --force-new-cluster
docker swarm init --force-new-cluster
docker swarm init --force-new-cluster
docker swarm init --force-new-cluster
docker swarm init --force-new-cluster
```

## Swarm: Promote Worker to Manager

```bash
# make a worker node also a manager in a swarm
# run this on the current manager
docker node promote NODEID

docker run -d --name myweb httpd:latest

# commands to remove image even if
# containers are based on the container
docker rmi -f mistake:v1

docker container inspect CONTAINER | grep $VAR
docker container inspect CONTAINER | grep IPAddress
docker container inspect CONTAINER | grep Ports
docker container inspect --format="{{.NetworkSettings.Networks.[yournetworkdriver].IPAddress}}" CONTAINER
docker container inspect --format="{{.NetworkSettings.Ports}}" CONTAINER
```

### import a saved image tar file

> docker load -i httpd-latest.tar

## Registry Stuff

> docker pull registry
Runs on port 5000, uses TLS to help you setup private registry

## Remove a Node from cluster

> docker node rm NODEID

only works on a manager

## Remove drained nodes or re-add previously drained nodes

It's a node

> docker node update --availability drain NODEID
> docker node update --availability active NODEID

- draining... a cluster node to prevent services running on that node
- do this when we are geting ready to remove the node

> docker node update --availability drain NODEID
from the manager

## how do you update a privously draining / removed node from the cluster

> docker node update --availablity active NODEID

do this from the manager

## Which package should be installed to manage the Docker0 interface

REVIEW

- UBUNTU bridge-utils
- Centos we use net-utils...

## Information about global service

REVIEW

- runs on each active node in the swarm
- --mode [global]

command to create/init one replica

> docker swarm create --name --replica 1
> docker exec -it IMAGENAME \bin\bash

Login with specific username
> docker login --username=COMPANY_ACCOUNT

## Export (save) an image to a tar file

A tar archive containing all image layers and tags

> docker save -o http-latest.tar httpd:latest

Remember save -o --outputs **outputs** to a file.  We need to to give it a -o or --output and a file name with the image.

Export saves and image by outputing it to a file.  SAVE OUT. LOAD IN.

Export or Save the Image

```bash
docker save -o httpd-latest.tar httpd:latest
docker save -o httpd-latest.tar httpd:latest
docker save -o httpd-latest.tar httpd:latest
docker save -o httpd-latest.tar httpd:latest
docker save -o httpd-latest.tar httpd:latest
docker save -o httpd-latest.tar httpd:latest
docker save -o httpd-latest.tar httpd:latest
```

## Import/Load

Import loads a file from an **input** string -i --input.  SAVE OUT LOAD IN.

```bash
docker load -i http.latest.tar
docker load -i http.latest.tar
docker load -i http.latest.tar
docker load -i http.latest.tar
docker load -i http.latest.tar
docker load -i http.latest.tar
docker load -i http.latest.tar
```

## Dockerfiles

REVIEW

Create a mount point, remember in Dockerfile we only want volumes we can use anywhere so MOUNT on host is bad we need docker create VOLUME, and even though in a swarm we get the volume files are not on same servers unless your volume is like the same S3 bucket.

VOLUME

What is the correct syntax for the "exec" format of the CMD instruction?
CMD ["executable","param1","param2"]

## Inspect a node

> docker node inspect --pretty NODEID

## Swarm

How to you create a swarm to make it ready for new nodes

> docker swarm init
> docker swarm init --advertise-addr IPADDRESS

Lock a swarm

```bash
docker swarm init --auto-lock --advertise-addr IPADDRESS
docker swarm init --auto-lock --advertise-addr
docker swarm init --auto-lock --advertise-addr
docker swarm init --auto-lock --advertise-addr
docker swarm init --auto-lock --advertise-addr
docker swarm init --auto-lock --advertise-addr
docker swarm init --auto-lock --advertise-addr
docker swarm init --auto-lock --advertise-addr
```

> docker swarm join-token worker
> docker swarm join-token manager

Drop old nodes from the cluster
> docker swarm init --force-new-cluster

Join Example

> docker swarm join TOKEN:IP
> docker swarm join --token SWMTKN-1-146lxhb1sbm06h3kvzs3ha45l8jvnfrl1g1wt7rk1oad39mkrw-5c5uveacyu7svzff3kjckpnx5 192.168.65.3:2377

review a node, with formatted output
> docker node inspect --pretty NODEID

List all running swarms (WRONG OR RIGHT?)

> docker swarm ls #did not work on mac

### Initialize a swarm with autolocking enabled

> docker swarm init auto-lock --advertise-addr IPADDRESS

Swarm initialized: current node (k1q27tfyx9rncpixhk69sa61v) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join \
    --token SWMTKN-1-0j52ln6hxjpxk2wgk917abcnxywj3xed0y8vi1e5m9t3uttrtu-7bnxvvlz2mrcpfonjuztmtts9 \
    172.31.46.109:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.

To unlock a swarm manager after it restarts, run the `docker swarm unlock`
command and provide the following key:

    SWMKEY-1-WuYH/IX284+lRcXuoVf38viIDK3HJEKY13MIHX+tTt8

### Unlock A Swarm

docker swarm unlock
--give me your key

### Remove a manager from the swarm

> docker node demote NODEID

GRACEFULLY

> docker swarm leave
> docker swarm join-token manager

### Drain a node, and then bring node back online in a swarm

> docker node update --availability drain NODEID
> docker node update --availability active NODEID

## Lock Swarm that's already running with 'docker swarm update'

> docker swarm update --autolock=true

Swarm updated.
To unlock a swarm manager after it restarts, run the `docker swarm unlock`
command and provide the following key:

    SWMKEY-1-+MrE8NgAyKj5r3NcR4FiQMdgu+7W72urH0EZeSmP/0Y

Please remember to store this key in a password manager, since without it you
will not be able to restart the manager.S

### Rotate the unlock key

> docker swarm unlock-key --rotate

You should rotate the locked swarm’s unlock key on a regular schedule.

Successfully rotated manager unlock key.

To unlock a swarm manager after it restarts, run the `docker swarm unlock`
command and provide the following key:

    SWMKEY-1-8jDgbUNlJtUe5P/lcr9IXGVxqZpZUXPzd+qzcGp4ZYA

Please remember to store this key in a password manager, since without it you
will not be able to restart the manager.

### View the current unlock key for a running swarm

> docker swarm unlock-key
To unlock a swarm manager after it restarts, run the `docker swarm unlock`
command and provide the following key:

    SWMKEY-1-8jDgbUNlJtUe5P/lcr9IXGVxqZpZUXPzd+qzcGp4ZYA

Please remember to store this key in a password manager, since without it you
will not be able to restart the manager.

### Unlock

> docker swarm unlock

Please enter unlock key:

## Questions

REVIEW
Q: Which two ways does a source container make connectivity information available to a linked destination container?
A: Via environment variables and updates to the /etc/hosts file

Remember linked is old and uses env.

Q: What is the default MTU applied to the "docker0" bridge?
1500 bytes

Q:What is the function of the CMD instruction if the ENTRYPOINT instruction is also used?
A: CMD instructions get interpreted as arguments to ENTRYPOINT

CMD ["echo","this reality","cd /","ls -al"]

Q:Which 3rd party command line tool is often used to inspect "docker0" bridge config information?
A: brctl

Q: What happens to files and directories in the same directory as the Dockerfile?
A: Ignored...  need to use COPY to be added to the image.

## Docker Networks

> docker network create --subnet[RANGE/24] myNetworkName
> docker network create --driver bridge --subnet 10.1.0.0/24 --gateway 10.1.0.1 mybridge01
> docker network inpect

```json
[
    {
        "Name": "mybridge01",
        "Id": "c938ecbf8fcd2d938ddff5ff5379d74f14f6307f0e74d82e022be18486b72dc9",
        "Created": "2018-08-09T12:38:09.7344879Z",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": {},
            "Config": [
                {
                    "Subnet": "10.1.0.0/24",
                    "Gateway": "10.1.0.1"
                }
            ]
        },
        "Internal": false,
        "Attachable": false,
        "Ingress": false,
        "ConfigFrom": {
            "Network": ""
        },
        "ConfigOnly": false,
        "Containers": {},
        "Options": {},
        "Labels": {}
    }
]
```

Use Case:
When using my own network this way we could restrict the .4 to say ... node # 4

> docker run -it --name nettest1 --net br04 centos:latest /bin/bash

Static IP assigned

> docker run -it --name nettest2 --net br04 --ip 10.1.4.100 centos:latest /bin/bash

Review

> docker network inspect br04

```json
[
    {
        "Name": "br04",
        "Id": "4ffc6b3f2d02d5ad1000fb292aa6725847d18a022ee253810b17d265f6435d80",
        "Created": "2018-08-09T12:59:58.8237428Z",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": {},
            "Config": [
                {
                    "Subnet": "10.1.0.0/16",
                    "IPRange": "10.1.4.0/24",
                    "Gateway": "10.1.0.1"
                }
            ]
        },
        "Internal": false,
        "Attachable": false,
        "Ingress": false,
        "ConfigFrom": {
            "Network": ""
        },
        "ConfigOnly": false,
        "Containers": {},
        "Options": {},
        "Labels": {
            "host4network": ""
        }
    }
]
```

## Murder Death Kill (joke about a movie)

stop a stuck / frozen container

> docker kill myweb

Stop a container 10 seconds after execution of a request

```bash
docker stop -t 10 myweb
docker stop -t 10 myweb
docker stop -t 10 myweb
```

## Taging

> docker --tag httpd:latest http:old
> docker --tag httpd:new_image http:old_image

REVIEW

List the services

> docker service ls

List this processes running in SWARM cluster.  Process is PID.
PID runs are node.  PIDs exist because they are a service which is a continer.

> docker service ps SERVICENAME

FYI - Processes in a swarm cluster are the SERVICES.
FYI - Processes in a swarm cluster are the SERVICES

List the nodes in a swarm

> docker node ls

List the Volumes

> docker volume ls
- list the volumes
- will propogate on ... something

Status of a swarm cluster

> docker node ls

Shows the status of each node in the cluster.

> docker network create --subnet=[0.0.0.0/16] mynet

Stop a container in 10 seconds

> docker stop -t 10 myweb

REVIEW
--change dns

```json
daemon.json
{
  "log-driver" : "syslog",
  "log-opts" : {
    "labels" : "production_log",
    "env" " "os,customer"
  }

  "dns" : ["8.8.8.8", "8.8.4.4"]
}
```

REVIEW UP
docker volume ls
docker volume inspect myvolume
docker create volume myvolume
docker info

--privledged

## Commit an container

When changes are made to a Docker image and are ready to be made available for containers to be instantiated on, which of the following commands would make that new image available, called 'httpd:v2'?

```bash
docker commit -m "Notes made here" myweb httpd:v2

# create new image from a container you have stopped.
# need to test if this works on running containers
# Yup works on running containers too...
docker commit changed_container newcontainer:v1
```

The 'docker commit' command is used to take a container's build and commit it to the indicated image name.

## Volumes

These are the same command.

docker run -d --name myweb -v /local/dir:/my/data/volume httpd:latest
docker run -d --name myweb --volumes /local/dir:/my/data/volume httpd:latest

You need to launch a detached web container based on the 'httpd' image on your system. That container should bind to a host directory called /my/webfiles to the /usr/local/apache2/htdocs directory on the container, to serve content from. Which of the following container instantiation commands would accomplish that goal?

docker run -d --mount type=bind,src=/my/webfiles,target=/usr/local/apache2/htdocs httpd

You have received a 'docker inspect' report that
 appears to be formatted as one long line. 
 What option can you instruct your staff to 
 use next time in order to clean up the format 
 into something more readable?

Correct answer
--format="{{.Structure.To.Review}}" [objectid/name]

## If you want an instantiated container named 'myweb' to have a path inside of it called '/my/data/volume', which command would accomplish this?

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

## Web Farm

--web farm
docker run -d -p 8080:80 httpd:myapp
docker run -d -p 8081:80 httpd:myapp
docker run -d -p 8082:80 httpd:myapp

-- setup load balance with haproxy
docker run -d -p 80:80 haproxy

## Additional Notes

## Docker Certified Associate Prep Course

  [ Complete Docker Installation on Multiple Platforms (CentOS/Red Hat) ]
    CentOS
    diff storage and device mappers for our containers
    Remove docker from general repo's for Centos and Redhat
    You need the official community edition for the test
    Login as root | sudo -s
    yum install -y yum-utils device-mapper-persistent-data lvm2
    Config Docker Repos
    yum-conifig-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    yum-conifig-manager --add-repo https://download.docker.com/linux/centos/docker-ee.repo
    yum update
    yum install docker-ce
    ----
    systemctl enable docker &amp;&amp; systemctl start docker &amp;&amp; systemctl status docker 
    Now we did all of this as root, so running as local admin we will get permissions denied when we run docker images
    adding our user account to docker file as non-root...
    cd /var/run
    ls -al docker.sock
    ---
    usermod -aG  docker user 
    exit
    logout and log back in, and you should be able to run docker as non root user

## Complete Docker Installation on Multiple Platforms (Debian/Ubuntu)

    debian/ubuntu install
    apt-get install apt-transport-https ca-certificates curl software-properties-common
    curl -fsSSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository &quot;deb [arch=amb64] https://download.docker.com/linux/ubuntu/ $(lsb_release -cs) stable&quot;
    apt-get update
    apt-get install docker-ce
    systemctl status docker
    cd /var/run
    ls -al docker.sock
    OR
    ls -al /var/run/docker.sock
    usermod -aG docker user
    exit
    exit
    docker images
    logout and then log in
    docker images
    KNOW OF EXAM
    We will use CentOS for this course

## Selecting a Storage Driver

    Storage Drivers - for volumes???
    depending on docker-ce or docker-ee and which OS the storage driver picked will allow for efficeinties
    CentOS Support - DeviceMapper
    BlockStorage Device - actual DISK
    How do you tell what your docker storage adapter is?
    docker info
    docker info | grep Storage
    overlay2
    on mac
    ee supports devicemapper
    sudo su - cd /etc/docker
    look for key.json
    vi daemon.json
    { &quot;storage driver&quot;: &quot;devicemapper&quot;}
    now we have to restart docker
    you should do this before you create or import images
    systemctl stop docker
    sysmctl start docker
    cd /var/lib/docker
    ls -ll
    cd devicemapper

## Configuring Logging Drivers (Syslog, JSON-File, etc.)

    LOGS
    https://docs.docker.com/config/containers/logging/configure/#supported-logging-drivers

## Setting Up Swarm (Add Nodes)

    docker swarm join --token $BIGLONTOKEN
    add that to another server on same network
    docker node ls
    reviews the swarm setup
    docker swarm join-token worker
    docker swarm join-token manager
    use those to get the tokens
    as long as you are on the server with the docker swarm manager running
    docker node ls
    id, hostname, status, availabiliy, manager status
    Manager Status = Leader
    ID with * means it has special status... it's the leader
    docker system info
    you can see one manager and one node in the info
    On the workers... docker node is will not work
    docker system info | more
    .. Swarm:  active
    Is Manager: true
    Managers: 1
    Nodes: 3

## Setting Up a Swarm (Backup and Restore)

     Setting Up a Swarm (Backup and Restore)
    docker images
    docker node ls
    docker service create --name bkupweb -p 80:80 httpd
    creates a services of web services instances
     docker service create --name bkupweb -p 80:80 --replicas 2 httpd
    docker service ls
    docker service ps bkupweb
    sudo su -
    cd /var/lib/docker
    ll
    cd swarm
    ll
    mkdir /root/swarm
    cd /root/swarm
    cp -rf /var/lib/docker/swarm
    ll
    this is a back up of our dir
    systemctl start docker
    system will restart to see if we backed up the service
    docker server ls
    docker service ps bkupweb
    this will show us where the services is backed up and running
    cd /root/swarm
    tar cvf swarm.tar /swarm
    we created a tar file
    we can push this back up somewhere we can restore it
    scp swarm.tar user@servicename
    pwd
    we just moved the file / backup to another server
    check the service
    systemctl status docker
    docker service ls
    systemctl stop docker
    docker ps -a
    sudo systemctl stop docker
    sudo  systemctl stop docker
    we crashed the swarm
    so how do we recover the swarm... 
    and put it back in the state while it was running
     cd /var/lib/docker
    sudo su -
    ll
    rm -rf /swarm
    remove it all 
    systemctl stop docker
    cd /home/user
    mkdir /tmp
    tar xvf ../swarm.tar
    ll
    mv swarm/ /var/lib/docker
    move the unpacked back up ... back into production
    cd /var/lib/docker
    ll
    check to see if it exists
    systemctl start docker
    soon as docker starts... we have to init a new cluster
    docker swarm init --force-new-cluster
    now the swarm join token is the same as the other workers
    we have persisted the keys .... and rebuilt the swarm
    docker service ls
    docker service ps bkupweb
    docker service ls
    all you need to do is copy the swarm directly... to backup and restore

## Outline the Sizing Requirements Prior to Installation

    Outline the Sizing Requirements Prior to Installation
    for our ENV
    CPU, Memory, DISK
    Concurrency - what the the requirements....
    expected generally load at any given time, at peak and total
    Peak for EVENTS
    typically load ... helps to size the instance ... 
    when devising constraints... 
    Universal Control Plane (UCP)
    Breakdown of Manager Nodes for Fault Tolerance
    firewalls, ... what are all the ports in docker... as well
    what is traveling over what port
    Min Requirements
    8GB RAM
    for managers...
    4GB RAM for Workers
    https://docs.docker.com/engine/swarm/admin_guide/#recover-from-disaster
    ------------
    recommended
    raft consenus timesout of 3 sec, not config
    gossip 5 sec.
    so when you arch.  manager to manager must be able to communicate within these time frames
    those timeouts are not all configurable... 
    what's my hop count?  optimize this...

## Set Up and Configure Universal Control Plane (UCP) and Docker Trusted Repository (DTR) for Secure Cluster Management

    no needed for DCA exam...
    Universal Control Plan
    you need 2GB or higher in memory for UCP
    all linux servers here at 2GB or memory
    need to have a cluster already created
    docker node ls
    docker container run --rm -it --name ucp -v /var/run/docker.sock:/var/run/docker.sock docker/ucp:2.2.4 install --host-address $PRIV_IP --iteractive
    cat /etc/hosts
    for this we had to add in hosts in DNS b/c LA cloud servers don't have this setup
    examples
    IP tcox4.mylabserver.com
    IP ucp.example.com
    IP tcox5.mylabserver.com
    IP dtr.example.com
    IP tcox6.mylabserver.com
    the IPs are the private IPs in cloud server
    example.com is wild card cert internal names that works with dtr
    PUBLICIP ucp.example.com
    PUBLICIP dtr.example.com
    finally run this...
    docker container run --rm -it --name ucp -v /var/run/docker.sock:/var/run/docker.sock docker/ucp:2.2.4 install --host-address $PRIV_IP --iteractive
    alias: ucp.example.com 
    ucp is now on the manager node
    docker ps
    needs lots of ports
    $ w
    shows load on server
    load eventually settles down, let is churn for 5 min below 1.5
    1-2 questions on exam... scenarios anything you can do in the web app you can do in the console

## Complete Backups for UCP and DTR

    omplete Backups for UCP and DTR (Docker Trusted Registry)
    docker container run --log-driver non --rm -i --name ucp -v /var/run/docker.sock:/var/run/docker.sock docker/upc backup &gt; backup.tar
    shows the id we need
     docker container run --log-driver non --rm -i --name ucp -v /var/run/docker.sock:/var/run/docker.sock docker/upc backup --id $ID &gt; backup.tar 
    --------
    ll
    see if .tar was created
    tar vck backup.tar
    restore
    docker container run --log-driver non --rm -i --name ucp -v /var/run/docker.sock:/var/run/docker.sock docker/upc restore --id $ID &lt; backup.tar
    ---
    mv backup.tar ucp-backup-20171231.tar
    DTR backup
    docker run -i --rm docker/dtp backup --ucp-insecure-tls --ucp-url https://tcox4.mylanbserver.com:443 --ucp-sername admin &gt; dtr.backup.tar
    ls -al
    is backup there
    tar tvf dtr.backup.tar
    tos ee whats in tar
    docker run -i --rm docker/dtp backup --ucp-insecure-tls --ucp-url https://tcox4.mylanbserver.com:443 --ucp-username admin --ucp-password password &lt; dtr.backup.tar
    that restores the dtr backup

## Setting Up Swarm (Configure Managers)

docker swam init --advertise-addr 10.0.0.11

## Pull an Image from a Registry (Using Docker Pull and Docker Images)

    docker images
    most will use docker pull and and push from docker... but we can also pull from private repo, but this is from enterprise edition
    This is just default docker hub...
    docker pull hello-world
    this will pull the latest tag but the lack of giving the docker pull a version
    what if you want to pul all the tags for an image
    docker pull -a hello-world
    docker pull --all hello-world
    When you do a docker pull it is assumed the images are verified by the repository
    you can pull images that have not been signed ... if you trust them
    docker pull --disable-content-trust  hellow-world
    max concurrent downloads... willl be discussed later
    docker images
    repo
    image id
    ted
    created
    size on disk
    docker run hello-world
    docker images
    docker images --all
    docker images --digests
    FILTERING
    dangling images... images not associated with anything
    docker pull centos:6
    filter just filters the images you are searching for
    show be images before or after an certain image was created
    docker images --filter &quot;before=centos&quot;
    docker images --filter &quot;since:centos&quot;
    docker images -- no-trunc
    shows us the full image id
    ImageID is 12 chars of the full image id
    docker images centos:6
    docker images -q
    lists just the short image id
    usefull for feeding this into an argument
    $(docker images -q)

## Searching an Image Repository

    docker search apache
    to find images to you might want to use
    let's get a line count of that
    docker search apache | wc -l
    counts the number of lines with word apache in the results
    docker search --filter stars=50 apache
    docker search -f stars=500 apache
    docker search --filter stars=500 apache
    show me results when &gt;=500 stars
    docker search --filter stars=500 is-official apache
    you can use only one filter at a time
    docker search --filter stars=50 --filter is-official=true apache
    docker search --limit 10 apache
    --gets you the top 10
    this will search from docker hub or your own enterprise repo

## Tag an Image

    CUSTOMIZE IMAGES
    docker tag SOURCE TARGET
    docker tag centos:6 mycentos:1
    centos                                     6                   70b5d81549ec        3 months ago        195MB mycentos                                   1                   70b5d81549ec        3 months ago        195MB
    docker rmi centos:6
      554  docker rmi centos:6   555  docker images   556  docker rmi mycentos:1   557  docker images

## Use CLI Commands to Manage Images (List, Delete, Prune, RMI, etc)

    IMAGE CMD
    docker image 
    build
    history
    import
    inspect
    load
    ls
    prune pull push
    rm
    save
    tag
    docker image history centos:6
    shows the build history of the image
    all of the command ran in the docker file
    docker image save - saves to a .tar file
    If i wanted to share an image with someone without pushing to a repo, I can just docker image save to a .tar push to usb or push the .tar around the network to the location
    docker image save NAMEOFIMAGE &gt; myimage.tar
    To remove an image use docker image rm IMAGENAME 
    OR
    docker rmi IMAGE
    docker image save mydreams &gt; mydreams.tar
    docker rmi mydreams
    if you have an image duplicated with the same imageid but diff. tags a rmi is not removing the base image since it is still being used
    if there is no dupe, the entire image is removed
    ls -la
    ls -al
    -rw-r--r--   1 cn  staff  701879296 Jul 30 12:46 mydreams.tar
    TWO WAYS TO FIX THIS
    load | import
    docker load
    docker import
    tar tvf mydreams.tar | more
    we have .json, version, layer files
    docker import mydreams.tar localimport:centos6
    docker load
    actually loads from a stream
    docker load --input mydreams.tar
    to restore something with a new name use IMPORT
    docker image prune
    remove dangling images where they are not associated with a contianer
    docker image prune
    docker image prune -a
    remove all images that have never been used to create a container
    docker image tag 

## Inspect Images and Report Specific Attributes Using Filter and Format

    docker image inspect
    docker image inspect centos:6
    The 'docker inspect' command can provide a plethora of insight into all of the attributes of your images. We will demonstrate how to display that information and then how to format that information to filter out only what you want in several different formats.
    docker image inspect multistage &gt; multistage.output
    See if we can search out the hostname
            &quot;ContainerConfig&quot;: {             &quot;Hostname&quot;: &quot;837a64dcc771&quot;,
    docker image  inspect multistage --format'{{.ContainerConfig.Hostname}}'
    docker image inspect multistage --format '{{.ContainerConfig.Hostname}}'
    docker image inspect multistage --format '{{json .ContainerConfig}}'
    docker image inspect multistage --format  '{{.RepoTags}}'

## Container Basics - Running, Attaching to, and Executing Commands in Containers

    what containers are running
    docker ps
    what containers have been stopped but not removed
    docker ps -a
    simplest way to run a container from a base image
    docker run centos:6 
    docker run -i -t
    -i interactive
    -t terminal attach it to my current termain
    docker run -it 
    run interactive on my terminal
    docker run -it centos:6
    when we exit, it kills the container as well container no longer runs
    we can control the sname or change the name too
    docker run -it --name container centos:6 /bin/bash
    we indicate we want to run basj
    bash
    if we want to restart that container we can
    docker restart testcontainer
    you can't run the same command again because this instance with the same name exists
    docker restart testcontainer
    docker rm testcontainer
    docker rm 'docker ps -a -q'
    docker rm `docker ps -a -q`
    remove the container once the container stops
    docker run -it --rm testcontainer centos:6 /bin/bash
    other docker run options
    --ip
    assign and IP address
    --privledge to give priv to user
    --evn
    environment var
    docker run -it --rm --env MYVAR=whatever testcontainer centos:6 /bin/bash
    docker run -it --rm --env MYVAR=whatever --name testcontainer centos:6 /bin/bash
    this is bad ass, we can send in environment vars into the container...
    instead of -it issue a -d to run the container in the back ground
    detached... 
    -d
    --detached
    docker run -d --name testcontainer centos:6
    we would typically do this for a web service
    server!!!
    docker run -d httpd
    docker ps
    http continues to run.. because the container is designed to keep running
    it is running in bkground
    we have two ways to attach
    if you use docker attach and exit this will stop the container
    so avoid this if you want to attach and keep the container running
    docker run -d httpd
    docker ps
    docker exec -it elastic_yellow /bin/bash 
    docker ps

## Create an Image with Dockerfile

> docker build -t customimage:v1 .

dot is current directory
the Dockerfile is in current dir
docker builds in steps
in layers
builds steps for each of the instrucations in the docker file
we will end up with image that is tag and docker images
SQUASH IMAGES DOWN

> docker build --pull --no-cache --squash -tag optimized:v1 .
> docker build --pull --no-cache --squash  -t optimized:v1 .

squash removes the layers and puts them all into one layer to optimize the size of the images
squash works only on Edge version right now

REMOVE  images
> docker rmi $(docker images --filter dangling=true -q --no-trunc)

## Dockerfile Options, Structure, and Efficiencies (Part I)

Dockerfile Options
For the Exam
FROM
ARG
RUN
CMD
LABEL
MAINTAINER
EXPOSE
MAINTAINER is deprecated
use LABLE instead
ENTRYPOINT
RUN**
executes a command in a new layer, and creates the immediate image layer during the image build process
Two forms
Shell or exec forms
exec is json array
RUN [&quot;yum&quot;, &quot;install&quot;]
RUN yum update -y &amp;&amp; yum install http net-tools
docker build -t  mywebserver:v1 .
docker run -d --name testweb1 --rm mywebserver:v1
docker inspect testweb1 | grep IPAddress
docker stop testweb1
docker images
311 mb in size
can we reduce the size
to be efficient combine all the commands together
see how many layers we have
docker history mywebserver:v1 | wc -l

## Dockerfile Options, Structure, and Efficiencies (Part II)

> docker build -t mywebserver:v3 -f Dockerfile3 .

ON MAC

> docker run -d --rm --name testweb1 -p 8080:80 mywebserver:v3

If you have an existing site, you would mount the container
docker ps --no-trunc
If we pipe or use ENTRYPOINT in docker file , it can't be overwritten when using docker run
you can't overwrite ... 
with the apache b/c it continuous ran we could attach but could not overwrite
WORKDIR we can overide this... and reset to another directory
WHERE is this pdf
Docker - Options and Stucture
STOPSIGNAL can be changed
sig kill instead
also overide the sheell with /bin/bash
the more CMDs i can run and the few number of instructions optimizes the structure  of the file so theimage size is smaller and uses a less number of intermediate # of containers to build

## Describe and Display How Image Layers Work

IMAGE LAYERS
how to view the image layers
docker image history mywebserver:v4
docker image history mywebserver:v4 --no-trunc

## Modify an Image to a Single Layer

There is no way to flatten all the layers into one layer it is only a ... external tool not part of docker

We can get a layer to single layer to save storage.

> docker run mywebserver:v4

Export the image, via --output,  -o

> docker save -o mywebserver.v2.tar mywebserver:v4

import / load the image

> docker load -i mywebserver.v2.tar

THIS DID NOT WORK WHY????????????????????????

## Selecting a Docker Storage Driver

Typically we use volumes to write data out to a place for keep since containers are ephemerial.
Wrting data inside of a container adds to the complexity... 
Even in swarm env pluggable storage drivers
Docker Daemon web site, review for what OS supports what.

devicemapper ....
Specific storage drivers allows for certain efficiencies.

Devicemapper officially supported on Centos

We can use this as block storage on disk, uses loopback adapter to provide this
OR it can be used with block storage actual disk.

Configure storage in the daemon to make sure the same one is used on the host.

```bash
docker info | grep Storage
su -
cd /etc/docker
ll
key.json
vi daemon.json
```

daemon.json

```json
{  
    "storage-driver" : "devicemapper"
}
```

Note, on centos, it's already setup with devicemapper

```bash
systemctl stop docker
systemctl start docker
cd /var/lib/docker
ll
devicemapper : usage of loopback devices is strongly discouraged for production use.
use --storage-opt dm.thinkpooldev to specify a custom block storage device
```

Reference to review: https://twitter.com/sophaskins/status/1024369008756191232

## Prepare for a Docker Secure Registry

- Setup our on private repo with TLS
- create a few directories...
- mkdir certs
- mkdir auth
- sudo yum install open-ssl
- see notes

## Managing Images in Your Private Repository

REVIEW
curl --insecure -u &quot;test:password&quot; https://myregistrydomain.com:5000/v2/_catalog
REVIEW THIS AGAIN AS WELL AS THE FIRST ONE BEFORE THIS ONE
THIS IS how to use API Calls using curl and wget
REVIEW

## Container Lifecycles - Setting the Restart Policies

> docker container run -d --name testweb --restart always httpd

If you stop manually, it ignores policy until server is rebooted or restart of docker is called

## Deploy, Configure, Log Into, Push, and Pull an Image in a Registry

    Correct answer --username=[USERNAME]  Explanation The '--username=[USERNAME]' will allow you to specify the intended account to login with at the remote image repository.
    docker run -d -p 5000:5000 -v `pwd`/certs:/certs -e REGISTRY_HTTP_TLS_ CERTIFICATE=/certs/dockerrepo.crt -e REGISTRY_HTTP_TLS_KEY=/certs/ dockerrepo.key -v `pwd`/auth:/auth -e REGISTRY_AUTH=htpasswd -e REGISTRY_ AUTH_HTPASSWD_REALM=&quot;Registry Realm&quot; -e REGISTRY_AUTH_HTPASSWD_ PATH=/auth/htpasswd registry:2
    docker run -d -p 5000:5000 --restart=always --name registry_auth  -v `pwd`/auth:/auth  -e REGISTRY_AUTH=htpasswd  -e REGISTRY_AUTH_HTPASSWD_REALM=&quot;Registry Realm&quot;  -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd  registry:2 docker login -u myuser -p mypassword localhost:5000
    SEE QUICKSTART02

## 'Drain' task applied to a node so that it can be removed from cluster.

> docker node update --availability drain [NODE ID]
  
## Undo the 'drain' task applied to a node so that it can be used again for services.

> docker node update --availability active [NODE ID]

## Troubleshoot Container and Engine Logs to Understand Connectivity Issues Between Containers

Centos Logs

- logs stored here: /var/log/messages
- ubunutu: /var/log/daemon

```bash
sudu su -
cd /var/log
cat /var/log/messages | grep [dD]ocker
#joining, starts, stops, swarms, ip, network ...
#connectivity messages... all logged here
docker images
docker run -d --name myweb httpd
docker container logs

#--var log messages for this container ... the last few messages
#not enough info outside of the container itself
docker ps
docker stop myweb
docker rm myweb
```

## Dockerfile Directives: USER and RUN

REVIEW THIS AGAIN IT WAS AWESOME
docker run -it -u 0 CONTAINER
run as root if we don't have priv

## Dockerfile Directives: RUN Order of Execution

Another Dockerfile

```Dockerfile
FROM centos:latest
MAINTAINER yourname@company.com
RUN user add -ms /bin/bash user 1
USER user
RUN echo &quot;EXPORT 192.168.0.0/24&quot; &gt;&gt; /etc/eports.list
```

> docker build -t centos7/cofig:v1 .
-- permission denied

order of execution matters
the USER user ... took precedence 
put USER user at the bottom of both RUNs
ORDER MATTERS IN DOCKERFILES
Linear from top to bottom

## Dockerfile Directives: ENV

Builds on last docker file

```Dockerfile
FROM centos:latest
MAINTAINER you @COMPANY.COM
RUN user add -ms /bin/bash
RUN echo &quot;EXPORT 192.168.0.0./24: &gt; /etc/exports.list
RUN yum update -y
RUN yum install -y net-tools wget
RUN ~cd wget --no-cookies --no-check-certificate --header &quot;Cookied.... blah blah blah
RUN yum local install -y ~/jre-8u60-linux-x64.rpm
USER user
#RUN cd ~
RUN cd ~ &amp;&amp; &quot;export JAVA_HOME=/usr/java/jdk1.8.0/jre&quot; &gt;&gt; /home/user/.bashrc
```

apply env system wide env vars
ENV JAVA_BIN /usr/java/jdk1.8.0/jre/bin
    This is system wide

## Dockerfile Directives: CMD vs. RUN

CMD is not run during the build
it is executed after the container is run...???

Install with RUN

start things/applications with CMD
FROM cento:latest
MAINTAINER user@home.com
RUN user add -ms /bin/bash user
CMD "echo" "This is a container message"

## Dockerfile Directives: ENTRYPOINT

ENTRYPOINT

when we put a command like echo in entrypoint
we can't over ride it here
docker run containerID /bin/echo &quot;Me new message&quot;
we get what the docker file had for entrypoint

## Dockerfile Directives: EXPOSE

EXPOSE
use EXPOSE if you want to use -P

## Container Volume Management

```bash
# create a new volume in a container at run time
docker run -it --name Vol1continer -v /mydata centos:latest /bin/bash
df -h
# echo data into mydata
# exit
# /var/lib/docker/containers/
# /var/lib/docker/volumes

docker inspect Vol1continer
# .... Mounts
# directory inside volumes
# RE WATCH
# -----------------
# host has dir with files

# map a local dir to mydata in a new container where mydata did not exist
docker run -it --name Vol2continer -v /root/Build/MtHostdir:/mydata centos:latest /bin/bash
# now my hosts files are accessible in the container
# you can not provide a host dir to a container dir in a Dockerfile
# Dockerfile assumed to be portable
```

## Docker Network: List and Inspect

```bash
docker network create --dns --subnet MYNETWORK
# this allows us  to create our own network instead of using the bridges default network in docker0
# docker0 is bridge adapter, not a physical device
# a bride to your default ... networking device
# defaults to ...
#  &quot;Subnet&quot;: &quot;172.17.0.0/16&quot;,    &quot;Gateway&quot;: &quot;172.17.0.1&quot;
# docker network inspect host
# hardly any config... points to docker0
# same for
# docker network inspect none
# for just comm with underlying host
```

## Docker Network: Create and Remove

192., 10., 172 are internal ranges for networks.

```bash
docker network create --subnet 10.1.0.0/24 --gateway 10.1.0.1  mybridge01
docker network inspect mybridge01
# ifconfig will / should see our out adapter in there by the ID
# docker will create the new bridge adapter
# If you ever removed the default docker network adapters... just re-install docker???  this has to be ascript to fix somewhere right???

docker network rm mybridge01
```

## Docker Network: Assign to Containers

Put a container on our own network instead of the default one
create a subnet with lots of IPs, class B address
10.1.0.0/16

```bash
docker network create --subnet 10.1.0.0/16 --gateway 10.1.0.1  --ip-range=10.1.4.0/24 --driver=bridge   br01

#so... for this cmd above, we will only use 10.1.4.X for the IP addresses.
#this way we could restrict the .4 to say ... node # 4
#when we run this on the host... node4
#10.1.4.0/24 is class C address the first 3 values will not change

docker network create --subnet 10.1.0.0/16 --gateway 10.1.0.1 --ip-range=10.1.4.0/24 --driver=bridge--label=host4network br04

# assign network to a container
docker run -it --name nettest1 --net br04 centos:latest /bin/bash

# run some stuff inside of the container iteractively
yum update
yum update -y
yum install -y net-tools
ifconfig
ping google.com
netstat -rn
cat /etc/resolve.conf
#shows us our internal network
#netstat shows us the routing??????
#can we now assign a static IP to a container
```

Only works on user create networks.. the networks you create
you can use it on docker0 network

> docker run -it --name nettest2 --net br04 --ip 10.1.4. 100 centos:latest /bin/bash

## Inspect Container Processes

```bash
docker top container-name
which ps
docker stats container-name
```

## Previous Container Management

```bash
docker ps -a -q
wc  -l
docker ps -a -q | wc -l
#that gets the line count
#remove running container

docker remove -f CONTAINER
#remove a running a container

#docker rm -f CONTAINER
#if you remove a container from /var/lib/docker/conatiners by the ID
#you gotta restart docker daemon
systemctl restart docker
```

## Controlling Port Exposure on Containers

> docker run -itd -p 80  nginx

> docker run --name testweb -P
### Dockerfile

    another way to map ports
    if Dockerfile has EXPOSE 80 443
    and you use
    it will map port 80
    --------

## Naming Containers

> docker rename OLDCONTAINER NEWCONTAINER_NAME

Just on stopped containers .... right

> docker rename CONTAINER_ID myNewIDName

YES WE CAN RENAME when running or stopped

## Docker Events

Determine how docker containers are performing on our system by monitoring for events.

Real time feed

> docker events

This is just like `docker stats` but we can also look at docker historical events.

> docker events --since '1h'

Monitors entire docker instance on that HOST only

Use Case - We might audit for attach to a container b/c this kills the container on exit.

docker events --filter container=$VAR

- event
- image
- label
- type
- volume
- network
- daemon

Filtering for events

```bash
docker events --filter event=attach
# How could i keep my container registering events????
# container=stop
# container=die
```

```bash
docker events --filter event=die --filter event=stop
#--filter event=start
#SAME for docker volume, docker network ... etc...
#where is this data stored???
#https://docs.docker.com/engine/reference/commandline/events/
```

## Managing and Removing Base Images

```bash
# You can have an image with same imageid, and if you do

docker rmi IMAGEID
# will this remove them both?
# --- it will not remove both unless your force it
docker rmi -f IMAGEID
```

## Saving and Loading Docker Images

Everything needs to be backed up

- Back up your created images you have edited in case they get deleted by accident
- Back up your created images if they are not published to registry
- Back up your create images off site
- Create an image from a stopped container (docker ps -a)

```bash
# create new image from a container you have stopped.
# need to test if this works on running containers
# Yup works on running containers too...
docker commit changed_container newcontainer:v1


docker save -o centos.latest.tar centos:latest
docker save --output centos.latest.tar centos:latest

#you can save a container if you want to remove it from
# docker images
# tar tvf centos.latest.tar
# zips up the /var/lib/docker dir for that container

# RESTORE
docker load --input centos.latest.tar

# .tar files are not compressed.
# when you back up compress the .tars

#wait there is more, load directly form gzip file
docker load --input centos.lastest.tar.gz
```

## Image History

```bash
docker history centos:latest
#shows the layers

#--no-trunc, shows only IDs the entire string
docker history --quiet --no-trunc nginx

```

## Tags

As a result of having a number of images, we may need to tag them with non-default names for testing/updating/distribution. Additionally, tags are an important precursor to publishing our images to public or private repositories.

```bash
docker tag IMAGEID mine/centos:v1.0
repo = mine/centos
tag = v1.0
docker tag OLD NEW

#tag name
#can't start with period or dash and is 128 chars at max
```

## References

https://www.youtube.com/watch?v=sJx_emIiABk

-- 

Questions from test

What namespace is not setup by default in Docker.

what runs and listent to all containers...

docker system events | docker events???
docker system df
docker system events
docker system info
docker system prune

  df          Show docker disk usage
  events      Get real time events from the server
  info        Display system-wide information
  prune       Remove unused data

HARD TO FORGET TEST QUESTIONS

1. question about correct commands

    docker port CONTAINER
    docker container inspect CONTAINER

    not docker port inspect CONTAINER

1. Question about Quorum and when we have 3 availability zones

  and with managers in each, when a quorum goes in non-voting stats
  
  review the chart...

  4,1,1 or 4,2,1
  idk

1. 2 containers, 4 cpus.

assign each container 2 cpus - on run of the containers

1. what's the point of docker layers?

paralized the docker builds?
or keep the images cached so rebuilds are quick...

1. DTR - i lost it

https://docs.docker.com/network/overlay/#encrypt-traffic-on-an-overlay-network


1. docker network create --opt encrypted --driver overlay --attachable my-attachable-multi-host-network

encrypt and overlay network connection (let's hack this or MITM it

1. sudo docker run -p 53160:53160 -p 53160:53160/udp -p 58846:58846 -p 8112:8112 -t -i aostanin/deluge /start.sh

send data over udp
-p 53:53/udp

1. Something about what does not get backed up in UCP, or DTR???

blobs
meta data
something
something

1. question about setting user with list privliedges

Choose two

- add them to docker group
- ?
- ?
- ?

1. Qustions on labels and limits too...

1. CPU

--cpuset-cpus
Limit the specific CPUs or cores a container can use. A comma-separated list or hyphen-separated range of CPUs a container can use, if you have more than one CPU. The first CPU is numbered 0. A valid value might be 0-3 (to use the first, second, third, and fourth CPU) or 1,3 (to use the second and fourth CPU).

docker run -it --cpus=".5" ubuntu /bin/bash

1. The following example starts a Redis container and configures it to always restart unless it is explicitly stopped or Docker is restarted.

docker run -dit --restart unless-stopped redis

If you manually stop a container, its restart policy is ignored until the Docker daemon restarts or the container is manually restarted. This is another attempt to prevent a restart loop.

Restart policies only apply to containers. Restart policies for swarm services are configured differently. See the flags related to service restart.

1. question about trust that was different than what I had seen or forgotten.

1. something about HEALTHCHECK CMD  http://localhost/health : exit 1

https://docs.docker.com/engine/reference/builder/#healthcheck

HEALTHCHECK CMD curl --fail http://localhost || exit 1
https://blog.sixeyed.com/docker-healthchecks-why-not-to-use-curl-or-iwr/

HEALTHCHECK --interval=5m --timeout=3s \
  CMD curl -f http://localhost/ || exit 1

1. WORKDIR in Docker file, what is shown when we use 'pwd'

WORKDIR /a
WORKDIR b
WORKDIR c

I mean.. HELL - READ ALL THE DOCS NEXT TIME

The WORKDIR instruction can be used multiple times in a Dockerfile. If a relative path is provided, it will be relative to the path of the previous WORKDIR instruction. For example:

WORKDIR /a
WORKDIR b
WORKDIR c
RUN pwd
The output of the final pwd command in this Dockerfile would be /a/b/c.

1. something about ADD Vs COPY in a Dockerfile

The ADD instruction copies new files, directories or remote file URLs from <src> and adds them to the filesystem of the image at the path <dest>.

Multiple <src> resources may be specified but if they are files or directories, their paths are interpreted as relative to the source of the context of the build.

Each <src> may contain wildcards and matching will be done using Go’s filepath.Match rules. For example:

COPY

The COPY instruction copies new files or directories from <src> and adds them to the filesystem of the container at the path <dest>.

1. What's the thing with

import/export
load/save

1. Ignore TLS during docker run and other places for DOCKER_CERTIFICATE_TRUST= false

1. secrets was on the test

1. there was template question of some type...