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