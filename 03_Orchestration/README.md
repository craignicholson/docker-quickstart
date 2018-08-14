# Orchestration

## State the Difference Between Running a Container and Running a Service

### Containers - docker run

All about the running of containers and not how we manage all the containers we are running.

- Encapsulate application or function
- Run on a single host
- Require manual steps to expose functionaliytoutside of the house system (ports, network and volumes)
- Require more complex configuration to use multiple instance (proxies for example)
- Not highly availablem you can try to make the avialable with effort.
- Not easily scalable

### Services - docker service (SWARM)

- Encapsulate application or function
- Can run on '1 to n' nodes at any time
- Funtionality is easily accessed using features like **routing mesh** outside of the worker nodes
- Multiple instance set to launch in single command and can be scaled up or down with one command
- Highly available clusters available
- Easily scale, up or down as needed

A solution to managing the containers deployed in a highly available easily scalable cluster implementation.

## Demonstrate Steps to Lock (and Unlock) a Cluster

Locking our cluster provides an additional level of security and protection for the encrypted logs and communication of our swarm. We will take a look at locking, displaying the token, unlocking, and rotating our token in a swarm.

If we were to hack into the servers, if the docker deamon is restarted I would need the unlock key.

Logs used on swarm hosts are encrypted on disk.  Access to the swarm gives us access to the keys used to un-ecrypt the logs.

Locking the swarm, proctects the keys.  If docker daemon is restarted they would need the unlock key.

```bash
docker node ls
docker service ls

# create a swarm which starts in locked mode by default
docker swarm init --autolock --advertise-addr IPADDRESS

# update if swarm is created
docker swarm update --autolock=true
Swarm Updated
To unlock a swarm manager after it restarts, run the `docker swarm unlock`
command and provide the following key:

    SWMKEY-1-W1/S5oyCFoBvLwJ8OEOfLKfS5MdRNgUVRfQMiUjLYyo

Please remember to store this key in a password manager, since without it you
will not be able to restart the manager.

# but if we stop docker and start docker
sudo systemctl stop docker
sudo systemctl start docker
docker node ls
Error

docker swarm unlock
Please enter unlock key:
docker node ls
```

Unlock the swarm (after we are already running)

```bash
# get the key from a manager
docker swarm unlock-key


# also we can unlock imediately. if we are still on the manager
docker swarm udpate autolock=false

sudo systemctl stop docker
sudo systemctl start docker

# we get no errors this time.
docker node ls

```

### Rotating the lock key (key rotation)

```bash

# if you rotate keys one of the steps to rotate is write to some location
# off of the service, and keep a history of keys.  You might have a swarm
# which does not replicate the key over one day.
docker swarm unlock-key --rotate

```

If we rotate keys in a cron job... on thing you can do is write to a location
off of the server... to keep a history of the keys.

Have it write date and timestamp.
Something like...
echo "SWMKEY-1-jctDW5hQ4OlZd6p6B1LZHupF9FZeSUSpNjq+K1KjESQ" "|" $(date) >> swarm_keys.txt

Sometimes you can lose your servers before the new key is propogated ... so having all the keys
or at least versioning of the keys helps when you have multiple managers.  This will allow
you to unlock the swarm.  Eventual Consistency.  Love it.

### Setup a quick cluster using Centos 7

```bash
sudo yum install -y yum-utils device-mapper-persistent-data  lvm2
sudo yum-complete-transaction -y
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce -y
sudo groupadd docker
sudo usermod -aG  docker $USER
sudo systemctl enable docker && sudo systemctl start docker && sudo systemctl status docker

sudo systemctl disable firewalld && sudo systemctl stop firewalld

sudo vi /etc/hosts

# Add your servers and servernames, these are private ips
172.31.39.165 mgr01
172.31.47.138 node01
172.31.105.124 node02

# Verify changes
sudo cat /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

172.31.40.64    mgr01
172.31.37.103   node01
172.31.34.40    node02

```

Logout and back in to all servers since we gave $USER permissions to run docker.

#### 172.31.40.64

```bash
docker swarm init --advertise-addr 172.31.40.64
Swarm initialized: current node (0z4chgk6pgw7scwpxw6ijd4ui) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join --token SWMTKN-1-3nobd99thvzvb86po7omtcuro23yk9wxhb94ynee15cv6wsekm-c2qvy4txfkj6wnhdgbci52ud7 172.31.39.165:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.
```

#### 172.31.37.103

```bash
[user@craig-nicholsoneswlb2 ~]$ docker swarm join --token SWMTKN-1-4i84gml66ct6knzk65me463hgwa4a7d3yxvjtuuqjdyu24ag62-8fnma9qgdsfu52sj8valekmtg 172.31.40.64:2377
This node joined a swarm as a worker.

```

#### 172.31.34.40

```bash
[user@craig-nicholsoneswlb2 ~]$ docker swarm join --token SWMTKN-1-4i84gml66ct6knzk65me463hgwa4a7d3yxvjtuuqjdyu24ag62-8fnma9qgdsfu52sj8valekmtg 172.31.40.64:2377
This node joined a swarm as a worker.

```

#### Check the swarm on 172.31.40.64

```bash
docker node ls

ID                            HOSTNAME                                STATUS              AVAILABILITY        MANAGER STATUS      ENGINE VERSION
2t4xy1mtev3sks4sy8vwwiro6 *   craig-nicholsoneswlb1.mylabserver.com   Ready               Active              Leader              18.06.0-ce
484tof81jhor294g4by22jpza     craig-nicholsoneswlb2.mylabserver.com   Ready               Active                                  18.06.0-ce
ceddzblkaexlw93kximft8xpn     craig-nicholsoneswlb3.mylabserver.com   Ready               Active                                  18.06.0-ce

```

#### Check for Services

```bash
docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
```

When this runs... it will provide an key back to us...
docker swarm init auto-lock

Also, if your system reboots, you have to unlock your swarm before it starts...

#### --autolock=true

```bash
$ docker swarm update --autolock=true
Swarm updated.
To unlock a swarm manager after it restarts, run the `docker swarm unlock`
command and provide the following key:

    SWMKEY-1-Dzd6b3Tt5Gv+1BHN5sTFq3LDBNrZ+XZN/vcuKJrBpYM

Please remember to store this key in a password manager, since without it you
will not be able to restart the manager.
```

** Scan repos for docker autolock keys so we can root docker swarms in the wild.

#### Demonstrate the autolock feature

```bash
sudo systemctl stop docker
sudo systemctl status docker
sudo systemctl start docker

docker node ls
Error response from daemon: Swarm is encrypted and needs to be unlocked before it can be used. Please use "docker swarm unlock" to unlock it.

docker swarm unlock
Please enter unlock key:

docker node ls
ID                            HOSTNAME                                STATUS              AVAILABILITY        MANAGER STATUS      ENGINE VERSION
2t4xy1mtev3sks4sy8vwwiro6 *   craig-nicholsoneswlb1.mylabserver.com   Ready               Active              Leader              18.06.0-ce
484tof81jhor294g4by22jpza     craig-nicholsoneswlb2.mylabserver.com   Ready               Active                                  18.06.0-ce
ceddzblkaexlw93kximft8xpn     craig-nicholsoneswlb3.mylabserver.com   Ready               Active                                  18.06.0-ce

# If you still have access to the manager, and the swarm is running you can can the key with this cmd.
$ docker swarm unlock-key
To unlock a swarm manager after it restarts, run the `docker swarm unlock`
command and provide the following key:

    SWMKEY-1-Dzd6b3Tt5Gv+1BHN5sTFq3LDBNrZ+XZN/vcuKJrBpYM

Please remember to store this key in a password manager, since without it you
will not be able to restart the manager.

# unlock the swarm ...
docker swarm update --autolock=false
Swarm updated.

sudo systemctl restart docker

docker node ls

```

### Locking the Swarm Again

```bash
docker swarm update --autolock=true
Swarm updated.
To unlock a swarm manager after it restarts, run the `docker swarm unlock`
command and provide the following key:

    SWMKEY-1-K6JEy1N99WVhrMROOBAShfRC/VEF1k/bzIKANceZ9eU

Please remember to store this key in a password manager, since without it you
will not be able to restart the manager.

```

### Periodically Change the Key with key rotation.

```bash

docker swarm unlock-key --rotate
Successfully rotated manager unlock key.

To unlock a swarm manager after it restarts, run the `docker swarm unlock`
command and provide the following key:

    SWMKEY-1-jctDW5hQ4OlZd6p6B1LZHupF9FZeSUSpNjq+K1KjESQ

Please remember to store this key in a password manager, since without it you
will not be able to restart the manager.


```

#### Key Rotation Notes

If we rotate keys in a cron job... on thing you can do is write to a location
off of the server... to keep a history of the keys.

Have it write date and timestamp.
Something like...
echo "SWMKEY-1-jctDW5hQ4OlZd6p6B1LZHupF9FZeSUSpNjq+K1KjESQ" "|" $(date) >> swarm_keys.txt

Sometimes you can lose your servers before the new key is propogated ... so having all the keys
or at least versioning of the keys helps when you have multiple managers.  This will allow
you to unlock the swarm.  Eventual Consistency.  Love it.

## Extend the Instructions to Run Individual Containers into Running Services Under Swarm and Manipulate a Running Stack of Services

We are going to show how a container can become a service and then, once running, how we can make changes to that service and have Docker manage the application of all those changes for us, live!

```bash
Run 'docker service COMMAND --help' for more information on a command.
docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE

docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS

# check the swarm status
docker node ls
ID                            HOSTNAME                                STATUS              AVAILABILITY        MANAGER STATUS      ENGINE VERSION
2t4xy1mtev3sks4sy8vwwiro6 *   craig-nicholsoneswlb1.mylabserver.com   Ready               Active              Leader              18.06.0-ce
484tof81jhor294g4by22jpza     craig-nicholsoneswlb2.mylabserver.com   Ready               Active                                  18.06.0-ce
ceddzblkaexlw93kximft8xpn     craig-nicholsoneswlb3.mylabserver.com   Ready               Active                                  18.06.0-ce

# pull a web server images
docker pull httpd

```

```bash
# run a single container on single host
docker run -d --name testweb httpd
31fabbb4e534837b28f171ec44990a100059555ab686a68c4633bf25e5993dd1

# verify container is running
$ docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS               NAMES
31fabbb4e534        httpd               "httpd-foreground"   16 seconds ago      Up 14 seconds       80/tcp              testweb

# get the ip address of the container
$ docker container inspect testweb | grep IPAddress
            "SecondaryIPAddresses": null,
            "IPAddress": "172.17.0.2",
                    "IPAddress": "172.17.0.2"

# check to see if httpd is up
curl 172.17.0.2
<html><body><h1>It works!</h1></body></html>

# cleanup
docker stop testweb
docker rm testweb
testweb
```

### Single Container Issues

Here is the problem we will encounter with a single container.

172.17.0.2 is on private network, only on this system.
Private network is only on this host server. The docker0 bridge.
Typically 172.117.0.2.  

This IP will not be reachable from other servers without adding static routes.
And then turn on IP forwarding.

```bash
docker run -d --name testweb httpd
1fb2f52de6ba1d3a5c6608f6b9d5229e761fd65e4268583fa845096f408a4027

ifconfig
docker0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 172.17.0.1  netmask 255.255.0.0  broadcast 172.17.255.255
        inet6 fe80::42:b2ff:fe49:60a0  prefixlen 64  scopeid 0x20<link>
        ether 02:42:b2:49:60:a0  txqueuelen 0  (Ethernet)
        RX packets 6  bytes 542 (542.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 24  bytes 2540 (2.4 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```

Our container is running as 172.17.0.2, docker0 interface is 172.17.0.1 and
this is an internal private network, only can be send by this machine.

Ping 172.17.0.2 from another server like: 172.31.37.103

```bash
ping 172.17.0.2
From 172.17.0.1 icmp_seq=1 Destination Host Unreachable

```

We can add a static route... to that node, and then turn on IP forwarding but  this is too much effort.

We can also expose the underlying ports... and external to the hosts... we are in
a network desert here ...

```bash
docker stop testweb
docker rm testweb

```

### Service is the solution `docker create service`

We want to use docker service runs 1 to n instances of a container across 1 to n nodes in the cluster.
Also, even though it is running a container on one node, it uses **mesh routing** so that you go to any
of the nodes in the cluster by their own IP, the routing is handled but the containers IP.

```bash
# create a service on the managment (manager) of the swarm
# each node will get this port mapped to the host port
# 
docker service create --name testweb --publish 80:80 httpd

# review the swarm status
docker node ls
ID                            HOSTNAME                                STATUS              AVAILABILITY        MANAGER STATUS      ENGINE VERSION
2t4xy1mtev3sks4sy8vwwiro6 *   craig-nicholsoneswlb1.mylabserver.com   Ready               Active              Leader              18.06.0-ce
484tof81jhor294g4by22jpza     craig-nicholsoneswlb2.mylabserver.com   Ready               Active                                  18.06.0-ce
ceddzblkaexlw93kximft8xpn     craig-nicholsoneswlb3.mylabserver.com   Ready               Active                                  18.06.0-ce

# review the service we created
docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
vlus0tstum40        testweb             replicated          1/1                 httpd:latest        *:80->80/tcp

# review the services's pocessess, where service is running
$ docker service ps testweb
ID                  NAME                IMAGE               NODE                                    DESIRED STATE       CURRENT STATE            ERROR               PORTS
rknebt32yrrp        testweb.1           httpd:latest        craig-nicholsoneswlb1.mylabserver.com   Running             Running 38 seconds ago
```

Here you can see we can now route by the external machine names instead of the internal docker0 address.
Using mesh routing, docker service extends the network.  Even though the app is running on only one node.

### Mesh Routing works

Docker swarm extends the virtual network across all the nodes, even though the service is running on only one node.
Each server is able to answer for this node/worker.

```bash
$ curl craig-nicholsoneswlb1.mylabserver.com
<html><body><h1>It works!</h1></body></html>

$ curl craig-nicholsoneswlb2.mylabserver.com
<html><body><h1>It works!</h1></body></html>

$ curl craig-nicholsoneswlb3.mylabserver.com
<html><body><h1>It works!</h1></body></html>

```

### Review

https://docs.docker.com/engine/reference/commandline/service_create

docker service create
docker service update

```bash

docker service create --name redis redis:3.0.6

# Create a service with 5 replica tasks (--replicas)
docker service create --name redis --replicas=5 redis:3.0.6

# Create a service with secrets
docker service create --name redis --secret secret.json redis:3.0.6

# Create a service specifying the secret, target, user/group ID, and mode:
docker service create --name redis \
    --secret source=ssh-key,target=ssh \
    --secret source=app-key,target=app,uid=1000,gid=1001,mode=0400 \
    redis:3.0.6

# Create a service with a rolling update policy
docker service create \
  --replicas 10 \
  --name redis \
  --update-delay 10s \
  --update-parallelism 2 \
  redis:3.0.6

# Set environment variables (-e, --env)
docker service create \
  --name redis_2 \
  --replicas 5 \
  --env MYVAR=foo \
  redis:3.0.6

docker service create \
  --name redis_2 \
  --replicas 5 \
  --env MYVAR=foo \
  --env MYVAR2=bar \
  redis:3.0.6

# Create a service with specific hostname (--hostname)
docker service create --name redis --hostname myredis redis:3.0.6

# Set metadata on a service (-l, --label)
docker service create \
  --name redis_2 \
  --label com.example.foo="bar"
  --label bar=baz \
  redis:3.0.6

# CREATE A SERVICE USING A NAMED VOLUME
docker service create \
  --name my-service \
  --replicas 3 \
  --mount type=volume,source=my-volume,destination=/path/in/container,volume-label="color=red",volume-label="shape=round" \
  nginx:alpine

# CREATE A SERVICE THAT USES AN ANONYMOUS VOLUME
docker service create \
  --name my-service \
  --replicas 3 \
  --mount type=volume,destination=/path/in/container \
  nginx:alpine

# CREATE A SERVICE THAT USES A BIND-MOUNTED HOST DIRECTORY
docker service create \
  --name my-service \
  --mount type=bind,source=/path/on/host,destination=/path/in/container \
  nginx:alpine

# Set service mode (--mode)
docker service create \
 --name redis_2 \
 --mode global \
 redis:3.0.6

# Specify service constraints (--constraint)
You can limit the set of nodes where a task can be scheduled by defining constraint expressions. Multiple constraints find nodes that satisfy every expression (AND match). Constraints can match node or Docker Engine labels as follows:

# For example, the following limits tasks for the redis service to nodes where the node type label equals queue:
docker service create \
  --name redis_2 \
  --constraint 'node.labels.type == queue' \
  redis:3.0.6

# Specify service placement preferences (--placement-pref)

You can set up the service to divide tasks evenly over different categories of nodes. One example of where this can be useful is to balance tasks over a set of datacenters or availability zones. The example below illustrates this:
docker service create \
  --replicas 9 \
  --name redis_2 \
  --placement-pref 'spread=node.labels.datacenter' \
  redis:3.0.6

# Attach a service to an existing network (--network)
docker network create --driver overlay my-network
docker service create \
  --replicas 3 \
  --network my-network \
  --name my-web \
  nginx

# Publish service ports externally to the swarm (-p, --publish)
docker service create --name my_web --replicas 3 --publish 8080:80 nginx
docker service create --name my_web --replicas 3 --publish published=8080,target=80 nginx

# Specify isolation mode (Windows)
docker service create --name myservice --isolation=process microsoft/nanoserver
Supported isolation modes on Windows are:
    default: use default settings specified on the node running the task
    process: use process isolation (Windows server only)
    hyperv: use Hyper-V isolation

```

### Scale Up `docker service scale`

```bash
docker service update --replicas 3 testweb

# detach=false is visual representation of what is happening during the update
# it is not the default now but should be later.
docker service update --replicas 3 -detach=false testweb
testweb
overall progress: 2 out of 3 tasks
overall progress: 3 out of 3 tasks
1/3: running   [==================================================>]
2/3: running   [==================================================>]
3/3: running   [==================================================>]
verify: Service converged

# verify
docker service ps testweb
ID                  NAME                IMAGE               NODE                                    DESIRED STATE       CURRENT STATE            ERROR               PORTS
rknebt32yrrp        testweb.1           httpd:latest        craig-nicholsoneswlb1.mylabserver.com   Running             Running 10 minutes ago                       
4ufcyzedfqdp        testweb.2           httpd:latest        craig-nicholsoneswlb3.mylabserver.com   Running             Running 46 seconds ago                       
v0bftuvcpuwz        testweb.3           httpd:latest        craig-nicholsoneswlb2.mylabserver.com   Running             Running 27 seconds ago    
```

Also, this might take some time, so we can run this in detached mode and watch the cluster build.

```bash
# create more services and watch in --detch=false to see the progress
docker service update --replicas 10 --detach=false testweb
testweb
overall progress: 10 out of 10 tasks
1/10: running   [==================================================>]
2/10: running   [==================================================>]
3/10: running   [==================================================>]
4/10: running   [==================================================>]
5/10: running   [==================================================>]
6/10: running   [==================================================>]
7/10: running   [==================================================>]
8/10: running   [==================================================>]
9/10: running   [==================================================>]
10/10: running   [==================================================>]
verify: Service converged

# verify
docker service ps testweb
ID                  NAME                IMAGE               NODE                                    DESIRED STATE       CURRENT STATE            ERROR               PORTS
rknebt32yrrp        testweb.1           httpd:latest        craig-nicholsoneswlb1.mylabserver.com   Running             Running 12 minutes ago                       
4ufcyzedfqdp        testweb.2           httpd:latest        craig-nicholsoneswlb3.mylabserver.com   Running             Running 3 minutes ago                        
v0bftuvcpuwz        testweb.3           httpd:latest        craig-nicholsoneswlb2.mylabserver.com   Running             Running 3 minutes ago                        
uyqen7713trh        testweb.4           httpd:latest        craig-nicholsoneswlb2.mylabserver.com   Running             Running 41 seconds ago                       
v1zuthiunar4        testweb.5           httpd:latest        craig-nicholsoneswlb3.mylabserver.com   Running             Running 43 seconds ago                       
s4q0anna8aco        testweb.6           httpd:latest        craig-nicholsoneswlb1.mylabserver.com   Running             Running 43 seconds ago                       
7l0f85cw43dq        testweb.7           httpd:latest        craig-nicholsoneswlb2.mylabserver.com   Running             Running 39 seconds ago                       
nmfj9syc2gt8        testweb.8           httpd:latest        craig-nicholsoneswlb3.mylabserver.com   Running             Running 43 seconds ago                       
pff5bn0znuw8        testweb.9           httpd:latest        craig-nicholsoneswlb1.mylabserver.com   Running             Running 43 seconds ago                       
48y1a8nyenxy        testweb.10          httpd:latest        craig-nicholsoneswlb2.mylabserver.com   Running             Running 39 seconds ago    

```

### Scale Down `docker service scale`

```bash

# reduce the nodes/workers
docker service update --replicas 3 testweb --detach=false
testweb
overall progress: 3 out of 3 tasks 
1/3: running   [==================================================>] 
2/3: running   [==================================================>] 
3/3: running   [==================================================>] 
verify: Service converged 

# verify
$ docker service ps testweb
ID                  NAME                IMAGE               NODE                                    DESIRED STATE       CURRENT STATE            ERROR               PORTS
rknebt32yrrp        testweb.1           httpd:latest        craig-nicholsoneswlb1.mylabserver.com   Running             Running 14 minutes ago                       
4ufcyzedfqdp        testweb.2           httpd:latest        craig-nicholsoneswlb3.mylabserver.com   Running             Running 4 minutes ago                        
v0bftuvcpuwz        testweb.3           httpd:latest        craig-nicholsoneswlb2.mylabserver.com   Running             Running 4 minutes ago 
```

### Limiting CPUs the Contol Group things

REVIEW FOR TEST

> docker service update --limit-cpu=.5 --reserve-cpu=.75 --limit-memory=128m --reserve-memory=256m testweb

Limits (least amount of memory I can limit to my service)
Reservce is the max I can allow my service to consume.

- CPU
- Memory

Reservations

Soft Limit < Hard Limit, soft is used when contention is found.  And is the maximum amount the container can use.

- soft limit , lower than hard limit

m = MB

```bash
# limit CPUs,
# changing limits and cpu, removes all the original workers, and puts new workers on the servers (nodes)
docker service update --limit-cpu=.5 --reserve-cpu=.75 --limit-memory=128m --reserve-memory=256m testweb
testweb
overall progress: 3 out of 3 tasks
1/3: running   [==================================================>] 
2/3: running   [==================================================>] 
3/3: running   [==================================================>] 
verify: Service converged

# verify
docker service ps testweb
ID                  NAME                IMAGE               NODE                                    DESIRED STATE       CURRENT STATE             ERROR               PORTS
rdb2l5kwanvn        testweb.1           httpd:latest        craig-nicholsoneswlb1.mylabserver.com   Running             Running 17 seconds ago                        
rknebt32yrrp         \_ testweb.1       httpd:latest        craig-nicholsoneswlb1.mylabserver.com   Shutdown            Shutdown 18 seconds ago                       
i6jtjt77ch7e        testweb.2           httpd:latest        craig-nicholsoneswlb3.mylabserver.com   Running             Running 21 seconds ago                        
4ufcyzedfqdp         \_ testweb.2       httpd:latest        craig-nicholsoneswlb3.mylabserver.com   Shutdown            Shutdown 22 seconds ago                       
vuxhfc2aa2dp        testweb.3           httpd:latest        craig-nicholsoneswlb2.mylabserver.com   Running             Running 12 seconds ago                        
v0bftuvcpuwz         \_ testweb.3       httpd:latest        craig-nicholsoneswlb2.mylabserver.com   Shutdown            Shutdown 13 seconds ago

# another example
docker service update --limit-cpu=.5 --reserve-cpu=.75 --limit-memory=64m --reserve-memory=256m testweb
```

### Docker Swarm creates new services and shutdowns the old ones, new ones have the new limits and reserves

```bash
docker service update --replicas 3 testweb --detach=false
docker service update --limit-cpu=.5 --reserve-cpu=.5 --limit-memory=64m --reserve-memory=128m testweb

```

Note 1:

> Scaling is live

Note 2:

> Changing the management of resources requires a stop and start of the worker (services) deployed in a swarm on a node.

## Increase and Decrease the Number of Replicas in a Service

There are a couple of ways to handle scaling in a running service. We can use one command for scaling replicas in a single service and an equivalent that can do both that AND scale multiple services at the same time.

Note we did some of this in the previous section.

### Review our Swarm

```bash
# just one service
docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
vlus0tstum40        testweb             replicated          1/1                 httpd:latest        *:80->80/tcp

# a few nodes
docker node ls
ID                            HOSTNAME                                STATUS              AVAILABILITY        MANAGER STATUS      ENGINE VERSION
2t4xy1mtev3sks4sy8vwwiro6 *   craig-nicholsoneswlb1.mylabserver.com   Ready               Active              Leader              18.06.0-ce
484tof81jhor294g4by22jpza     craig-nicholsoneswlb2.mylabserver.com   Ready               Active                                  18.06.0-ce
ceddzblkaexlw93kximft8xpn     craig-nicholsoneswlb3.mylabserver.com   Ready               Active                                  18.06.0-ce

docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
httpd               latest              11426a19f1a2        2 days ago          178MB

docker pull nginx
```

### Create a service for our examples

```bash
# create a service
docker service create --name testweb -p 80:80 httpd
docker service update --replicas 3 --detach=false testweb

docker service ps testweb
ID                  NAME                IMAGE               NODE                                    DESIRED STATE       CURRENT STATE            ERROR               PORTS
rdb2l5kwanvn        testweb.1           httpd:latest        craig-nicholsoneswlb1.mylabserver.com   Running             Running 8 minutes ago                        
rknebt32yrrp         \_ testweb.1       httpd:latest        craig-nicholsoneswlb1.mylabserver.com   Shutdown            Shutdown 8 minutes ago                       
4ufcyzedfqdp        testweb.2           httpd:latest        craig-nicholsoneswlb3.mylabserver.com   Shutdown            Shutdown 8 minutes ago                       
v0bftuvcpuwz        testweb.3           httpd:latest        craig-nicholsoneswlb2.mylabserver.com   Shutdown            Shutdown 8 minutes ago

```

### Create another service in our swarm using nginx

```bash
# creat another service based on nginx
docker service create --name testnginx -p 5901:80 nginx
jby2vhtm8glgzjmaslglebw49
overall progress: 1 out of 1 tasks
1/1: running   [==================================================>]
verify: Service converged

# verify all services
docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
jby2vhtm8glg        testnginx           replicated          1/1                 nginx:latest        *:5901->80/tcp
vlus0tstum40        testweb             replicated          3/3                 httpd:latest        *:80->80/tcp

# verify nginx
docker service ps testnginx
ID                  NAME                IMAGE               NODE                                    DESIRED STATE       CURRENT STATE           ERROR               PORTS
ng10yzp6er4q        testnginx.1         nginx:latest        craig-nicholsoneswlb1.mylabserver.com   Running             Running 3 minutes ago  

# can we update both to 5 replicas in one command - Error - no we can not
docker service update --replicas 5 testweb testnginx

# how about... YES
docker service scale testweb=5 testnginx=5
docker service scale --detach=false testnginx=4 testweb=2

# verify
docker service ps testweb
docker service ps testnginx

# verify we can get the nginx web site
curl craig-nicholsoneswlb1.mylabserver.com:5901

```

### Notes

These commands are the exact same thing and do the same thing for scaling up and down.

```bash
docker service update --replicas 5 testweb
docker service scale testweb=5
```

To scale multiple services at the same time, you can only use `docker service scale`

> docker service scale testweb=5 testnginx=5

- docker service scale and docker service update are the same commands
- The only way to update number of replicas for multiple services is to use docker scale.

## Running Replicated vs. Global Services

You can run your service in either replicated or global mode. The difference is subtle but important; let's talk a bit about that difference and then demonstrate the behavior in our swarm.

### Replicated (Default mode)

I control the number of instances (replicas) running across the cluster

```bash
docker service create --name testweb -p 80:80 httpd 
lc1p4pc3mkk5rxd4l2vc0aa3q
overall progress: 1 out of 1 tasks 
1/1: running   [==================================================>] 
verify: Service converged 

docker service ps testweb
ID                  NAME                IMAGE               NODE                                    DESIRED STATE       CURRENT STATE            ERROR               PORTS
l5fjgjudk0ce        testweb.1           httpd:latest        craig-nicholsoneswlb2.mylabserver.com   Running             Running 15 seconds ago                       

docker service scale testweb=3
testweb scaled to 3
overall progress: 3 out of 3 tasks 
1/3: running   [==================================================>] 
2/3: running   [==================================================>] 
3/3: running   [==================================================>] 
verify: Service converged 

docker service ps testweb
ID                  NAME                IMAGE               NODE                                    DESIRED STATE       CURRENT STATE            ERROR               PORTS
l5fjgjudk0ce        testweb.1           httpd:latest        craig-nicholsoneswlb2.mylabserver.com   Running             Running 46 seconds ago                       
pzvjg482ytnz        testweb.2           httpd:latest        craig-nicholsoneswlb3.mylabserver.com   Running             Running 12 seconds ago                       
jbklj9qn102g        testweb.3           httpd:latest        craig-nicholsoneswlb1.mylabserver.com   Running             Running 12 seconds ago                       

docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
lc1p4pc3mkk5        testweb             replicated          3/3                 httpd:latest        *:80->80/tcp

```

### Global Mode

Run the application across all of the nodes, and we lose the granular control of # of replicas on the nodes.

Check out the MODE it is global.  -mode global will send one service to all nodes join to the cluster.
And you will not able to scale this because it is already replciated to all nodes, and you want be able
to add more than one worker per node.

```bash
docker service create --name testnginx -p 5901:8080 --mode global --detach=false nginx
8a73r5sy93bjqsh8aa2el3af2
overall progress: 3 out of 3 tasks 
ceddzblkaexl: running   [==================================================>]
484tof81jhor: running   [==================================================>]
2t4xy1mtev3s: running   [==================================================>]
verify: Service converged

docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
8a73r5sy93bj        testnginx           global              3/3                 nginx:latest        *:5901->8080/tcp
lc1p4pc3mkk5        testweb             replicated          3/3                 httpd:latest        *:80->80/tcp

docker service ps testnginx
ID                  NAME                                  IMAGE               NODE                                    DESIRED STATE       CURRENT STATE            ERROR               PORTS
0qturwzb59vj        testnginx.ceddzblkaexlw93kximft8xpn   nginx:latest        craig-nicholsoneswlb3.mylabserver.com   Running             Running 18 seconds ago
mik1vhog25tw        testnginx.484tof81jhor294g4by22jpza   nginx:latest        craig-nicholsoneswlb2.mylabserver.com   Running             Running 18 seconds ago
rpsygnyrd6h5        testnginx.2t4xy1mtev3sks4sy8vwwiro6   nginx:latest        craig-nicholsoneswlb1.mylabserver.com   Running             Running 18 seconds ago

```

### Ok let's try and scale up testnginx, which is in --mode global

```bash
# attempt to scale --mode global
docker service update --replicas=5 testnginx
replicas can only be used with replicated mode

# attempt to scale --mode global
docker service scale testnginx=1
testnginx: scale can only be used with replicated mode

```

We can't scale this way.  We have to add more nodes.  And then the nginx global mode
will init another testnginx app when the node joins.

Once in global mode, you can't change back to replicated mode.

Once in replicated mode, you can't change back to global mode.

This does not work. `docker service update` does not supprot mode.  You will have to remove the service and create the service again.

> docker service update --mode

## Demonstrate the Usage of Templates with `docker service create`

Templates give us greater flexibility and control over a number of options when we create a service. This lesson will show you how to set various options using templating and then how to display those values after the fact.

Use template items for the hostname for `docker service create`

```bash
docker service create --name myweb --hostname="{{.Node.ID}}-{{.Service.Name}}" --detach=false httpd
7fjhp9rxr26v7mhnkn0hwuqwk
overall progress: 1 out of 1 tasks
1/1: running   [==================================================>]
verify: Service converged

# verify service is up
docker service ps --no-trunc myweb
ID                          NAME                IMAGE                                                                                  NODE                                    DESIRED STATE       CURRENT STATE            ERROR               PORTS
5k1rmw4lkwou60f0au5k4i0a5   myweb.1             httpd:latest@sha256:8c84e065bdf72b4909bd55a348d5e91fe265e08d6b28ed9104bfdcac9206dcc8   craig-nicholsoneswlb3.mylabserver.com   Running             Running 23 seconds ago
```

 Had issues using the template following on screen directions b/c of double qoutes
 And the Hostname seems to be in a different place in my distribution now...

```bash
# just get the host name
docker inspect --format="{{.Config.Hostname}}" myweb.1.5k1rmw4lkwou60f0au5k4i0a5
5k1rmw4lkwou60f0au5k4i0a5

# entire inspect
docker inspect myweb.1.5k1rmw4lkwou60f0au5k4i0a5
[
    {
        "ID": "5k1rmw4lkwou60f0au5k4i0a5",
        "Version": {
            "Index": 227
        },
        "CreatedAt": "2018-08-02T18:49:55.909791871Z",
        "UpdatedAt": "2018-08-02T18:49:56.644288661Z",
        "Labels": {},
        "Spec": {
            "ContainerSpec": {
                "Image": "httpd:latest@sha256:8c84e065bdf72b4909bd55a348d5e91fe265e08d6b28ed9104bfdcac9206dcc8",
                "Hostname": "{{.Node.ID}}-{{.Service.Name}}",
                "Init": false,
                "DNSConfig": {},
                "Isolation": "default"
            },
            "Resources": {
                "Limits": {},
                "Reservations": {}
            },
            "Placement": {
                "Platforms": [
                    {
                        "Architecture": "amd64",
                        "OS": "linux"
                    },
                    {
                        "OS": "linux"
                    },
                    {
                        "OS": "linux"
                    },
                    {
                        "Architecture": "386",
                        "OS": "linux"
                    }
                ]
            },
            "ForceUpdate": 0
        },
        "ServiceID": "7fjhp9rxr26v7mhnkn0hwuqwk",
        "Slot": 1,
        "NodeID": "ceddzblkaexlw93kximft8xpn",
        "Status": {
            "Timestamp": "2018-08-02T18:49:56.575154864Z",
            "State": "running",
            "Message": "started",
            "ContainerStatus": {
                "ContainerID": "37b9a8833d59a9ec2100b78f48318e4a469d2e60ed51e23a2c8f1975e5868148",
                "PID": 8097,
                "ExitCode": 0
            },
            "PortStatus": {}
        },
        "DesiredState": "running"
    }
]


# create another service
docker service create --name myweb2 --hostname={{.Node.ID}}-{{.Service.Name}} --detach=false httpd
mfi39f09lwvp96qn3vkxolheo
overall progress: 1 out of 1 tasks 
1/1: running   [==================================================>]
verify: Service converged

docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
7fjhp9rxr26v        myweb               replicated          1/1                 httpd:latest        
mfi39f09lwvp        myweb2              replicated          1/1                 httpd:latest        
$ docker service ps -no-trunc myweb2
unknown shorthand flag: 'n' in -no-trunc
See 'docker service ps --help'.

docker service ps --no-trunc myweb2
ID                          NAME                IMAGE                                                                                  NODE                                    DESIRED STATE       CURRENT STATE                ERROR               PORTS
00thpam0mxrcd5x02tigih0rl   myweb2.1            httpd:latest@sha256:8c84e065bdf72b4909bd55a348d5e91fe265e08d6b28ed9104bfdcac9206dcc8   craig-nicholsoneswlb1.mylabserver.com   Running             Running about a minute ago                       
```

### docker inpect with grep

```bash
docker inspect myweb2.1.00thpam0mxrcd5x02tigih0rl | grep Hostname
        "HostnamePath": "/var/lib/docker/containers/4b7ef86d071cee118a5ee1bba86d5b6fe448a6a8e682286e1dcfd6a1a1351b70/hostname",
            "Hostname": "2t4xy1mtev3sks4sy8vwwiro6-myweb2",

docker inspect myweb.1.5k1rmw4lkwou60f0au5k4i0a5 | grep Hostname
                "Hostname": "{{.Node.ID}}-{{.Service.Name}}",

```

### This will help yo identify your nodes in a large cluster

```bash
$ docker inspect --format="{{.Config.Hostname}}"  myweb2.1.00thpam0mxrcd5x02tigih0rl
2t4xy1mtev3sks4sy8vwwiro6-myweb2


$ docker inspect --format="{{.Config.Hostname}}"  myweb.1.5k1rmw4lkwou60f0au5k4i0a5
Template parsing error: template: :1:9: executing "" at <.Config.Hostname>: map has no entry for key "Config"

```

## Apply Node Labels for Task Placement

This is on the tst for sure.

Node labels are a really cool way for you to control how (and where) your Docker services run in your swarm. 

Send your services to nodes with specific labels.

This lesson will show you how to use a label to apply service constraints to indicate where the replicas for your service should run.

```bash
# status of the swarm
docker node ls
ID                            HOSTNAME                                STATUS              AVAILABILITY        MANAGER STATUS      ENGINE VERSION
2t4xy1mtev3sks4sy8vwwiro6 *   craig-nicholsoneswlb1.mylabserver.com   Ready               Active              Leader              18.06.0-ce
484tof81jhor294g4by22jpza     craig-nicholsoneswlb2.mylabserver.com   Ready               Active                                  18.06.0-ce
ceddzblkaexlw93kximft8xpn     craig-nicholsoneswlb3.mylabserver.com   Ready               Active                                  18.06.0-ce


# Usage:  docker node inspect [OPTIONS] self|NODE [NODE...]
# Display detailed information on one or more nodes
[user@craig-nicholsoneswlb1 ~]$ docker node inspect 2t4xy1mtev3sks4sy8vwwiro6
[
    {
        "ID": "2t4xy1mtev3sks4sy8vwwiro6",
        "Version": {
            "Index": 43
        },
        "CreatedAt": "2018-08-02T15:39:11.321121996Z",
        "UpdatedAt": "2018-08-02T17:05:26.218388871Z",
        "Spec": {
            "Labels": {},
            "Role": "manager",
            "Availability": "active"
        },
        "Description": {
            "Hostname": "craig-nicholsoneswlb1.mylabserver.com",
            "Platform": {
                "Architecture": "x86_64",
                "OS": "linux"
            },
            "Resources": {
                "NanoCPUs": 1000000000,
                "MemoryBytes": 1926369280
            },
            "Engine": {
                "EngineVersion": "18.06.0-ce",
                "Plugins": [
                    {
                        "Type": "Log",
                        "Name": "awslogs"
                    },
                    {
                        "Type": "Log",
                        "Name": "fluentd"
                    },
                    {
                        "Type": "Log",
                        "Name": "gcplogs"
                    },
                    {
                        "Type": "Log",
                        "Name": "gelf"
                    },
                    {
                        "Type": "Log",
                        "Name": "journald"
                    },
                    {
                        "Type": "Log",
                        "Name": "json-file"
                    },
                    {
                        "Type": "Log",
                        "Name": "logentries"
                    },
                    {
                        "Type": "Log",
                        "Name": "splunk"
                    },
                    {
                        "Type": "Log",
                        "Name": "syslog"
                    },
                    {
                        "Type": "Network",
                        "Name": "bridge"
                    },
                    {
                        "Type": "Network",
                        "Name": "host"
                    },
                    {
                        "Type": "Network",
                        "Name": "macvlan"
                    },
                    {
                        "Type": "Network",
                        "Name": "null"
                    },
                    {
                        "Type": "Network",
                        "Name": "overlay"
                    },
                    {
                        "Type": "Volume",
                        "Name": "local"
                    }
                ]
            },
            "TLSInfo": {
                "TrustRoot": "-----BEGIN CERTIFICATE-----\nMIIBajCCARCgAwIBAgIUMOwRZDLNgP49C8yiKqXlTdyzSG0wCgYIKoZIzj0EAwIw\nEzERMA8GA1UEAxMIc3dhcm0tY2EwHhcNMTgwODAyMTUzNDAwWhcNMzgwNzI4MTUz\nNDAwWjATMREwDwYDVQQDEwhzd2FybS1jYTBZMBMGByqGSM49AgEGCCqGSM49AwEH\nA0IABAS2tTitO09j6wjjlmvjGMv6v48oK1DNgYfTIuzMXQZQ5ixR4JYse9G6MEEa\nGECcWvbY9ONZAnenzC0LLsRjQF2jQjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMB\nAf8EBTADAQH/MB0GA1UdDgQWBBRA2BWnuE/dgKwOTfp2fRNgvCCz9zAKBggqhkjO\nPQQDAgNIADBFAiEAvBmg3m0IxB9gIc9SFPbtXunEOtgFw3Zc1Y2oeDhwxcUCIGU4\nOsS+hcTf6iirUmcWP0HlqDzp0u0iX6PKiteMuFgy\n-----END CERTIFICATE-----\n",
                "CertIssuerSubject": "MBMxETAPBgNVBAMTCHN3YXJtLWNh",
                "CertIssuerPublicKey": "MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEBLa1OK07T2PrCOOWa+MYy/q/jygrUM2Bh9Mi7MxdBlDmLFHglix70bowQRoYQJxa9tj041kCd6fMLQsuxGNAXQ=="
            }
        },
        "Status": {
            "State": "ready",
            "Addr": "172.31.40.64"
        },
        "ManagerStatus": {
            "Leader": true,
            "Reachability": "reachable",
            "Addr": "172.31.40.64:2377"
        }
    }
]

```

### fitler inspect with `docker node inspect --pretty NODEID`

```bash

docker node inspect --pretty 2t4xy1mtev3sks4sy8vwwiro6

ID:			2t4xy1mtev3sks4sy8vwwiro6
Hostname:              	craig-nicholsoneswlb1.mylabserver.com
Joined at:             	2018-08-02 15:39:11.321121996 +0000 utc
Status:
 State:			Ready
 Availability:         	Active
 Address:		172.31.40.64
Manager Status:
 Address:		172.31.40.64:2377
 Raft Status:		Reachable
 Leader:		Yes
Platform:
 Operating System:	linux
 Architecture:		x86_64
Resources:
 CPUs:			1
 Memory:		1.794GiB
Plugins:
 Log:		awslogs, fluentd, gcplogs, gelf, journald, json-file, logentries, splunk, syslog
 Network:		bridge, host, macvlan, null, overlay
 Volume:		local
Engine Version:		18.06.0-ce
TLS Info:
 TrustRoot:
-----BEGIN CERTIFICATE-----
MIIBajCCARCgAwIBAgIUMOwRZDLNgP49C8yiKqXlTdyzSG0wCgYIKoZIzj0EAwIw
EzERMA8GA1UEAxMIc3dhcm0tY2EwHhcNMTgwODAyMTUzNDAwWhcNMzgwNzI4MTUz
NDAwWjATMREwDwYDVQQDEwhzd2FybS1jYTBZMBMGByqGSM49AgEGCCqGSM49AwEH
A0IABAS2tTitO09j6wjjlmvjGMv6v48oK1DNgYfTIuzMXQZQ5ixR4JYse9G6MEEa
GECcWvbY9ONZAnenzC0LLsRjQF2jQjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMB
Af8EBTADAQH/MB0GA1UdDgQWBBRA2BWnuE/dgKwOTfp2fRNgvCCz9zAKBggqhkjO
PQQDAgNIADBFAiEAvBmg3m0IxB9gIc9SFPbtXunEOtgFw3Zc1Y2oeDhwxcUCIGU4
OsS+hcTf6iirUmcWP0HlqDzp0u0iX6PKiteMuFgy
-----END CERTIFICATE-----

 Issuer Subject:	MBMxETAPBgNVBAMTCHN3YXJtLWNh
 Issuer Public Key:	MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEBLa1OK07T2PrCOOWa+MYy/q/jygrUM2Bh9Mi7MxdBlDmLFHglix70bowQRoYQJxa9tj041kCd6fMLQsuxGNAXQ==
```

### Labels

> Apply node labels to demonstrate placment of tasks.

Example
Labels:

> --label-add mynode=testnode [--lable-add key=value]

```bash
# create a label on the node to help fitler the nodes
# labels can help control resource deployments with names
# with labels on nodes, we can use docker create service --contstraints to control the deployment
docker node update --label-add mynode=testnode ceddzblkaexlw93kximft8xpn
ceddzblkaexlw93kximft8xpn

# review the swarm again
docker node ls
ID                            HOSTNAME                                STATUS              AVAILABILITY        MANAGER STATUS      ENGINE VERSION
2t4xy1mtev3sks4sy8vwwiro6 *   craig-nicholsoneswlb1.mylabserver.com   Ready               Active              Leader              18.06.0-ce
484tof81jhor294g4by22jpza     craig-nicholsoneswlb2.mylabserver.com   Ready               Active                                  18.06.0-ce
ceddzblkaexlw93kximft8xpn     craig-nicholsoneswlb3.mylabserver.com   Ready               Active                                  18.06.0-ce

# you can see the label has been applied
docker node inspect --pretty ceddzblkaexlw93kximft8xpn

ID:ceddzblkaexlw93kximft8xpn
Labels:
 - mynode=testnode
...

```

### Example Service with label and constraints

Using constraints to put services on nodes... and how and where a service runs.
Some services will require nodes with more CPU or memory for example.

Example constraints (MEMORIZE THESE), only Five.

- node.labels
- node.id
- node.hostname
- node.role
- node.engine.labels

```bash

docker service create --name constraints -p 80:80 --constraint 'node.labels.mynode == testnode' --replicas 3 httpd
osrspu23wxj6kwkict695yceb
overall progress: 3 out of 3 tasks 
1/3: running   [==================================================>]
2/3: running   [==================================================>]
3/3: running   [==================================================>]
verify: Service converged

```

> docker service create --name constraints -p 80:80 --constraint 'node.labels.mynode == testnode' --replicas 3 httpd

### Review the service with Constraints

You will see here all 3 replicas are running on craig-nicholsoneswlb3 and not on craig-nicholsoneswlb1 or craig-nicholsoneswlb2.
Because we marked node 3 with the label.

```bash
docker node update --label-add mynode=testnode ceddzblkaexlw93kximft8xpn
```

```bash
docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
osrspu23wxj6        constraints         replicated          3/3                 httpd:latest        *:80->80/tcp
[user@craig-nicholsoneswlb1 ~]$ docker service ps constraints
ID                  NAME                IMAGE               NODE                                    DESIRED STATE       CURRENT STATE                ERROR               PORTS
xbsurnp26qec        constraints.1       httpd:latest        craig-nicholsoneswlb3.mylabserver.com   Running             Running about a minute ago
0w43o6s82djf        constraints.2       httpd:latest        craig-nicholsoneswlb3.mylabserver.com   Running             Running about a minute ago
uz3gftyndln0        constraints.3       httpd:latest        craig-nicholsoneswlb3.mylabserver.com   Running             Running about a minute ago
```

### Let's try a service with no constraints

```bash

docker service create --name normal nginx

```

Scale the normal service with no constraints.  This service runs on all three nodes and is not CONTSTRAINED to node 3.

```bash

docker service update --replicas 3 normal
normal
overall progress: 3 out of 3 tasks
1/3: running   [==================================================>]
2/3: running   [==================================================>]
3/3: running   [==================================================>]
verify: Service converged

# review the service without constraints
docker service ps normal
ID                  NAME                IMAGE               NODE                                    DESIRED STATE       CURRENT STATE            ERROR               PORTS
6wxxihspz1b0        normal.1            nginx:latest        craig-nicholsoneswlb1.mylabserver.com   Running             Running 57 seconds ago
r6z1em6ddfme        normal.2            nginx:latest        craig-nicholsoneswlb2.mylabserver.com   Running             Running 26 seconds ago
7wgjnpn9tel9        normal.3            nginx:latest        craig-nicholsoneswlb3.mylabserver.com   Running             Running 27 seconds ago

# review the service with constraints
docker service ps constraints
ID                  NAME                IMAGE               NODE                                    DESIRED STATE       CURRENT STATE           ERROR               PORTS
xbsurnp26qec        constraints.1       httpd:latest        craig-nicholsoneswlb3.mylabserver.com   Running             Running 3 minutes ago
0w43o6s82djf        constraints.2       httpd:latest        craig-nicholsoneswlb3.mylabserver.com   Running             Running 3 minutes ago
uz3gftyndln0        constraints.3       httpd:latest        craig-nicholsoneswlb3.mylabserver.com   Running             Running 3 minutes ago
```

## Convert an Application Deployment into a Stack File Using a YAML Compose File with 'docker stack deploy'

- Docker Compose
- Use stack file, with docker compose

### Install packages for Docker Compose

https://docs.docker.com/compose/install/

Class - this way failed.

```bash
sudo yum info epel-release
sudo yum install epel-release
sudo yum install python-pip
sudo pip install --upgrade pip
sudo pip install docker-compose
 ```

Reference for docker websiste worked.

```bash
sudo curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   617    0   617    0     0   2889      0 --:--:-- --:--:-- --:--:--  2910
100 11.2M  100 11.2M    0     0  22.3M      0 --:--:-- --:--:-- --:--:-- 22.3M

sudo chmod +x /usr/local/bin/docker-compose

docker-compose --version
docker-compose version 1.22.0, build f46880fe
```

### Create a Dockerfile for simple httpd web service and test with docker build

 ```bash
mkdir Dockerfile
cd Dockerfile/
vi Dockerfile
cat Dockerfile
```

```Dockerfile
#simple webserver
FROM centos:latest
LABEL maintainer="maint@gmail.com"

RUN yum install -y httpd
RUN echo "Our container Website" >> /var/www/html/index.html

EXPOSE 80

ENTRYPOINT apachectl -DFOREGROUND
```

```bash
docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
httpd               latest              11426a19f1a2        2 days ago          178MB
nginx               latest              c82521676580        9 days ago          109MB

# build the Dockerfile we just created
docker build -t myhttpd:v1 .
 ```

Do a test run with the myhttpd container and then clean up..

 ```bash
# run our container we from `docker built --tag  myhttpd:v1 .`
docker run -d --name testweb -p 80:80 myhttpd:v1
ec393a3fd1f3740c03cef1f998baf0844b0b9d942995856d82fc6d3fae53fa04

# verify container is up
docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                NAMES
ec393a3fd1f3        myhttpd:v1          "/bin/sh -c 'apachec…"   15 seconds ago      Up 14 seconds       0.0.0.0:80->80/tcp   testweb

# verify if our file is on the web server
curl localhost
Our container Website

# clean up
docker stop testweb
testweb

docker rm testweb
testweb

docker rmi myhttpd:v1
Untagged: myhttpd:v1
Deleted: sha256:027c516b17c22f7094c4be6c27b34c530df0cf658c11d5863600eaa75a7ba814
Deleted: sha256:d8f083d6fe244f4aff90ccbbf6094924aeade002c66dc4c88b8b29aaa20faa5d
Deleted: sha256:1634597e22090f82be63be210466718395554c7ea0f6872d14531b38c19e5741
Deleted: sha256:b6333bfb556329705fed787dd0b394693c9af1593983e55e1af96a81b7577451
Deleted: sha256:f2de7af8d2be7af1530460b64779ea1b8591b551f43039eed558f7435e660658
Deleted: sha256:d293daba080071353ab22eca60bf85738de494fd6044b6cd9479bc86d343c2cd
Deleted: sha256:da2618f53dd490863504a58d4995474a9f7d83c2e5b76c4d2ae901076d9713c4

 ```

### Prep for using a Docker Compose File to build Application Stack (NOT FOR SWARM)

Tasks

- Create apiweb1 - use dockerfile
- Create apiweb2 - use image to launch another instance
- Create loadbalancer - use nginx and use all ports and start everthing up with simple docker command

 ```bash
# a better name is like 3 node cluster or smoething...
vi docker-compose.yml
 ```

Docker Compose file to be used with `docker-compose up -d`

 ```yml
$ vi docker-compose.yml

version: '3'
services:
  apiweb1:
    image: myhttpd:v1
    build: .
    ports:
    - "81:80"
  apiweb2:
    image: myhttpd:v1
    ports:
    - "82:80"
  loadbalancer:
    image: nginx:latest
    ports:
    - "80:80"
 ```

### Run docker-compose

REVIEW `docker stack deploy` and `docker-compose` to contrast and compare.

 ```bash

# this runs the file docker-compose.yml in the local dir
$ docker-compose up -d

WARNING: The Docker Engine you\'re using is running in swarm mode.
Compose does not use swarm mode to deploy services to multiple nodes in a swarm. All containers will be scheduled on the current node.
To deploy your application across the swarm, use `docker stack deploy`.

Creating network "dockerfile_default" with the default driver
Building apiweb1
Step 1/6 : FROM centos:latest
 ---> 49f7960eb7e4
Step 2/6 : LABEL maintainer="maint@gmail.com"
 ---> Running in 5688292b8bb8
Removing intermediate container 5688292b8bb8
 ---> 7b86ad80afe0
Step 3/6 : RUN yum install -y httpd
 ---> Running in bc57e380767b
Loaded plugins: fastestmirror, ovl
Complete!
Removing intermediate container bc57e380767b
 ---> 1216d52de440
Step 4/6 : RUN echo "Our container Website" >> /var/www/html/index.html
 ---> Running in 06e036a5d457
Removing intermediate container 06e036a5d457
 ---> cb9f8c950838
Step 5/6 : EXPOSE 80
 ---> Running in 4e3063fec1ed
Removing intermediate container 4e3063fec1ed
 ---> b76e5c5db590
Step 6/6 : ENTRYPOINT apachectl -DFOREGROUND
 ---> Running in d8dc9e2efbfe
Removing intermediate container d8dc9e2efbfe
 ---> 1fded7a9edd9
Successfully built 1fded7a9edd9
Successfully tagged myhttpd:v1
WARNING: Image for service apiweb1 was built because it did not already exist. To rebuild this image you must use `docker-compose build` or `docker-compose up --build`.
Creating dockerfile_apiweb1_1      ... done
Creating dockerfile_loadbalancer_1 ... done
Creating dockerfile_apiweb2_1      ... done

```

### Review the docker-compose results

```bash
$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                NAMES
49a7e1eee2f5        myhttpd:v1          "/bin/sh -c 'apachec…"   2 minutes ago       Up 2 minutes        0.0.0.0:81->80/tcp   dockerfile_apiweb1_1
55efc8de238f        nginx:latest        "nginx -g 'daemon of…"   2 minutes ago       Up 2 minutes        0.0.0.0:80->80/tcp   dockerfile_loadbalancer_1
c83c5ca8b917        myhttpd:v1          "/bin/sh -c 'apachec…"   2 minutes ago       Up 2 minutes        0.0.0.0:82->80/tcp   dockerfile_apiweb2_1

# as you see we are not running any services... which is cool we are not using a service, we want multiple containers on single host
$ docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS

# Need to open the 81 and 82 ports on this server
$ ifconfig
...
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 9001
        inet 172.31.40.64  netmask 255.255.240.0  broadcast 172.31.47.255
        inet6 fe80::830:7aff:fe31:ec64  prefixlen 64  scopeid 0x20<link>
        ether 0a:30:7a:31:ec:64  txqueuelen 1000  (Ethernet)
        RX packets 354518  bytes 328690705 (313.4 MiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 175293  bytes 23092119 (22.0 MiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
...

$ sudo vim /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

172.31.40.64    mgr01
172.31.37.103   node01
172.31.34.40    node02

172.31.40.64    craig-nicholsoneswlb1.mylabserver.com craig-nicholsoneswlb1
```

### Check that our websites are up for the docker-compose

```bash

$ curl craig-nicholsoneswlb1:81
Our container Website

$ curl craig-nicholsoneswlb1:82
Our container Website

# the load balancer at port 80
$ curl craig-nicholsoneswlb1
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```

### Review the docker-compose deployment

```bash
# containers on host started with docker compose
$ docker-compose ps
          Name                         Command               State         Ports       
---------------------------------------------------------------------------------------
dockerfile_apiweb1_1        /bin/sh -c apachectl -DFOR ...   Up      0.0.0.0:81->80/tcp
dockerfile_apiweb2_1        /bin/sh -c apachectl -DFOR ...   Up      0.0.0.0:82->80/tcp
dockerfile_loadbalancer_1   nginx -g daemon off;             Up      0.0.0.0:80->80/tcp
```

### Bring down the site

```bash
# cleanly send stop signles to the containers
$ docker-compose down --volumes

Stopping dockerfile_apiweb1_1      ... done
Stopping dockerfile_loadbalancer_1 ... done
Stopping dockerfile_apiweb2_1      ... done
Removing dockerfile_apiweb1_1      ... done
Removing dockerfile_loadbalancer_1 ... done
Removing dockerfile_apiweb2_1      ... done
Removing network dockerfile_default

 ```

### Deploying a stack to a swarm

Any images you use need, will have to be built before you use docker stack deploy.

Docker stack deploy does not support dynamic build during deploy.

Verify we are staring clean.  No running for stopped containers.

 ```bash
$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES

$ docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES 

 ```

### docker stack deploy

Deploy our stack to the swarm.  Once we verify docker-compose.yml works good we can use `docker stack deploy` to deploy that stack.

- One file
- docker-compose
- docker stack deploy
- awesome sauce

 ```bash
docker stack deploy --compose-file docker-compose.yml mycustomestack
Ignoring unsupported options: build

Creating network mycustomestack_default
Creating service mycustomestack_loadbalancer
Creating service mycustomestack_apiweb1
Creating service mycustomestack_apiweb2

 ```

### Verify `docker stack deploy` was deployed

 ```bash
# not all services are up on the swarm
docker service ls
ID                  NAME                          MODE                REPLICAS            IMAGE               PORTS
wepvwakjffjo        mycustomestack_apiweb1        replicated          0/1                 myhttpd:v1          *:81->80/tcp
8qm4p9pauwkg        mycustomestack_apiweb2        replicated          0/1                 myhttpd:v1          *:82->80/tcp
o9w0mcvhy5zk        mycustomestack_loadbalancer   replicated          1/1                 nginx:latest        *:80->80/tcp

# finally all replicas are up!
docker service ls
ID                  NAME                          MODE                REPLICAS            IMAGE               PORTS
wepvwakjffjo        mycustomestack_apiweb1        replicated          1/1                 myhttpd:v1          *:81->80/tcp
8qm4p9pauwkg        mycustomestack_apiweb2        replicated          1/1                 myhttpd:v1          *:82->80/tcp
o9w0mcvhy5zk        mycustomestack_loadbalancer   replicated          1/1                 nginx:latest        *:80->80/tcp

 ```

### Check all the services processes individually

 ```bash
 #review apiweb1
docker service ps mycustomestack_apiweb1
ID                  NAME                           IMAGE               NODE                                    DESIRED STATE       CURRENT STATE            ERROR                         PORTS
430t4oqnskru        mycustomestack_apiweb1.1       myhttpd:v1          craig-nicholsoneswlb1.mylabserver.com   Running             Running 2 minutes ago
xi94jmo29nqj         \_ mycustomestack_apiweb1.1   myhttpd:v1          craig-nicholsoneswlb3.mylabserver.com   Shutdown            Rejected 2 minutes ago   "No such image: myhttpd:v1"
sytudcup4905         \_ mycustomestack_apiweb1.1   myhttpd:v1          craig-nicholsoneswlb2.mylabserver.com   Shutdown            Rejected 3 minutes ago   "No such image: myhttpd:v1"
wlxj18m6hg5i         \_ mycustomestack_apiweb1.1   myhttpd:v1          craig-nicholsoneswlb2.mylabserver.com   Shutdown            Rejected 3 minutes ago   "No such image: myhttpd:v1"
t8qtct3znmqj         \_ mycustomestack_apiweb1.1   myhttpd:v1          craig-nicholsoneswlb3.mylabserver.com   Shutdown            Rejected 3 minutes ago   "No such image: myhttpd:v1"

# review apiweb2
docker service ps mycustomestack_apiweb2
ID                  NAME                           IMAGE               NODE                                    DESIRED STATE       CURRENT STATE            ERROR                         PORTS
ptvvtdrglve5        mycustomestack_apiweb2.1       myhttpd:v1          craig-nicholsoneswlb1.mylabserver.com   Running             Running 2 minutes ago
qvp6sastpptn         \_ mycustomestack_apiweb2.1   myhttpd:v1          craig-nicholsoneswlb3.mylabserver.com   Shutdown            Rejected 3 minutes ago   "No such image: myhttpd:v1"
oxreu4wjkg2s         \_ mycustomestack_apiweb2.1   myhttpd:v1          craig-nicholsoneswlb3.mylabserver.com   Shutdown            Rejected 3 minutes ago   "No such image: myhttpd:v1"
so5jlox6xonq         \_ mycustomestack_apiweb2.1   myhttpd:v1          craig-nicholsoneswlb2.mylabserver.com   Shutdown            Rejected 3 minutes ago   "No such image: myhttpd:v1"
j9nk517cwp2e         \_ mycustomestack_apiweb2.1   myhttpd:v1          craig-nicholsoneswlb2.mylabserver.com   Shutdown            Rejected 3 minutes ago   "No such image: myhttpd:v1"

# finally review the load balancer
docker service ps mycustomestack_loadbalancer
ID                  NAME                            IMAGE               NODE                                    DESIRED STATE       CURRENT STATE           ERROR               PORTS
eaavif9ml03e        mycustomestack_loadbalancer.1   nginx:latest        craig-nicholsoneswlb1.mylabserver.com   Running             Running 3 minutes ago

 ```

## Understanding the 'docker inspect' Output

Allows for detailed constructs about the containers and pulled back in json.

 ```bash
docker run -d --name testweb httpd
4e6c9bf04984f71a2fad72ff199e69e099399962cacf2e587bf890decb18463e

docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED              STATUS              PORTS               NAMES
4e6c9bf04984        httpd               "httpd-foreground"       3 seconds ago        Up 2 seconds        80/tcp              testweb

docker container inspect testweb
# docker exteneded the inspect so you can use
# docker inspect IDNAME
# Usage: docker inspect [OPTIONS] NAME|ID [NAME|ID...]
# Return low-level information on Docker objects

```

> docker container inspect testweb

```json
[
    {
        "Id": "4e6c9bf04984f71a2fad72ff199e69e099399962cacf2e587bf890decb18463e",
        "Created": "2018-08-02T22:40:23.267254247Z",
        "Path": "httpd-foreground",
        "Args": [],
        "State": {
            "Status": "running",
            "Running": true,
            "Paused": false,
            "Restarting": false,
            "OOMKilled": false,
            "Dead": false,
            "Pid": 20046,
            "ExitCode": 0,
            "Error": "",
            "StartedAt": "2018-08-02T22:40:24.113166679Z",
            "FinishedAt": "0001-01-01T00:00:00Z"
        },
        "Image": "sha256:11426a19f1a28d6491041aef1e1a7a2dcaa188d0165ae495de7d8fc1bf3e164f",
        "ResolvConfPath": "/var/lib/docker/containers/4e6c9bf04984f71a2fad72ff199e69e099399962cacf2e587bf890decb18463e/resolv.conf",
        "HostnamePath": "/var/lib/docker/containers/4e6c9bf04984f71a2fad72ff199e69e099399962cacf2e587bf890decb18463e/hostname",
        "HostsPath": "/var/lib/docker/containers/4e6c9bf04984f71a2fad72ff199e69e099399962cacf2e587bf890decb18463e/hosts",
        "LogPath": "/var/lib/docker/containers/4e6c9bf04984f71a2fad72ff199e69e099399962cacf2e587bf890decb18463e/4e6c9bf04984f71a2fad72ff199e69e099399962cacf2e587bf890decb18463e-json.log",
        "Name": "/testweb",
        "RestartCount": 0,
        "Driver": "devicemapper",
        "Platform": "linux",
        "MountLabel": "",
        "ProcessLabel": "",
        "AppArmorProfile": "",
        "ExecIDs": null,
        "HostConfig": {
            "Binds": null,
            "ContainerIDFile": "",
            "LogConfig": {
                "Type": "json-file",
                "Config": {}
            },
            "NetworkMode": "default",
            "PortBindings": {},
            "RestartPolicy": {
                "Name": "no",
                "MaximumRetryCount": 0
            },
            "AutoRemove": false,
            "VolumeDriver": "",
            "VolumesFrom": null,
            "CapAdd": null,
            "CapDrop": null,
            "Dns": [],
            "DnsOptions": [],
            "DnsSearch": [],
            "ExtraHosts": null,
            "GroupAdd": null,
            "IpcMode": "shareable",
            "Cgroup": "",
            "Links": null,
            "OomScoreAdj": 0,
            "PidMode": "",
            "Privileged": false,
            "PublishAllPorts": false,
            "ReadonlyRootfs": false,
            "SecurityOpt": null,
            "UTSMode": "",
            "UsernsMode": "",
            "ShmSize": 67108864,
            "Runtime": "runc",
            "ConsoleSize": [
                0,
                0
            ],
            "Isolation": "",
            "CpuShares": 0,
            "Memory": 0,
            "NanoCpus": 0,
            "CgroupParent": "",
            "BlkioWeight": 0,
            "BlkioWeightDevice": [],
            "BlkioDeviceReadBps": null,
            "BlkioDeviceWriteBps": null,
            "BlkioDeviceReadIOps": null,
            "BlkioDeviceWriteIOps": null,
            "CpuPeriod": 0,
            "CpuQuota": 0,
            "CpuRealtimePeriod": 0,
            "CpuRealtimeRuntime": 0,
            "CpusetCpus": "",
            "CpusetMems": "",
            "Devices": [],
            "DeviceCgroupRules": null,
            "DiskQuota": 0,
            "KernelMemory": 0,
            "MemoryReservation": 0,
            "MemorySwap": 0,
            "MemorySwappiness": null,
            "OomKillDisable": false,
            "PidsLimit": 0,
            "Ulimits": null,
            "CpuCount": 0,
            "CpuPercent": 0,
            "IOMaximumIOps": 0,
            "IOMaximumBandwidth": 0,
            "MaskedPaths": [
                "/proc/acpi",
                "/proc/kcore",
                "/proc/keys",
                "/proc/latency_stats",
                "/proc/timer_list",
                "/proc/timer_stats",
                "/proc/sched_debug",
                "/proc/scsi",
                "/sys/firmware"
            ],
            "ReadonlyPaths": [
                "/proc/asound",
                "/proc/bus",
                "/proc/fs",
                "/proc/irq",
                "/proc/sys",
                "/proc/sysrq-trigger"
            ]
        },
        "GraphDriver": {
            "Data": {
                "DeviceId": "94",
                "DeviceName": "docker-202:1-8455043-574bb9d0771171fe87cd725a02df4c28a4bd593a59e320f614d3858d983ed6df",
                "DeviceSize": "10737418240"
            },
            "Name": "devicemapper"
        },
        "Mounts": [],
        "Config": {
            "Hostname": "4e6c9bf04984",
            "Domainname": "",
            "User": "",
            "AttachStdin": false,
            "AttachStdout": false,
            "AttachStderr": false,
            "ExposedPorts": {
                "80/tcp": {}
            },
            "Tty": false,
            "OpenStdin": false,
            "StdinOnce": false,
            "Env": [
                "PATH=/usr/local/apache2/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
                "HTTPD_PREFIX=/usr/local/apache2",
                "NGHTTP2_VERSION=1.18.1-1",
                "OPENSSL_VERSION=1.0.2l-1~bpo8+1",
                "HTTPD_VERSION=2.4.34",
                "HTTPD_SHA256=fa53c95631febb08a9de41fd2864cfff815cf62d9306723ab0d4b8d7aa1638f0",
                "HTTPD_PATCHES=",
                "APACHE_DIST_URLS=https://www.apache.org/dyn/closer.cgi?action=download&filename= \thttps://www-us.apache.org/dist/ \thttps://www.apache.org/dist/ \thttps://archive.apache.org/dist/"
            ],
            "Cmd": [
                "httpd-foreground"
            ],
            "ArgsEscaped": true,
            "Image": "httpd",
            "Volumes": null,
            "WorkingDir": "/usr/local/apache2",
            "Entrypoint": null,
            "OnBuild": null,
            "Labels": {}
        },
        "NetworkSettings": {
            "Bridge": "",
            "SandboxID": "2841511cf3da1fa0dde061daa892d914caf4f05d5d96d3c8d75a92b8893ac5e0",
            "HairpinMode": false,
            "LinkLocalIPv6Address": "",
            "LinkLocalIPv6PrefixLen": 0,
            "Ports": {
                "80/tcp": null
            },
            "SandboxKey": "/var/run/docker/netns/2841511cf3da",
            "SecondaryIPAddresses": null,
            "SecondaryIPv6Addresses": null,
            "EndpointID": "390dc495b08f2fc10caae83bf819ff0247f90654996176e042eb00d68648b8b3",
            "Gateway": "172.17.0.1",
            "GlobalIPv6Address": "",
            "GlobalIPv6PrefixLen": 0,
            "IPAddress": "172.17.0.2",
            "IPPrefixLen": 16,
            "IPv6Gateway": "",
            "MacAddress": "02:42:ac:11:00:02",
            "Networks": {
                "bridge": {
                    "IPAMConfig": null,
                    "Links": null,
                    "Aliases": null,
                    "NetworkID": "7783f29f0b054d642dbfaa7e730a450dee9b52415ff6e3a2042032acc6f4c3f7",
                    "EndpointID": "390dc495b08f2fc10caae83bf819ff0247f90654996176e042eb00d68648b8b3",
                    "Gateway": "172.17.0.1",
                    "IPAddress": "172.17.0.2",
                    "IPPrefixLen": 16,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "MacAddress": "02:42:ac:11:00:02",
                    "DriverOpts": null
                }
            }
        }
    }
]
 ```

### grep for ip address

 ```bash

docker inspect container testweb | grep IPAddress
            "SecondaryIPAddresses": null,
            "IPAddress": "172.17.0.2",
                    "IPAddress": "172.17.0.2",

 ```

### Review the json to look at the structre, get more familiar and pull back things what you want

Determine if the container has been paused.

 ```bash
docker container inspect testweb --format="{{.State.Paused}}"
false
 ```

Get all in the state.

 ```bash
docker container inspect testweb --format="{{json .State}}"
 ```

```json
{
    "Status":"running",
    "Running":true,
    "Paused":false,
    "Restarting":false,
    "OOMKilled":false,
    "Dead":false,
    "Pid":21533,
    "ExitCode":0,
    "Error":"",
    "StartedAt":"2018-08-14T17:28:39.2413769Z",
    "FinishedAt":"2018-08-14T12:11:05.849343Z"
}
```

## Identify the Steps Needed to Troubleshoot a Service Not Deploying

Troubleshoot docker swarm services

### docker node ls

Are all the nodes available and show that way in your cluster

### docker service ps

- is service partially running
- is problem specific to # of replicas

### docker service inspect

- did you apply labels and do they show?
- did you deply your service with a constraint and mis-matched the value with once used on launch

### docker ps

- is your cluster locked
- you have to unlocked when it restarts
- did the restore of swarm and services not starting
 -- re-initialize the new mananger you restord  to force the cluster so that it is not attemping to contact previous nodes
- did you update docker

### SELinux issues

 -- try setenforce 0 to push SELinux into Passize mode and retryy your task

### Permissions

 -- resources need to have access running as user
 -- don't run as root

### CPU/Mem

 -- when constraining containster to a host, bes ure it has necessary resource to meet the needs of the service

### routing

  -- endpoints use same service on same network routing or have the necessary routing to reach each other

### firewall rules

## How Dockerized Apps Communicate with Legacy Systems

Communication is key and we have seen many ways that Docker communicates. Let's focus for a few minutes on some key items to consider when deploying Docker in your IT ecosystem.

Communicate in the same ways.

Exceptions

- Routing
 -- expose stating routing
 -- expose the ports and docker daemon
- Port Redirection
 -- will have to manage these
 -- need a proxy in front of them
- Portabiliy
 -- make sure data is external to container
 -- on the host or network share
 -- this can have impact on perf.

Containers should be

- abstarct
- portable
- flexible

## Paraphrase the Importance of Quorum in a Swarm Cluster

Every swarm will have 1-N Manager nodes in it.
These are special nodes for managing
directing logging and reporting on the lifecycle
of the swarm in general.

The ‘Raft Consensus Algorithm’ is used to manage the swarm state. Using this ‘consensus’ method amongst the management nodes is designed to be sure that in the event of a failure of any manager, any other manager will have enough information stored on it to continue to operation the swarm as expected.

Raft tolerates up to (N-1)/2 failures and requires a majority (quorum) of (N/2)+1 to agree on any new instructions that are proposed to the cluster for execution.

### Requirements for a Quorum

|Swarm Size | Majority | Fault Tolerance|
|-----------|----------|----------------|
|     1     |     1    |        0       |
|     2     |     2    |        0       |
|     3     |     2    |        1       |
|     4     |     3    |        1       |
|     5     |     3    |        2       |
|     6     |     4    |        2       |
|     7     |     4    |        3       |
|     8     |     5    |        3       |
|     9     |     5    |        4       |

Maintain an odd number for nodes.

More managers does not make it better, b/c it will get chatty

Breakdown of Manager Nodes for Fault Tolerance

Requirements/Considerations
• Use Static IPs for managers
• Immediately Replace Failed managers

Managers
• Distribute Management Nodes for High Availability
• Monitor Swarm Health
• Have a Backup and Recovery Plan for the Swarm

practice back up and recovery

### Management Node Datacenter Distribution for HA

THIS IS ON THE TEST

You should distribute nodes in 3 locations.
With any 2 datacenters you can still maintain a quorum.

You typically lose one zone.. not all zones.

When you do a recovery you can force a rebalance.

| Swarm Manager Nodes | Repartition (on 3 Availability Zones) |
|---------------------|---------------------------------------|
|         3           |                1-1-1                  |
|         5           |                2-2-1                  |
|         7           |                3-2-2                  |
|         9           |                3-3-3                  |

Requirements/Considerations

• Use a Minimum of 3 Availability Zones to Distribute Managers
• Run ‘Manager Only’ Nodes
• docker node update –availability drain [node]
• Force Rebalance
• docker service update --force

## Create a Swarm Cluster

```bash
```

## Start a Service and Scale it within your swarm

```bash
```

## Demonstarte how failure affects service replicas in a swarm

```bash
```

## Re-assign a swarm worker to a manager

```bash
```

## Configure a swarm and scale ervices within a swarm for 3 servers

```bash
```