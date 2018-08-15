# docker-quickstart

This is a collection of information used to learn docker.

## Outline

3 servers
Need a registry setup container, always running
Need a manager
Need at least 2 nodes for the swarm


### Cheat Sheet

Simple quick refernce of commands and notes to memorize.

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

### Examples

- https://docs.docker.com/compose/aspnet-mssql-compose/
- https://training.play-with-docker.com/alacart/

## References

- Installing Docker | https://docs.docker.com/install/
- http://containertutorials.com/volumes/get_started.html