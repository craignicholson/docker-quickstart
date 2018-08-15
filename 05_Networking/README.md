# Networking

## Create a Docker Bridge Network for a Developer to Use for Their Containers

Creating and managing a network for Docker to use is exactly like creating and managing other components within the purview of the Docker daemon. This video will show you how to create one to use by your development shop.

```bash
# list the current networks
docker network ls
NETWORK ID          NAME                DRIVER              SCOPE
ea552c9d75d9        bridge              bridge              local
27db192e0193        host                host                local
221b28c65035        none                null                local
ff42167e05c4        ps-bridge           bridge              local

# inspect the network
# docker network inspect bridge, or drop the network
docker inspect bridge
[
    {
        "Name": "bridge",
        "Id": "3dfea661473c474da866d0a5c84f5675b7624b77d09ae174d7b055332873ae1d",
        "Created": "2018-08-14T18:08:28.941497196Z",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": null,
            "Config": [
                {
                    "Subnet": "172.17.0.0/16",
                    "Gateway": "172.17.0.1"
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
            "com.docker.network.bridge.default_bridge": "true",
            "com.docker.network.bridge.enable_icc": "true",
            "com.docker.network.bridge.enable_ip_masquerade": "true",
            "com.docker.network.bridge.host_binding_ipv4": "0.0.0.0",
            "com.docker.network.bridge.name": "docker0",
            "com.docker.network.driver.mtu": "1500"
        },
        "Labels": {}
    }
]
```

### Options

We can set all of these options are selves as well.

Just know we can add options vs memroize these options.

```json
        "Options": {
            "com.docker.network.bridge.default_bridge": "true",
            "com.docker.network.bridge.enable_icc": "true",
            "com.docker.network.bridge.enable_ip_masquerade": "true",
            "com.docker.network.bridge.host_binding_ipv4": "0.0.0.0",
            "com.docker.network.bridge.name": "docker0",
            "com.docker.network.driver.mtu": "1500"
        }
```

### Container and Network Example

```bash
# create a quick container
docker run -d --name testweb -p 80:80 https

# view the ip created for this container
docker container inspect --format="{{.NetworkSettings.Networks.bridge.IPAddress}}" testweb
172.17.0.2

# create bridge network so devs can use for their containers
docker network create --driver=bridge --subnet=192.168.1.0/24 --opt "com.docker.network.driver.mtu"="1501" devel0
5cd5d9a315c9e5db69ff5d06cc6c670a6b97afcc69b174ff02faa903b86a9b1d

docker network ls
NETWORK ID          NAME                DRIVER              SCOPE
ea552c9d75d9        bridge              bridge              local
5cd5d9a315c9        devel0              bridge              local
27db192e0193        host                host                local
221b28c65035        none                null                local
ff42167e05c4        ps-bridge           bridge              local

docker container inspect --format="{{.NetworkSettings.Networks.bridge.IPAddress}}" testweb
172.17.0.2


docker container inspect --format="{{.NetworkSettings.Networks.devel0.IPAddress}}" testweb
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
```

### Connect a running container to a new network

> Connecting to new network does not disconnect from previous network

```bash
# Can I add a running container to a network
docker network connect
"docker network connect" requires exactly 2 arguments.
See 'docker network connect --help'.

Usage:  docker network connect [OPTIONS] NETWORK CONTAINER

# Connect a container to a network
# We can only specify the IP address to a user created network not the orig bridge
# also connecting it does not disconnect it from its current network
docker container inspect --format="{{.NetworkSettings.Networks.bridge.IPAddress}}" testweb
172.17.0.2

# connect to new network
docker network connect --ip=192.168.1.10 devel0 testweb
docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS                NAMES
a2d8009856ea        httpd               "httpd-foreground"   7 minutes ago       Up 7 minutes        0.0.0.0:80->80/tcp   testweb

# check the bridge network for the container
docker container inspect --format="{{.NetworkSettings.Networks.bridge.IPAddress}}" testweb
172.17.0.2

# check the devel0 network for the container
docker container inspect --format="{{.NetworkSettings.Networks.devel0.IPAddress}}" testweb
192.168.1.10

# curl to see the web page in the container
curl 172.17.0.2
<html><body><h1>It works!</h1></body></html>

# curl to see the web page in the container
curl 192.168.1.10
<html><body><h1>It works!</h1></body></html>

# review the networks
docker container inspect testweb | grep IPAddress
            "SecondaryIPAddresses": null,
            "IPAddress": "172.17.0.2",
                    "IPAddress": "172.17.0.2",
                    "IPAddress": "192.168.1.10",

# Ok, let's remove the original bridge network on 172.17.0.2"
docker network disconnect bridge testweb

# review the change
docker container inspect testweb | grep IPAddress
"SecondaryIPAddresses": null,
"IPAddress": "",
        "IPAddress": "192.168.1.10",

# review the devel0 web page
craig@cn:~$ curl 192.168.1.10
<html><body><h1>It works!</h1></body></html>

# check the bridge
docker container inspect --format="{{.NetworkSettings.Networks.bridge.IPAddress}}" testweb
<no value>

# check the devel0
docker container inspect --format="{{.NetworkSettings.Networks.devel0.IPAddress}}" testweb
192.168.1.10

# clean up
docker stop testweb
testweb

docker network rm devel0
devel0

```

## Configure Docker for External DNS

There are two ways to override the default DNS settings for containers. In this lesson, we will demonstrate and confirm both of them.

This is for a single host, or DNS for the entire swarm.

### How DNS works on Linux (short version)

Our host's DNS is used in the containers unless we pass in something different.

```bash
# review the dns setting on centos
sudo cat /etc/resolv.conf
. genreated by /usr/sbin/dhclient-script
search mylabserver.com
nameserver 172.31.02

# mac os
#
# macOS Notice
#
# This file is not consulted for DNS hostname resolution, address
# resolution, or the DNS query routing mechanism used by most
# processes on this system.
#
# To view the DNS configuration used by this system, use:
#   scutil --dns
#
# SEE ALSO
#   dns-sd(1), scutil(8)
#
# This file is automatically generated.
#
nameserver 8.8.8.8
nameserver 8.8.4.4
```

### More Review

```bash

# Let's review DNS
cat /etc/resolv.conf
# Dynamic resolv.conf(5) file for glibc resolver(3) generated by resolvconf(8)
#     DO NOT EDIT THIS FILE BY HAND -- YOUR CHANGES WILL BE OVERWRITTEN
nameserver 127.0.1.1

# start a container and review the contents
docker run -d --name testweb httpd
23efd07100e0cfbaab80af1d94b605b289dcb4881125aa31873e626d829fbf18

# verify container is running
docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS               NAMES
23efd07100e0        httpd               "httpd-foreground"   3 seconds ago       Up 1 second         80/tcp              testweb

# check the dns setting in our container
# and you will see the dns has been passed in from the host
docker exec -it testweb /bin/bash
root@23efd07100e0:/usr/local/apache2# cat /etc/resolv.conf
# Dynamic resolv.conf(5) file for glibc resolver(3) generated by resolvconf(8)
#     DO NOT EDIT THIS FILE BY HAND -- YOUR CHANGES WILL BE OVERWRITTEN
nameserver 127.0.1.1

root@23efd07100e0:/usr/local/apache2# exit
exit

# clean up
docker stop testweb
dtestweb
docker rm testweb
testweb
```

### We can overide DNS on the cli at run time

> /etc/resolv.conf only supports 3 DNS servers

```bash

# We can overide this on the cli at run
docker run -d --name testweb --dns=8.8.8.8 --dns=8.8.4.4 httpd
32fa74e2dfc70694cf01c949cdc39928f7e02f545fdf153f8c0351c5484063b6

docker exec -it testweb /bin/bash
root@32fa74e2dfc7:/usr/local/apache2# cat /etc/resolv.conf
nameserver 8.8.8.8
nameserver 8.8.4.4
root@32fa74e2dfc7:/usr/local/apache2# exit
exit

# this is just for this one container
docker stop testweb
testweb

docker rm testweb
testweb
```

### DNS with `/etc/docker/daemon.json`

Make all containers on lauch use a diff DNS than the host at launch.

```bash
sudo vim /etc/docker/daemon.json
sudo cat /etc/docker/daemon.json
{
    "dns" : ["8.8.8.8", "8.8.4.4"]
}

# restart docker so the new config in daemon.json is picked up
sudo systemctl restart docker
docker run -d --name testweb httpd
e4074e66467732ad24b72ef3d050415215caaf9acd0345e389bc566e943c6258

# review the dns in the container
docker exec -it testweb /bin/bash
root@e4074e664677:/usr/local/apache2# cat /etc/resolv.conf 
nameserver 8.8.8.8
nameserver 8.8.4.4
root@e4074e664677:/usr/local/apache2# exit
exit

# Use daemon.json to set it for all containers
# Or for each individual containers
```

## Publish a Port So That an Application Is Accessible Externally and Identify the Port and IP It Is On

```bash
# run container
# use the flag -P to map a containers exposed ports to random port on host 
# random port will be above 32768
# you can't pick the rand port #
docker run -d --name testweb httpd
dd83f2205e878c6532841c312005da49320883f6a7aa7a7399a1903d41f286f1

craig@cn:~$ docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS               NAMES
dd83f2205e87        httpd               "httpd-foreground"   2 seconds ago       Up 1 second         80/tcp              testweb

docker stop testweb
docker rm testweb
```

### -P

```bash
# map exposed ports to random port above 32768 using -P
docker run -d --name testweb -P httpd
0f80579a55ba2cf63d26637953f920fbdd392799b3fc245cfec6e969902235a7

docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS                   NAMES
0f80579a55ba        httpd               "httpd-foreground"   2 seconds ago       Up 1 second         0.0.0.0:32768->80/tcp   testweb

curl localhost:32768
<html><body><h1>It works!</h1></body></html>


# inspect the container to find the IP address
docker container inspect testweb | grep IPAddress
            "SecondaryIPAddresses": null,
            "IPAddress": "172.17.0.2",
                    "IPAddress": "172.17.0.2",

# we can get more specific with the --format
docker container inspect  --format="{{.NetworkSettings.Networks.bridge.IPAddress}}" testweb
172.17.0.2

# if we were connected to another network we would swap that birdge with our own network
# this makes the application avail to anyone on our network 172.17.0.2:32768
docker stop testweb
dotestweb
docker rm testweb
testweb
```

### --publish 80:80

```bash
# explicit maping of ports
docker run -d --name testweb --publish 80:80 httpd
219b548b3aee8708785063319f22b446385b2d67a0a508f288f6fda3581d2561

# verify
docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS                NAMES
219b548b3aee        httpd               "httpd-foreground"   5 seconds ago       Up 5 seconds        0.0.0.0:80->80/tcp   testweb

curl localhost
<html><body><h1>It works!</h1></body></html>

# check again
craig@cn:~$ docker container inspect  --format="{{.NetworkSettings.Networks.bridge.IPAddress}}" testweb
172.17.0.2
```

### -publish 5901:80

```bash
# map to another port for another container testweb2
craig@cn:~$ docker run -d --name testweb2 --publish 5901:80 httpd
17565d7bd0fb723f19d1bab0b933b34aa59924bfed2fb0eed6f4a2cafba7a5d5

# verify container is up
docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED              STATUS              PORTS                  NAMES
17565d7bd0fb        httpd               "httpd-foreground"   4 seconds ago        Up 2 seconds        0.0.0.0:5901->80/tcp   testweb2
219b548b3aee        httpd               "httpd-foreground"   About a minute ago   Up About a minute   0.0.0.0:80->80/tcp     testweb

# check the ip address
docker container inspect  --format="{{.NetworkSettings.Networks.bridge.IPAddress}}" testweb2
172.17.0.3

# check the web page
curl localhost:5901
<html><body><h1>It works!</h1></body></html>

# clean up
docker stop testweb
testweb
docker stop testweb2
testweb2
docker rm testweb
testweb
docker rm testweb2
testweb2
```

## Deploy a SERVICE on a Docker overlay network

The overlay network is a network that allows containers within a swarm to communicate across it. We will create the overlay, watch how it is propagated across our cluster, identify the IPs on each node's container instances, and verify they can communicate with it.

Make sure you have a swarm already initialized up and running on this host.

```bash
# create an overlay network, C range
docker network create --driver=overlay --subnet=192.168.1.0/24 overlay_example

docker network ls
NETWORK ID          NAME                DRIVER              SCOPE
3dfea661473c        bridge              bridge              local
bb40db4af280        devel0              bridge              local
bd3cdee9ee3b        docker_gwbridge     bridge              local
c2194805c103        host                host                local
svr2501tmbiw        ingress             overlay             swarm
317edff763f3        none                null                local
uj9uturci2tu        overlay_example     overlay             swarm

docker network inspect overlay_example
[
    {
        "Name": "overlay_example",
        "Id": "uj9uturci2tu35q56gkkpsiig",
        "Created": "2018-08-15T13:59:47.3289886Z",
        "Scope": "swarm",
        "Driver": "overlay",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": null,
            "Config": [
                {
                    "Subnet": "10.10.1.0/24",
                    "Gateway": "10.10.1.1"
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


# If you run docker network ls on each node, you will not see overlay0
# you first need to create a service to use this network
# and then this network will be transfered to each of the nodes
docker service create --name testweb -p 80:80 --network=overlay_example --replicas 2  httpd
7lmrliea83gryeii41jczpmhs
overall progress: 2 out of 2 tasks
1/2: running   [==================================================>]
2/2: running   [==================================================>]
verify: Service converged


# List containers
# check the service instances running
docker service ps testweb
ID                  NAME                IMAGE               NODE                    DESIRED STATE       CURRENT STATE            ERROR               PORTS
44v0hdujq5fm        testweb.1           httpd:latest        linuxkit-025000000001   Running             Running 29 seconds ago
sqeodj9j0pg0        testweb.2           httpd:latest        linuxkit-025000000001   Running             Running 29 seconds ago

# review the running containers on this host
docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS               NAMES
25691df0e486        httpd:latest        "httpd-foreground"   2 minutes ago       Up 2 minutes        80/tcp              testweb.2.sqeodj9j0pg07lmueq523gf4q
3f3e55f4342e        httpd:latest        "httpd-foreground"   2 minutes ago       Up 2 minutes        80/tcp              testweb.1.44v0hdujq5fmb9ww4heqb4u0u

# review the inner workings on one container in the cluster/swarm
docker exec -it 25691df0e486 /bin/bash
root@1f67efd0710a:/usr/local/apache2# exit
exit

# review the IPAddresses on each container
docker container inspect 25691df0e486 | grep IPAddress
            "SecondaryIPAddresses": null,
            "IPAddress": "",
                    "IPAddress": "10.255.0.42",
                    "IPAddress": "10.10.1.5",


# review the IPAddresses on each container
docker container inspect 3f3e55f4342e | grep IPAddress
            "SecondaryIPAddresses": null,
            "IPAddress": "",
                    "IPAddress": "10.255.0.41",
                    "IPAddress": "10.10.1.4",

```

### Can these containers see each other

Can we ping on container from the other, since the containers are on the same network?

Overlay allows all the containers in the swarm to communicate over this overlay network.

Yes!

```bash
# Overlay allows inter-container communication over this ip range instead of external
ping 192.168.1.4
PING 192.168.1.4 (192.168.1.4) 56(84) bytes of data.
^C
--- 192.168.1.4 ping statistics ---
3 packets transmitted, 0 received, 100% packet loss, time 2031ms

docker exec -it 25691df0e486 /bin/bash
root@1f67efd0710a:/usr/local/apache2# ping 10.10.1.4
PING 192.168.1.4 (192.168.1.4) 56(84) bytes of data.
64 bytes from 192.168.1.4: icmp_seq=1 ttl=64 time=0.208 ms
64 bytes from 192.168.1.4: icmp_seq=2 ttl=64 time=0.105 ms
64 bytes from 192.168.1.4: icmp_seq=3 ttl=64 time=0.093 ms

craig@cn:~$ # The last was us pinging the GATEWAY
craig@cn:~$ # OVERLAY IS GOOD FOR INTER CONTAINER NETWORK COMMUNICATION


# clean up
docker service rm testweb
docker network rm overlay_example
```

## Describe the built in network drivers and the use cases for each and detail the differecnes betweek host and ingress network port publishing mode

Types

- Bridge
- None
- Host
- Overlay
- Ingress
- Docker Gateway Brigde

### Bridge (default)

- Simple to understand, use and troubleshoot, and is the **default** on stand-alone Docker hosts.
- Consists of a private network that is internal to the host system; all containers implemented on this host using Bridge networking can communicate.
- External access is granted by port exposure of the container’s services and accessed by the host OR static routes added with the host as the gateway for that network.
- Typically 172.17.0.X

### None (null)

- Used when the container(s) in question need absolutely no networking access at all.
- Containers operating on this driver can only be accessed on the host they are running on.
- These containers can be attached directly (using ‘docker attach [containerid]’) or executing by another command on the running container (using ‘docker exec -it [containerid] [command]).
- Not commonly used.

### Host

- Sometimes referred to as ‘Host Only Networking’.
- Only accessible via the underlying host.
- Access to services can only be provided by exposing container service ports to the host system.

### Overlay (default for swarm)

- Allows communication among all Docker Daemons that are participating in a Swarm.
- It is a **Swarm Scope** driver in that it extends itself (building previously non-existent networks on Workers if needed) to all daemons in the Swarm cluster.
- Allows the communication of multiple services that may have replicas running on any number of Workers in the Swarm, regardless of their origination or destination.
- Default mode of Swarm communication.

> DefaultSwarms need to run over Overlay and Overlay2

### Ingress

- Special **overlay network** that load balances network traffic amongst a given service’s working nodes.
- Maintains a list of all IP addresses from nodes that participate in that service (using the IPVS module) and when a request comes in, routes to one of them for the indicated service.
- Provides the ‘routing mesh’ that allows services to be exposed to the external network without having a replica running on every node in the Swarm.

> Extended across all the nodes in the cluster so it can route requests.

If we only have 3 nodes up (node1, node2, node3), and only one worker on node1 running a web site, we can still reach into the cluster using any of the nodes since the ingress will handling the routing.

Example:

curl node2 or curl node3 will still bring up the web site on worker node1, even though node2 and node3 don't have any workers yet.  The ingress network handles the routing for us, because it keeps track the network and nodes.

### Docker Gateway Bridge

DNS is pass through.. this is why it needs physical access of the host.

- Special bridge network that allows overlay networks (including Ingress) access to an individual Docker daemon’s physical network.
- Every container run within a service is connected to the local Docker daemon’s host network.
- Automatically created when a Swarm is initialized or joined.

docker swarm init --advertise-addr

docker swarm join-token $TOKEN:IPAddress

### Two types of port publishing modes: Host & Ingress

#### Hosts Question

• Ports for containers are only available on the underlying host system and are NOT available for services outside of the host where that instance exists.
• Used in single host environments or in environments where you need complete control over routing.

> You are responsible for knowing where all instances are at all times, controlled with ‘mode=host’ in deployment.

#### Ingress Question

• Since it is responsible for ‘routing mesh’, it makes all published ports available on all hosts (nodes or Workers) participating in the cluster so that the service is accessible from every node regardless of whether there is a service replica running on it at any given time.

> Ingress takes care of knowing where everything is and routes traffic for you.

You can use any node to hit a service b/c of the ingress network.

We may be asked about one or the other on test.

## Troubleshoot Container and Engine Logs to Understand Connectivity Issues Between Containers

### Centos Troubleshooting

```bash

# Docker daemon
#logs stored here
/var/log/messages
ubunutu
/var/log/daemon
--

# search the messages
sudu su -
cd /var/log
cat /var/log/messages | grep [dD]ocker
# if you expect 3 nodes, but only see 2 joining look for errors on the missing node
# joining, starts, stops, swarms, ip, network ...
# connectivity messages... all logged here
# lots of info in the log file

# example to look at docker container logs
docker run -d --name myweb httpd

# docker container logs CONTAINER
# this is all inside of the container, not much to see outside of the container
docker container logs myweb
AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 172.17.0.2. Set the 'ServerName' directive globally to suppress this message
AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 172.17.0.2. Set the 'ServerName' directive globally to suppress this message
[Wed Aug 15 14:32:58.099954 2018] [mpm_event:notice] [pid 1:tid 140279824066432] AH00489: Apache/2.4.34 (Unix) configured -- resuming normal operations
[Wed Aug 15 14:32:58.100137 2018] [core:notice] [pid 1:tid 140279824066432] AH00094: Command line: 'httpd -D FOREGROUND'

# clean up
docker ps
docker stop myweb
docker rm myweb

# service example
docker service create --name testweb -p 80:80 httpd
docker service update --replicas 3 testweb

# docker service logs
# aggregate of all the logs files sent to the docker service log files... so all workers
docker service logs testweb
testweb.1.9lruignhrid3@linuxkit-025000000001    | AH00557: httpd: apr_sockaddr_info_get() failed for 893305b01c03
testweb.1.9lruignhrid3@linuxkit-025000000001    | AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 127.0.0.1. Set the 'ServerName' directive globally to suppress this message
testweb.2.j5jkakg5s3po@linuxkit-025000000001    | AH00557: httpd: apr_sockaddr_info_get() failed for 8e71c918cb89
testweb.3.mf3mcacu96al@linuxkit-025000000001    | AH00557: httpd: apr_sockaddr_info_get() failed for b6dd2f9d3c2b
testweb.1.9lruignhrid3@linuxkit-025000000001    | AH00557: httpd: apr_sockaddr_info_get() failed for 893305b01c03
testweb.1.9lruignhrid3@linuxkit-025000000001    | AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 127.0.0.1. Set the 'ServerName' directive globally to suppress this message
testweb.2.j5jkakg5s3po@linuxkit-025000000001    | AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 127.0.0.1. Set the 'ServerName' directive globally to suppress this message
testweb.3.mf3mcacu96al@linuxkit-025000000001    | AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 127.0.0.1. Set the 'ServerName' directive globally to suppress this message
testweb.3.mf3mcacu96al@linuxkit-025000000001    | AH00557: httpd: apr_sockaddr_info_get() failed for b6dd2f9d3c2b
testweb.1.9lruignhrid3@linuxkit-025000000001    | [Wed Aug 15 14:34:33.177101 2018] [mpm_event:notice] [pid 1:tid 139843953330048] AH00489: Apache/2.4.34 (Unix) configured -- resuming normal operations
testweb.2.j5jkakg5s3po@linuxkit-025000000001    | AH00557: httpd: apr_sockaddr_info_get() failed for 8e71c918cb89
testweb.2.j5jkakg5s3po@linuxkit-025000000001    | AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 127.0.0.1. Set the 'ServerName' directive globally to suppress this message
testweb.1.9lruignhrid3@linuxkit-025000000001    | [Wed Aug 15 14:34:33.177259 2018] [core:notice] [pid 1:tid 139843953330048] AH00094: Command line: 'httpd -D FOREGROUND'
testweb.3.mf3mcacu96al@linuxkit-025000000001    | AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 127.0.0.1. Set the 'ServerName' directive globally to suppress this message
testweb.2.j5jkakg5s3po@linuxkit-025000000001    | [Wed Aug 15 14:34:47.531907 2018] [mpm_event:notice] [pid 1:tid 140429836810112] AH00489: Apache/2.4.34 (Unix) configured -- resuming normal operations
testweb.3.mf3mcacu96al@linuxkit-025000000001    | [Wed Aug 15 14:34:47.725304 2018] [mpm_event:notice] [pid 1:tid 140154537412480] AH00489: Apache/2.4.34 (Unix) configured -- resuming normal operations
testweb.3.mf3mcacu96al@linuxkit-025000000001    | [Wed Aug 15 14:34:47.725864 2018] [core:notice] [pid 1:tid 140154537412480] AH00094: Command line: 'httpd -D FOREGROUND'
testweb.2.j5jkakg5s3po@linuxkit-025000000001    | [Wed Aug 15 14:34:47.532045 2018] [core:notice] [pid 1:tid 140429836810112] AH00094: Command line: 'httpd -D FOREGROUND'

# review specific container... when we have an issue
# AH00557: httpd: apr_sockaddr_info_get() failed for 8e71c918cb89
docker container logs b6dd2f9d3c2b


# clean up
docker service rm testweb
```

## Understanding the Container Network Model (CNM)

The Container Network Model is the core of how Docker networks are handled and address spaces are tracked and provisioned. 

In regards to networks: what that means and how it is implemented.

Implementation that formalizes how networking for containers is provided while allowing abstractions that are used to support multiple network drivers. It is built on three main components:
Components

### Sandbox

Encompasses the network stack configuration, including management of interfaces, routing and DNS of 1 to N endpoints on 1 to N networks.

### Endpoint

Interfaces, switches, ports, etc and belong to only one network at a time

### Network

A collection of endpoints that can communicate directly (bridges, VLANS, etc) and can consist of 1 to N endpoints

[Container Network Model](container_network_model.png)

The CNM and Docker Daemon interface at multiple points in a container’s lifecycle depending on its implementation as a single container, single host or a multi-replica service communicating in an overlay across a Docker Swarm cluster.

Objects inside the network model include:
• Network Controller
• Driver
• Network
• Endpoint
• Sandbox

Each of those having (potentially) options and labels, and interacting with each other as specified.

### Docker Networking and IPAM (Internet Protocol Address Management)

Managing addresses across multiple hosts on separate physical networks while providing routing to the underlying swarm networks externally is ‘the IPAM problem’ for Docker (and any other container cluster management system).

Depending on the network driver chose, IPAM is handled at different layers in the stack.

On a single host, IPAM is not as challenging and routing is generally handled manually or through port exposure and each network is specific to the host system.

Network drivers enable IPAM through DHCP drivers or plugin drivers so that complex implementations support what would normally be overlapping addresses.

## Understand and Describe the Traffic Types that Flow Between the Docker Engine, UCP and DTR

> SHOULD ANY OF THIS BE MEMORIZED

- Docker Engine
- Universal Control Plane
- Docker Trusted Registry

[Communication Traffic](comm_traffic.png)

### UCP Components (Manager)

|UCP Component | Description|
|--------------|------------|
|ucp-agent | Monitors the node and ensures the right UCP services are running.|
|ucp-reconcile | When the agent detects the node is not running correct components, it has the container convert to the desired |state.|
|ucp-auth-api | Centralized service for identity and authentication used by UCP and DTR.|
|ucp-auth-store | Stores authentication configurations and data for users, organizations, and teams.|
|ucp-auth-worker | Performs scheduled LDAP sync (when configured) and cleans authentication and authorization data.|
|ucp-client-root-ca | Certificate authority to sign client bundles.|
|ucp-cluster-root-ca | Certificate authority used for TLS communication between UCP components.|
|ucp-controller | UCP Web Server.|
|ucp-dsinfo | Docker system information collection script to assist with troubleshooting.|
|ucp-kv | Used to store the UCP configurations (internal use only).|
|ucp-metrics | Used to collect and process metrics for a node (i.e. disk available).|
|ucp-proxy | A TLS proxy that allows the local Docker Engine secure access to the UCP components.|
|ucp-swarm-manager | Used to provide backwards-compatibility with Docker Swarm.|

### UCP Components (Workers)

|UCP Component | Description|
|--------------|------------|
|ucp-agent | Monitors the node and ensures the right UCP services are running.|
|ucp-dsinfo | Docker system information collection script to assist with troubleshooting.|
|ucp-reconcile | When the agent detects the node is not running correct components, it has the container convert to the desired |state.|
|ucp-proxy | A TLS proxy that allows the local Docker Engine secure access to the UCP components.|

Communication between the Docker Engine, UCP, and DTR can happen:

• Over TCP/UDP – depends on the port and whether a response is required or if the message is a notification.
• IPC – services on the same node can use IPC to communicate amongst each other.
• API – will take place over TCP (of course), but uses the API directly to query and update the components across the entire cluster.

## Exposing Ports to Your Host System

```bash
# Using the appropriate Docker CE commands, download the latest 'nginx' webserver image from Docker Hub.

docker pull nginx
Using default tag: latest
latest: Pulling from library/nginx
e7bb522d92ff: Pull complete
0f4d7753723e: Pull complete
91470a14d63f: Pull complete
Digest: sha256:edc8182581fdaa985a39b3021836aa09a69f9b966d1a0ff2f338be6f2fbfe238
Status: Downloaded newer image for nginx:latest

# Instantiate a container based on the 'nginx' image from the previous step. This container should have the following characteristics:
#  * when started, the container should run in 'detached' mode
#  * name the container 'nginxtest'
#  * use the appropriate option to allow Docker to map all container service ports to random host ports over 32768
#  * the container is based on the 'nginx' image from step one
docker run -d --name nginxtests -P nginx
590b38619f5db236b2ee77d2594ec23da0d7a041c80a86c7c29ad56abb0f8885

# Verify the container is running and find the host port that is mapped to the web server's port 80
docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                   NAMES
590b38619f5d        nginx               "nginx -g 'daemon ..."   31 seconds ago      Up 30 seconds       0.0.0.0:32768->80/tcp   nginxtests

# Using any tool you wish, verify that the default site page is served (NOTE: use the cloud server's PRIVATE ADDRESS for your testing)
curl localhost: 32768
```

## Create a Docker Service on Your Swarm and Expose Service Ports to Each Host

You will be using a THREE NODE Docker Swarm (a Single Manager and Two Worker Nodes). If you do not have that set up at this point, please see the exercise in doing so or complete that setup before you begin this exercise.
The tasks that need to be completed include the following:

```bash

# Create a service on your cluster that meets the following requirements:
#  * name the service 'testweb'
#  * map the service web port of 80 to the underlying service hosts port of 80
#  * base it on the 'httpd' service above
#  * initialize the service with three replicas
docker service create --name testweb -p 80:80 --replicas 3 httpd
xeyuhxsv2j5uyt9rsv3uj3ue9

# Verify the service is running
docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
xeyuhxsv2j5u        testweb             replicated          3/3                 httpd:latest        *:80->80/tcp

# List the all nodes and verify replicas are running on all three
docker service ps testweb
ID                  NAME                IMAGE               NODE                    DESIRED STATE       CURRENT STATE            ERROR               PORTS
qfbrk9v1tl4l        testweb.1           httpd:latest        tcox4.mylabserver.com   Running             Running 59 seconds ago
omuirsvknr6m        testweb.2           httpd:latest        tcox5.mylabserver.com   Running             Running 28 seconds ago
0fey7m5i4dkd        testweb.3           httpd:latest        tcox6.mylabserver.com   Running             Running 58 seconds ago

# Using whatever method you choose, check that the default site in the service is being served when you check port 80 on all three nodes
curl http://server1 http://server2 http://server3
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

## Utilize External DNS With Your Containers

Your company's DNS servers are having issues but you need to launch a web container that can resolve outside named resources. Your tasks are as follows:

Using the Docker base image for Ubuntu, create a container with the following characteristics:

- Interactive
- Attached to Terminal
- Using Google Public DNS
- Named 'mycontainer1'

```bash

# Start a container,and notice it uses the nameserver from the host
# note, my laptop is already set to 8.8.8.8 LOL
docker container run -it --name mycontainer1 --dns 8.8.8.8 ubuntu
root@fa6b1f65e621:/# cat /etc/resolv.conf
search mylabserver.com
nameserver 8.8.8.8
root@fa6b1f65e621:/# exit
exit
 
# Exit the container from Step #1. Using the Docker base image for Ubuntu, create a container with the following characteristics:
#  - Interactive
#  - Attached to Terminal 
#  - Using Google Public DNS
#  - Using Domain Search "mydomain.local"
#  - Named 'mycontainer2'
docker container run -it --name mycontainer2 --dns 8.8.8.8 --dns-search "mydomain.local" ubuntu

root@64892f5624cb:/# cat /etc/resolv.conf
search mydomain.local
nameserver 8.8.8.8
root@64892f5624cb:/# exit
exit

# Exit the container from Step #2. List all the containers. List all characteristics inspected from 'mycontainer2' and then remove and verify removal of all containers.
docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED              STATUS                          PORTS               NAMES
64892f5624cb        ubuntu              "/bin/bash"         About a minute ago   Exited (0) About a minute ago                       mycontainer2
fa6b1f65e621        ubuntu              "/bin/bash"         3 minutes ago        Exited (0) 2 minutes ago

# inspect the container
docker container inspect mycontainer2
[
    {
        "Id": "64892f5624cb257063987203b8985a15039e14b0e4ad1b12ab651f6a84bc74b6",
        "Created": "2017-12-21T18:12:42.598971852Z",
        "Path": "/bin/bash",
        "Args": [],
        "State": {
            "Status": "exited",
            "Running": false,
            "Paused": false,
            "Restarting": false,
            "OOMKilled": false,
            "Dead": false,
            "Pid": 0,
            "ExitCode": 0,
            "Error": "",
            "StartedAt": "2017-12-21T18:12:42.781703941Z",
            "FinishedAt": "2017-12-21T18:12:56.041500473Z"
        },
        "Image": "sha256:00fd29ccc6f167fa991580690a00e844664cb2381c74cd14d539e36ca014f043",
        "ResolvConfPath": "/var/lib/docker/containers/64892f5624cb257063987203b8985a15039e14b0e4ad1b12ab651f6a84bc74b6/resolv.conf",
        "HostnamePath": "/var/lib/docker/containers/64892f5624cb257063987203b8985a15039e14b0e4ad1b12ab651f6a84bc74b6/hostname",
        "HostsPath": "/var/lib/docker/containers/64892f5624cb257063987203b8985a15039e14b0e4ad1b12ab651f6a84bc74b6/hosts",
        "LogPath": "/var/lib/docker/containers/64892f5624cb257063987203b8985a15039e14b0e4ad1b12ab651f6a84bc74b6/64892f5624cb257063987203b8985a15039e14b0e4ad1b12ab651f6a84bc74b6-json.log",
        "Name": "/mycontainer2",
        "RestartCount": 0,
        "Driver": "overlay",
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
            "Dns": [
                "8.8.8.8"
            ],
            "DnsOptions": [],
            "DnsSearch": [
                "mydomain.local"
            ],
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
            "IOMaximumBandwidth": 0
        },
        "GraphDriver": {
            "Data": {
                "LowerDir": "/var/lib/docker/overlay/76e57b86561da0566062dbb9cb04fd2a57e80c3d9b420337c42a5b8063ea7c7f/root",
                "MergedDir": "/var/lib/docker/overlay/5516024b09144e76d012d02da6b2630e904e93dc5a543dbc6b451b895547dc54/merged",
                "UpperDir": "/var/lib/docker/overlay/5516024b09144e76d012d02da6b2630e904e93dc5a543dbc6b451b895547dc54/upper",
                "WorkDir": "/var/lib/docker/overlay/5516024b09144e76d012d02da6b2630e904e93dc5a543dbc6b451b895547dc54/work"
            },
            "Name": "overlay"
        },
        "Mounts": [],
        "Config": {
            "Hostname": "64892f5624cb",
            "Domainname": "",
            "User": "",
            "AttachStdin": true,
            "AttachStdout": true,
            "AttachStderr": true,
            "Tty": true,
            "OpenStdin": true,
            "StdinOnce": true,
            "Env": [
                "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
            ],
            "Cmd": [
                "/bin/bash"
            ],
            "ArgsEscaped": true,
            "Image": "ubuntu",
            "Volumes": null,
            "WorkingDir": "",
            "Entrypoint": null,
            "OnBuild": null,
            "Labels": {}
        },
        "NetworkSettings": {
            "Bridge": "",
            "SandboxID": "b76bc7be5a8408a09b4a00d32d6e2af567db24e9a7b641fcddb9f088ce81a9fd",
            "HairpinMode": false,
            "LinkLocalIPv6Address": "",
            "LinkLocalIPv6PrefixLen": 0,
            "Ports": {},
            "SandboxKey": "/var/run/docker/netns/b76bc7be5a84",
            "SecondaryIPAddresses": null,
            "SecondaryIPv6Addresses": null,
            "EndpointID": "",
            "Gateway": "",
            "GlobalIPv6Address": "",
            "GlobalIPv6PrefixLen": 0,
            "IPAddress": "",
            "IPPrefixLen": 0,
            "IPv6Gateway": "",
            "MacAddress": "",
            "Networks": {
                "bridge": {
                    "IPAMConfig": null,
                    "Links": null,
                    "Aliases": null,
                    "NetworkID": "4ba1c0249a8ccf3234a7fc768deb0db6ecf2b6621cc589d01c930ea25877b542",
                    "EndpointID": "",
                    "Gateway": "",
                    "IPAddress": "",
                    "IPPrefixLen": 0,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "MacAddress": "",
                    "DriverOpts": null
                }
            }
        }
    }
]

# clean up
docker stop mycontainer1
docker stop mycontainer2
docker rm `docker ps -a -q`
```

## Create a New Bridge Network and Assign a Container To It

Your development team would like a separate container test network on their Docker host to assign and test certain workloads. You have been asked to create one and verify it works as expected. Your tasks are as follows:

```bash
# Display existing Docker networks and names on your host
docker network ls
NETWORK ID          NAME                DRIVER              SCOPE
3092c22e2f99        bridge              bridge              local
5ee8aa70a57c        docker_gwbridge     bridge              local
d50effa7e823        host                host                local
koijigc21abd        ingress             overlay             swarm
1c1832dfeb9f        none                null                local

# Create a new network as follows:
#  * use the 'bridge' driver
#  * assigns IP addresses in the '192.168.1.0/24' network range
#  * uses a gateway address of 192.168.1.250
#  * called 'dev_bridge'
docker network create --driver=bridge --subnet=192.168.1.0/24 --gateway=192.168.1.250 dev_bridge
9172f9fed208df5717df937dc7d5e284ce6a32b2e7ce72ffeaa325c169fdb842

# Display all Docker networks on the host
docker network ls
NETWORK ID          NAME                DRIVER              SCOPE
3092c22e2f99        bridge              bridge              local
9172f9fed208        dev_bridge          bridge              local
5ee8aa70a57c        docker_gwbridge     bridge              local
d50effa7e823        host                host                local
koijigc21abd        ingress             overlay             swarm
1c1832dfeb9f        none                null                local

# Pull the 'httpd' image and install locally
docker pull httpd
Status: Downloaded newer image for httpd:latest

#Create a container called 'testweb' based on the image in the previous step as follows:
#  * assigned to new 'dev_bridge' network on start
docker run -d --name testweb --network=dev_bridge httpd
8d6ce33684248269da414fc3f8cd2b084ce6b7c787461278673637764c008a6a

# Using the appropriately formatted Docker command output, display the container's IP(s) to include the new network
docker container inspect --format="{{.NetworkSettings.Networks.dev_bridge.IPAddress}}" testweb
192.168.1.1
```

## Encryption of Networks in Docker

Reference: https://docs.docker.com/v17.09/engine/userguide/networking/overlay-security-model/

Overlay networking for Docker Engine swarm mode comes secure out of the box. The swarm nodes exchange overlay network information using a gossip protocol.

By default the nodes encrypt and authenticate information they exchange via gossip using the AES algorithm in GCM mode. Manager nodes in the swarm rotate the key used to encrypt gossip data every 12 hours.

You can also **encrypt data exchanged** between containers on different nodes on the overlay network. To enable encryption, when you create an overlay network pass the --opt encrypted flag:

> --opt encrypted flag | encrypt data exchanged between containers on different nodes on the overlay network

```bash
docker network create --opt encrypted --driver overlay my-multi-host-network
```

### docker network create [OPTIONS] NETWORK

Usage: docker network create [OPTIONS] NETWORK

Create a network

Options:
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

### To create an overlay network which can be used by swarm services or standalone containers to communicate with other standalone containers running on other Docker daemons, add the --attachable flag

> docker network create -d overlay --attachable my-attachable-overlay