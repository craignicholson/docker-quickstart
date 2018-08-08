# docker-quickstart

This is a collection of information used to learn docker.

## Outline

### Cheat Sheet

Simple quick refernce of commands and notes to memorize.

[CheetSheet](cheetsheet.md)

### Docker Installation & Configuration

- [Centos](01_InstallationConfiguration/CENTOSINSTALL.md)
- Ubuntu 16.04

See references for operating system updates from Docker.

#### Storage

- Select Storage Driver

#### Logging

- Configure Log Driver
 -- syslog
 -- json
 -- etc

#### Swarm Setup

- Managers
- Add Nodes
- Remove Nodes
- promote node
- demote node
- backup & restore
- Sizing Requirements before Install

#### UCP & DTR

- Setup Universal Control Plane
- Configure UCP
- Docker Trusted Registry
- Backup UCP
- Backup DTR
- Manage UPC users and teams

#### namespaces & cgroups

### Image Creation, Management, and Registry

- Pulling Images
- Search via CLI for Image on Respository
- Tag Image

#### CLI Commands

 -- docker images
 -- docker rmi image IMAGEID
 -- docker prune -a --volumes
 -- etc..

#### Additional Image ... stuff

- Inspect Images and Report Specific Attributes Using Filter and Format
- Container Basics - Running, Attaching to, and Executing Commands in Containers
- Create an Image with Dockerfile
- Dockerfile Options, Structure, and Efficiencies (Part I)
- Dockerfile Options, Structure, and Efficiencies (Part II)
- Describe and Display How Image Layers Work
- Modify an Image to a Single Layer
- Selecting a Docker Storage Driver
- Prepare for a Docker Secure Registry
- Deploy, Configure, Log Into, Push, and Pull an Image in a Registry
- Managing Images in Your Private Repository
- Container Lifecycles - Setting the Restart Policies

### Orchestration

- State the Difference Between Running a Container and Running a Service
- Demonstrate Steps to Lock (and Unlock) a Cluster
- Extend the Instructions to Run Individual Containers into Running Services Under Swarm and Manipulate a Running Stack of Services
- Increase and Decrease the Number of Replicas in a Service
- Running Replicated vs. Global Services
- Demonstrate the Usage of Templates with 'docker service create'
- Apply Node Labels for Task Placement
- Convert an Application Deployment into a Stack File Using a YAML Compose File with 'docker stack deploy'
- Understanding the 'docker inspect' Output
- Identify the Steps Needed to Troubleshoot a Service Not Deploying
- How Dockerized Apps Communicate with Legacy Systems
- Paraphrase the Importance of Quorum in a Swarm Cluster

### Storage & Volumes

- State Which Graph Driver Should Be Used on Which OS
- Summarize How an Image Is Composed of Multiple Layers on the Filesystem
- Describe How Storage and Volumes Can Be Used Across Cluster Nodes for Persistent Storage
- Identify the Steps You Would Take to Clean Up Unused Images (and Other Resources) On a File System (CLI)
- Exercise: Creating and Working With Volumes
- Exercise: Using External Volumes Within Your Containers
- Exercise: Creating a Bind Mount to Link Container Filesystem to Host Filesystem
- Exercise: Display Details About Your Containers and Control the Display of Output
- Hands-on Labs: Working with the DeviceMapper Storage Driver
- Hands-on Labs: Configuring Containers to Use Host Storage Mounts

### Networking

- Create a Docker Bridge Network for a Developer to Use for Their Containers
- Configure Docker for External DNS
- Publish a Port So That an Application Is Accessible Externally and Identify the Port and IP It Is On
- Deploy a Service on a Docker Overlay Network
- Describe the Built In Network Drivers and Use Cases for Each and Detail the Difference Between Host and Ingress Network Port Publishing Mode
- Troubleshoot Container and Engine Logs to Understand Connectivity Issues Between Containers
- Understanding the Container Network Model
- Understand and Describe the Traffic Types that Flow Between the Docker Engine, Registry and UCP 
- Exercise: Exposing Ports to Your Host System
- Exercise: Create a Docker Service on Your Swarm and Expose Service Ports to Each Host
- Exercise: Utilize External DNS With Your Containers
- Exercise: Create a New Bridge Network and Assign a Container To It

### Security

- Describe the Process of Signing an Image and Enable Docker Content Trust
- Demonstrate That an Image Passes a Security Scan
- Identity Roles
- Configure RBAC and Enable LDAP in UCP
- Demonstrate Creation and Use of UCP Client Bundles and Protect the Docker Daemon With Certificates
- Describe the Process to Use External Certificates with UCP and DTR
- Describe Default Docker Swarm and Engine Security
- Describe MTLS

### Example Applications

- Exercise: Create a Swarm Cluster
- Exercise: Start a Service and Scale It Within Your Swarm
- Exercise: Demonstrate How Failure Affects Service Replicas in a Swarm
- Exercise: Reassign a Swarm Worker to Manager
- Hands-on Labs: Configure a Swarm and Scale Services Within Your Cluster

- Exercise: Creating and Working With Volumes
- Exercise: Using External Volumes Within Your Containers
- Exercise: Creating a Bind Mount to Link Container Filesystem to Host Filesystem
- Exercise: Display Details About Your Containers and Control the Display of Output
- Hands-on Labs: Working with the DeviceMapper Storage Driver
- Hands-on Labs: Configuring Containers to Use Host Storage Mounts

- Exercise: Exposing Ports to Your Host System
- Exercise: Create a Docker Service on Your Swarm and Expose Service Ports to Each Host
- Exercise: Utilize External DNS With Your Containers
- Exercise: Create a New Bridge Network and Assign a Container To It

## References

- Installing Docker | https://docs.docker.com/install/

### Examples

- https://docs.docker.com/compose/aspnet-mssql-compose/
- https://training.play-with-docker.com/alacart/

## CentOS script

```bash
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum update -y
yum install docker-ce -y
yum-complete-transaction --cleanup-only
systemctl enable docker && systemctl start docker && systemctl status docker
usermod -aG docker $USER
```

## CentOs Change Storage Driver

Depending on docker-ce or docker-ee and which OS the storage driver picked will allow for efficiencies.

- CentOS Supports - devicemapper
- BlockStorage Device - actual DISK

### Determine your docker storage adapter

```bash
docker info
docker info | grep Storage
overlay2
```

Change the storage driver

```bash
sudo su cd /etc/docker
# ls to review the folder structure
ls

# create the daemon.json file with the driver you want to use
sudo vi daemon.json
{ "storage driver": "devicemapper"}
:w
:q

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

### What's going on here... Setting up the container to log to rsyslog?

https://en.wikipedia.org/wiki/Rsyslog

Uncomment 2 lines {ModLoad imtcp,$InputTCPServerRun 514 }

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

todo: put in full path here...

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