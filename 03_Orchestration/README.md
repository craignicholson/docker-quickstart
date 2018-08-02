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
[sudo] password for user: 
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
[user@craig-nicholsoneswlb1 ~]$ docker service ls
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

```bash

```


```bash

```