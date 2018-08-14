# Installation & Configuration

## Complete Docker Installation on Multiple Platforms (CentOS/Red Hat)

```bash

# centos is more comprehensize sometimes but first step if make sure any docker is uninstalled
sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine

# use device-mapper storage system and lvm2
sudo yum install -y yum-utils device-mapper-persistent-data  lvm2

# add the new repo to yum
# if installing enterprise use:
#        https://download.docker.com/linux/centos/docker-ee.repo
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum update
sudo yum install docker-ce -y

# check the permission on the docker.sock file
# we want to run docker.ock as non-root
ls -al /var/run/docker.sock

# Check if group docker exists
sudo cat /etc/group | grep docker

# if docker ground is missing
# sdd docker group is the docker group is missing
sudo groupadd docker

# curent user as non-root to docker.sock
sudo usermod -aG  docker $USER

# Log out and log back in so that your group membership is re-evaluated.
exit
# log in your use name

# check which users are in the docker group
sudo cat /etc/group | grep docker

# Configure docker to run on boot
#sudo systemctl enable docker --create the sym link
#sudo systemctl start docker
#sudo systemctl status docker
sudo systemctl enable docker && sudo systemctl start docker && sudo systemctl status docker

```

## Complete Docker Installation on Multiple Platforms (Debian/Ubuntu)

```bash
sudo apt-get remove docker docker-engine docker.io
sudo apt-get update

sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

## pull to gpg key repo
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install docker-ce

sudo cat /etc/group | grep docker
sudo groupadd docker
sudo usermod -aG  docker $USER
```

## Selecting a Storage Driver

[compatibility-matrix](https://success.docker.com/article/compatibility-matrix)
[Docker Storage Drivers](https://docs.docker.com/storage/storagedriver/select-storage-driver/)

- afus is not officially supportted with debain
- devicemapper officailly supported on centos

Ideally, very little data is written to a container’s writable layer, and you use Docker volumes 
to write data. However, some workloads require you to be able to write to the container’s 
writable layer. This is where storage drivers come in.

overlay2 is preferred, followed by overlay. Neither of these requires extra configuration. 
overlay2 is the default choice for Docker CE.

```bash

# determine what our storage driver is
docker info | grep Storage
Storage Driver: overlay2

docker system info | grep Storage
Storage Driver: overlay2

```

### Ways to Change the storage driver

```bash
/etc/docker/daemon.json
sudo cat /etc/docker/daemon.json
```

Depends on your OS distribution, centos below

```json
{
        "storage-driver":"devicemapper"
}
```

After changing the storage driver you can do one of the following:

```bash
systemctl restart docker

# or
systemctl stop docker
systemctl start docker
```

Note:  If you change the storage-device, you will lose all your current images, unless you
back them up first, and re-import after the storage-driver has been changed.

### /var/lib/docker

```bash
# You should now see
cd /var/lib/docker/devicemapper

docker pull centos:6
# once we pull this image it will now use the devicemapper storage-driver

```

### Question

devicemapper is next, but requires **direct-lvm** for production environments,
because **loopback-lvm**, while zero-configuration, has very poor performance.

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

### Change the storage driver using the daemon.json

```bash
sudo su cd /etc/docker
# ls to review the folder structure
ls

# create the daemon.json file with the driver you want to use
sudo vi daemon.json
{
    "storage-driver": "devicemapper"
}
:wq
```

After making or edits.

```bash
# Restart docker
# You should do this before you create or import images
# Changing the storage driver after we create images - you will lose those images
systemctl stop docker
sysmctl start docker
cd /var/lib/docker
ls -ll
cd devicemapper
```

### Review the changes made for the storage-driver

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

## Configuring Logging Drivers (Syslog, JSON-File, etc.)

Docker uses json logs by default:

- none
- json (default)
- syslog
- journald
- gelf
- fluentd
- aws log
- splunk
- windows
- gcp logs

```bash
docker system info | grep Logging
Logging Driver: json-file

docker  info | grep Logging
Logging Driver: json-file
```

### Logging driver for running/stopped container

```bash
docker inspect -f '{{.HostConfig.LogConfig.Type}}' CONTAINERID
json-file
```

### none

Don't use a logging driver, with alpine image launching into ash (shell for alpine)

```bash
docker run -it --log-driver none alpine ash
```

### json

```json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m"
  }
}
```

```bash
docker run -–log-driver json-file --log-opt max-size=10m alpine echo hello world
```

### syslog

```json
{
  "log-driver": "syslog",
  "log-opts": {
    "syslog-address": "udp://1.2.3.4:1111"
  }
}
```

```bash
docker run -–log-driver syslog –-log-opt syslog-address=udp://1.2.3.4:1111 alpine echo hello world
```

### journald

```json
{
  "log-driver": "journald"
}
```

```bash
docker run --log-driver=journald ...
```

### Setup new syslog driver on centos

Uncomment 2 lines {$ModLoad imtcp, $InputTCPServerRun 514 }

```bash

# pull web service image so we can generate some logs
docker pull httpd
docker images

docker run -d --name testweb httpd
docker run -d --name testweb -p 80:80 httpd
docker ps
docker stop testweb
docker rm testweb

docker container inspect testweb | grep IPAddress

# get the logs for this docker host
# docker logs CONTAINERID, there is no just docker logs
# there is docker service logs SERVICEID
docker logs testweb
```

#### Setup Syslog to be the default.  Confirm if syslog is installed

```bash
cd /etc/
# rsyslog.conf will be here is syslog is installed

# we need to edit this .conf file to turn on syslog.
vi rsyslog.conf

# Provides TCP syslog reception
$ModLoad imtcp
$InputTCPServerRun 514
```

#### Start up syslog

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

#### Setup docker to use log-driver to write to rsyslog

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

# for this example let's wipe it clean
echo "" >> /var/log/messages

systemctl restart docker

# run a container
docker run -d -name testweb -p 80:80 httpd

# review we are getting messages
tail -f /var/log/messages

docker info | grep Logging
WARNING: devicemapper: usage of loopback devices is strongly discouraged for production use.
         Use `--storage-opt dm.thinpooldev` to specify a custom block storage device.
Logging Driver: syslog

Jul 22 01:39:15 craig-nicholsoneswlb1 dockerd: time="2018-07-22T01:39:15.339810481Z" level=error msg="Handler for GET /v1.38/containers/testweb/logs returned error: configured logging driver does not support reading"

docker stop testweb
docker rm testweb
```

QUESION:
Notice we get the warning where loopback devices are not production ready.
Use --storage-opt dm.thinpooldev` to specify a custom block storage device.

#### Run container with a log driver, overide the default driver

```bash
docker container run -d --name testweb --log-driver json-file -p 80:80 httpd
f6209c6fe44c57a448f656dc4850b812db718231d8ec1ab95116d6fd4dc676f6

docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS               NAMES
f6209c6fe44c        httpd               "httpd-foreground"   5 seconds ago       Up 4 seconds     
   80/tcp              test_log

```

Run some commands

```bash
 curl localhost
```

Review the logs

```bash
docker logs CONTAINERID
docker logs testweb

AH00558: httpd: Could not reliably determine the server\'s fully qualified domain name, using 172.17.0.2. Set the \'ServerName\' directive globally to suppress this message AH00558: httpd: Could not reliably determine the server\'s fully qualified domain name, using 172.17.0.2. Set the \'ServerName\' directive globally to suppress this message
[Sun Jul 22 01:43:18.975697 2018] [mpm_event:notice] [pid 1:tid 140311907870592] AH00489: Apache/2.4.34 (Unix) configured -- resuming normal operations
[Sun Jul 22 01:43:18.982186 2018] [core:notice] [pid 1:tid 140311907870592] AH00094: Command line: 'httpd -D FOREGROUND'

docket stop testweb
docker rm testweb
```

## Setting Up Swarm (Configure Managers)

### Setup One Manager

Intialize a swarm on this node, which is now a manager

```bash
docker swam init --advertise-addr 10.0.0.11
To add a worker to this swarm, run the following command:

    docker swarm join --token SWMTKN-1-146lxhb1sbm06h3kvzs3ha45l8jvnfrl1g1wt7rk1oad39mkrw-5c5uveacyu7svzff3kjckpnx5 192.168.65.3:2377

```

Worker - Run this on a manager or primary manager

```bash
docker swam join-token worker
To add a worker to this swarm, run the following command:

    docker swarm join --token SWMTKN-1-146lxhb1sbm06h3kvzs3ha45l8jvnfrl1g1wt7rk1oad39mkrw-5c5uveacyu7svzff3kjckpnx5 192.168.65.3:2377

```

Manager - Run on primary manager

```bash
To add a manager to this swarm, run the following command:

    docker swarm join --token SWMTKN-1-146lxhb1sbm06h3kvzs3ha45l8jvnfrl1g1wt7rk1oad39mkrw-0a9vfmt8qkb7qp53wa7admxam 192.168.65.3:2377

```

By the third dash... we have a difference in the token values
docker swarm join --token SWMTKN-1-146lxhb1sbm06h3kvzs3ha45l8jvnfrl1g1wt7rk1oad39mkrw-**5c5uveacyu7svzff3kjckpnx5** 192.168.65.3:2377
docker swarm join --token SWMTKN-1-146lxhb1sbm06h3kvzs3ha45l8jvnfrl1g1wt7rk1oad39mkrw-**0a9vfmt8qkb7qp53wa7admxam** 192.168.65.3:2377

## Setting Up Swarm (Add Nodes)

ssh or login to your node and copy and past the token for the worker or the manager or both.

Worker node joins a manager

```bash

docker swarm join --token SWMTKN-1-146lxhb1sbm06h3kvzs3ha45l8jvnfrl1g1wt7rk1oad39mkrw-5c5uveacyu7svzff3kjckpnx5 192.168.65.3:2377

```

review on the on manager with `docker system info`

```bash
docker system info | more
```

```bash
...
Swarm: active
 NodeID: pq82zxhf5mrukhotrf8gwcmlt
 Is Manager: true
 ClusterID: yio7zyxleuak0vayrap75tivc
 Managers: 1
 Nodes: 1
 Orchestration:
  Task History Retention Limit: 5
 Raft:
  Snapshot Interval: 10000
  Number of Old Snapshots to Retain: 0
  Heartbeat Tick: 1
  Election Tick: 10
 Dispatcher:
  Heartbeat Period: 5 seconds
 CA Configuration:
  Expiry Duration: 3 months
  Force Rotate: 0
 Autolock Managers: false
 Root Rotation In Progress: false
 Node Address: 192.168.65.3
 Manager Addresses:
  192.168.65.3:2377
  ...
```

```bash
docker node ls
```

tear down a swarm

```bash
docker swarm leave

Error response from daemon: You are attempting to leave the swarm on a node that is participating as a manager. Removing the last manager erases all current state of the swarm. Use `--force` to ignore this message.
```

## Setting Up a Swarm (Backup and Restore)

One of the most common administrative tasks on your plate every day is setting up backups and testing restores. Today, we will show you how to easily back up your swarm configuration AND state, and restore it to a completely different system to have it pick right up where it left off.

```bash
# see what we have running
docker service create --name backupweb -p 80:80 --replicas 2 httpd
uxz2ij8mqz3j410v6hxqkpajw

overall progress: 2 out of 2 tasks
1/2: running   [==================================================>]
2/2: running   [==================================================>]
verify: Service converged 

docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
uxz2ij8mqz3j        backupweb           replicated          2/2                 httpd:latest        *:80->80/tcp

docker service ps backupweb
ID                  NAME                IMAGE               NODE                    DESIRED STATE       CURRENT STATE            ERROR               PORTS
ah3z9ok8dne7        backupweb.1         httpd:latest        linuxkit-025000000001   Running             Running 14 seconds ago                       
yetgjgoo80xw        backupweb.2         httpd:latest        linuxkit-025000000001   Running             Running 14 seconds ago                       

```

Stop docker first

```bash
sudo systemctl stop docker
#docker ps will not show anyting on any of the nodes, only the manager knows what is going on
```

```bash
sudo -i

cd /var/lib/docker/swarm
# a few json files...
# raft logs, workers, managers
# all of this needs to be backed up

cp -rf /var/lib/docker/swarm /root/swarm

systemctl start docker
# docker will attempt to bring the services back up.

docker node ls
docker serivice
docker service ps backupweb
```

Tar up that directory, and now you can move to another node, that
has not been a member of this swarm before.

systemctl status docker
systemctl stop docker
systemctl start docker
docker node ls

Recover the swarm, re-init, and get back to our last good state.

Something like this...

```bash
cd /root/swarm

Remove the swarm directory on the other system...
/var/lib/docker/swarm

tar xvf swarm.tar > /var/lib/docker/swarm

systemctl start docker

docker swarm init --force-new-cluster

docker service ls
docker service ps backupweb
```

As long as we have healthy cluster and copy the swarm directory, you are
good to go.

## Outline the Sizing Requirements Prior to Installation

### General

- CPU, MEM, Disk
- Concurrency (load requirement at Peak and normal)
- UCP Universal Controle Plane
 -- Web UI
 -- Docker EE homegrown, cluster management system
 -- Managers / Worker Nodes

Breakdown for Manager Nodes for Fault Tolerance
(Nat, firewall, tcp and udp ports)

#### UCP Miniumu Rquirements

- 8GB RAM (Managers or DTR [docker trusted registry] Nodes)
- 4GB RAM Workers
- 3 GB Free Disk space

#### Production Requirement (Swarms, or cluster or swarms)

- 16GB RAM (Managers or DTR [docker trusted registry] Nodes)
- 4 vCPUs (Workers or DTR nodes)

#### Requirements (UCP, DTR, Docker EE)

- Raft consenus timesout of 3 sec, not config.
- Gossip 5 sec.

You have to be sure all nodes and managers are able to commmunicate
manager to manager in 3 seconds.  Should be able to send information across
any node within 5 seconds.

- etcd

Is set to 0.5 second, but is configurable.

You need to consider the speed of the network
Hop count between data centers.
Are we traveling over vpn, increasing the transient time.

### Docker EE (3 versions)

Docker EE Includes

- Docker Engine with Support
- Docker Trusted Registry (DTR)
- Universal Control Plane

Compatabiliy

- Docker Engine 17.06+
- DTR 2.3+
- UCP 2.2+

Recommendation

- Plan for Load Balancing
- User External Certificate Authoritiy for Production

## Set Up and Configure Universal Control Plane (UCP) and Docker Trusted Repository (DTR) for Secure Cluster Management

Although not a requirement for the certification exam, we will be walking through the installation and configuration of both UCP and DTR for use throughout portions of the remainder of the course.

https://linuxacademy.com/cp/courses/lesson/course/1376/lesson/9/completed/8/module/150

## Complete Backups for UCP and DTR

Backups of our newly minted UCP and DTR consoles are on the agenda. Let's take a look at how to get both of them backed up to a file that can be protected with our normal backup process.

You can to login to the container/server UCP is running and execute the commands.

### UCP Backup

```bash
# This is a transient container and we don't need the logs

docker container run --log-driver non --rm -i --name ucp \
        -v /var/run/docker.sock:/var/run/docker.sock \
        docker/upc backup > backup.tar

#shows the id we need, so we run again with the id.

docker container run --log-driver non --rm -i --name ucp \
        -v /var/run/docker.sock:/var/run/docker.sock \
        docker/upc backup --id m79885766GHFJ89898 > backup.tar

# stops UCP containers
# backs them up
# creates the tar file

```

Back up complete

```bash
ll
#see if .tar was created
tar tvf backup.tar

# restore
docker container run --log-driver non --rm -i --name ucp \
        -v /var/run/docker.sock:/var/run/docker.sock \
        docker/upc restore --id m79885766GHFJ89898 < backup.tar

# maybe save the back up somewhere else
# setup cron job to backup and save the backups
mv backup.tar backup-YYYY-MM-DD-HHMMSSS.tar
```

### DTR backup

```bash
docker run -i --rm docker/dtp backup --ucp-insecure-tls \
        --ucp-url https://tcox4.mylanbserver.com:443 \
        --ucp-sername admin > dtr.backup.tar

# check to see if back is writen to disk
ls -al

# check the contents
tar tvf dtr.backup.tar

# restore
docker run -i --rm docker/dtp backup --ucp-insecure-tls \
        --ucp-url https://tcox4.mylanbserver.com:443  \
        --ucp-username admin --ucp-password password < dtr.backup.tar


#that restores the dtr backup
```

## Create and Manage UCP Users and Teams

Now that we have our UCP system set up, we need to add some structure to the access and utilization. In this lesson, let's show you how to create a user and then assign that user to an Organization's team!

This is done in the EE UI web interface.

Teams

- QA Testers
 -- Add User
   -- QA User

Users can be members to 1 to n Organizations and/or Teams.  And Users will maintain
their roles in each Organization or Team.

## Namespaces & CGroups

Understanding what namespaces and cgroups are will further your overall understanding of how Docker (and containers in general) 'do what they do' behind the scenes. This lesson will give you an overview of both.

### namespaces

Namespaces provide isolation so that other parts fo the system remain unafffected
by whatever is within that namespace.

Docker users namespaces of various kinds to provide the isolation that containers
need in order to remain portable and refrain from affecting the reminader of the 
host system.

Namespaces Determine what a PID (process) can see.

- Data directories. (/data)
- Other processes (PIDs)
- Only see's it's on slice of the universe

Namepace Types

- process id (pid)
- mount (mnt)
- interprocess communication (ipc)
- User ID (user, currently experimental in Docker 1.2) - remap users from container to underlying host.  Issue: this can break the other isolation with other containers.
- network (net)

Docker uses namespaces, network and pid for security

### cgroups

Determin what the PID can **USE**.  5GB Memory, 5 CPU's, etc...

Control Groups provide resource limitation and reporting capability within the container space. They allow granualar control over what host resources are allocated to the
containers and when they are allocated.

- CPU
- Memory
- Network Bandwidth
- Disk
- Priority

### Reservations

Amount of each dedicated to the container during heavy peak.

### Limit

Highest amount you will allow your container to use.