# Networking

## Create a Docker Bridge Network for a Developer to Use for Their Containers

```bash

craig@cn:~$ docker --version
Docker version 18.06.0-ce, build 0ffa825
craig@cn:~$ docker pull httpd
Using default tag: latest
latest: Pulling from library/httpd
Digest: sha256:8c84e065bdf72b4909bd55a348d5e91fe265e08d6b28ed9104bfdcac9206dcc8
Status: Image is up to date for httpd:latest
craig@cn:~$ docker run -d --name testweb -p 80:80 httpd
a2d8009856ea1d70a9957c48869b91167142e1966e27271e8d3cff6df4957a1c
craig@cn:~$ docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS                NAMES
a2d8009856ea        httpd               "httpd-foreground"   2 seconds ago       Up 2 seconds        0.0.0.0:80->80/tcp   testweb
craig@cn:~$ docker container inspect ^C
craig@cn:~$ ^C
craig@cn:~$ docker container inspect a2 | grep IPAddress
            "SecondaryIPAddresses": null,
            "IPAddress": "172.17.0.2",
                    "IPAddress": "172.17.0.2",
craig@cn:~$ curl 172.17.0.2
<html><body><h1>It works!</h1></body></html>
craig@cn:~$ curl localhost
<html><body><h1>It works!</h1></body></html>
craig@cn:~$ docker network ls
NETWORK ID          NAME                DRIVER              SCOPE
ea552c9d75d9        bridge              bridge              local
27db192e0193        host                host                local
221b28c65035        none                null                local
ff42167e05c4        ps-bridge           bridge              local
craig@cn:~$ # Let us join this container to another network
craig@cn:~$ docker container inspect --format="{{.NetworkSettings.Networks.bridge.IPAddress}}" testweb
172.17.0.2

craig@cn:~$ # create bridge network so devs can use
craig@cn:~$ docker network create --driver=bridge --subet=192.168.1.0/24 --opt "com.docker.network.driver.mtu"="1501" devel0
unknown flag: --subet
See 'docker network create --help'.
craig@cn:~$ docker network create --driver=bridge --subnet=192.168.1.0/24 --opt "com.docker.network.driver.mtu"="1501" devel0
5cd5d9a315c9e5db69ff5d06cc6c670a6b97afcc69b174ff02faa903b86a9b1d

craig@cn:~$ docker network ls
NETWORK ID          NAME                DRIVER              SCOPE
ea552c9d75d9        bridge              bridge              local
5cd5d9a315c9        devel0              bridge              local
27db192e0193        host                host                local
221b28c65035        none                null                local
ff42167e05c4        ps-bridge           bridge              local
craig@cn:~$ docker container inspect --format="{{.NetworkSettings.Networks.bridge.IPAddress}}" testweb
172.17.0.2
craig@cn:~$ docker container inspect --format="{{.NetworkSettings.Networks.devel0.IPAddress}}" testweb
<no value>
craig@cn:~$ docker network inspect devel0
[
    {
        "Name": "devel0",
        "Id": "5cd5d9a315c9e5db69ff5d06cc6c670a6b97afcc69b174ff02faa903b86a9b1d",
        "Created": "2018-08-04T09:29:21.138135612-04:00",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": {},
            "Config": [
                {
                    "Subnet": "192.168.1.0/24"
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
        "Options": {
            "com.docker.network.driver.mtu": "1501"
        },
        "Labels": {}
    }
]

craig@cn:~$ # Can i add a running container to a network
craig@cn:~$ docker network connect
"docker network connect" requires exactly 2 arguments.
See 'docker network connect --help'.

Usage:  docker network connect [OPTIONS] NETWORK CONTAINER

Connect a container to a network
craig@cn:~$ # We can only specify the IP address to a user created network not the orig bridge
craig@cn:~$ # also connecting it does not disconnect it from its current network
craig@cn:~$ docker container inspect --format="{{.NetworkSettings.Networks.bridge.IPAddress}}" testweb
172.17.0.2

craig@cn:~$ docker network connect --ip=192.168.1.10 devel0 testweb
craig@cn:~$ docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS                NAMES
a2d8009856ea        httpd               "httpd-foreground"   7 minutes ago       Up 7 minutes        0.0.0.0:80->80/tcp   testweb

craig@cn:~$ docker container inspect --format="{{.NetworkSettings.Networks.devel0.IPAddress}}" testweb
192.168.1.10

craig@cn:~$ curl 192.168.1.10
<html><body><h1>It works!</h1></body></html>

craig@cn:~$ docker network ls
NETWORK ID          NAME                DRIVER              SCOPE
ea552c9d75d9        bridge              bridge              local
5cd5d9a315c9        devel0              bridge              local
27db192e0193        host                host                local
221b28c65035        none                null                local
ff42167e05c4        ps-bridge           bridge              local

craig@cn:~$ docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS                NAMES
a2d8009856ea        httpd               "httpd-foreground"   8 minutes ago       Up 8 minutes        0.0.0.0:80->80/tcp   testweb

craig@cn:~$ docker container inspect testweb | grep IPAddress
            "SecondaryIPAddresses": null,
            "IPAddress": "172.17.0.2",
                    "IPAddress": "172.17.0.2",
                    "IPAddress": "192.168.1.10",

craig@cn:~$ # Ok, let's remove the original bridge network on 172.17
craig@cn:~$ docker network disconnect bridge testweb
craig@cn:~$ docker container inspect testweb | grep IPAddress
            "SecondaryIPAddresses": null,
            "IPAddress": "",
                    "IPAddress": "192.168.1.10",

craig@cn:~$ curl 192.168.1.10
<html><body><h1>It works!</h1></body></html>

craig@cn:~$ docker container inspect --format="{{.NetworkSettings.Networks.bridge.IPAddress}}" testweb
<no value>

craig@cn:~$ docker container inspect --format="{{.NetworkSettings.Networks.devel0.IPAddress}}" testweb
192.168.1.10

craig@cn:~$ docker network ls 
NETWORK ID          NAME                DRIVER              SCOPE
ea552c9d75d9        bridge              bridge              local
5cd5d9a315c9        devel0              bridge              local
27db192e0193        host                host                local
221b28c65035        none                null                local
ff42167e05c4        ps-bridge           bridge              local

craig@cn:~$ docker stop testweb
testweb

craig@cn:~$ docker network ls
NETWORK ID          NAME                DRIVER              SCOPE
ea552c9d75d9        bridge              bridge              local
5cd5d9a315c9        devel0              bridge              local
27db192e0193        host                host                local
221b28c65035        none                null                local
ff42167e05c4        ps-bridge           bridge              local

craig@cn:~$ docker network rm devel0
devel0

craig@cn:~$ docker network ls
NETWORK ID          NAME                DRIVER              SCOPE
ea552c9d75d9        bridge              bridge              local
27db192e0193        host                host                local
221b28c65035        none                null                local
ff42167e05c4        ps-bridge           bridge              local

```

## Configure Docker for External DNS

Ways to ovride the default DNS setting for containers.

Our DNS is carried over to the container... 

```bash

craig@cn:~$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
httpd               latest              11426a19f1a2        3 days ago          178MB
nginx               latest              c82521676580        10 days ago         109MB
centos              latest              49f7960eb7e4        2 months ago        200MB
alpine              latest              3fd9065eaf02        6 months ago        4.15MB
craig@cn:~$ # Let's review DNS

craig@cn:~$ cat /etc/resolv.conf 
# Dynamic resolv.conf(5) file for glibc resolver(3) generated by resolvconf(8)
#     DO NOT EDIT THIS FILE BY HAND -- YOUR CHANGES WILL BE OVERWRITTEN
nameserver 127.0.1.1
craig@cn:~$ # start a container and review the contents

craig@cn:~$ docker run -d --name testweb httpd
23efd07100e0cfbaab80af1d94b605b289dcb4881125aa31873e626d829fbf18

craig@cn:~$ docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS               NAMES
23efd07100e0        httpd               "httpd-foreground"   3 seconds ago       Up 1 second         80/tcp              testweb

craig@cn:~$ docker exec -it testweb /bin/bash
root@23efd07100e0:/usr/local/apache2# cat /etc/resolv.conf 
# Dynamic resolv.conf(5) file for glibc resolver(3) generated by resolvconf(8)
#     DO NOT EDIT THIS FILE BY HAND -- YOUR CHANGES WILL BE OVERWRITTEN

nameserver 8.8.8.8
nameserver 8.8.4.4
root@23efd07100e0:/usr/local/apache2# exit
exit
craig@cn:~$ docker stop testweb
dtestweb
craig@cn:~$ docker rm testweb
testweb

craig@cn:~$ # We can overide this on the cli at run
craig@cn:~$ docker run -d --name testweb --dns=8.8.8.8 --dns=8.8.4.4 httpd
32fa74e2dfc70694cf01c949cdc39928f7e02f545fdf153f8c0351c5484063b6

craig@cn:~$ docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS               NAMES
32fa74e2dfc7        httpd               "httpd-foreground"   3 seconds ago       Up 2 seconds        80/tcp              testweb

craig@cn:~$ docker exec -it testweb /bin/bash
root@32fa74e2dfc7:/usr/local/apache2# cat /etc/resolv.conf 
nameserver 8.8.8.8
nameserver 8.8.4.4
root@32fa74e2dfc7:/usr/local/apache2# exit
exit

craig@cn:~$ # this is just for this one container
craig@cn:~$ docker stop testweb 
testweb

craig@cn:~$ docker rm testweb 
testweb
craig@cn:~$ # What is we want containers DNS use a  diff DNS each time they launch

craig@cn:~$ sudo vim /etc/docker/daemon.json
craig@cn:~$ sudo cat /etc/docker/daemon.json
{
	"dns" : ["8.8.8.8", "8.8.4.4"]
}

craig@cn:~$ sudo systemctl restart docker
craig@cn:~$ docker run -d --name testweb httpd
e4074e66467732ad24b72ef3d050415215caaf9acd0345e389bc566e943c6258
craig@cn:~$ docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS               NAMES
e4074e664677        httpd               "httpd-foreground"   2 seconds ago       Up 1 second         80/tcp              testweb

craig@cn:~$ docker exec -it testweb /bin/bash
root@e4074e664677:/usr/local/apache2# cat /etc/resolv.conf 
nameserver 8.8.8.8
nameserver 8.8.4.4
root@e4074e664677:/usr/local/apache2# exit
exit

craig@cn:~$ # Use daemon.json to set it for all containers
craig@cn:~$ # Or for each individual containers
```

## Publish a Port so tshat an application is accessible externally and identify the port and ip it is on

```bash
craig@cn:~/github.com/docker-quickstart$ cd
craig@cn:~$ 
craig@cn:~$ 
craig@cn:~$ clear
craig@cn:~$ # run container
craig@cn:~$ # use the flag -P to map a containers exposed ports to random port on host 
craig@cn:~$ # random port will be above 32768
craig@cn:~$ # you can't pick the rand port #
craig@cn:~$ docker run -d --name testweb httpd
dd83f2205e878c6532841c312005da49320883f6a7aa7a7399a1903d41f286f1
craig@cn:~$ docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS               NAMES
dd83f2205e87        httpd               "httpd-foreground"   2 seconds ago       Up 1 second         80/tcp              testweb
craig@cn:~$ docker stop testweb
testweb
craig@cn:~$ docker rm testweb
testweb
craig@cn:~$ docker run -d --name -P testweb httpd
Unable to find image 'testweb:latest' locally
docker: Error response from daemon: pull access denied for testweb, repository does not exist or may require 'docker login'.
See 'docker run --help'.
craig@cn:~$ docker run -d --name testweb -P httpd
0f80579a55ba2cf63d26637953f920fbdd392799b3fc245cfec6e969902235a7
craig@cn:~$ docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS                   NAMES
0f80579a55ba        httpd               "httpd-foreground"   2 seconds ago       Up 1 second         0.0.0.0:32768->80/tcp   testweb
craig@cn:~$ curl localhost:32768
<html><body><h1>It works!</h1></body></html>
craig@cn:~$ docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED              STATUS              PORTS                   NAMES
0f80579a55ba        httpd               "httpd-foreground"   About a minute ago   Up About a minute   0.0.0.0:32768->80/tcp   testweb
craig@cn:~$ # inspect the container to find the IP address
craig@cn:~$ docker container inspect testweb | grep IPAddress
            "SecondaryIPAddresses": null,
            "IPAddress": "172.17.0.2",
                    "IPAddress": "172.17.0.2",
craig@cn:~$ # we can get more specific with the --format
craig@cn:~$ docker container inspect testweb --format="{{.NetworkSettings.Networks.bridge.IPAdress}}"

Template parsing error: template: :1:18: executing "" at <.NetworkSettings.Net...>: map has no entry for key "IPAdress"
craig@cn:~$ docker container inspect  --format="{{.NetworkSettings.Networks.bridge.IPAdress}}" testweb

Template parsing error: template: :1:18: executing "" at <.NetworkSettings.Net...>: map has no entry for key "IPAdress"
craig@cn:~$ docker container inspect  --format="{{.NetworkSettings.Networks.bridge.IPAddress}}" testweb
172.17.0.2
craig@cn:~$ # if we were connected to another network we would swap that birdge with our own network
craig@cn:~$ # this makes the application avail to anyone on our network 172.17.0.2:32768
craig@cn:~$ docker stop testweb
dotestweb
craig@cn:~$ docker rm testweb
testweb
craig@cn:~$ docker run -d --name testweb --publish 80:80 httpd
219b548b3aee8708785063319f22b446385b2d67a0a508f288f6fda3581d2561
craig@cn:~$ docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS                NAMES
219b548b3aee        httpd               "httpd-foreground"   5 seconds ago       Up 5 seconds        0.0.0.0:80->80/tcp   testweb
craig@cn:~$ curl localhost
<html><body><h1>It works!</h1></body></html>
craig@cn:~$ docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS                NAMES
219b548b3aee        httpd               "httpd-foreground"   24 seconds ago      Up 23 seconds       0.0.0.0:80->80/tcp   testweb
craig@cn:~$ docker container inspect  --format="{{.NetworkSettings.Networks.bridge.IPAddress}}" testweb
172.17.0.2
craig@cn:~$ docker run -d --name testweb2 --publish 5901:80 httpd
17565d7bd0fb723f19d1bab0b933b34aa59924bfed2fb0eed6f4a2cafba7a5d5
craig@cn:~$ docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED              STATUS              PORTS                  NAMES
17565d7bd0fb        httpd               "httpd-foreground"   4 seconds ago        Up 2 seconds        0.0.0.0:5901->80/tcp   testweb2
219b548b3aee        httpd               "httpd-foreground"   About a minute ago   Up About a minute   0.0.0.0:80->80/tcp     testweb
craig@cn:~$ docker container inspect  --format="{{.NetworkSettings.Networks.bridge.IPAddress}}" testweb2
172.17.0.3
craig@cn:~$ curl localhost:5901
<html><body><h1>It works!</h1></body></html>
craig@cn:~$ docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED              STATUS              PORTS                  NAMES
17565d7bd0fb        httpd               "httpd-foreground"   About a minute ago   Up About a minute   0.0.0.0:5901->80/tcp   testweb2
219b548b3aee        httpd               "httpd-foreground"   2 minutes ago        Up 2 minutes        0.0.0.0:80->80/tcp     testweb
craig@cn:~$ docker stop testweb
testweb
craig@cn:~$ docker stop testweb2 
testweb2
craig@cn:~$ docker rm testweb
testweb
craig@cn:~$ docker rm testweb2 
testweb2
```

## Deploy a SERVICE on a Docker overlay network

```bash

craig@cn:~/github.com/docker-quickstart$ cd 
craig@cn:~$ docker network ls
NETWORK ID          NAME                DRIVER              SCOPE
1632cbeb43ba        bridge              bridge              local
27db192e0193        host                host                local
221b28c65035        none                null                local
ff42167e05c4        ps-bridge           bridge              local

craig@cn:~$ # Missing a few networks here b/c I never started swarm lets do that.


craig@cn:~$ ifconfig
br-ff42167e05c4 Link encap:Ethernet  HWaddr 02:42:42:1b:a8:eb  
          inet addr:10.0.0.1  Bcast:10.0.0.255  Mask:255.255.255.0
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

docker0   Link encap:Ethernet  HWaddr 02:42:5d:a1:1f:f1  
          inet addr:172.17.0.1  Bcast:172.17.255.255  Mask:255.255.0.0
          inet6 addr: fe80::42:5dff:fea1:1ff1/64 Scope:Link
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:28 errors:0 dropped:0 overruns:0 frame:0
          TX packets:153 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:2654 (2.6 KB)  TX bytes:21511 (21.5 KB)

lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:2052 errors:0 dropped:0 overruns:0 frame:0
          TX packets:2052 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:204305 (204.3 KB)  TX bytes:204305 (204.3 KB)

virbr0    Link encap:Ethernet  HWaddr 00:00:00:00:00:00  
          inet addr:192.168.122.1  Bcast:192.168.122.255  Mask:255.255.255.0
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

vmnet1    Link encap:Ethernet  HWaddr 00:50:56:c0:00:01  
          inet addr:172.16.243.1  Bcast:172.16.243.255  Mask:255.255.255.0
          inet6 addr: fe80::250:56ff:fec0:1/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:227 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

vmnet8    Link encap:Ethernet  HWaddr 00:50:56:c0:00:08  
          inet addr:192.168.171.1  Bcast:192.168.171.255  Mask:255.255.255.0
          inet6 addr: fe80::250:56ff:fec0:8/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:230 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

wlp1s0    Link encap:Ethernet  HWaddr ac:2b:6e:5f:b8:2e  
          inet addr:192.168.116.239  Bcast:192.168.116.255  Mask:255.255.255.0
          inet6 addr: fe80::b8ed:ecd1:fcf4:f648/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:120366 errors:0 dropped:0 overruns:0 frame:0
          TX packets:19351 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:165466413 (165.4 MB)  TX bytes:3255049 (3.2 MB)

craig@cn:~$ ^C

craig@cn:~$ docker swarm init -advertise-addr 192.168.116.239
unknown shorthand flag: 'a' in -advertise-addr
See 'docker swarm init --help'.
craig@cn:~$ docker swarm init --advertise-addr 192.168.116.239
Swarm initialized: current node (smu46t0gppawtq9foticekhmm) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join --token SWMTKN-1-63cdayq5bl41g8ykrmj9y6eqrbd2tl5adcd8agudb5z4r145us-7o14c0jtvnbklg1269311pkd5 192.168.116.239:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.

craig@cn:~$ docker network ls
NETWORK ID          NAME                DRIVER              SCOPE
1632cbeb43ba        bridge              bridge              local
e1712d35997b        docker_gwbridge     bridge              local
27db192e0193        host                host                local
2bycncbbdz7i        ingress             overlay             swarm
221b28c65035        none                null                local
ff42167e05c4        ps-bridge           bridge              local
craig@cn:~$ 


craig@cn:~/github.com/docker-quickstart$ cd
craig@cn:~$ docker network ls
NETWORK ID          NAME                DRIVER              SCOPE
1632cbeb43ba        bridge              bridge              local
e1712d35997b        docker_gwbridge     bridge              local
27db192e0193        host                host                local
2bycncbbdz7i        ingress             overlay             swarm
221b28c65035        none                null                local
ff42167e05c4        ps-bridge           bridge              local
craig@cn:~$ docker network create --driver=overlay --subnet=192.168.1.0/24 overlay0
fo188g1cpeqly1xj70tyf6z5r
craig@cn:~$ # This is a C Class network with 256 addresses
craig@cn:~$ docker network inspect overlay0
[
    {
        "Name": "overlay0",
        "Id": "fo188g1cpeqly1xj70tyf6z5r",
        "Created": "2018-08-04T14:46:04.285405369Z",
        "Scope": "swarm",
        "Driver": "overlay",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": null,
            "Config": [
                {
                    "Subnet": "192.168.1.0/24",
                    "Gateway": "192.168.1.1"
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
        "Containers": null,
        "Options": {
            "com.docker.network.driver.overlay.vxlanid_list": "4097"
        },
        "Labels": null
    }
]
craig@cn:~$ # If you run docker network ls on each node, you will not see overlay0
craig@cn:~$ # you first need to create a service to use this network
craig@cn:~$ # and then this network will be transfered to each of the nodes
craig@cn:~$ docker service create --name testweb -p 80:80 --network=overlay0 --replicas 2  httpd
7lmrliea83gryeii41jczpmhs
overall progress: 2 out of 2 tasks 
1/2: running   [==================================================>] 
2/2: running   [==================================================>] 
verify: Service converged 

craig@cn:~$ docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
7lmrliea83gr        testweb             replicated          2/2                 httpd:latest        *:80->80/tcp
craig@cn:~$ docker ps testweb
"docker ps" accepts no arguments.
See 'docker ps --help'.

Usage:  docker ps [OPTIONS]

List containers
craig@cn:~$ docker service ps testweb
ID                  NAME                IMAGE               NODE                DESIRED STATE       CURRENT STATE            ERROR               PORTS
hx123zqr280o        testweb.1           httpd:latest        cn                  Running             Running 29 seconds ago                       
zt00oy2rwnix        testweb.2           httpd:latest        cn                  Running             Running 29 seconds ago                       
craig@cn:~$ # on the other nodes you can no run docker network ls
craig@cn:~$ # and docker ps
craig@cn:~$ # and docker container inspect [CONTAINER ID] | grep IPAddress
craig@cn:~$ # and docker container inspect [CONTAINER ID] | grep IP
craig@cn:~$ # you can't use these new IPs on the other services

craig@cn:~$ docker service ps testweb
ID                  NAME                IMAGE               NODE                DESIRED STATE       CURRENT STATE           ERROR               PORTS
hx123zqr280o        testweb.1           httpd:latest        cn                  Running             Running 3 minutes ago                       
zt00oy2rwnix        testweb.2           httpd:latest        cn                  Running             Running 3 minutes ago                       

craig@cn:~$ docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS               NAMES
1f67efd0710a        httpd:latest        "httpd-foreground"   5 minutes ago       Up 5 minutes        80/tcp              testweb.2.zt00oy2rwnix00g0zd2s64mgm
cf90d46d996d        httpd:latest        "httpd-foreground"   5 minutes ago       Up 5 minutes        80/tcp              testweb.1.hx123zqr280omp9gg9uwxbi2n
craig@cn:~$ docker exec -it 1f67efd0710a /bin/bash
root@1f67efd0710a:/usr/local/apache2# exit
exit
craig@cn:~$ docker container inspect 1f67efd0710a | grep IPAddress
            "SecondaryIPAddresses": null,
            "IPAddress": "",
                    "IPAddress": "10.255.0.5",
                    "IPAddress": "192.168.1.5",
craig@cn:~$ docker container inspect cf | grep IPAddress
            "SecondaryIPAddresses": null,
            "IPAddress": "",
                    "IPAddress": "10.255.0.4",
                    "IPAddress": "192.168.1.4",
craig@cn:~$ # overlay allows inter-container communication over this ip range instead of external
craig@cn:~$ ping 192.168.1.4
PING 192.168.1.4 (192.168.1.4) 56(84) bytes of data.
^C
--- 192.168.1.4 ping statistics ---
3 packets transmitted, 0 received, 100% packet loss, time 2031ms

craig@cn:~$ docker exec -it 1f67efd0710a /bin/bash
root@1f67efd0710a:/usr/local/apache2# whoami
root
root@1f67efd0710a:/usr/local/apache2# ifconfig      
bash: ifconfig: command not found
root@1f67efd0710a:/usr/local/apache2# ping 192.168.1.4
PING 192.168.1.4 (192.168.1.4) 56(84) bytes of data.
64 bytes from 192.168.1.4: icmp_seq=1 ttl=64 time=0.208 ms
64 bytes from 192.168.1.4: icmp_seq=2 ttl=64 time=0.105 ms
64 bytes from 192.168.1.4: icmp_seq=3 ttl=64 time=0.093 ms
^C
--- 192.168.1.4 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2024ms
rtt min/avg/max/mdev = 0.093/0.135/0.208/0.052 ms
root@1f67efd0710a:/usr/local/apache2# ping 192.168.1.5
PING 192.168.1.5 (192.168.1.5) 56(84) bytes of data.
64 bytes from 192.168.1.5: icmp_seq=1 ttl=64 time=0.097 ms
64 bytes from 192.168.1.5: icmp_seq=2 ttl=64 time=0.065 ms
64 bytes from 192.168.1.5: icmp_seq=3 ttl=64 time=0.066 ms
^C
--- 192.168.1.5 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2054ms
rtt min/avg/max/mdev = 0.065/0.076/0.097/0.014 ms
root@1f67efd0710a:/usr/local/apache2# ping 192.168.1.1
PING 192.168.1.1 (192.168.1.1) 56(84) bytes of data.
64 bytes from 192.168.1.1: icmp_seq=1 ttl=64 time=0.204 ms
64 bytes from 192.168.1.1: icmp_seq=2 ttl=64 time=0.082 ms
64 bytes from 192.168.1.1: icmp_seq=3 ttl=64 time=0.081 ms
^C
--- 192.168.1.1 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2051ms
rtt min/avg/max/mdev = 0.081/0.122/0.204/0.058 ms
root@1f67efd0710a:/usr/local/apache2# exit
exit
craig@cn:~$ # The last was us pinging the GATEWAY
craig@cn:~$ # OVERLAY IS GOOD FOR INTER CONTAINER NETWORK COMMUNICATION

```

## Describe the built in network drivers and the use cases for each and detail the differecnes betweek host and ingress network port publishing mode.

Types
 
- Bridge
- None
- Host
- Overlay
- Ingress
- Docker Gateway Brigde

### Bridge

Bridge
• Simple to understand, use and troubleshoot, and is the default on stand-alone Docker hosts.
• Consists of a private network that is internal to the host system; all containers implemented
on this host using Bridge networking can communicate.
• External access is granted by port exposure of the container’s services and accessed by the host OR static routes added with the host as the gateway for that network.

None
• Used when the container(s) in question need absolutely no networking access at all.
• Containers operating on this driver can only be accessed on the host they are running on.
• These containers can be attached directly (using ‘docker attach [containerid]’) or executing by another command on the running container (using ‘docker exec -it [containerid] [command]).
• Not commonly used.
 

 Host
• Sometimes referred to as ‘Host Only Networking’.
• Only accessible via the underlying host.
• Access to services can only be provided by exposing container service ports to the host system.
 


Overlay
• Allows communication among all Docker Daemons that are participating in a Swarm.
• It is a ‘Swarm Scope’ driver in that it extends itself (building previously non-existent networks
on Workers if needed) to all daemons in the Swarm cluster.
• Allows the communication of multiple services that may have replicas running on any number of Workers in the Swarm, regardless of their origination or destination.
• Default mode of Swarm communication.
 

 Ingress
• Special overlay network that load balances network traffic amongst a given service’s working nodes.
• Maintains a list of all IP addresses from nodes that participate in that service (using the IPVS module) and when a request comes in, routes to one of them for the indicated service.
• Provides the ‘routing mesh’ that allows services to be exposed to the external network without having a replica running on every node in the Swarm.
 
 Docker Gateway Bridge
• Special bridge network that allows overlay networks (including Ingress) access to an individual Docker daemon’s physical network.
• Every container run within a service is connected to the local Docker daemon’s host network.
• Automatically created when a Swarm is initialized or joined.
 
 Two types of port publishing modes: • Host
• Ports for containers are only available on the underlying host system and are NOT available for services outside of the host where that instance exists.
• Used in single host environments or in environments where you need complete control over routing.
• You are responsible for knowing where all instances are at all times, controlled with ‘mode=host’
• Ingress
in deployment.
• Since it is responsible for ‘routing mesh’, it makes all published ports available on all hosts (nodes or Workers) participating in the cluster so that the service is accessible from every node regardless of whether there is a service replica running on it at any given time.
 
 
```bash


```
