# Container Networking with Networks

Using the details below, create a new Docker network named borkspace using the 192.168.10.0/24 network range, with the gateway IP address 192.168.10.250. Once the borkspace network is created, use it to launch a new app named treattransfer in interactive mode using the spacebones/nyancat:latest. Once the container is running, you should see a live view of Droolidian cadets running to the rescue!

> docker network ls


```bash
NETWORK ID          NAME                DRIVER              SCOPE
49c5d22d061a        bridge              bridge              local
675889a73672        host                host                local
e7de6905863c        none                null                local
```

> docker network inspect bridge

```json
[
    {
        "Name": "bridge",
        "Id": "49c5d22d061a13dac8fc22786cca18be8db23e12e0562fad78fd7242c7d3317f",
        "Created": "2018-08-08T08:41:13.257287999-04:00",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": null,
            "Config": [
                {
                    "Subnet": "172.17.0.0/16"
                }
            ]
        },
        "Internal": false,
        "Attachable": false,
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

Create the network

> docker network create --driver bridge --subnet=192.168.10.0/24 --gateway=192.168.10.250 borkspace

c43dfc94492a61206941f53e5c4c30e57c8f8c13372c1de4c14a61f52374d769

> docker network ls

```bash
NETWORK ID          NAME                DRIVER              SCOPE
c43dfc94492a        borkspace           bridge              local
49c5d22d061a        bridge              bridge              local
675889a73672        host                host                local
e7de6905863c        none                null                local
```

docker network inspect borkspace
```json
[
    {
        "Name": "borkspace",
        "Id": "c43dfc94492a61206941f53e5c4c30e57c8f8c13372c1de4c14a61f52374d769",
        "Created": "2018-08-08T08:54:20.962924618-04:00",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": {},
            "Config": [
                {
                    "Subnet": "192.168.10.0/24",
                    "Gateway": "192.168.10.250"
                }
            ]
        },
        "Internal": false,
        "Attachable": false,
        "Containers": {},
        "Options": {},
        "Labels": {}
    }
]
```

Run the container...

> docker run -it --name treatransfer --network=borkspace spacebones/nyancat

> docker rm `docker ps -a -q`

>  docker run -d --name treatransfer --network=borkspace spacebones/nyancat

> docker container inspect treatransfer | grep IPAddress
```bash
            "SecondaryIPAddresses": null,
            "IPAddress": "",
                    "IPAddress": "192.168.10.1",
```