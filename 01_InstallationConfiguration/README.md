# Installation & Configuration

## Storage Driver

[Docker Storage Drivers](https://docs.docker.com/storage/storagedriver/select-storage-driver/)

Docker's Reference to the storage drivers by operating systems.

### Change Storage Driver

Depending on docker-ce or docker-ee and which OS the storage driver picked will allow for efficiencies.

- CentOS Supports - devicemapper
- BlockStorage Device is the actual disk

### Determine your docker storage adapter

Check what storage adapter is setup by default.

```bash
docker info
docker info | grep Storage
overlay2
```

Change the storage driver using the daemon.json

```bash
sudo su cd /etc/docker
# ls to review the folder structure
ls

# create the daemon.json file with the driver you want to use
sudo vi daemon.json
{
    "storage driver": "devicemapper"
}
:wq

# Restart docker
# You should do this before you create or import images
# Changing the storage driver after we create images - you will lose those images
systemctl stop docker
sysmctl start docker
cd /var/lib/docker
ls -ll
cd devicemapper
```

Review the changes

```bash
$ docker info | grep Storage
WARNING: devicemapper: usage of loopback devices is strongly discouraged for production use.
         Use `--storage-opt dm.thinpooldev` to specify a custom block storage device.
Storage Driver: devicemapper

# review the location where the storage driver is setup
ls -al /var/lib/docker/
total 8
drwx--x--x. 15 root root 4096 Jul 22 00:53 .
drwxr-xr-x. 49 root root 4096 Jul 21 22:19 ..
drwx------.  2 root root   23 Jul 21 22:19 builder
drwx------.  4 root root   87 Jul 21 22:19 buildkit
drwx------.  3 root root   19 Jul 21 22:19 containerd
drwx------.  2 root root    6 Jul 21 22:19 containers
drwx------.  4 root root   40 Jul 21 22:19 devicemapper
drwx------.  3 root root   25 Jul 21 22:19 image
drwxr-x---.  3 root root   18 Jul 21 22:19 network
drwx------.  4 root root   30 Jul 21 22:19 plugins
drwx------.  2 root root    6 Jul 22 00:53 runtimes
drwx------.  2 root root    6 Jul 21 22:19 swarm
drwx------.  2 root root    6 Jul 22 00:53 tmp
drwx------.  2 root root    6 Jul 21 22:19 trust
drwx------.  2 root root   24 Jul 21 22:19 volumes

ls -al /var/lib/docker/devicemapper/
total 4
drwx------.  4 root root   40 Jul 21 22:19 .
drwx--x--x. 15 root root 4096 Jul 22 00:53 ..
drwx------.  2 root root   32 Jul 21 22:19 devicemapper
drwx------.  2 root root   69 Jul 22 00:52 metadata

ls -al /var/lib/docker/devicemapper/devicemapper/
total 11336
drwx------. 2 root root           32 Jul 21 22:19 .
drwx------. 4 root root           40 Jul 21 22:19 ..
-rw-------. 1 root root 107374182400 Jul 21 22:19 data
-rw-------. 1 root root   2147483648 Jul 22 00:54 metadata

ls -al /var/lib/docker/devicemapper/devicemapper/data
-rw-------. 1 root root 107374182400 Jul 21 22:19 /var/lib/docker/devicemapper/devicemapper/data
```

Why are we running a container here?

```bash
docker image pull httpd
docker container run -d --name testweb httpd
372d863f15556126e5b4b6cf11fc35faa1cf47f8551203c64c770a90d7d88f04

docker container inspect testweb | grep IPAddr
            "SecondaryIPAddresses": null,
            "IPAddress": "172.17.0.2",
                    "IPAddress": "172.17.0.2",
yum install telnet elinks
yum install telnet elinks

```

### Setting up the container to log to rsyslog

https://en.wikipedia.org/wiki/Rsyslog

Uncomment 2 lines {$ModLoad imtcp, $InputTCPServerRun 514 }

```bash
vi rsyslog.conf

# Provides TCP syslog reception
$ModLoad imtcp
$InputTCPServerRun 514
```

Setup up rsyslog

```bash
systemctl start rsyslog
systemctl status rsyslog

rsyslog.service - System Logging Service
   Loaded: loaded (/usr/lib/systemd/system/rsyslog.service; enabled; vendor preset: enabled)
   Active: active (running) since Sun 2018-07-22 00:53:07 UTC; 25min ago
     Docs: man:rsyslogd(8)
           http://www.rsyslog.com/doc/
 Main PID: 1104 (rsyslogd)
    Tasks: 3
   Memory: 2.9M
   CGroup: /system.slice/rsyslog.service
           └─1104 /usr/sbin/rsyslogd -n
Jul 22 00:53:07 craig-nicholsoneswlb1.mylabserver.com systemd[1]: Starting System Logging Service...
Jul 22 00:53:07 craig-nicholsoneswlb1.mylabserver.com rsyslogd[1104]:  [origin software="rsyslogd" swVersion="8.24.0" x-pid="1104" x-info="http:/... start
Jul 22 00:53:07 craig-nicholsoneswlb1.mylabserver.com systemd[1]: Started System Logging Service.
Hint: Some lines were ellipsized, use -l to show in full."
```

Setup docker to use log-driver to write to rsyslog.  

Location of the daemon.json - /etc/docker/daemon.json

```bash
cd docker/
vim daemon.json
daemon.json
{
        "log-driver" : "syslog",
        "log-opts": {
                "syslog-address" : "udp://172.31.113.224:514"
        }
}

cd docker/
cat daemon.json
{
        "log-driver" : "syslog",
        "log-opts": {
                "syslog-address" : "udp://172.31.113.224:514"
        }
}
```

Restart Docker

```bash
systemctl restart docker
docker info | grep Logging
WARNING: devicemapper: usage of loopback devices is strongly discouraged for production use.
         Use `--storage-opt dm.thinpooldev` to specify a custom block storage device.
Logging Driver: syslog

Jul 22 01:39:15 craig-nicholsoneswlb1 dockerd: time="2018-07-22T01:39:15.339810481Z" level=error msg="Handler for GET /v1.38/containers/testweb/logs retur
ned error: configured logging driver does not support reading"
```

Run container with a log driver

```bash
docker container run -d --name test_log --log-driver json-file httpd
f6209c6fe44c57a448f656dc4850b812db718231d8ec1ab95116d6fd4dc676f6

docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS               NAMES
f6209c6fe44c        httpd               "httpd-foreground"   5 seconds ago       Up 4 seconds        80/tcp              test_log
```

Review the logs

```bash
docker logs test_log

AH00558: httpd: Could not reliably determine the server\'s fully qualified domain name, using 172.17.0.2. Set the \'ServerName\' directive globally to suppress this message AH00558: httpd: Could not reliably determine the server\'s fully qualified domain name, using 172.17.0.2. Set the \'ServerName\' directive globally to suppress this message
[Sun Jul 22 01:43:18.975697 2018] [mpm_event:notice] [pid 1:tid 140311907870592] AH00489: Apache/2.4.34 (Unix) configured -- resuming normal operations
[Sun Jul 22 01:43:18.982186 2018] [core:notice] [pid 1:tid 140311907870592] AH00094: Command line: 'httpd -D FOREGROUND'
```