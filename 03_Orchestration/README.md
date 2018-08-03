# Orchestration

## State the Difference Between Running a Container and Running a Service

### Containers - docker run

All about the running of containers and not how we manage all the containers we are running.

- Encapsulate application or function
- run in single host
- require manual steps to expose functionaliytoutside of the house system (ports, network and volumes)
- require more complex configuration to use multiple instance (proxies for example)
- not highly available
- not easily scalable

### Services - docker service

- Encapsulate application or function
- can run on '1 to n' nodes at any time
- funtionality is easily accessed using features like routing mesh outside of the worker nodes
- multiple instance set to launch in single command and can be scaled up or down with one command
- highly available clusters available
- easily scale, up or down as needed

A solution to managing the containers deployed in a highly available easily scalable cluster implementation.

## Demonstrate Steps to Lock (and Unlock) a Cluster

Locking our cluster provides an additional level of security and protection for the encrypted logs and communication of our swarm. We will take a look at locking, displaying the token, unlocking, and rotating our token in a swarm.

If we were to hack into the servers, if the docker deamon is restarted I would need the unlock key.

TODO: Terraform a 3 node cluster with docker from scratch on AWS
TODO: Terraform a 3 node cluster with docker from scratch on AWS, with all nodes setup and joined and autolock key saved.

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

```

```bash
$ sudo vi /etc/hosts

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

### Docker Certification Distribution

172.31.40.64

```bash
docker swarm init --advertise-addr 172.31.40.64
Swarm initialized: current node (0z4chgk6pgw7scwpxw6ijd4ui) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join --token SWMTKN-1-3nobd99thvzvb86po7omtcuro23yk9wxhb94ynee15cv6wsekm-c2qvy4txfkj6wnhdgbci52ud7 172.31.39.165:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.
```

172.31.37.103

```bash
[user@craig-nicholsoneswlb2 ~]$ docker swarm join --token SWMTKN-1-4i84gml66ct6knzk65me463hgwa4a7d3yxvjtuuqjdyu24ag62-8fnma9qgdsfu52sj8valekmtg 172.31.40.64:2377
This node joined a swarm as a worker.

```

172.31.34.40

```bash
[user@craig-nicholsoneswlb2 ~]$ docker swarm join --token SWMTKN-1-4i84gml66ct6knzk65me463hgwa4a7d3yxvjtuuqjdyu24ag62-8fnma9qgdsfu52sj8valekmtg 172.31.40.64:2377
This node joined a swarm as a worker.

```

Check the swarm on 172.31.40.64

```bash
docker node ls

ID                            HOSTNAME                                STATUS              AVAILABILITY        MANAGER STATUS      ENGINE VERSION
2t4xy1mtev3sks4sy8vwwiro6 *   craig-nicholsoneswlb1.mylabserver.com   Ready               Active              Leader              18.06.0-ce
484tof81jhor294g4by22jpza     craig-nicholsoneswlb2.mylabserver.com   Ready               Active                                  18.06.0-ce
ceddzblkaexlw93kximft8xpn     craig-nicholsoneswlb3.mylabserver.com   Ready               Active                                  18.06.0-ce

```

Check for Services

```bash
docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
```

When this runs... it will provide an key back to us...
docker swarm init auto-lock

Also, if your system reboots, you have to unlock your swarm before it starts...

### --autolock=true

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

### Demonstrate the autolock feature

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

## Locking the Swarm Again

```bash
docker swarm update --autolock=true
Swarm updated.
To unlock a swarm manager after it restarts, run the `docker swarm unlock`
command and provide the following key:

    SWMKEY-1-K6JEy1N99WVhrMROOBAShfRC/VEF1k/bzIKANceZ9eU

Please remember to store this key in a password manager, since without it you
will not be able to restart the manager.

```

Periodically Change the Key with key rotation.

```bash

docker swarm unlock-key --rotate
Successfully rotated manager unlock key.

To unlock a swarm manager after it restarts, run the `docker swarm unlock`
command and provide the following key:

    SWMKEY-1-jctDW5hQ4OlZd6p6B1LZHupF9FZeSUSpNjq+K1KjESQ

Please remember to store this key in a password manager, since without it you
will not be able to restart the manager.


```

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
$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE

$ docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS

$ docker node ls
ID                            HOSTNAME                                STATUS              AVAILABILITY        MANAGER STATUS      ENGINE VERSION
2t4xy1mtev3sks4sy8vwwiro6 *   craig-nicholsoneswlb1.mylabserver.com   Ready               Active              Leader              18.06.0-ce
484tof81jhor294g4by22jpza     craig-nicholsoneswlb2.mylabserver.com   Ready               Active                                  18.06.0-ce
ceddzblkaexlw93kximft8xpn     craig-nicholsoneswlb3.mylabserver.com   Ready               Active                                  18.06.0-ce 

docker pull httpd

```

```bash
docker run -d --name testweb httpd
31fabbb4e534837b28f171ec44990a100059555ab686a68c4633bf25e5993dd1

$ docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS               NAMES
31fabbb4e534        httpd               "httpd-foreground"   16 seconds ago      Up 14 seconds       80/tcp              testweb

$ docker container inspect testweb | grep IPAddress
            "SecondaryIPAddresses": null,
            "IPAddress": "172.17.0.2",
                    "IPAddress": "172.17.0.2"

# check to see if httpd is up
curl 172.17.0.2
<html><body><h1>It works!</h1></body></html>
```

Clean Up

```bash

$ docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS               NAMES
31fabbb4e534        httpd               "httpd-foreground"   3 minutes ago       Up 3 minutes        80/tcp              testweb
$ docker stop testweb
testweb
$ docker ps -a
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS                     PORTS               NAMES
31fabbb4e534        httpd               "httpd-foreground"   3 minutes ago       Exited (0) 4 seconds ago                       testweb
$ docker rm testweb
testweb

```

Discussion...

Here is the problem we will encounter with a single container.
172.17.0.2 is on private network, only on this system.



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

docker_gwbridge: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 172.18.0.1  netmask 255.255.0.0  broadcast 172.18.255.255
        inet6 fe80::42:74ff:fe78:ae39  prefixlen 64  scopeid 0x20<link>
        ether 02:42:74:78:ae:39  txqueuelen 0  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 8  bytes 648 (648.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 9001
        inet 172.31.40.64  netmask 255.255.240.0  broadcast 172.31.47.255
        inet6 fe80::830:7aff:fe31:ec64  prefixlen 64  scopeid 0x20<link>
        ether 0a:30:7a:31:ec:64  txqueuelen 1000  (Ethernet)
        RX packets 103325  bytes 97608314 (93.0 MiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 56081  bytes 6381212 (6.0 MiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 84  bytes 7344 (7.1 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 84  bytes 7344 (7.1 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

vethcab47b8: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet6 fe80::f856:a5ff:fe20:dbf3  prefixlen 64  scopeid 0x20<link>
        ether fa:56:a5:20:db:f3  txqueuelen 0  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 8  bytes 648 (648.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

vethd54780b: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet6 fe80::706a:7bff:feae:f63f  prefixlen 64  scopeid 0x20<link>
        ether 72:6a:7b:ae:f6:3f  txqueuelen 0  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 8  bytes 648 (648.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```

Our container is running as 172.17.0.2, docker0 interface is 172.17.0.1 and
this is an internal private network, only can be send by this machine.

Ping 172.17.0.2 from another server like: 172.31.37.103

```bash
ping 172.17.0.2
From 172.17.0.1 icmp_seq=1 Destination Host Unreachable

```

We can add a static route... to that node, and then turn on IP forwarding but 
this is too much effort.

We can also expose the underlying ports... and external to the hosts... we are in
a network desert here ...

```bash
docker stop testweb
docker rm testweb

```

### Service is the solution

We want to use docker service runs 1 to n instances of a container across 1 to n nodes in the cluster.
Also, even though it is running a container on one node, it uses mesh routing so that you go to any
of the nodes in the cluster by their own IP, the routing is handled but the containers IP.

```bash

docker service create --name testweb --publish 80:80 httpd

docker node ls
ID                            HOSTNAME                                STATUS              AVAILABILITY        MANAGER STATUS      ENGINE VERSION
2t4xy1mtev3sks4sy8vwwiro6 *   craig-nicholsoneswlb1.mylabserver.com   Ready               Active              Leader              18.06.0-ce
484tof81jhor294g4by22jpza     craig-nicholsoneswlb2.mylabserver.com   Ready               Active                                  18.06.0-ce
ceddzblkaexlw93kximft8xpn     craig-nicholsoneswlb3.mylabserver.com   Ready               Active                                  18.06.0-ce

$ docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
vlus0tstum40        testweb             replicated          1/1                 httpd:latest        *:80->80/tcp

$ docker service ps testweb
ID                  NAME                IMAGE               NODE                                    DESIRED STATE       CURRENT STATE            ERROR               PORTS
rknebt32yrrp        testweb.1           httpd:latest        craig-nicholsoneswlb1.mylabserver.com   Running             Running 38 seconds ago           
```

Here you can see we can now route by the external machine names instead of the internal docker0 address.
Using mesh routing, docker service extends the network.  Even though the app is running on only one node.

```bash

$ curl craig-nicholsoneswlb1.mylabserver.com
<html><body><h1>It works!</h1></body></html>

$ curl craig-nicholsoneswlb2.mylabserver.com
<html><body><h1>It works!</h1></body></html>

$ curl craig-nicholsoneswlb3.mylabserver.com
<html><body><h1>It works!</h1></body></html>

```

Review:

docker service create
docker service update

### Scale Up and Down with docker service

```bash
docker service update --replicas 3 testweb
testweb
overall progress: 2 out of 3 tasks
overall progress: 3 out of 3 tasks
1/3: running   [==================================================>]
2/3: running   [==================================================>]
3/3: running   [==================================================>]
verify: Service converged


 docker service ps testweb
ID                  NAME                IMAGE               NODE                                    DESIRED STATE       CURRENT STATE            ERROR               PORTS
rknebt32yrrp        testweb.1           httpd:latest        craig-nicholsoneswlb1.mylabserver.com   Running             Running 10 minutes ago                       
4ufcyzedfqdp        testweb.2           httpd:latest        craig-nicholsoneswlb3.mylabserver.com   Running             Running 46 seconds ago                       
v0bftuvcpuwz        testweb.3           httpd:latest        craig-nicholsoneswlb2.mylabserver.com   Running             Running 27 seconds ago    
```

Also, this might take some time, so we can run this in detached mode and watch the cluster build.

```bash
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

Decreast the # of nodes

```bash
docker service update --replicas 3 testweb --detach=false
testweb
overall progress: 3 out of 3 tasks 
1/3: running   [==================================================>] 
2/3: running   [==================================================>] 
3/3: running   [==================================================>] 
verify: Service converged 

$ docker service ps testweb
ID                  NAME                IMAGE               NODE                                    DESIRED STATE       CURRENT STATE            ERROR               PORTS
rknebt32yrrp        testweb.1           httpd:latest        craig-nicholsoneswlb1.mylabserver.com   Running             Running 14 minutes ago                       
4ufcyzedfqdp        testweb.2           httpd:latest        craig-nicholsoneswlb3.mylabserver.com   Running             Running 4 minutes ago                        
v0bftuvcpuwz        testweb.3           httpd:latest        craig-nicholsoneswlb2.mylabserver.com   Running             Running 4 minutes ago 
```

### Limiting CPUs the Contol Group things...

Limits

- CPU
- Memory

Reservations

- soft limit , lower than hard limit

m = MB

```bash
docker service update --limit-cpu=.5 --reserve-cpu=.75 --limit-memory=128m --reserve-memory=256m testweb
testweb
overall progress: 3 out of 3 tasks 
1/3: running   [==================================================>] 
2/3: running   [==================================================>] 
3/3: running   [==================================================>] 
verify: Service converged 

$ docker service ps testweb
ID                  NAME                IMAGE               NODE                                    DESIRED STATE       CURRENT STATE             ERROR               PORTS
rdb2l5kwanvn        testweb.1           httpd:latest        craig-nicholsoneswlb1.mylabserver.com   Running             Running 17 seconds ago                        
rknebt32yrrp         \_ testweb.1       httpd:latest        craig-nicholsoneswlb1.mylabserver.com   Shutdown            Shutdown 18 seconds ago                       
i6jtjt77ch7e        testweb.2           httpd:latest        craig-nicholsoneswlb3.mylabserver.com   Running             Running 21 seconds ago                        
4ufcyzedfqdp         \_ testweb.2       httpd:latest        craig-nicholsoneswlb3.mylabserver.com   Shutdown            Shutdown 22 seconds ago                       
vuxhfc2aa2dp        testweb.3           httpd:latest        craig-nicholsoneswlb2.mylabserver.com   Running             Running 12 seconds ago                        
v0bftuvcpuwz         \_ testweb.3       httpd:latest        craig-nicholsoneswlb2.mylabserver.com   Shutdown            Shutdown 13 seconds ago     

```

Docker Swarm creates new services and shutdowns the old ones, new ones have the new limits and reserves.

```bash
docker service update --replicas 1 testweb --detach=false
```

- Scaling is live
- Changing the management of resources requires a stop and start.

## Increase and Decrease the Number of Replicas in a Service

There are a couple of ways to handle scaling in a running service. We can use one command for scaling replicas in a single service and an equivalent that can do both that AND scale multiple services at the same time.

```bash
docker service ls
docker node ls
docker images

docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
vlus0tstum40        testweb             replicated          1/1                 httpd:latest        *:80->80/tcp

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

Review what we have running

```bash
docker service ps testweb

docker service ps testweb
ID                  NAME                IMAGE               NODE                                    DESIRED STATE       CURRENT STATE            ERROR               PORTS
rdb2l5kwanvn        testweb.1           httpd:latest        craig-nicholsoneswlb1.mylabserver.com   Running             Running 8 minutes ago                        
rknebt32yrrp         \_ testweb.1       httpd:latest        craig-nicholsoneswlb1.mylabserver.com   Shutdown            Shutdown 8 minutes ago                       
4ufcyzedfqdp        testweb.2           httpd:latest        craig-nicholsoneswlb3.mylabserver.com   Shutdown            Shutdown 8 minutes ago                       
v0bftuvcpuwz        testweb.3           httpd:latest        craig-nicholsoneswlb2.mylabserver.com   Shutdown            Shutdown 8 minutes ago 

```



```bash
docker service update --replicas 3 --detach=false testweb


docker service ps testweb

```

Create another service in our swarm using nginx

```bash
docker service create --name testnginx -p 5901:80 nginx
docker service create --name testnginx -p 5901:80 nginx
jby2vhtm8glgzjmaslglebw49
overall progress: 1 out of 1 tasks
1/1: running   [==================================================>]
verify: Service converged

docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
jby2vhtm8glg        testnginx           replicated          1/1                 nginx:latest        *:5901->80/tcp
vlus0tstum40        testweb             replicated          3/3                 httpd:latest        *:80->80/tcp

docker service ps testnginx
ID                  NAME                IMAGE               NODE                                    DESIRED STATE       CURRENT STATE           ERROR               PORTS
ng10yzp6er4q        testnginx.1         nginx:latest        craig-nicholsoneswlb1.mylabserver.com   Running             Running 3 minutes ago  

# verify
curl craig-nicholsoneswlb1.mylabserver.com:5901

```

Check open ports on the server

```bash
sudo netstat -lptu
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name    
tcp        0      0 0.0.0.0:6080            0.0.0.0:*               LISTEN      1249/python         
tcp        0      0 0.0.0.0:nfs             0.0.0.0:*               LISTEN      -                   
tcp        0      0 0.0.0.0:sunrpc          0.0.0.0:*               LISTEN      623/rpcbind         
tcp        0      0 0.0.0.0:39504           0.0.0.0:*               LISTEN      -                   
tcp        0      0 0.0.0.0:mountd          0.0.0.0:*               LISTEN      1118/rpc.mountd     
tcp        0      0 0.0.0.0:ssh             0.0.0.0:*               LISTEN      1172/sshd           
tcp        0      0 localhost:smtp          0.0.0.0:*               LISTEN      1054/master         
tcp        0      0 0.0.0.0:53434           0.0.0.0:*               LISTEN      1108/rpc.statd      
tcp6       0      0 [::]:42910              [::]:*                  LISTEN      -                   
tcp6       0      0 [::]:31297              [::]:*                  LISTEN      938/node            
tcp6       0      0 [::]:nfs                [::]:*                  LISTEN      -                   
tcp6       0      0 [::]:2377               [::]:*                  LISTEN      4044/dockerd        
tcp6       0      0 [::]:7946               [::]:*                  LISTEN      4044/dockerd        
tcp6       0      0 [::]:5901               [::]:*                  LISTEN      4044/dockerd        
tcp6       0      0 [::]:sunrpc             [::]:*                  LISTEN      623/rpcbind         
tcp6       0      0 [::]:http               [::]:*                  LISTEN      4044/dockerd        
tcp6       0      0 [::]:mountd             [::]:*                  LISTEN      1118/rpc.mountd     
tcp6       0      0 [::]:ssh                [::]:*                  LISTEN      1172/sshd           
```

```bash
docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
jby2vhtm8glg        testnginx           replicated          1/1                 nginx:latest        *:5901->80/tcp
vlus0tstum40        testweb             replicated          3/3                 httpd:latest        *:80->80/tcp


```

Let's scale nginx to 3 nodes now... we have to use 'service scale' b/c we have more than one container image running.

When it is complete you can see the REPLICAS changed from 1/1 to 3/3

```bash

docker service scale testniginx=3 --detach=false
testnginx scaled to 3
overall progress: 3 out of 3 tasks
1/3: running   [==================================================>]
2/3: running   [==================================================>]
3/3: running   [==================================================>]
verify: Service converged
$ docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
jby2vhtm8glg        testnginx           replicated          3/3                 nginx:latest        *:5901->80/tcp
vlus0tstum40        testweb             replicated          3/3                 httpd:latest        *:80->80/tcp

```

Can we update both at the same time now? In one command.

```bash

docker service scale --detach=false testnginx=4 testweb=2
docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
jby2vhtm8glg        testnginx           replicated          4/4                 nginx:latest        *:5901->80/tcp
vlus0tstum40        testweb             replicated          2/2                 httpd:latest        *:80->80/tcp
```

- docker service scale and docker service update are the same commands
- The only way to update number of replicas for multiple services is to use docker scale.

## Running Replicated vs. Global Services

You can run your service in either replicated or global mode. The difference is subtle but important; let's talk a bit about that difference and then demonstrate the behavior in our swarm.

Clean Up

```bash
docker service rm jb
jb
$ docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
vlus0tstum40        testweb             replicated          2/2                 httpd:latest        *:80->80/tcp

$ docker service rm vl

docker service create --name testweb -p 80:80 httpd 
lc1p4pc3mkk5rxd4l2vc0aa3q
overall progress: 1 out of 1 tasks 
1/1: running   [==================================================>] 
verify: Service converged 

$ docker service ps testweb
ID                  NAME                IMAGE               NODE                                    DESIRED STATE       CURRENT STATE            ERROR               PORTS
l5fjgjudk0ce        testweb.1           httpd:latest        craig-nicholsoneswlb2.mylabserver.com   Running             Running 15 seconds ago                       
$ docker service scale testweb=3
testweb scaled to 3
overall progress: 3 out of 3 tasks 
1/3: running   [==================================================>] 
2/3: running   [==================================================>] 
3/3: running   [==================================================>] 
verify: Service converged 
$ docker service ps testweb
ID                  NAME                IMAGE               NODE                                    DESIRED STATE       CURRENT STATE            ERROR               PORTS
l5fjgjudk0ce        testweb.1           httpd:latest        craig-nicholsoneswlb2.mylabserver.com   Running             Running 46 seconds ago                       
pzvjg482ytnz        testweb.2           httpd:latest        craig-nicholsoneswlb3.mylabserver.com   Running             Running 12 seconds ago                       
jbklj9qn102g        testweb.3           httpd:latest        craig-nicholsoneswlb1.mylabserver.com   Running             Running 12 seconds ago                       

$ docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
lc1p4pc3mkk5        testweb             replicated          3/3                 httpd:latest        *:80->80/tcp


```

### Global Mode

Run the application across all of the nodes, and we lose the granular control of # of replicas on the nodes.

Check out the MODE it is global

```bash
docker service create --name testnginx -p 5901:8080 --mode global --detach=false nginx
8a73r5sy93bjqsh8aa2el3af2
overall progress: 3 out of 3 tasks 
ceddzblkaexl: running   [==================================================>]
484tof81jhor: running   [==================================================>]
2t4xy1mtev3s: running   [==================================================>]
verify: Service converged
$ docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
8a73r5sy93bj        testnginx           global              3/3                 nginx:latest        *:5901->8080/tcp
lc1p4pc3mkk5        testweb             replicated          3/3                 httpd:latest        *:80->80/tcp
$ docker service ps testnginx
ID                  NAME                                  IMAGE               NODE                                    DESIRED STATE       CURRENT STATE            ERROR               PORTS
0qturwzb59vj        testnginx.ceddzblkaexlw93kximft8xpn   nginx:latest        craig-nicholsoneswlb3.mylabserver.com   Running             Running 18 seconds ago                       
mik1vhog25tw        testnginx.484tof81jhor294g4by22jpza   nginx:latest        craig-nicholsoneswlb2.mylabserver.com   Running             Running 18 seconds ago                       
rpsygnyrd6h5        testnginx.2t4xy1mtev3sks4sy8vwwiro6   nginx:latest        craig-nicholsoneswlb1.mylabserver.com   Running             Running 18 seconds ago             

```

Ok let's try and scale up testnginx

```bash
$ docker service update --replicas=5 testnginx
replicas can only be used with replicated mode

$ docker service scale testnginx=1
testnginx: scale can only be used with replicated mode

```

We can't scale this way.  We have to add more nodes.  And then the nginx global mode
will init another testnginx app when the node joins.

Once in global mode, you can't change back to replicated mode.

Once in replicated mode, you can't change back to global mode.

## Demonstrate the Usage of Templates with 'docker service create'

Templates give us greater flexibility and control over a number of options when we create a service. This lesson will show you how to set various options using templating and then how to display those values after the fact.

Clean up

```bash
$ docker service rm $(docker service ls -q)
8a73r5sy93bj
lc1p4pc3mkk5
$ docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
```

use template items for the hostname

```bash
docker service create --name myweb --hostname="{{.Node.ID}}-{{.Service.Name}}" --detach=false httpd
7fjhp9rxr26v7mhnkn0hwuqwk
overall progress: 1 out of 1 tasks 
1/1: running   [==================================================>] 
verify: Service converged 
$ docker service ps --no-trunc myweb
ID                          NAME                IMAGE                                                                                  NODE                                    DESIRED STATE       CURRENT STATE            ERROR               PORTS
5k1rmw4lkwou60f0au5k4i0a5   myweb.1             httpd:latest@sha256:8c84e065bdf72b4909bd55a348d5e91fe265e08d6b28ed9104bfdcac9206dcc8   craig-nicholsoneswlb3.mylabserver.com   Running             Running 23 seconds ago 
```

 Had issues using the template following on screen directions b/c of double qoutes
 And the Hostname seems to be in a different place in my distribution now...

```bash
$ docker inspect --format="{{.Config.Hostname}}" myweb.1

Error: No such object: myweb.1
$ docker inspect --format="{{.Config.Hostname}}" myweb.1.5k1rmw4lkwou60f0au5k4i0a5

Template parsing error: template: :1:9: executing "" at <.Config.Hostname>: map has no entry for key "Config"
$ 
$ 
$ docker inspect myweb.1.5k1rmw4lkwou60f0au5k4i0a5
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
$ docker service create --name myweb2 --hostname={{.Node.ID}}-{{.Service.Name}} --detach=false httpd
mfi39f09lwvp96qn3vkxolheo
overall progress: 1 out of 1 tasks 
1/1: running   [==================================================>] 
verify: Service converged 
$ docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
7fjhp9rxr26v        myweb               replicated          1/1                 httpd:latest        
mfi39f09lwvp        myweb2              replicated          1/1                 httpd:latest        
$ docker service ps -no-trunc myweb2
unknown shorthand flag: 'n' in -no-trunc
See 'docker service ps --help'.
$ docker service ps --no-trunc myweb2
ID                          NAME                IMAGE                                                                                  NODE                                    DESIRED STATE       CURRENT STATE                ERROR               PORTS
00thpam0mxrcd5x02tigih0rl   myweb2.1            httpd:latest@sha256:8c84e065bdf72b4909bd55a348d5e91fe265e08d6b28ed9104bfdcac9206dcc8   craig-nicholsoneswlb1.mylabserver.com   Running             Running about a minute ago                       
$ docker inspect myweb2.1.00thpam0mxrcd5x02tigih0rl
[
    {
        "Id": "4b7ef86d071cee118a5ee1bba86d5b6fe448a6a8e682286e1dcfd6a1a1351b70",
        "Created": "2018-08-02T18:58:35.233119114Z",
        "Path": "httpd-foreground",
        "Args": [],
        "State": {
            "Status": "running",
            "Running": true,
            "Paused": false,
            "Restarting": false,
            "OOMKilled": false,
            "Dead": false,
            "Pid": 10204,
            "ExitCode": 0,
            "Error": "",
            "StartedAt": "2018-08-02T18:58:35.752512584Z",
            "FinishedAt": "0001-01-01T00:00:00Z"
        },
        "Image": "sha256:11426a19f1a28d6491041aef1e1a7a2dcaa188d0165ae495de7d8fc1bf3e164f",
        "ResolvConfPath": "/var/lib/docker/containers/4b7ef86d071cee118a5ee1bba86d5b6fe448a6a8e682286e1dcfd6a1a1351b70/resolv.conf",
        "HostnamePath": "/var/lib/docker/containers/4b7ef86d071cee118a5ee1bba86d5b6fe448a6a8e682286e1dcfd6a1a1351b70/hostname",
        "HostsPath": "/var/lib/docker/containers/4b7ef86d071cee118a5ee1bba86d5b6fe448a6a8e682286e1dcfd6a1a1351b70/hosts",
        "LogPath": "/var/lib/docker/containers/4b7ef86d071cee118a5ee1bba86d5b6fe448a6a8e682286e1dcfd6a1a1351b70/4b7ef86d071cee118a5ee1bba86d5b6fe448a6a8e682286e1dcfd6a1a1351b70-json.log",
        "Name": "/myweb2.1.00thpam0mxrcd5x02tigih0rl",
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
                "Name": "",
                "MaximumRetryCount": 0
            },
            "AutoRemove": false,
            "VolumeDriver": "",
            "VolumesFrom": null,
            "CapAdd": null,
            "CapDrop": null,
            "Dns": null,
            "DnsOptions": null,
            "DnsSearch": null,
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
            "Isolation": "default",
            "CpuShares": 0,
            "Memory": 0,
            "NanoCpus": 0,
            "CgroupParent": "",
            "BlkioWeight": 0,
            "BlkioWeightDevice": null,
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
            "Devices": null,
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
            ],
            "Init": false
        },
        "GraphDriver": {
            "Data": {
                "DeviceId": "33",
                "DeviceName": "docker-202:1-8455043-521cb9e73a2b2a95ae50a02eb2e6943c6005350751807bb7cef79f40c16aae9e",
                "DeviceSize": "10737418240"
            },
            "Name": "devicemapper"
        },
        "Mounts": [],
        "Config": {
            "Hostname": "2t4xy1mtev3sks4sy8vwwiro6-myweb2",
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
            "Image": "httpd:latest@sha256:8c84e065bdf72b4909bd55a348d5e91fe265e08d6b28ed9104bfdcac9206dcc8",
            "Volumes": null,
            "WorkingDir": "/usr/local/apache2",
            "Entrypoint": null,
            "OnBuild": null,
            "Labels": {
                "com.docker.swarm.node.id": "2t4xy1mtev3sks4sy8vwwiro6",
                "com.docker.swarm.service.id": "mfi39f09lwvp96qn3vkxolheo",
                "com.docker.swarm.service.name": "myweb2",
                "com.docker.swarm.task": "",
                "com.docker.swarm.task.id": "00thpam0mxrcd5x02tigih0rl",
                "com.docker.swarm.task.name": "myweb2.1.00thpam0mxrcd5x02tigih0rl"
            }
        },
        "NetworkSettings": {
            "Bridge": "",
            "SandboxID": "4fddd658418089712062f52bb21add3f4192c89959836ec76a6d4e9bf7d59d1f",
            "HairpinMode": false,
            "LinkLocalIPv6Address": "",
            "LinkLocalIPv6PrefixLen": 0,
            "Ports": {
                "80/tcp": null
            },
            "SandboxKey": "/var/run/docker/netns/4fddd6584180",
            "SecondaryIPAddresses": null,
            "SecondaryIPv6Addresses": null,
            "EndpointID": "7d9b0047f90dfe8f3c5cc2484caf7ae57404a5060456e6c7ff41a1c15ece7410",
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
                    "NetworkID": "d5b2f81d22eee28f7344b4578a9692430f414fad77ae20ada2d5a237e21889f1",
                    "EndpointID": "7d9b0047f90dfe8f3c5cc2484caf7ae57404a5060456e6c7ff41a1c15ece7410",
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
$ docker inspect --format={{.Config.Hostname}} myweb.1.5k1rmw4lkwou60f0au5k4i0a5

Template parsing error: template: :1:9: executing "" at <.Config.Hostname>: map has no entry for key "Config"
$ docker inspect myweb2.1.00thpam0mxrcd5x02tigih0rl
[
    {
        "Id": "4b7ef86d071cee118a5ee1bba86d5b6fe448a6a8e682286e1dcfd6a1a1351b70",
        "Created": "2018-08-02T18:58:35.233119114Z",
        "Path": "httpd-foreground",
        "Args": [],
        "State": {
            "Status": "running",
            "Running": true,
            "Paused": false,
            "Restarting": false,
            "OOMKilled": false,
            "Dead": false,
            "Pid": 10204,
            "ExitCode": 0,
            "Error": "",
            "StartedAt": "2018-08-02T18:58:35.752512584Z",
            "FinishedAt": "0001-01-01T00:00:00Z"
        },
        "Image": "sha256:11426a19f1a28d6491041aef1e1a7a2dcaa188d0165ae495de7d8fc1bf3e164f",
        "ResolvConfPath": "/var/lib/docker/containers/4b7ef86d071cee118a5ee1bba86d5b6fe448a6a8e682286e1dcfd6a1a1351b70/resolv.conf",
        "HostnamePath": "/var/lib/docker/containers/4b7ef86d071cee118a5ee1bba86d5b6fe448a6a8e682286e1dcfd6a1a1351b70/hostname",
        "HostsPath": "/var/lib/docker/containers/4b7ef86d071cee118a5ee1bba86d5b6fe448a6a8e682286e1dcfd6a1a1351b70/hosts",
        "LogPath": "/var/lib/docker/containers/4b7ef86d071cee118a5ee1bba86d5b6fe448a6a8e682286e1dcfd6a1a1351b70/4b7ef86d071cee118a5ee1bba86d5b6fe448a6a8e682286e1dcfd6a1a1351b70-json.log",
        "Name": "/myweb2.1.00thpam0mxrcd5x02tigih0rl",
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
                "Name": "",
                "MaximumRetryCount": 0
            },
            "AutoRemove": false,
            "VolumeDriver": "",
            "VolumesFrom": null,
            "CapAdd": null,
            "CapDrop": null,
            "Dns": null,
            "DnsOptions": null,
            "DnsSearch": null,
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
            "Isolation": "default",
            "CpuShares": 0,
            "Memory": 0,
            "NanoCpus": 0,
            "CgroupParent": "",
            "BlkioWeight": 0,
            "BlkioWeightDevice": null,
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
            "Devices": null,
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
            ],
            "Init": false
        },
        "GraphDriver": {
            "Data": {
                "DeviceId": "33",
                "DeviceName": "docker-202:1-8455043-521cb9e73a2b2a95ae50a02eb2e6943c6005350751807bb7cef79f40c16aae9e",
                "DeviceSize": "10737418240"
            },
            "Name": "devicemapper"
        },
        "Mounts": [],
        "Config": {
            "Hostname": "2t4xy1mtev3sks4sy8vwwiro6-myweb2",
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
            "Image": "httpd:latest@sha256:8c84e065bdf72b4909bd55a348d5e91fe265e08d6b28ed9104bfdcac9206dcc8",
            "Volumes": null,
            "WorkingDir": "/usr/local/apache2",
            "Entrypoint": null,
            "OnBuild": null,
            "Labels": {
                "com.docker.swarm.node.id": "2t4xy1mtev3sks4sy8vwwiro6",
                "com.docker.swarm.service.id": "mfi39f09lwvp96qn3vkxolheo",
                "com.docker.swarm.service.name": "myweb2",
                "com.docker.swarm.task": "",
                "com.docker.swarm.task.id": "00thpam0mxrcd5x02tigih0rl",
                "com.docker.swarm.task.name": "myweb2.1.00thpam0mxrcd5x02tigih0rl"
            }
        },
        "NetworkSettings": {
            "Bridge": "",
            "SandboxID": "4fddd658418089712062f52bb21add3f4192c89959836ec76a6d4e9bf7d59d1f",
            "HairpinMode": false,
            "LinkLocalIPv6Address": "",
            "LinkLocalIPv6PrefixLen": 0,
            "Ports": {
                "80/tcp": null
            },
            "SandboxKey": "/var/run/docker/netns/4fddd6584180",
            "SecondaryIPAddresses": null,
            "SecondaryIPv6Addresses": null,
            "EndpointID": "7d9b0047f90dfe8f3c5cc2484caf7ae57404a5060456e6c7ff41a1c15ece7410",
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
                    "NetworkID": "d5b2f81d22eee28f7344b4578a9692430f414fad77ae20ada2d5a237e21889f1",
                    "EndpointID": "7d9b0047f90dfe8f3c5cc2484caf7ae57404a5060456e6c7ff41a1c15ece7410",
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
$ docker inspect myweb2.1.00thpam0mxrcd5x02tigih0rl
[
    {
        "Id": "4b7ef86d071cee118a5ee1bba86d5b6fe448a6a8e682286e1dcfd6a1a1351b70",
        "Created": "2018-08-02T18:58:35.233119114Z",
        "Path": "httpd-foreground",
        "Args": [],
        "State": {
            "Status": "running",
            "Running": true,
            "Paused": false,
            "Restarting": false,
            "OOMKilled": false,
            "Dead": false,
            "Pid": 10204,
            "ExitCode": 0,
            "Error": "",
            "StartedAt": "2018-08-02T18:58:35.752512584Z",
            "FinishedAt": "0001-01-01T00:00:00Z"
        },
        "Image": "sha256:11426a19f1a28d6491041aef1e1a7a2dcaa188d0165ae495de7d8fc1bf3e164f",
        "ResolvConfPath": "/var/lib/docker/containers/4b7ef86d071cee118a5ee1bba86d5b6fe448a6a8e682286e1dcfd6a1a1351b70/resolv.conf",
        "HostnamePath": "/var/lib/docker/containers/4b7ef86d071cee118a5ee1bba86d5b6fe448a6a8e682286e1dcfd6a1a1351b70/hostname",
        "HostsPath": "/var/lib/docker/containers/4b7ef86d071cee118a5ee1bba86d5b6fe448a6a8e682286e1dcfd6a1a1351b70/hosts",
        "LogPath": "/var/lib/docker/containers/4b7ef86d071cee118a5ee1bba86d5b6fe448a6a8e682286e1dcfd6a1a1351b70/4b7ef86d071cee118a5ee1bba86d5b6fe448a6a8e682286e1dcfd6a1a1351b70-json.log",
        "Name": "/myweb2.1.00thpam0mxrcd5x02tigih0rl",
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
                "Name": "",
                "MaximumRetryCount": 0
            },
            "AutoRemove": false,
            "VolumeDriver": "",
            "VolumesFrom": null,
            "CapAdd": null,
            "CapDrop": null,
            "Dns": null,
            "DnsOptions": null,
            "DnsSearch": null,
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
            "Isolation": "default",
            "CpuShares": 0,
            "Memory": 0,
            "NanoCpus": 0,
            "CgroupParent": "",
            "BlkioWeight": 0,
            "BlkioWeightDevice": null,
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
            "Devices": null,
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
            ],
            "Init": false
        },
        "GraphDriver": {
            "Data": {
                "DeviceId": "33",
                "DeviceName": "docker-202:1-8455043-521cb9e73a2b2a95ae50a02eb2e6943c6005350751807bb7cef79f40c16aae9e",
                "DeviceSize": "10737418240"
            },
            "Name": "devicemapper"
        },
        "Mounts": [],
        "Config": {
            "Hostname": "2t4xy1mtev3sks4sy8vwwiro6-myweb2",
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
            "Image": "httpd:latest@sha256:8c84e065bdf72b4909bd55a348d5e91fe265e08d6b28ed9104bfdcac9206dcc8",
            "Volumes": null,
            "WorkingDir": "/usr/local/apache2",
            "Entrypoint": null,
            "OnBuild": null,
            "Labels": {
                "com.docker.swarm.node.id": "2t4xy1mtev3sks4sy8vwwiro6",
                "com.docker.swarm.service.id": "mfi39f09lwvp96qn3vkxolheo",
                "com.docker.swarm.service.name": "myweb2",
                "com.docker.swarm.task": "",
                "com.docker.swarm.task.id": "00thpam0mxrcd5x02tigih0rl",
                "com.docker.swarm.task.name": "myweb2.1.00thpam0mxrcd5x02tigih0rl"
            }
        },
        "NetworkSettings": {
            "Bridge": "",
            "SandboxID": "4fddd658418089712062f52bb21add3f4192c89959836ec76a6d4e9bf7d59d1f",
            "HairpinMode": false,
            "LinkLocalIPv6Address": "",
            "LinkLocalIPv6PrefixLen": 0,
            "Ports": {
                "80/tcp": null
            },
            "SandboxKey": "/var/run/docker/netns/4fddd6584180",
            "SecondaryIPAddresses": null,
            "SecondaryIPv6Addresses": null,
            "EndpointID": "7d9b0047f90dfe8f3c5cc2484caf7ae57404a5060456e6c7ff41a1c15ece7410",
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
                    "NetworkID": "d5b2f81d22eee28f7344b4578a9692430f414fad77ae20ada2d5a237e21889f1",
                    "EndpointID": "7d9b0047f90dfe8f3c5cc2484caf7ae57404a5060456e6c7ff41a1c15ece7410",
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
$ docker inspect myweb2.1.00thpam0mxrcd5x02tigih0rl | grep Hostname
        "HostnamePath": "/var/lib/docker/containers/4b7ef86d071cee118a5ee1bba86d5b6fe448a6a8e682286e1dcfd6a1a1351b70/hostname",
            "Hostname": "2t4xy1mtev3sks4sy8vwwiro6-myweb2",
$ docker inspect myweb.1.5k1rmw4lkwou60f0au5k4i0a5 | grep Hostname
                "Hostname": "{{.Node.ID}}-{{.Service.Name}}",

```

This will help yo uidentify your nodes in a large cluster.

```bash
$ docker inspect --format="{{.Config.Hostname}}"  myweb2.1.00thpam0mxrcd5x02tigih0rl
2t4xy1mtev3sks4sy8vwwiro6-myweb2


$ docker inspect --format="{{.Config.Hostname}}"  myweb.1.5k1rmw4lkwou60f0au5k4i0a5
Template parsing error: template: :1:9: executing "" at <.Config.Hostname>: map has no entry for key "Config"

```

## Apply Node Labels for Task Placement

Node labels are a really cool way for you to control how (and where) your Docker services run in your swarm. 

Send your services to nodes with specific labels.

This lesson will show you how to use a label to apply service constraints to indicate where the replicas for your service should run.


```bash
[user@craig-nicholsoneswlb1 ~]$ docker node ls
ID                            HOSTNAME                                STATUS              AVAILABILITY        MANAGER STATUS      ENGINE VERSION
2t4xy1mtev3sks4sy8vwwiro6 *   craig-nicholsoneswlb1.mylabserver.com   Ready               Active              Leader              18.06.0-ce
484tof81jhor294g4by22jpza     craig-nicholsoneswlb2.mylabserver.com   Ready               Active                                  18.06.0-ce
ceddzblkaexlw93kximft8xpn     craig-nicholsoneswlb3.mylabserver.com   Ready               Active                                  18.06.0-ce
[user@craig-nicholsoneswlb1 ~]$ docker node inspect
"docker node inspect" requires at least 1 argument.
See 'docker node inspect --help'.

Usage:  docker node inspect [OPTIONS] self|NODE [NODE...]

Display detailed information on one or more nodes
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


```bash
[user@craig-nicholsoneswlb1 ~]$ docker node inspect --pretty 2t4xy1mtev3sks4sy8vwwiro6
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

Add this:

Labels:
 - mynode=testnode

```bash

[user@craig-nicholsoneswlb1 ~]$ docker node update --label-add mynode=testnode ceddzblkaexlw93kximft8xpn
ceddzblkaexlw93kximft8xpn
[user@craig-nicholsoneswlb1 ~]$ docker node ls
ID                            HOSTNAME                                STATUS              AVAILABILITY        MANAGER STATUS      ENGINE VERSION
2t4xy1mtev3sks4sy8vwwiro6 *   craig-nicholsoneswlb1.mylabserver.com   Ready               Active              Leader              18.06.0-ce
484tof81jhor294g4by22jpza     craig-nicholsoneswlb2.mylabserver.com   Ready               Active                                  18.06.0-ce
ceddzblkaexlw93kximft8xpn     craig-nicholsoneswlb3.mylabserver.com   Ready               Active                                  18.06.0-ce
[user@craig-nicholsoneswlb1 ~]$ docker node inspect --pretty ceddzblkaexlw93kximft8xpn
ID:			ceddzblkaexlw93kximft8xpn
Labels:
 - mynode=testnode
Hostname:              	craig-nicholsoneswlb3.mylabserver.com
Joined at:             	2018-08-02 15:42:11.056214928 +0000 utc
Status:
 State:			Ready
 Availability:         	Active
 Address:		172.31.34.40
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

Using constraints to put services on nodes... and how and where a service runs.
Some services will require nodes with more CPU or memory for example.

constraints

- node.labels
- node.id
- node.hostname
- node.role
- node.enginel.lables???

```bash
 docker service create --name constraints -p 80:80 --constraint 'node.labels.mynode == testnode' --replicas 3 httpd
osrspu23wxj6kwkict695yceb
overall progress: 3 out of 3 tasks 
1/3: running   [==================================================>] 
2/3: running   [==================================================>] 
3/3: running   [==================================================>] 
verify: Service converged 

```


```bash
[user@craig-nicholsoneswlb1 ~]$ docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
osrspu23wxj6        constraints         replicated          3/3                 httpd:latest        *:80->80/tcp
[user@craig-nicholsoneswlb1 ~]$ docker service ps constraints
ID                  NAME                IMAGE               NODE                                    DESIRED STATE       CURRENT STATE                ERROR               PORTS
xbsurnp26qec        constraints.1       httpd:latest        craig-nicholsoneswlb3.mylabserver.com   Running             Running about a minute ago                       
0w43o6s82djf        constraints.2       httpd:latest        craig-nicholsoneswlb3.mylabserver.com   Running             Running about a minute ago                       
uz3gftyndln0        constraints.3       httpd:latest        craig-nicholsoneswlb3.mylabserver.com   Running             Running about a minute ago                       
[user@craig-nicholsoneswlb1 ~]$
```

Let's try a service with no constraints

```bash

docker service create --name normal nginx

```

```bash

docker service update --replicas 3 normal
normal
overall progress: 3 out of 3 tasks 
1/3: running   [==================================================>] 
2/3: running   [==================================================>] 
3/3: running   [==================================================>] 
verify: Service converged 
[user@craig-nicholsoneswlb1 ~]$ docker service ps normal
ID                  NAME                IMAGE               NODE                                    DESIRED STATE       CURRENT STATE            ERROR               PORTS
6wxxihspz1b0        normal.1            nginx:latest        craig-nicholsoneswlb1.mylabserver.com   Running             Running 57 seconds ago                       
r6z1em6ddfme        normal.2            nginx:latest        craig-nicholsoneswlb2.mylabserver.com   Running             Running 26 seconds ago                       
7wgjnpn9tel9        normal.3            nginx:latest        craig-nicholsoneswlb3.mylabserver.com   Running             Running 27 seconds ago                       
[user@craig-nicholsoneswlb1 ~]$ docker service ps constraints
ID                  NAME                IMAGE               NODE                                    DESIRED STATE       CURRENT STATE           ERROR               PORTS
xbsurnp26qec        constraints.1       httpd:latest        craig-nicholsoneswlb3.mylabserver.com   Running             Running 3 minutes ago                       
0w43o6s82djf        constraints.2       httpd:latest        craig-nicholsoneswlb3.mylabserver.com   Running             Running 3 minutes ago                       
uz3gftyndln0        constraints.3       httpd:latest        craig-nicholsoneswlb3.mylabserver.com   Running             Running 3 minutes ago         
```

By issues a label to some value, I can determine where that service runs.

## Convert an Application Deployment into a Stack File Using a YAML Compose File with 'docker stack deploy'

- Docker Compose
- Use stack file, with docker compose

Run check for the packages

```bash

[user@craig-nicholsoneswlb1 ~]$ yum info epel-release
Loaded plugins: fastestmirror
Determining fastest mirrors
 * base: centos.servint.com
 * epel: mirror.cogentco.com
 * extras: mirrors.centos.webair.com
 * nux-dextop: mirror.li.nux.ro
 * updates: mirror.es.its.nyu.edu
epel                                                                                                                                                                                                                          12639/12639
Installed Packages
Name        : epel-release
Arch        : noarch
Version     : 7
Release     : 11
Size        : 24 k
Repo        : installed
From repo   : extras
Summary     : Extra Packages for Enterprise Linux repository configuration
URL         : http://download.fedoraproject.org/pub/epel
License     : GPLv2
Description : This package contains the Extra Packages for Enterprise Linux (EPEL) repository
            : GPG key as well as configuration for yum.

[user@craig-nicholsoneswlb1 ~]$ sudo yum install epel-release
[sudo] password for user: 
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
 * base: centos.servint.com
 * epel: mirror.cogentco.com
 * extras: mirrors.centos.webair.com
 * nux-dextop: mirror.li.nux.ro
 * updates: mirror.trouble-free.net
Package epel-release-7-11.noarch already installed and latest version
Nothing to do

```

install python

```bash
 sudo yum install python-pip
[user@craig-nicholsoneswlb1 ~]$ sudo pip intall --upgrade pip
ERROR: unknown command "intall" - maybe you meant "install"
[user@craig-nicholsoneswlb1 ~]$ sudo pip install --upgrade pip
Collecting pip
  Downloading https://files.pythonhosted.org/packages/5f/25/e52d3f31441505a5f3af41213346e5b6c221c9e086a166f3703d2ddaf940/pip-18.0-py2.py3-none-any.whl (1.3MB)
    100% |████████████████████████████████| 1.3MB 886kB/s 
Installing collected packages: pip
  Found existing installation: pip 8.1.2
    Uninstalling pip-8.1.2:
      Successfully uninstalled pip-8.1.2
Successfully installed pip-18.0
[user@craig-nicholsoneswlb1 ~]$ sudo pip install docker-compose
Collecting docker-compose
  Downloading https://files.pythonhosted.org/packages/67/03/b833b571595e05c933d3af3685be3b27b1166c415d005b3eadaa5be80d25/docker_compose-1.22.0-py2.py3-none-any.whl (126kB)
    100% |████████████████████████████████| 133kB 18.9MB/s 
Requirement already satisfied: PyYAML<4,>=3.10 in /usr/lib64/python2.7/site-packages (from docker-compose) (3.10)
Requirement already satisfied: backports.ssl-match-hostname>=3.5; python_version < "3.5" in /usr/lib/python2.7/site-packages (from docker-compose) (3.5.0.1)
Requirement already satisfied: six<2,>=1.3.0 in /usr/lib/python2.7/site-packages (from docker-compose) (1.9.0)
Collecting docker<4.0,>=3.4.1 (from docker-compose)
  Downloading https://files.pythonhosted.org/packages/a5/64/8c0a5d22e70257e6b7ef7f14b577f99f0b9b1560c604f87856d0db80d151/docker-3.4.1-py2.py3-none-any.whl (124kB)
    100% |████████████████████████████████| 133kB 15.1MB/s 
Collecting texttable<0.10,>=0.9.0 (from docker-compose)
  Downloading https://files.pythonhosted.org/packages/02/e1/2565e6b842de7945af0555167d33acfc8a615584ef7abd30d1eae00a4d80/texttable-0.9.1.tar.gz
Collecting dockerpty<0.5,>=0.4.1 (from docker-compose)
  Downloading https://files.pythonhosted.org/packages/8d/ee/e9ecce4c32204a6738e0a5d5883d3413794d7498fe8b06f44becc028d3ba/dockerpty-0.4.1.tar.gz
Requirement already satisfied: ipaddress>=1.0.16; python_version < "3.3" in /usr/lib/python2.7/site-packages (from docker-compose) (1.0.16)
Collecting requests!=2.11.0,!=2.12.2,!=2.18.0,<2.19,>=2.6.1 (from docker-compose)
  Downloading https://files.pythonhosted.org/packages/49/df/50aa1999ab9bde74656c2919d9c0c085fd2b3775fd3eca826012bef76d8c/requests-2.18.4-py2.py3-none-any.whl (88kB)
    100% |████████████████████████████████| 92kB 26.7MB/s 
Collecting websocket-client<1.0,>=0.32.0 (from docker-compose)
  Downloading https://files.pythonhosted.org/packages/8a/a1/72ef9aa26cfe1a75cee09fc1957e4723add9de098c15719416a1ee89386b/websocket_client-0.48.0-py2.py3-none-any.whl (198kB)
    100% |████████████████████████████████| 204kB 26.7MB/s 
Collecting enum34<2,>=1.0.4; python_version < "3.4" (from docker-compose)
  Downloading https://files.pythonhosted.org/packages/c5/db/e56e6b4bbac7c4a06de1c50de6fe1ef3810018ae11732a50f15f62c7d050/enum34-1.1.6-py2-none-any.whl
Collecting docopt<0.7,>=0.6.1 (from docker-compose)
  Downloading https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz
Collecting jsonschema<3,>=2.5.1 (from docker-compose)
  Downloading https://files.pythonhosted.org/packages/77/de/47e35a97b2b05c2fadbec67d44cfcdcd09b8086951b331d82de90d2912da/jsonschema-2.6.0-py2.py3-none-any.whl
Collecting cached-property<2,>=1.2.0 (from docker-compose)
  Downloading https://files.pythonhosted.org/packages/88/09/4b7a484f96cbceda746e03f0167021c909c3ceae1c6f2e844d79476cb70e/cached_property-1.4.3-py2.py3-none-any.whl
Collecting docker-pycreds>=0.3.0 (from docker<4.0,>=3.4.1->docker-compose)
  Downloading https://files.pythonhosted.org/packages/ea/bf/7e70aeebc40407fbdb96fa9f79fc8e4722ea889a99378303e3bcc73f4ab5/docker_pycreds-0.3.0-py2.py3-none-any.whl
Collecting urllib3<1.23,>=1.21.1 (from requests!=2.11.0,!=2.12.2,!=2.18.0,<2.19,>=2.6.1->docker-compose)
  Downloading https://files.pythonhosted.org/packages/63/cb/6965947c13a94236f6d4b8223e21beb4d576dc72e8130bd7880f600839b8/urllib3-1.22-py2.py3-none-any.whl (132kB)
    100% |████████████████████████████████| 133kB 24.8MB/s 
Collecting idna<2.7,>=2.5 (from requests!=2.11.0,!=2.12.2,!=2.18.0,<2.19,>=2.6.1->docker-compose)
  Downloading https://files.pythonhosted.org/packages/27/cc/6dd9a3869f15c2edfab863b992838277279ce92663d334df9ecf5106f5c6/idna-2.6-py2.py3-none-any.whl (56kB)
    100% |████████████████████████████████| 61kB 25.5MB/s 
Collecting chardet<3.1.0,>=3.0.2 (from requests!=2.11.0,!=2.12.2,!=2.18.0,<2.19,>=2.6.1->docker-compose)
  Downloading https://files.pythonhosted.org/packages/bc/a9/01ffebfb562e4274b6487b4bb1ddec7ca55ec7510b22e4c51f14098443b8/chardet-3.0.4-py2.py3-none-any.whl (133kB)
    100% |████████████████████████████████| 143kB 29.8MB/s 
Collecting certifi>=2017.4.17 (from requests!=2.11.0,!=2.12.2,!=2.18.0,<2.19,>=2.6.1->docker-compose)
  Downloading https://files.pythonhosted.org/packages/7c/e6/92ad559b7192d846975fc916b65f667c7b8c3a32bea7372340bfe9a15fa5/certifi-2018.4.16-py2.py3-none-any.whl (150kB)
    100% |████████████████████████████████| 153kB 28.8MB/s 
Collecting functools32; python_version == "2.7" (from jsonschema<3,>=2.5.1->docker-compose)
  Downloading https://files.pythonhosted.org/packages/c5/60/6ac26ad05857c601308d8fb9e87fa36d0ebf889423f47c3502ef034365db/functools32-3.2.3-2.tar.gz
Installing collected packages: websocket-client, docker-pycreds, urllib3, idna, chardet, certifi, requests, docker, texttable, dockerpty, enum34, docopt, functools32, jsonschema, cached-property, docker-compose
  Found existing installation: urllib3 1.10.2
    Uninstalling urllib3-1.10.2:
      Successfully uninstalled urllib3-1.10.2
  Found existing installation: chardet 2.2.1
    Uninstalling chardet-2.2.1:
      Successfully uninstalled chardet-2.2.1
  Found existing installation: requests 2.6.0
Cannot uninstall 'requests'. It is a distutils installed project and thus we cannot accurately determine which files belong to it which would lead to only a partial uninstall.
[user@craig-nicholsoneswlb1 ~]$ 
 ```

 Create a Dockerfile for simple httpd web service and test with docker build

 ```bash
[user@craig-nicholsoneswlb1 ~]$ mkdir Dockerfile
[user@craig-nicholsoneswlb1 ~]$ cd Dockerfile/
$ vi Dockerfile
$ cat Dockerfile 
#simple webserver
FROM centos:latest
LABEL maintainer="maint@gmail.com"

RUN yum install -y httpd
RUN echo "Our container Website" >> /var/www/html/index.html

EXPOSE 80

ENTRYPOINT apachectl -DFOREGROUND
$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
httpd               latest              11426a19f1a2        2 days ago          178MB
nginx               latest              c82521676580        9 days ago          109MB
$ docker build -t myhttpd:v1 .
Sending build context to Docker daemon  2.048kB
Step 1/6 : FROM centos:latest
latest: Pulling from library/centos
7dc0dca2b151: Pull complete 
Digest: sha256:b67d21dfe609ddacf404589e04631d90a342921e81c40aeaf3391f6717fa5322
Status: Downloaded newer image for centos:latest
 ---> 49f7960eb7e4
Step 2/6 : LABEL maintainer="maint@gmail.com"
 ---> Running in b8db637c2ad7
Removing intermediate container b8db637c2ad7
 ---> da2618f53dd4
Step 3/6 : RUN yum install -y httpd
 ---> Running in 90aeaa99a161
Loaded plugins: fastestmirror, ovl
Determining fastest mirrors
 * base: mirror.ash.fastserv.com
 * extras: mirror.cs.pitt.edu
 * updates: mirror.cs.pitt.edu
Resolving Dependencies
--> Running transaction check
---> Package httpd.x86_64 0:2.4.6-80.el7.centos.1 will be installed
--> Processing Dependency: httpd-tools = 2.4.6-80.el7.centos.1 for package: httpd-2.4.6-80.el7.centos.1.x86_64
--> Processing Dependency: system-logos >= 7.92.1-1 for package: httpd-2.4.6-80.el7.centos.1.x86_64
--> Processing Dependency: /etc/mime.types for package: httpd-2.4.6-80.el7.centos.1.x86_64
--> Processing Dependency: libaprutil-1.so.0()(64bit) for package: httpd-2.4.6-80.el7.centos.1.x86_64
--> Processing Dependency: libapr-1.so.0()(64bit) for package: httpd-2.4.6-80.el7.centos.1.x86_64
--> Running transaction check
---> Package apr.x86_64 0:1.4.8-3.el7_4.1 will be installed
---> Package apr-util.x86_64 0:1.5.2-6.el7 will be installed
---> Package centos-logos.noarch 0:70.0.6-3.el7.centos will be installed
---> Package httpd-tools.x86_64 0:2.4.6-80.el7.centos.1 will be installed
---> Package mailcap.noarch 0:2.1.41-2.el7 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

================================================================================
 Package           Arch        Version                       Repository    Size
================================================================================
Installing:
 httpd             x86_64      2.4.6-80.el7.centos.1         updates      2.7 M
Installing for dependencies:
 apr               x86_64      1.4.8-3.el7_4.1               base         103 k
 apr-util          x86_64      1.5.2-6.el7                   base          92 k
 centos-logos      noarch      70.0.6-3.el7.centos           base          21 M
 httpd-tools       x86_64      2.4.6-80.el7.centos.1         updates       90 k
 mailcap           noarch      2.1.41-2.el7                  base          31 k

Transaction Summary
================================================================================
Install  1 Package (+5 Dependent packages)

Total download size: 24 M
Installed size: 31 M
Downloading packages:
warning: /var/cache/yum/x86_64/7/base/packages/apr-util-1.5.2-6.el7.x86_64.rpm: Header V3 RSA/SHA256 Signature, key ID f4a80eb5: NOKEY
Public key for apr-util-1.5.2-6.el7.x86_64.rpm is not installed
Public key for httpd-tools-2.4.6-80.el7.centos.1.x86_64.rpm is not installed
--------------------------------------------------------------------------------
Total                                               10 MB/s |  24 MB  00:02     
Retrieving key from file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
Importing GPG key 0xF4A80EB5:
 Userid     : "CentOS-7 Key (CentOS 7 Official Signing Key) <security@centos.org>"
 Fingerprint: 6341 ab27 53d7 8a78 a7c2 7bb1 24c6 a8a7 f4a8 0eb5
 Package    : centos-release-7-5.1804.el7.centos.2.x86_64 (@Updates)
 From       : /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Installing : apr-1.4.8-3.el7_4.1.x86_64                                   1/6 
  Installing : apr-util-1.5.2-6.el7.x86_64                                  2/6 
  Installing : httpd-tools-2.4.6-80.el7.centos.1.x86_64                     3/6 
  Installing : centos-logos-70.0.6-3.el7.centos.noarch                      4/6 
  Installing : mailcap-2.1.41-2.el7.noarch                                  5/6 
  Installing : httpd-2.4.6-80.el7.centos.1.x86_64                           6/6 
  Verifying  : mailcap-2.1.41-2.el7.noarch                                  1/6 
  Verifying  : httpd-tools-2.4.6-80.el7.centos.1.x86_64                     2/6 
  Verifying  : apr-util-1.5.2-6.el7.x86_64                                  3/6 
  Verifying  : httpd-2.4.6-80.el7.centos.1.x86_64                           4/6 
  Verifying  : apr-1.4.8-3.el7_4.1.x86_64                                   5/6 
  Verifying  : centos-logos-70.0.6-3.el7.centos.noarch                      6/6 

Installed:
  httpd.x86_64 0:2.4.6-80.el7.centos.1                                          

Dependency Installed:
  apr.x86_64 0:1.4.8-3.el7_4.1                                                  
  apr-util.x86_64 0:1.5.2-6.el7                                                 
  centos-logos.noarch 0:70.0.6-3.el7.centos                                     
  httpd-tools.x86_64 0:2.4.6-80.el7.centos.1                                    
  mailcap.noarch 0:2.1.41-2.el7                                                 

Complete!
Removing intermediate container 90aeaa99a161
 ---> f2de7af8d2be
Step 4/6 : RUN echo "Our container Website" >> /var/www/html/index.html
 ---> Running in 34999dad612b
Removing intermediate container 34999dad612b
 ---> 1634597e2209
Step 5/6 : EXPOSE 80
 ---> Running in 84c051ea35a7
Removing intermediate container 84c051ea35a7
 ---> d8f083d6fe24
Step 6/6 : ENTRYPOINT apachectl -DFOREGROUND
 ---> Running in 71212283f72f
Removing intermediate container 71212283f72f
 ---> 027c516b17c2
Successfully built 027c516b17c2
Successfully tagged myhttpd:v1
$ 


 ```

Do a test run with the myhttpd container and then clean up..

 ```bash
docker run -d --name testweb -p 80:80 myhttpd:v1
b117c962cee122336672893fcbab6e0976255449534765d8edcc5eb0530f54ce
docker: Error response from daemon: driver failed programming external connectivity on endpoint testweb (9f1c40b7f6167fce3332ea186b3f78c48a4f830f55a148c51f4eab7e91ab9a2b): Error starting userland proxy: listen tcp 0.0.0.0:80: bind: address already in use.
$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
696d67f3ac4e        nginx:latest        "nginx -g 'daemon of…"   18 minutes ago      Up 18 minutes       80/tcp              normal.1.6wxxihspz1b08uknieo3z8b46
$ docker stop 696
696
$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
$ docker ps -1
unknown shorthand flag: '1' in -1
See 'docker ps --help'.
$ docker ps -a
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                      PORTS               NAMES
3bd92bde40c1        nginx:latest        "nginx -g 'daemon of…"   10 seconds ago      Up 4 seconds                80/tcp              normal.1.u0e0mj9np2h1m8j0y96sgtau2
b117c962cee1        myhttpd:v1          "/bin/sh -c 'apachec…"   32 seconds ago      Created                                         testweb
696d67f3ac4e        nginx:latest        "nginx -g 'daemon of…"   18 minutes ago      Exited (0) 10 seconds ago                       normal.1.6wxxihspz1b08uknieo3z8b46
$ docker remove 3b

Usage:	docker [OPTIONS] COMMAND

A self-sufficient runtime for containers

Options:
      --config string      Location of client config files (default "/home/user/.docker")
  -D, --debug              Enable debug mode
  -H, --host list          Daemon socket(s) to connect to
  -l, --log-level string   Set the logging level ("debug"|"info"|"warn"|"error"|"fatal") (default "info")
      --tls                Use TLS; implied by --tlsverify
      --tlscacert string   Trust certs signed only by this CA (default "/home/user/.docker/ca.pem")
      --tlscert string     Path to TLS certificate file (default "/home/user/.docker/cert.pem")
      --tlskey string      Path to TLS key file (default "/home/user/.docker/key.pem")
      --tlsverify          Use TLS and verify the remote
  -v, --version            Print version information and quit

Management Commands:
  config      Manage Docker configs
  container   Manage containers
  image       Manage images
  network     Manage networks
  node        Manage Swarm nodes
  plugin      Manage plugins
  secret      Manage Docker secrets
  service     Manage services
  stack       Manage Docker stacks
  swarm       Manage Swarm
  system      Manage Docker
  trust       Manage trust on Docker images
  volume      Manage volumes

Commands:
  attach      Attach local standard input, output, and error streams to a running container
  build       Build an image from a Dockerfile
  commit      Create a new image from a container's changes
  cp          Copy files/folders between a container and the local filesystem
  create      Create a new container
  diff        Inspect changes to files or directories on a container's filesystem
  events      Get real time events from the server
  exec        Run a command in a running container
  export      Export a container's filesystem as a tar archive
  history     Show the history of an image
  images      List images
  import      Import the contents from a tarball to create a filesystem image
  info        Display system-wide information
  inspect     Return low-level information on Docker objects
  kill        Kill one or more running containers
  load        Load an image from a tar archive or STDIN
  login       Log in to a Docker registry
  logout      Log out from a Docker registry
  logs        Fetch the logs of a container
  pause       Pause all processes within one or more containers
  port        List port mappings or a specific mapping for the container
  ps          List containers
  pull        Pull an image or a repository from a registry
  push        Push an image or a repository to a registry
  rename      Rename a container
  restart     Restart one or more containers
  rm          Remove one or more containers
  rmi         Remove one or more images
  run         Run a command in a new container
  save        Save one or more images to a tar archive (streamed to STDOUT by default)
  search      Search the Docker Hub for images
  start       Start one or more stopped containers
  stats       Display a live stream of container(s) resource usage statistics
  stop        Stop one or more running containers
  tag         Create a tag TARGET_IMAGE that refers to SOURCE_IMAGE
  top         Display the running processes of a container
  unpause     Unpause all processes within one or more containers
  update      Update configuration of one or more containers
  version     Show the Docker version information
  wait        Block until one or more containers stop, then print their exit codes

Run 'docker COMMAND --help' for more information on a command.
$ docker rm 3b
Error response from daemon: You cannot remove a running container 3bd92bde40c1f586baf01a70e63497bcac268efa0b9c4239d28ae9eea825486f. Stop the container before attempting removal or force remove
$ docker stop 3b
3b
$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
$ docker ps -a
CONTAINER ID        IMAGE               COMMAND                  CREATED              STATUS                      PORTS               NAMES
47ca9a0ba363        nginx:latest        "nginx -g 'daemon of…"   9 seconds ago        Up 3 seconds                80/tcp              normal.1.jz44ed8cubxmi2ztqga32nn4n
3bd92bde40c1        nginx:latest        "nginx -g 'daemon of…"   45 seconds ago       Exited (0) 8 seconds ago                        normal.1.u0e0mj9np2h1m8j0y96sgtau2
b117c962cee1        myhttpd:v1          "/bin/sh -c 'apachec…"   About a minute ago   Created                                         testweb
696d67f3ac4e        nginx:latest        "nginx -g 'daemon of…"   19 minutes ago       Exited (0) 45 seconds ago                       normal.1.6wxxihspz1b08uknieo3z8b46
$ docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
osrspu23wxj6        constraints         replicated          3/3                 httpd:latest        *:80->80/tcp
jx6wba7rmdil        normal              replicated          3/3                 nginx:latest        
$ docker service rm osrspu23wxj6
osrspu23wxj6
$ docker service rm jx6wba7rmdil
jx6wba7rmdil
$ docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
$ docker ps 
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
$ docker ps -a
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
b117c962cee1        myhttpd:v1          "/bin/sh -c 'apachec…"   2 minutes ago       Created                                 testweb
$ docker rm b11
b11
$ docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
$ docker run -d --name testweb -p 80:80 myhttpd:v1
ec393a3fd1f3740c03cef1f998baf0844b0b9d942995856d82fc6d3fae53fa04
$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                NAMES
ec393a3fd1f3        myhttpd:v1          "/bin/sh -c 'apachec…"   15 seconds ago      Up 14 seconds       0.0.0.0:80->80/tcp   testweb
$ curl localhost
Our container Website
$ docker stop testweb
testweb
$ docker rm testweb
testweb
$ docker rmi myhttpd
Error: No such image: myhttpd
$ docker rmi myhttpd:v1
Untagged: myhttpd:v1
Deleted: sha256:027c516b17c22f7094c4be6c27b34c530df0cf658c11d5863600eaa75a7ba814
Deleted: sha256:d8f083d6fe244f4aff90ccbbf6094924aeade002c66dc4c88b8b29aaa20faa5d
Deleted: sha256:1634597e22090f82be63be210466718395554c7ea0f6872d14531b38c19e5741
Deleted: sha256:b6333bfb556329705fed787dd0b394693c9af1593983e55e1af96a81b7577451
Deleted: sha256:f2de7af8d2be7af1530460b64779ea1b8591b551f43039eed558f7435e660658
Deleted: sha256:d293daba080071353ab22eca60bf85738de494fd6044b6cd9479bc86d343c2cd
Deleted: sha256:da2618f53dd490863504a58d4995474a9f7d83c2e5b76c4d2ae901076d9713c4

 ```

Prep for using a Docker Compose File

Goals

- Create apiweb1 - use dockerfile
- Create apiweb2 - use image to launch another instance
- Create loadbalancer - use nginx and use all ports and start everthing up with simple docker command

FYI - INSTALL ABOVE IS NO GOOD FOR ME

https://docs.docker.com/compose/install/#install-compose

```bash
$ sudo curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   617    0   617    0     0   2889      0 --:--:-- --:--:-- --:--:--  2910
100 11.2M  100 11.2M    0     0  22.3M      0 --:--:-- --:--:-- --:--:-- 22.3M
$ sudo chmod +x /usr/local/bin/docker-compose
$ docker-compose --version
docker-compose version 1.22.0, build f46880fe
```


 ```bash
vi Dockercompse.yml
 ```

Da' yaml

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

Run Compose

 ```bash

$ sudo curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   617    0   617    0     0   2889      0 --:--:-- --:--:-- --:--:--  2910
100 11.2M  100 11.2M    0     0  22.3M      0 --:--:-- --:--:-- --:--:-- 22.3M

$ sudo chmod +x /usr/local/bin/docker-compose
$ docker-compose --version
docker-compose version 1.22.0, build f46880fe

$ vi docker-compose.yml

$ docker-compose up -d
WARNING: The Docker Engine you're using is running in swarm mode.
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
Determining fastest mirrors
 * base: centos2.zswap.net
 * extras: mirror.atlanticmetro.net
 * updates: centos.servint.com
Resolving Dependencies
--> Running transaction check
---> Package httpd.x86_64 0:2.4.6-80.el7.centos.1 will be installed
--> Processing Dependency: httpd-tools = 2.4.6-80.el7.centos.1 for package: httpd-2.4.6-80.el7.centos.1.x86_64
--> Processing Dependency: system-logos >= 7.92.1-1 for package: httpd-2.4.6-80.el7.centos.1.x86_64
--> Processing Dependency: /etc/mime.types for package: httpd-2.4.6-80.el7.centos.1.x86_64
--> Processing Dependency: libaprutil-1.so.0()(64bit) for package: httpd-2.4.6-80.el7.centos.1.x86_64
--> Processing Dependency: libapr-1.so.0()(64bit) for package: httpd-2.4.6-80.el7.centos.1.x86_64
--> Running transaction check
---> Package apr.x86_64 0:1.4.8-3.el7_4.1 will be installed
---> Package apr-util.x86_64 0:1.5.2-6.el7 will be installed
---> Package centos-logos.noarch 0:70.0.6-3.el7.centos will be installed
---> Package httpd-tools.x86_64 0:2.4.6-80.el7.centos.1 will be installed
---> Package mailcap.noarch 0:2.1.41-2.el7 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

================================================================================
 Package           Arch        Version                       Repository    Size
================================================================================
Installing:
 httpd             x86_64      2.4.6-80.el7.centos.1         updates      2.7 M
Installing for dependencies:
 apr               x86_64      1.4.8-3.el7_4.1               base         103 k
 apr-util          x86_64      1.5.2-6.el7                   base          92 k
 centos-logos      noarch      70.0.6-3.el7.centos           base          21 M
 httpd-tools       x86_64      2.4.6-80.el7.centos.1         updates       90 k
 mailcap           noarch      2.1.41-2.el7                  base          31 k

Transaction Summary
================================================================================
Install  1 Package (+5 Dependent packages)

Total download size: 24 M
Installed size: 31 M
Downloading packages:
warning: /var/cache/yum/x86_64/7/base/packages/apr-1.4.8-3.el7_4.1.x86_64.rpm: Header V3 RSA/SHA256 Signature, key ID f4a80eb5: NOKEY
Public key for apr-1.4.8-3.el7_4.1.x86_64.rpm is not installed
Public key for httpd-tools-2.4.6-80.el7.centos.1.x86_64.rpm is not installed
--------------------------------------------------------------------------------
Total                                               13 MB/s |  24 MB  00:01     
Retrieving key from file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
Importing GPG key 0xF4A80EB5:
 Userid     : "CentOS-7 Key (CentOS 7 Official Signing Key) <security@centos.org>"
 Fingerprint: 6341 ab27 53d7 8a78 a7c2 7bb1 24c6 a8a7 f4a8 0eb5
 Package    : centos-release-7-5.1804.el7.centos.2.x86_64 (@Updates)
 From       : /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Installing : apr-1.4.8-3.el7_4.1.x86_64                                   1/6 
  Installing : apr-util-1.5.2-6.el7.x86_64                                  2/6 
  Installing : httpd-tools-2.4.6-80.el7.centos.1.x86_64                     3/6 
  Installing : centos-logos-70.0.6-3.el7.centos.noarch                      4/6 
  Installing : mailcap-2.1.41-2.el7.noarch                                  5/6 
  Installing : httpd-2.4.6-80.el7.centos.1.x86_64                           6/6 
  Verifying  : mailcap-2.1.41-2.el7.noarch                                  1/6 
  Verifying  : httpd-tools-2.4.6-80.el7.centos.1.x86_64                     2/6 
  Verifying  : apr-util-1.5.2-6.el7.x86_64                                  3/6 
  Verifying  : httpd-2.4.6-80.el7.centos.1.x86_64                           4/6 
  Verifying  : apr-1.4.8-3.el7_4.1.x86_64                                   5/6 
  Verifying  : centos-logos-70.0.6-3.el7.centos.noarch                      6/6 

Installed:
  httpd.x86_64 0:2.4.6-80.el7.centos.1                                          

Dependency Installed:
  apr.x86_64 0:1.4.8-3.el7_4.1                                                  
  apr-util.x86_64 0:1.5.2-6.el7                                                 
  centos-logos.noarch 0:70.0.6-3.el7.centos                                     
  httpd-tools.x86_64 0:2.4.6-80.el7.centos.1                                    
  mailcap.noarch 0:2.1.41-2.el7                                                 

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

$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                NAMES
49a7e1eee2f5        myhttpd:v1          "/bin/sh -c 'apachec…"   2 minutes ago       Up 2 minutes        0.0.0.0:81->80/tcp   dockerfile_apiweb1_1
55efc8de238f        nginx:latest        "nginx -g 'daemon of…"   2 minutes ago       Up 2 minutes        0.0.0.0:80->80/tcp   dockerfile_loadbalancer_1
c83c5ca8b917        myhttpd:v1          "/bin/sh -c 'apachec…"   2 minutes ago       Up 2 minutes        0.0.0.0:82->80/tcp   dockerfile_apiweb2_1
$ docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS

# Need to open the 81 and 82 ports on this server
$ ifconfig
br-a22f299ae250: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 172.19.0.1  netmask 255.255.0.0  broadcast 172.19.255.255
        inet6 fe80::42:88ff:fec3:5555  prefixlen 64  scopeid 0x20<link>
        ether 02:42:88:c3:55:55  txqueuelen 0  (Ethernet)
        RX packets 6  bytes 1230 (1.2 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 29  bytes 2965 (2.8 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

docker0: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
        inet 172.17.0.1  netmask 255.255.0.0  broadcast 172.17.255.255
        inet6 fe80::42:b2ff:fe49:60a0  prefixlen 64  scopeid 0x20<link>
        ether 02:42:b2:49:60:a0  txqueuelen 0  (Ethernet)
        RX packets 15674  bytes 858378 (838.2 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 24267  bytes 74773306 (71.3 MiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

docker_gwbridge: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 172.18.0.1  netmask 255.255.0.0  broadcast 172.18.255.255
        inet6 fe80::42:74ff:fe78:ae39  prefixlen 64  scopeid 0x20<link>
        ether 02:42:74:78:ae:39  txqueuelen 0  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 25  bytes 2668 (2.6 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 9001
        inet 172.31.40.64  netmask 255.255.240.0  broadcast 172.31.47.255
        inet6 fe80::830:7aff:fe31:ec64  prefixlen 64  scopeid 0x20<link>
        ether 0a:30:7a:31:ec:64  txqueuelen 1000  (Ethernet)
        RX packets 354518  bytes 328690705 (313.4 MiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 175293  bytes 23092119 (22.0 MiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 95  bytes 8504 (8.3 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 95  bytes 8504 (8.3 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

veth459746a: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet6 fe80::e822:52ff:fe0c:9762  prefixlen 64  scopeid 0x20<link>
        ether ea:22:52:0c:97:62  txqueuelen 0  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 22  bytes 2410 (2.3 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

vetha6657e8: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet6 fe80::14ae:78ff:fe20:1949  prefixlen 64  scopeid 0x20<link>
        ether 16:ae:78:20:19:49  txqueuelen 0  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 25  bytes 2668 (2.6 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

vethcab47b8: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet6 fe80::f856:a5ff:fe20:dbf3  prefixlen 64  scopeid 0x20<link>
        ether fa:56:a5:20:db:f3  txqueuelen 0  (Ethernet)
        RX packets 40  bytes 3988 (3.8 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 69  bytes 5068 (4.9 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

vethe50892a: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet6 fe80::e864:98ff:fec4:bde  prefixlen 64  scopeid 0x20<link>
        ether ea:64:98:c4:0b:de  txqueuelen 0  (Ethernet)
        RX packets 6  bytes 1230 (1.2 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 29  bytes 2965 (2.8 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

$ sudo vim /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

172.31.40.64    mgr01
172.31.37.103   node01
172.31.34.40    node02
172.31.40.64    craig-nicholsoneswlb1.mylabserver.com craig-nicholsoneswlb1


$ curl craig-nicholsoneswlb1:81
Our container Website

$ curl craig-nicholsoneswlb1:82
Our container Website

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

$ docker-compose ps
          Name                         Command               State         Ports       
---------------------------------------------------------------------------------------
dockerfile_apiweb1_1        /bin/sh -c apachectl -DFOR ...   Up      0.0.0.0:81->80/tcp
dockerfile_apiweb2_1        /bin/sh -c apachectl -DFOR ...   Up      0.0.0.0:82->80/tcp
dockerfile_loadbalancer_1   nginx -g daemon off;             Up      0.0.0.0:80->80/tcp

# bring down the site
$ docker-compose down --volumes
Stopping dockerfile_apiweb1_1      ... done
Stopping dockerfile_loadbalancer_1 ... done
Stopping dockerfile_apiweb2_1      ... done
Removing dockerfile_apiweb1_1      ... done
Removing dockerfile_loadbalancer_1 ... done
Removing dockerfile_apiweb2_1      ... done
Removing network dockerfile_default

 ```

Use compose to deploy a swarm ...
Any images you use need to be built before you use docker stack deploy
docker stack deploy does not support dynamic build during deploy

Verify we are staring clean.  No running for stopped containers.

 ```bash
$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES

$ docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES 

 ```

Run Compose Deploy

 ```bash
docker stack deploy --compose-file docker-compose.yml mycustomestack
Ignoring unsupported options: build

Creating network mycustomestack_default
Creating service mycustomestack_loadbalancer
Creating service mycustomestack_apiweb1
Creating service mycustomestack_apiweb2

 ```

Verify

 ```bash
docker service ls
ID                  NAME                          MODE                REPLICAS            IMAGE               PORTS
wepvwakjffjo        mycustomestack_apiweb1        replicated          0/1                 myhttpd:v1          *:81->80/tcp
8qm4p9pauwkg        mycustomestack_apiweb2        replicated          0/1                 myhttpd:v1          *:82->80/tcp
o9w0mcvhy5zk        mycustomestack_loadbalancer   replicated          1/1                 nginx:latest        *:80->80/tcp

docker service ls
ID                  NAME                          MODE                REPLICAS            IMAGE               PORTS
wepvwakjffjo        mycustomestack_apiweb1        replicated          1/1                 myhttpd:v1          *:81->80/tcp
8qm4p9pauwkg        mycustomestack_apiweb2        replicated          1/1                 myhttpd:v1          *:82->80/tcp
o9w0mcvhy5zk        mycustomestack_loadbalancer   replicated          1/1                 nginx:latest        *:80->80/tcp

 ```

Check all the services individually

 ```bash
[user@craig-nicholsoneswlb1 Dockerfile]$ docker service ps mycustomestack_apiweb1
ID                  NAME                           IMAGE               NODE                                    DESIRED STATE       CURRENT STATE            ERROR                         PORTS
430t4oqnskru        mycustomestack_apiweb1.1       myhttpd:v1          craig-nicholsoneswlb1.mylabserver.com   Running             Running 2 minutes ago                                  
xi94jmo29nqj         \_ mycustomestack_apiweb1.1   myhttpd:v1          craig-nicholsoneswlb3.mylabserver.com   Shutdown            Rejected 2 minutes ago   "No such image: myhttpd:v1"   
sytudcup4905         \_ mycustomestack_apiweb1.1   myhttpd:v1          craig-nicholsoneswlb2.mylabserver.com   Shutdown            Rejected 3 minutes ago   "No such image: myhttpd:v1"   
wlxj18m6hg5i         \_ mycustomestack_apiweb1.1   myhttpd:v1          craig-nicholsoneswlb2.mylabserver.com   Shutdown            Rejected 3 minutes ago   "No such image: myhttpd:v1"   
t8qtct3znmqj         \_ mycustomestack_apiweb1.1   myhttpd:v1          craig-nicholsoneswlb3.mylabserver.com   Shutdown            Rejected 3 minutes ago   "No such image: myhttpd:v1"   
[user@craig-nicholsoneswlb1 Dockerfile]$ docker service ps mycustomestack_apiweb2
ID                  NAME                           IMAGE               NODE                                    DESIRED STATE       CURRENT STATE            ERROR                         PORTS
ptvvtdrglve5        mycustomestack_apiweb2.1       myhttpd:v1          craig-nicholsoneswlb1.mylabserver.com   Running             Running 2 minutes ago                                  
qvp6sastpptn         \_ mycustomestack_apiweb2.1   myhttpd:v1          craig-nicholsoneswlb3.mylabserver.com   Shutdown            Rejected 3 minutes ago   "No such image: myhttpd:v1"   
oxreu4wjkg2s         \_ mycustomestack_apiweb2.1   myhttpd:v1          craig-nicholsoneswlb3.mylabserver.com   Shutdown            Rejected 3 minutes ago   "No such image: myhttpd:v1"   
so5jlox6xonq         \_ mycustomestack_apiweb2.1   myhttpd:v1          craig-nicholsoneswlb2.mylabserver.com   Shutdown            Rejected 3 minutes ago   "No such image: myhttpd:v1"   
j9nk517cwp2e         \_ mycustomestack_apiweb2.1   myhttpd:v1          craig-nicholsoneswlb2.mylabserver.com   Shutdown            Rejected 3 minutes ago   "No such image: myhttpd:v1"   
[user@craig-nicholsoneswlb1 Dockerfile]$ docker service ps mycustomestack_loadbalancer
ID                  NAME                            IMAGE               NODE                                    DESIRED STATE       CURRENT STATE           ERROR               PORTS
eaavif9ml03e        mycustomestack_loadbalancer.1   nginx:latest        craig-nicholsoneswlb1.mylabserver.com   Running             Running 3 minutes ago                       

 ```

## Understanding the 'docker inspect' Output

Allows for detailed constructs about the containers and pulled back in json.

 ```bash
 [user@craig-nicholsoneswlb1 ~]$ docker run -d --name testweb httpd
4e6c9bf04984f71a2fad72ff199e69e099399962cacf2e587bf890decb18463e
[user@craig-nicholsoneswlb1 ~]$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED              STATUS              PORTS               NAMES
4e6c9bf04984        httpd               "httpd-foreground"       3 seconds ago        Up 2 seconds        80/tcp              testweb
240d3680b26c        nginx:latest        "nginx -g 'daemon of…"   About a minute ago   Up About a minute   80/tcp              mycustomestack_loadbalancer.1.wb44pa09wfuukhoowxcgif74n
96b6173d4f97        myhttpd:v1          "/bin/sh -c 'apachec…"   About a minute ago   Up About a minute   80/tcp              mycustomestack_apiweb1.1.q8uwx9l59mqhdj5njl9dn2e1n
b4f7ee34c4a0        myhttpd:v1          "/bin/sh -c 'apachec…"   About a minute ago   Up About a minute   80/tcp              mycustomestack_apiweb2.1.570ecryosd718lf2ecq9i8ef9
[user@craig-nicholsoneswlb1 ~]$ docker inspect container testweb
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
Error: No such object: container
 ```

 ```bash

[user@craig-nicholsoneswlb1 ~]$ docker inspect container testweb | grep IPAddress
Error: No such object: container
            "SecondaryIPAddresses": null,
            "IPAddress": "172.17.0.2",
                    "IPAddress": "172.17.0.2",

 ```

 One or more things you can do are , look at the structre, get more familiar and pull back things what you want.


Determin if the container has been paused.

 ```bash

docker container inspect testweb --format="{{.State.Paused}}"
false

 ```

Get all in the state.

 ```bash

docker container inspect testweb --format="{{json .State}}"

 ```

## Identify the Steps Needed to Troubleshoot a Service Not Deploying

Troubleshoot docker swarm services

- docker node ls
 -- are all the nodes available and show that way in your cluster
- docker service ps
 -- is service partially running
 -- is problem specific to # of replicas
- docker service inspect
 -- did you apply labels and do they show?
 -- did you deply your service with a constraint and mis-matched the value with once used on launch

- docker ps
 -- is your cluster locked
 -- you have to unlocked when it restarts
 
- did the restore of swarm and services not starting
 -- re-initialize the new mananger you restord  to force the cluster so that it is not attemping to contact previous nodes

- did you update docker
 -- 

Troubleshooting requires experience.

- SELinux issues
 -- try setenforce 0 to push SELinux into Passize mode and retryy your task

- Permissions
 -- resources need to have access running as user
 -- don't run as root

- CPU/Mem
 -- when constraining containster to a host, bes ure it has necessary resource to meet the needs of the service

- routing
  -- endpoints use same service on same network routing or have the necessary routing to reach each other

- firewall rules

## How Dockerized Apps Communicate with Legacy Systems

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

### Requirements

Swarm Size | Majority | Fault Tolerance
1 1 0
2 2 0
3 2 1
4 3 1
5 3 2
6 4 2
7 4 3
8 5 3
9 5 4

maintain and odd number 

more managers does not make it better, b/c it will get chatty

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

You should distribute nodes in 3 locations.
With any 2 datacenters you can still maintain a quorum.
you typically lose one zone.. not all zones.

we you do a recovery you can force a rebalance.

Swarm Manager Nodes | Repartition (on 3 Availability Zones)
3 1-1-1
5 2-2-1
7 3-2-2
9 3-3-3

Requirements/Considerations

• Use a Minimum of 3 Availability Zones to Distribute Managers
• Run ‘Manager Only’ Nodes
• docker node update –availability drain [node]
• Force Rebalance
• docker service update --force


```bash
```

```bash
```

```bash
```

```bash
```

```bash
```

```bash
```