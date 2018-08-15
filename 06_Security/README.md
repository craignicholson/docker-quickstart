# Security

## Describe the Process of Signing an Image and Enable Docker Content Trust

## Setup Registry

All images are implicitly trusted by your Docker daemon. However, there may be times that you want to ONLY allow working with a signed image. This lesson will show you how to configure your systems for trusting only image tags that have been signed.

[See setting up Registry Here](https://github.com/craignicholson/docker-quickstart/tree/master/02_ImageCreationManagementRegistry#prepare-for-a-docker-secure-registry-on-centos)

### Turn on docker content trust for a container

Process for signing an images is what we need to know for the certification.

Check to see if we can login to our registry

```bash
docker login myregistrydomain.com
Username (testuser): testuser
Password:
Login Succeeded
```

- Image is signed during the push process.

Create a Dockerfile we can use,

```bash
mkdir Dockerfiles
mkdir certs
mkdir auth
pwd
/home/user/Dockerfiles

cat Dockerfile
```

Sample Dockerfile

```Dockerfile
FROM busybox:latest
LABEL maintainer="admin@loclat.com"
ENV MYVAR = 1
EXPOSE 80
```

Build and Image and push to the private registry.  

The trust is implicit between the pull and push of images.  As long the certs between
registry and clients.

### DOCKER_CONTENT_TRUST

If using self-signed, you are out of luck.  Purchase a real key.

```bash
# build a container we can sign and push to registry
docker build -t myregistrydomain.com:5000/untrusted.latest .

#output
Sending build context to Docker daemon  3.072kB
Step 1/4 : FROM busybox:latest
latest: Pulling from library/busybox
Digest: sha256:cb63aa0641a885f54de20f61d152187419e8f6b159ed11a251a09d115fdff9bd
Status: Downloaded newer image for busybox:latest
 ---> e1ddd7948a1c
Step 2/4 : LABEL maintainer="admin@loclat.com"
 ---> Running in 16c5c7b822f2
Removing intermediate container 16c5c7b822f2
 ---> b052a5e11d1f
Step 3/4 : ENV MYVAR = 1
 ---> Running in ffcedade8b4c
Removing intermediate container ffcedade8b4c
 ---> 441429b7c0b3
Step 4/4 : EXPOSE 80
 ---> Running in ad3df79b5085
Removing intermediate container ad3df79b5085
 ---> f14d52f5a5a5
Successfully built f14d52f5a5a5
Successfully tagged myregisterydomain.com:5000/untrusted.latest:latest

# setup the DOCKER_CONTENT_TRUST environment variable
export DOCKER_CONTENT_TRUST=1
echo $DOCKER_CONTENT_TRUST
1

# push the image
docker push myregistrydomain.com:5000/untrusted.latest
f9d9e4e6e2f0: Pushed
latest: digest: sha256:9a71ddd7e18a7684e78ce3db226f904f678308b23f0a88b33a9879b6a4bf6fc6 size: 527
No tag specificed, skipping metadata push

# when signing and image, it is signed by tag. let's try again
# here we get the x509 error b/c of the self signed cert
# if this was not self-signed it would prompt you for the new root certificate that it will
# attach to the tag for signing that image
docker push myregistrydomain.com:5000/untrusted.latest:latest
The push refers to repository [myregistrydomain.com:5000/untrusted.latest]
f9d9e4e6e2f0: Layer already exists
latest: digest: sha256:9a71ddd7e18a7684e78ce3db226f904f678308b23f0a88b33a9879b6a4bf6fc6 size: 527
Signing and pushing trust metadata
Error: error contacting notary server: x509: certificate signed by unknown authority

# Turn this off for now 
export DOCKER_CONTENT_TRUST=0
```

> Use a valid CA - Certificate Authority in production!

We can now pull since `DOCKER_CONTENT_TRUST=0` because we don't care about trust anymore.

Client

```bash
docker rmi myregistrydomain.com:5000/untrusted.latest:latest
docker pull myregistrydomain.com:5000/untrusted.latest:latest
```

### Attempt to pull image from not trusted authority

Self Signed Certs will not work.  We need a valid CA.

```bash
export DOCKER_CONTENT_TRUST=1
docker pull myregistrydomain.com:5000/untrusted.latest:latest
Error: error contacting notary server: x509: certificate signed by unknown authority
```

### Implicit Trust of the Image

Set DOCKER_CONTENT_TRUST=0, to just leave us at implicit trust.

```bash
export DOCKER_CONTENT_TRUST=0
docker pull myregistrydomain.com:5000/untrusted.latest:latest
Downloaded newer image for myregistrydomain.com:5000/untrusted.latest:latest

docker images
# results
```

## Demonstrate that an Image Passes a Security Scan

Docker Cloud and Docker Hub offer you the ability to scan your private repository images for free (for now). 

We will tag an image and upload it to Docker Hub and then show you how to read the security scan results.

This uses Docker Hub to scan the image after we push the image.

> docker -tag busybox cnicholson/my-busybox

```bash
# create a tag for our own image for our docker hub account
docker -tag busybox cnicholson/my-busybox

# Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com to create one.
docker login
Username: cnicholson
Password:
WARNING! Your password will be stored unencrypted in /home/user/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store
Login Succeeded

docker images
REPOSITORY                                   TAG                 IMAGE ID            CREATED             SIZE
myregistrydomain.com:5000/untrusted.latest   latest              16d845c9ecba        31 minutes ago      1.16MB
cnicholson/my-busybox                        latest              e1ddd7948a1c        5 days ago          1.16MB
busybox                                      latest              e1ddd7948a1c        5 days ago          1.16MB
myregistrydomain.com:5000/my-busybox         latest              e1ddd7948a1c        5 days ago          1.16MB
httpd                                        latest              11426a19f1a2        5 days ago          178MB
ubuntu                                       latest              735f80812f90        10 days ago         83.5MB
registry                                     2                   b2b03e9146e1        4 weeks ago         33.3MB
```

> Create empty cnicholson/my-busybox on docker hub

### Push our tagged image

```bash
docker push cnicholson/my-busybox
The push refers to repository [docker.io/cnicholson/my-busybox]
f9d9e4e6e2f0: Mounted from library/busybox 
latest: digest: sha256:5e8e0509e829bb8f990249135a36e81a3ecbe94294e7a185cc14616e5fad96bd size: 527
```

Review it on hub.docker.  Note the security scan did not show on the web site for me.

## Identity Roles

Making sure we understand the concept of roles in UCP will determine our ability to apply them in RBAC. This lesson will help define what roles have what types of permissions.

With the Universal Control Plane, Docker has two types of users:

- Adminstrators - can make changes to the UCP swarm
- Regular Users - have permissions to full control to no access to any number of resources.

Within the UCP, only users that are dsignated as 'administrators' can make changes to the swarms.

- User Management
- Organization Management
- Team Management
- Granting Roles

Role consist of one or more permissions granted on a collection that is assigned to a
user, organization, and/or team by using grants.

Built-In Role | Description
NONE | No access to swarm resources
VIEW ONLY | user can VIEW resources (services, volumes, networks) but cannot create/delete/modiy them.
RESTRICTED CONTROL | grans the ability to view and edit volumes, networks, images but cannot run
services or containers on the running node.  restricts ability to mount a node directly or 'exec' into running ontainers.
SCHEDULER | allowed to view nodes and schedule workloads. need additional resource permissions
, like container view to perform other tasks
FULL CONTROL | user allowed to view and edit network, images, volumes as well as create containers and services withour restrition. 
They CANNOT see other users containers and services.

## Configure RBAC and Enable LDAP in UCP

Requires EE - https://docs.docker.com/ee/

Enabling LDAP for authentication allows you to integrate with your user management and authorization solution. Applying roles to your users and teams allow you to control the part they play in your cluster management and utilization implementation.

Lots of UI stuff which is in the EE application and not in CE.

## Demonstrate Creation and Use of UCP Client Bundles and Protect the Docker Daemon With Certificates

UCP Client Bundles allow you to provide a preconfigured setup for user accounts set up in UCP, along with the necessary trusted certificates to connect to and use the UCP cluster. You can then control what that user can do by granting roles to the account in UCP; we will show you how to accomplish all of that.

## Describe the Process to Use External Certificates with UCP and DTR

Using certificates from a Certificate Authority (like Verisign) is straightforward in your environment. We will show you where your new keys and certificates are installed in UCP.

https://docs.docker.com/ee/ucp/

## Describe Default Docker Swarm and Engine Security

Docker Engine Security
Docker Engine security involves the consideration of four areas:

1. The host’s kernel support of namespaces and cgroups.
1. Limited ‘attack surface’ of the Docker daemon.
1. Customization of container configuration profiles.
1. Hardening features of the kernel and their interaction with underlying containers.

Namespaces provide isolation to running containers so they cannot see or affect other processes on the host. Namespaces provide an isolated process, network, and volume stacks to enable that isolation.

Control groups implement resource management (allocating and reporting) to further minimize the effect of a container on a host. As a result, both play a role in minimizing (or mitigating completely) various security risks, such as the denial of service attacks on a container, privilege escalation exploits, etc.

### Docker Daemon requires root privilages

Lots of talk about getting rid of that soon...

### Docker Engine security involves the consideration of four areas

1. The host’s kernel support of namespaces and cgroups.
1. Limited ‘attack surface’ of the Docker daemon.
1. Customization of container configuration profiles.
1. Hardening features of the kernel and their interaction with underlying containers.

The ‘attack surface’ is affected by the fact that the **daemon requires ROOT account privileges**, so more care than normal should be applied when changing parameters and/or known secure default configurations.
Even when ‘trusted users’ are given access to the daemon for control, unknowingly malicious images with ‘docker load’ type commands is a concern. The addition of Docker Enterprise Edition features with UCP, DTR, and Docker Content Trust can address some of those risks.

### Docker Swarm

Docker Swarm makes heavy use of the Overlay Network Model

This model comes prepared with security and support for communication encryption (using the – opt encrypted option when creating the network for use).

> -opt ecnrypted option

NOTE: This does NOT extend to Windows, where encryption is not supported.

## Describe Mutually Authenticated TLS (MTLS)  

Just a passing question... What is it? Where is it used?

What is Mutually Authenticated TLS?

One of the primary goals of Docker Swarm is to be ‘secure by default’; a method to ensure communication within the swarm is implemented.

Mutually Authenticated TLS is the implementation that was chosen to secure that communication.

Any time a swarm is initialized, a self-signed Certificate Authority (CA) is generated and issues certificates to every node (manager or worker) to facilitate those secure communications.

TLS (Transport Layer Security) was born from the Secure Sockets Layer (SSL) whose name is more well known. However, TLS has since superseded its use. Although their names are often used interchangeably, TLS provides greater security through message authentication, key material generation, and supported cipher suites.

Using the temporary certificates that are generated during a swarm initialization, workers and managers can register themselves with the swarm for communication.

Using TLS (Transport Layer Security) provides both privacy and data integrity in communications within the swarm.
The transaction consists of a two-layer (Record and Handshake) protocol that provides both security and authentication.

### Key rotation

https://docs.docker.com/engine/swarm/swarm_manager_locking/
https://docs.docker.com/engine/swarm/swarm_manager_locking/#rotate-the-unlock-key

```bash
docker swarm init --autolock

Swarm initialized: current node (k1q27tfyx9rncpixhk69sa61v) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join \
    --token SWMTKN-1-0j52ln6hxjpxk2wgk917abcnxywj3xed0y8vi1e5m9t3uttrtu-7bnxvvlz2mrcpfonjuztmtts9 \
    172.31.46.109:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.

To unlock a swarm manager after it restarts, run the `docker swarm unlock`
command and provide the following key:

    SWMKEY-1-WuYH/IX284+lRcXuoVf38viIDK3HJEKY13MIHX+tTt8
```