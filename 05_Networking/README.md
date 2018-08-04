# Networking

## Create a Docker Bridge Network for a Developer to Use for Their Containers

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
craig@cn:~$ ^C
craig@cn:~$ pwd
/home/craig
craig@cn:~$ ^C
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
craig@cn:~$ 
