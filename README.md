# docker-quickstart

This is a collection of information used to learn docker.

## Outline

### Good to Have Items

#### Local Linux distro on laptop/desktop or a cloud server

Gives you a chance to review the directories and poke around.  The directories and networking is a little different on macos and windows.

#### Three servers for testing swarms

Two servers are ok though.

- LinuxAcademy Servers
- AWS
- GCP
- Virtual Box
- Vagrant

#### Private Registry

Once you have this setup, leave it up.  

### Cheat Sheet

Quick reference of commands and notes to memorize.

[CheetSheet](cheetsheet.md)

### Docker Installation & Configuration

- [Centos](01_InstallationConfiguration/CENTOSINSTALL.md)
- [Ubuntu 16.04](01_InstallationConfiguration/UBUNTUINSTALL.md)

See references for operating system updates from Docker.

#### Storage

- [Select Storage Driver](01_InstallationConfiguration/README.md)

#### Logging

- [Configure Log Driver](01_InstallationConfiguration/README.md)
 -- syslog
 -- json
 -- etc

#### Swarm Setup

Example to setup swarm on two services.  Creating more worker nodes is just a repeat of the worker node instructions.

[Swarm Example](](01_InstallationConfiguration/Swarm/CENTOS_DOCKERSWARM.md))

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

-[Namespaces * Cgroups](01_InstallationConfiguration/NAMESPACESCGROUPS.md)

### Orchestration (25%, 13-14 questions)

Domain​ ​1:​ ​Orchestration​ ​(25%​ ​of​ ​exam)

#### Complete the setup of a swarm mode cluster, with managers and worker nodes

Manager Node - Node0, IP 10.0.1.1

```bash
docker swarm init --advertise-addr 10.0.1.1
Swarm initialized: current node (bvz81updecsj6wjz393c09vti) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join \
    --token SWMTKN-1-3pu6hszjas19xyp7ghgosyx9k8atbfcr8p2is99znpy26u2lkl-1awxwuwd3z9j1z3puu7rcgdbx \
    10.0.1.1:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.
```

Worker Node - Node1, IP 10.0.1.2

```bash
    docker swarm join \
    --token SWMTKN-1-3pu6hszjas19xyp7ghgosyx9k8atbfcr8p2is99znpy26u2lkl-1awxwuwd3z9j1z3puu7rcgdbx \
    10.0.1.1:2377
```

Worker Node - Node1, IP 10.0.1.3

```bash
    docker swarm join \
    --token SWMTKN-1-3pu6hszjas19xyp7ghgosyx9k8atbfcr8p2is99znpy26u2lkl-1awxwuwd3z9j1z3puu7rcgdbx \
    10.0.1.1:2377
```

#### State the differences between running a container vs running a service

##### Containers

- Encapsulate application or function
- Run on a single host
- Require manual steps to expose functionality outside of the host system (ports, network and volumes)
- More complex configuration to use multiple instance (proxies for example)
- Not highly available -  you can try to make the avialable with effort.
- Not easily scalable

##### Services - docker service (SWARM)

- Encapsulate application or function (same as container)

Differences

- Can run on '1 to n' nodes at any time
- Funtionality is easily accessed using features like **routing mesh** outside of the worker nodes
- Multiple instance set to launch in single command and can be scaled up or down with one command
- Highly available clusters available
- Easily scale, up or down as needed

#### Demonstrate steps to lock a swarm cluster

You can lock a swarm at `docker swarm init` or `docker swarm update`

```bash
docker swarm init --autolock=true --advertise-addr 192.168.99.121
```

Update a swarm to autolock after the swarm has already been initialized

```bash
docker swarm update --autolock=true
Swarm Updated
To unlock a swarm manager after it restarts, run the `docker swarm unlock`
command and provide the following key:

    SWMKEY-1-W1/S5oyCFoBvLwJ8OEOfLKfS5MdRNgUVRfQMiUjLYyo

Please remember to store this key in a password manager, since without it you
will not be able to restart the manager.
```

##### Recover from losing the quorum && Restore from a backup

If you need to drop all nodes and re-init a running swarm use this command.

Start Docker on the new node. Unlock the swarm if necessary. Re-initialize the swarm using the following command, so that this node does not attempt to connect to nodes that were part of the old swarm, and presumably no longer exist.

```bash
docker swarm init --force-new-cluster
```

##### Unlock the Swarm

```bash
docker swarm unlock
Please enter unlock key:
```

● Extend the instructions to run individual containers into running services under swarm
● Interpret the output of "docker inspect" commands
● Convert an application deployment into a stack file using a YAML compose file with
"docker stack deploy"
● Manipulate a running stack of services
● Increase # of replicas
● Add networks, publish ports
● Mount volumes
● Illustrate running a replicated vs global service
● Identify the steps needed to troubleshoot a service not deploying
● Apply node labels to demonstrate placement of tasks
● Sketch how a Dockerized application communicates with legacy systems
● Paraphrase the importance of quorum in a swarm cluster
● Demonstrate the usage of templates with "docker service create"

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

### Image Creation, Management, and Registry (20%, 11 questions)

Domain​ ​2:​ ​Image​ ​Creation,​ ​Management,​ ​and​ ​Registry​ ​(20%​ ​of​ ​exam)
Content may include the following:
● Describe Dockerfile options [add, copy, volumes, expose, entrypoint, etc)
● Show the main parts of a Dockerfile
● Give examples on how to create an efficient image via a Dockerfile
● Use CLI commands such as list, delete, prune, rmi, etc to manage images
● Inspect images and report specific attributes using filter and format
● Demonstrate tagging an image
● Utilize a registry to store an image
● Display layers of a Docker image
● Apply a file to create a Docker image
Modify an image to a single layer
● Describe how image layers work
● Deploy a registry (not architect)
● Configure a registry
● Log into a registry
● Utilize search in a registry
● Tag an image
● Push an image to a registry
● Sign an image in a registry
● Pull an image from a registry
● Describe how image deletion works
● Delete an image from a registry

### Installation and Configuration (15%, 8-9 questions)

Content may include the following:
● Demonstrate the ability to upgrade the Docker engine
● Complete setup of repo, select a storage driver, and complete installation of Docker
engine on multiple platforms
● Configure logging drivers (splunk, journald, etc)
● Setup swarm, configure managers, add nodes, and setup backup schedule
● Create and manager user and teams
● Interpret errors to troubleshoot installation issues without assistance
● Outline the sizing requirements prior to installation
● Understand namespaces, cgroups, and configuration of certificates
● Use certificate-based client-server authentication to ensure a Docker daemon has the
rights to access images on a registry
● Consistently repeat steps to deploy Docker engine, UCP, and DTR on AWS and on
premises in an HA config
● Complete configuration of backups for UCP and DTR
● Configure the Docker daemon to start on boot

### Networking (15%, 8-9 questions)

Create a Docker bridge network for a developer to use for their containers
● Troubleshoot container and engine logs to understand a connectivity issue between
containers
● Publish a port so that an application is accessible externally
● Identify which IP and port a container is externally accessible on
● Describe the different types and use cases for the built-in network drivers
● Understand the Container Network Model and how it interfaces with the Docker engine
and network and IPAM drivers
● Configure Docker to use external DNS
● Use Docker to load balance HTTP/HTTPs traffic to an application (Configure L7 load
balancing with Docker EE)
● Understand and describe the types of traffic that flow between the Docker engine,
registry, and UCP controllers
● Deploy a service on a Docker overlay network
● Describe the difference between "host" and "ingress" port publishing mode

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

### Security (15%, 8-9 questions)

● Describe the process of signing an image
● Demonstrate that an image passes a security scan
● Enable Docker Content Trust
● Configure RBAC in UCP
● Integrate UCP with LDAP/AD
● Demonstrate creation of UCP client bundles
● Describe default engine security
● Describe swarm default security
● Describe MTLS
● Identity roles
● Describe the difference between UCP workers and managers
● Describe process to use external certificates with UCP and DTR

- Describe the Process of Signing an Image and Enable Docker Content Trust
- Demonstrate That an Image Passes a Security Scan
- Identity Roles
- Configure RBAC and Enable LDAP in UCP
- Demonstrate Creation and Use of UCP Client Bundles and Protect the Docker Daemon With Certificates
- Describe the Process to Use External Certificates with UCP and DTR
- Describe Default Docker Swarm and Engine Security
- Describe MTLS

### Storage & Volumes (10%, 5-6 questions)

● State which graph driver should be used on which OS
● Demonstrate how to configure devicemapper
● Compare object storage to block storage, and explain which one is preferable when
available
● Summarize how an application is composed of layers and where those layers reside on
the filesystem
● Describe how volumes are used with Docker for persistent storage
● Identify the steps you would take to clean up unused images on a filesystem, also on
DTR
● Demonstrate how storage can be used across cluster nodes

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

### Additional Image ... stuff

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

### Examples

- https://docs.docker.com/compose/aspnet-mssql-compose/
- https://training.play-with-docker.com/alacart/

## References

- Installing Docker | https://docs.docker.com/install/
- http://containertutorials.com/volumes/get_started.html