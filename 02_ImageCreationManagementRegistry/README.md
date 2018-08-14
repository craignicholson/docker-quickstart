# Image Creation, Management, and Registry (20% of Exam)

## Pull an Image from a Registry (Using Docker Pull and Docker Images)

### Basic

```bash
docker images
docker pull hello-world

# pull all the tags for an image
docker pull --all hello-world
docker pull -a hello-world

# pull an image where trust is failing
docker pull --disable-content-trust hello-world

docker images
docker images --all
docker images --digests

# get a list of the commands for docker images
docker images --help
  -a, --all             Show all images (default hides intermediate images)
      --digests         Show digests (long ids of the image)
  -f, --filter filter   Filter output based on conditions provided
      --format string   Pretty-print images using a Go template
      --no-trunc        Don\'t truncate output
  -q, --quiet           Only show numeric IDs


```

### Filtering

```bash
docker pull centos:6
docker images --filter "before=centos"
docker images --filter "since:centos"

# expanded view of the image ids
docker images --no-trunc
docker images centos:6

# ists just the short image id
docker images -q

#usefull for feeding this into an argument
$(docker images -q)
```

## Searching an Image Repository

Pulling a Docker image presumes you know the exact name of the image you want. Learn how to search the configured repository for an image name and filter the results to get what you need.

### Quick Searches

```bash
docker search apache
#to find images to you might want to use
#let's get a line count of that

docker search apache | wc -l
#counts the number of lines with word apache in the results

docker search --filter stars=50 apache
docker search -f stars=500 apache
docker search --filter stars=500 apache

#show me results when >=500 stars
docker search --filter stars=500 is-official apache

#you can use only one filter at a time
docker search --filter stars=50 --filter is-official=true apache

docker search --limit 10 apache
#gets you the top 10
#this will search from docker hub or your own enterprise repo
```

### docker search --help

```bash
docker search --help
Options:
  -f, --filter filter   Filter output based on conditions provided
      --format string   Pretty-print search using a Go template
      --limit int       Max number of search results (default 25)
      --no-trunc        Don't truncate output
```

## Tag an Image

We have talked about image tags but not explored exactly what they are, how to use them ourselves, and how they may affect the underlying storage of images. Let's take a look at that now.

Build on a container or image and commit it without changing the original image.

### How does it work

```bash
# SOURCE IS ORIGINAL
# TARGET IS THE NEW
docker tag SOURCE_IMAGE[:TAG] TARGET_IMAGE[:TAG]
```

### Examples

```bash
# keep the source and tag together
# for better granularity
docker tag centos:6 mycentos:1

# both centos:6 mycentos:1 will have same image id
# if you start a container, make changes and commit changes
# you should get a new container id

# if you are uploading to a registry
docker tag centos:6 myrepo/mycentos:V2

# quick removal of images
# this will just untag the image
# since we keep the base image for mycentos:1 and myrepo/mycentos:V2
docker rmi centos:6

```

## Use CLI Commands to Manage Images (List, Delete, Prune, RMI, etc)

Managing our local images goes beyond what we have seen so far in the 'docker images' command. We have the ability to back up, restore, list, remote, pull, push, and otherwise inspect the details of any image. We will show you how in this lesson.

### docker image commands

```bash

docker image

Commands:
  build       Build an image from a Dockerfile
  history     Show the history of an image
  import      Import the contents from a tarball to create a filesystem image
  inspect     Display detailed information on one or more images
  load        Load an image from a tar archive or STDIN
  ls          List images
  prune       Remove unused images
  pull        Pull an image or a repository from a registry
  push        Push an image or a repository to a registry
  rm          Remove one or more images
  save        Save one or more images to a tar archive (streamed to STDOUT by default)
  tag         Create a tag TARGET_IMAGE that refers to SOURCE_IMAGE

Run 'docker image COMMAND --help' for more information on a command.
```

```bash
docker images

# build image from Dockerfile
docker image build -t customimage:v1 .
docker build -t customimage:v1 .


# both of these do the same thing
docker image history testweb:v1
docker history testweb:v1

# import
docker image import mydreams.tar localimport:centos6
docker import mydreams.tar localimport:centos6

# inspect
docker image inspect testweb
docker inspect testweb

# load
docker import mycentos.custom.tar localimport:centos6
docker load --input mycentos.custom.tar
# Load gives us the original name, import you can rename the image being loaded.

# ls
docker images
docker image ls

# prune, remove dangling images where they are not associated with a contianer
docker image prune
# remove all images that have never been used to create a container
docker image prune -a

# pull, pulls from docker hub
docker pull image:v1

# push to docker hub
docker push myrepo/mycentos:v2

# rm
docker image rm mydreams
docker rmi mydreams

#if you have an image duplicated with the same imageid but diff. tags a rmi is not removing #the base image since it is still being used
#if there is no dupe, the entire image is removed
#ls -la
#ls -al
#-rw-r--r-- 1 cn staff 701879296 Jul 30 12:46 mydreams.tar
#TWO WAYS TO FIX THIS

# save
docker image save myrepo/mycentos:v2 > mycentos.custom.tar
#If i wanted to share an image with someone without pushing to a repo, I can just docker #image save to a .tar push to usb or push the .tar around the network to the location
#docker image save NAMEOFIMAGE > myimage.tar

# tag
docker tag centos:6 mycentos:2
docker image tag centos:6 mycentos:2

```

## Inspect Images and Report Specific Attributes Using Filter and Format

The 'docker inspect' command can provide a plethora of insight into all of the attributes of your images. We will demonstrate how to display that information and then how to format that information to filter out only what you want in several different formats.

Also

> docker inspect [OPTIONS] NAME|ID [NAME|ID...]

```bash
docker image inspect
docker image inspect centos:6


docker image inspect centos:6 > multistage.output
# See if we can search out the hostname

docker image inspect centos:6 --format'{{.ContainerConfig.Hostname}}'
docker image inspect multcentos:6istage --format '{{.ContainerConfig.Hostname}}'
docker image inspect centos:6 --format '{{json .ContainerConfig}}'
docker image inspect centos:6 --format '{{.RepoTags}}'

docker tag centos:6 anothercentos:6
# docker image tag centos:6 anothercentos:6

docker image inspect centos:6 --format '{{.RepoTags}}'

```

## Container Basics - Running, Attaching to, and Executing Commands in Containers

Although the basics of running containers are not emphasized on the exam, it is assumed you have the ability to run and understand the options for running containers. Let's take a moment and be sure we have a good idea how to start, run, attach to and work with containers before going forward.

```bash
#what containers are running
docker ps

#what containers have been stopped but not removed
docker ps -a

#simplest way to run a container from a base image
docker run centos:6

#docker run -i -t
#-i interactive
#-t terminal attach it to my current termain
#docker run -it
#run interactive on my terminal
docker run -it centos:6

#when we exit, it kills the container as well container no longer runs
#we can control the sname or change the name too
docker run -it --name testcontainer centos:6 /bin/bash
#we indicate we want to run bash
#if we want to restart that container we can
docker restart testcontainer
#you can\'t run the same command again because this instance with the same name exists

docker restart testcontainer
docker rm testcontainer
docker rm 'docker ps -a -q'
docker rm `docker ps -a -q`

#Remove the container once the container stops
docker run -it --rm testcontainer centos:6 /bin/bash
#other docker run options
#   --ip
#   assign and IP address
#   --privledge to give priv to user
#   --evn
#environment var
docker run -it --rm --env MYVAR=whatever testcontainer centos:6 /bin/bash
docker run -it --rm --env MYVAR=whatever --name testcontainer centos:6 /bin/bash

#this is bad ass, we can send in environment vars into the container...
#instead of -it issue a -d to run the container in the back ground
#detached...
#   -d
#   --detached
docker run -d --name testcontainer centos:6

#we would typically do this for a web server!!!
docker pull httpd
docker run -d httpd
docker ps

# http continues to run.. because the container is designed to keep running
#it is running in bkground
#we have two ways to attach
#if you use docker attach and exit this will stop the container
#so avoid this if you want to attach and keep the container running
docker run -d httpd
docker ps

docker exec -it elastic_yellow /bin/bash
docker ps
```

## Create an Image with Dockerfile

Before we talk about the structure, options, and optimizations around Dockerfiles, we need to understand how to use the 'build' command to complete a build with a variety of option.

### centos

```Dockerfile
FROM centos:latest
LABEL maintainer="myemail@email.com"
RUN yum update -y
```

```bash
docker image build -t customimage:v1 .

docker images
```

On rebuild you see it's super fast.  Used the the cache.

As long as the steps have not changed.  It uses the cache.

If you change the lable to another name.

```Dockerfile
FROM centos:latest
LABEL maintainer="myemail@email.com"
RUN yum update -y
```

```bash
docker image build -t customimage:v1 .

docker images
```

Second Step takes longer.  Once a layer changes. It rebuilds the layer.

### ubuntu

Dockerfile2

```Dockerfile
FROM ubuntu:latest
LABEL maintainer="myemail@email.com"
RUN apt-get update -y

```

```bash
docker image build -t customimage:v1 -f Dockerfile2 .
docker image build -t customimage:v1 --file Dockerfile2 .
```

### Another Way

```bash

docker build - < Dockerfile
```

### Squash images to single layer

Squash supported on Edge, only at this time.

```Dockerfile
FROM centos:latest
LABEL maintainer="myemail@email.com"
RUN yum update -y
```

```bash
docker build --pull --no-cache --squash -tag optimized:v1 .
docker build --pull --no-cache -tag optimized:v1 .
```

Re-pulls all the updates. Updates the local image.  It gets new image id.

## Dockerfile Options, Structure, and Efficiencies (Part I)

The Dockerfile has a large number of options that you need to be able to use effectively and efficiently. We will walk through them over the next couple of videos, while showing you the structure and differences between them.

Dockerfile Options UPDATE FROM HERE PLEASE
https://docs.docker.com/engine/reference/builder/

### Dockerfile Options

REVIEW THEM ALL

FROM
    <image> [AS <name>]
    <image>[:<tag>] [AS <name>]
ARG
    VARIABLE_NAME=[value]
    FROM base:${VARIABLE_NAME}
RUN
    <command> (shell form - /bin/sh –c)
    [“command”, “parm1”, ”parm2”] (exec form, JSON)
CMD
    [“command”, “parm1”, “parm2”] (exec form, JSON)
    [“parm1”,”parm2”] (parms for ENTRYPOINT)
LABEL
    metadata added to image, key/value pair
    “label details”=“label reference name”
MAINTAINER (deprecated)
    <name of maintainer>
LABEL maintainer=“name” (new format)
EXPOSE
    <port> [<port>/<protocol>...]
    Does NOT publish port, serves as documentation

ENV
    <key> <value>
    <key>=<value>
ADD
    <src>...<dest> (must include quotes if spaces)

WORKDIR – used as variable for relative path

COPY
    <src>...<dest> (must include quotes if spaces) WORKDIR – used as variable for relative path
ENTRYPOINT

    [“command”, “parm1”, “parm2”] (exec form, JSON)
    command parm1 parm2 (shell form)

VOLUME
[“/path”]
NOTE: Does not mount host path, not portable

USER
    <user>[:<group>] or <UID>[:<GID>]
    affects RUN, CMD or ENTRYPOINT
WORKDIR
    /path/to/dir

sets working directory for RUN, CMD, ENTRYPOINT

STOPSIGNAL
    NOTE: specific signal when a container is stopped

SHELL
    [“executable”,”parms”]
    overrides /bin/sh –c for RUN, CMD, etc

### Larger Dockerfile

```Dockerfile
# This is our first Dockerfile
# create centos apache web server from scratch
FROM centos:6

LABEL maintainer="latest@email.com"

# Run creates a new layer so we should have 3 layers
# if we use 3 RUN(s)
# httpd apache web service
# net-tools is for what?
#RUN yum update -y && yum install httpd net-tools -y
#RUN ["yum","install","telnet"], not prefered

# make our http dir, supporting dir for apache we server
#RUN mkdir -p /run/httpd

# clear out anything in the directories
#RUN rm -rf /run/http/* /tmp/httpd*

# COMBINED LINE to get one layer
RUN yum update -y && \
    yum install httpd net-tools -y && \
    mkdir -p /run/httpd && \
    rm -rf /run/http/* /tmp/httpd*

# Run a command
# Difference between an Array and String Based CMD
# Shell form sounds better in theory, but it can mess with signal processing.
# It also means the shell process ends up being PID 1 instead of whatever binary you’re running in your CMD.
# CMD prefered method is json ["","",""]
# CMD ["gunicorn", "-c", "python:config.gunicorn", "hello.app:create_app()"]
# CMD echo "remember to check your container IP address"
# Only one per docker file, and only the last one will run.
# Mostly is here to provide parameters to the ENTRYPOINT
# https://nickjanetakis.com/blog/docker-tip-63-difference-between-an-array-and-string-based-cmd
CMD ["echo","remember to check your container IP address"]

# Create env var for our use
ENV ENVIRONMENT="production"

# Expose some ports...
# expose TCP or ports and protocol
# This does not map it from container to localhost
# ... it just lets you
# know what ports should be open... right
EXPOSE 80

# JSON Array or a string as well.
ENTRYPOINT apachectl "-DFOREGROUND"
```

```bash
docker build -t mywebserver:v2 .

# run the container
docker run -d -name testweb1 --rm -p 80:80 mywebserver:v2

curl localhost
```

TESTPAGE FORAPACHE 2

## Dockerfile Options, Structure, and Efficiencies (Part II)

The Dockerfile has a large number of options that you need to be able to use effectively and efficiently. We will walk through them over the next couple of videos, while showing you the structure and differences between them.

Content

- Review of CMD, RUN, ENTRYPOINT.
- RUN executes a CMD in the build.
- CMD sets default comamnd for ENTRYPOINT
- COPY vs ADD
- VOLUME

### Dockerfile 3

```Dockerfile
# FROM is always first, unless ARG is used. 
# When ARG is before FROM, the only instruction that can use
ARG TAGVERSION=6
FROM centos:${TAGVERSION}

LABEL maintainer="latest@email.com"

RUN yum update -y && \
    yum install httpd net-tools -y && \
    mkdir -p /run/httpd && \
    rm -rf /run/http/* /tmp/httpd*

# Take files from local context and add to inside of the image
# COPY only works with files
# ADD supports URL
#ADD https://raw.githubusercontent.com/craignicholson/index.html /var/www/html/
# COPY from local and put in the apache web dir
COPY index.html /var/www/html/

CMD echo "remember to check your container IP address"

ENV ENVIRONMENT="production"

# Creates a mount within an image.
# There is no way in a Dockerfile tied to a hosts storage system
# no guarante mount is available on all hosts
# espcially for swarms
VOLUME /mymount

EXPOSE 80

ENTRYPOINT apachectl "-DFOREGROUND"
```

Run the build

```bash
docker build -t mywebserver:v3 .

# run the container
docker run -d -name testweb3 --rm -p 80:80 mywebserver:v3
docker ps
curl localhost

# to see the entire command running
docker ps --no--trunc

docker stop testweb3
```

This is a bad use case.  For external site we just mount a volume instead.

### Dockerfile 4

Demonstrate the difference between the RUN, CMD, and ENTRYPOINT.

```Dockerfile
ARG TAGVERSION=6
FROM centos:${TAGVERSION}

LABEL maintainer="latest@email.com"

RUN yum update -y && \
    yum install httpd net-tools -y && \
    mkdir -p /run/httpd && \
    rm -rf /run/http/* /tmp/httpd*

COPY index.html /var/www/html/

ENV ENVIRONMENT="production"

VOLUME /mymount

EXPOSE 80

# Illustrate the diff between the RUN, CMD, ENTRYPOINT
# get count of of files in root dir
ENTRYPOINT ls -al / | wc -l

```

```html
Hello World

```

Run the build

```bash
docker build -t mywebserver:v4 .
docker image build -t mywebserver:v4 .

# run the container
docker run -d -name testweb1 --rm -p 80:80 mywebserver:v4

# once i put something in ENTRYPOINT I can't over ride it
docker run -it mywebserver:v4
26
docker run -it mywebserver:v4 /bin/bash
26

```

### WORKDIR

We can overide this...

### STOPSIGNAL

### SHELL

## Describe and Display How Image Layers Work

When creating an image, a number of 'intermediate' layers are completed that, when aggregated together, form the image itself. In this lesson, we talk about that process and how to display the details of each layer.

### Why Layers

The purpose of the intermediate images and the reference to parent images, is to facilitate the use of Docker's build cache. The build cache is another important feature of the Docker platform, and is used to help the Docker Engine make use of pre-existing layer content, rather than regenerating the content needlessly for an identical build command. It makes the build process more efficient. When an image is built locally, the docker history command might provide output similar to the following:

### docker history examples

```bash
docker image history mybyuild:v4
docker history mybyuild:v4
```

```bash
docker image history 52920ad46f5b
docker history 52920ad46f5b

IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
52920ad46f5b        5 months ago        /bin/sh -c #(nop) COPY multi:cfd14efdb00aa7e…   32.7MB              
<missing>           5 months ago        /bin/sh -c #(nop) COPY multi:52cc673d9029cee…   159MB               
<missing>           5 months ago        /bin/sh -c #(nop)  EXPOSE 2379/tcp 2380/tcp …   0B                  
<missing>           5 months ago        /bin/sh -c #(nop)  CMD ["sh"]                   0B                  
<missing>           5 months ago        /bin/sh -c #(nop) ADD file:327f69fc1ac9a7b6e…   1.15MB  
```

https://windsock.io/explaining-docker-image-ids/
<missing> 

The <missing> value in the IMAGE field for all but one of the layers of the image, is misleading and a little unfortunate. It conveys the suggestion of an error, but there is no error as layers are no longer synonymous with a corresponding image and ID. I think it would have been more appropriate to have left the field blank. Also, the image ID appears to be associated with the uppermost layer, but in fact, the image ID doesn't 'belong' to any of the layers. Rather, the layers collectively belong to the image, and provide its filesystem definition.

### Images /var/lib/docker/image

Location of the images typically here, but they location is dependant on the driver.

## Modify an Image to a Single Layer

There is no easy way to reduce an image to a single layer to save storages.

> docker squash - external tool

```bash
docker image history mywebserver:v1
docker history mywebserver:v1
IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
404143a28b67        9 hours ago         /bin/sh -c #(nop)  ENTRYPOINT ["/bin/sh" "-c…   0B                  
e26b9f53ab7c        9 hours ago         /bin/sh -c #(nop)  EXPOSE 80                    0B                  
70ce40b4bfcd        9 hours ago         /bin/sh -c #(nop)  ENV ENVIRONMENT=production   0B                  
08c226874ae9        9 hours ago         /bin/sh -c #(nop)  CMD ["echo" "remember to …   0B                  
9774ba22bf2b        9 hours ago         /bin/sh -c yum update -y &&     yum install …   120MB               
6bcb1a41a431        9 hours ago         /bin/sh -c #(nop)  LABEL maintainer=latest@e…   0B                  
5182e96772bf        7 days ago          /bin/sh -c #(nop)  CMD ["/bin/bash"]            0B                  
<missing>           7 days ago          /bin/sh -c #(nop)  LABEL org.label-schema.sc…   0B                  
<missing>           7 days ago          /bin/sh -c #(nop) ADD file:6340c690b08865d7e…   200MB     
```

We can gain space if we squash into a single layer.

### `docker export`

```bash
docker export [OPTIONS] CONTAINER

docker run -d --name testweb mywebserver:v1
docker export testweb > mywebserver.tar

# we can also move this container around this way...

docker import mywebserver.tar mywebserver:v5

# clean up our example
rm mywebserver.tar
```

Review the images
https://docs.docker.com/engine/reference/commandline/images/#filtering

```bash
docker images

REPOSITORY                                 TAG                 IMAGE ID            CREATED             SIZE
mywebserver                                v5                  16e085d41a9e        13 seconds ago      298MB
mywebserver                                v1                  404143a28b67        9 hours ago         320MB

docker history mywebserver:v1
IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
404143a28b67        9 hours ago         /bin/sh -c #(nop)  ENTRYPOINT ["/bin/sh" "-c…   0B                  
e26b9f53ab7c        9 hours ago         /bin/sh -c #(nop)  EXPOSE 80                    0B                  
70ce40b4bfcd        9 hours ago         /bin/sh -c #(nop)  ENV ENVIRONMENT=production   0B                  
08c226874ae9        9 hours ago         /bin/sh -c #(nop)  CMD ["echo" "remember to …   0B                  
9774ba22bf2b        9 hours ago         /bin/sh -c yum update -y &&     yum install …   120MB               
6bcb1a41a431        9 hours ago         /bin/sh -c #(nop)  LABEL maintainer=latest@e…   0B                  
5182e96772bf        7 days ago          /bin/sh -c #(nop)  CMD ["/bin/bash"]            0B                  
<missing>           7 days ago          /bin/sh -c #(nop)  LABEL org.label-schema.sc…   0B                  
<missing>           7 days ago          /bin/sh -c #(nop) ADD file:6340c690b08865d7e…   200MB               

# unique image id, the docker way... and saved about 20MB of size.
# we do lose history 
docker history mywebserver:v5
IMAGE               CREATED             CREATED BY          SIZE                COMMENT
16e085d41a9e        5 minutes ago                           298MB               Imported from -

```

## Selecting a Docker Storage Driver

There are a variety of 'pluggable' storage drivers available for Docker CE and EE to use to store images and containers on the underlying host. We will display all the available storage drivers and show how to change our configuration to one officially supported for our distribution and version.

Containers are supposed to be portable.

If we write data inside of a container, it is less portable.

The Docker Storage Drivers are a way to save information, but the information is stored on the the host.

### How do you tell what your storage driver

```bash
docker info
docker system info

docker info | grep Storage
Storage Driver: overlay2

docker system info | grep Storage
Storage Driver: overlay2

```

### Change the storage driver

```bash
sudo ls etc/docker
/etc/docker/daemon.json
.
..
daemon.json
key.json
```

Example daemon.json file with storage-driver settings.

```json
daemon.json
{
  "storage-driver" : "devicemapper"
}
```

Restart Docker

```bash
systemctl restart docker
devicemapper : usage of loopback devices is strongly discouraged for production use.
use --storage-opt dm.thinkpooldev to specify a custom block storage device

```

Add to daemon.json

> --storage-opt dm.thinkpooldev we need to add to daemon.json and add that device

```bash
docker info
docker system info

docker info | grep Storage
Storage Driver: devicemapper

docker system info | grep Storage
Storage Driver: devicemapper
```

## Prepare for a Docker Secure Registry on centos

Before we can use a private repository, we will need to secure it and offer user authentication. Let's create a self-signed certificate, use the 'registry' container by Docker to create basic user authentication, and then copy the files where they need to go on the hosting server.

Docker is already has created a docker image for this secure registry

We will use TLS and user authentication.

```bash
sudo yum install openssl
mkdir certs
mkdir auth
mkdir /home/user/certs

# note this should not be on the test
# creates on key and one cert in our directories above
$ openssl req -newkey rsa:4096 -nodes -sha256 -keyout certs/dockerrepo.key -x509 -days 365 -out certs/dockerrepo.crt -subj /CN=myregistrydomain.com


# review the certs
cd certs/
ll
total 8
-rw-rw-r--. 1 user user 1818 Aug  1 23:04 dockerrepo.crt
-rw-rw-r--. 1 user user 3272 Aug  1 23:04 dockerrepo.key

# get our ip we need to open up the fire wall for our tes servers
ifconfig
...
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 9001
        inet 172.31.43.215  netmask 255.255.240.0  broadcast 172.31.47.255
        inet6 fe80::8b4:20ff:fec7:5dee  prefixlen 64  scopeid 0x20<link>
        ether 0a:b4:20:c7:5d:ee  txqueuelen 1000  (Ethernet)
        RX packets 75224  bytes 95734804 (91.2 MiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 32576  bytes 3953015 (3.7 MiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
...

# edit the hosts fiel to add our IP And domainname
sudo vim /etc/hosts
cat /etc/hosts

127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
172.31.43.215 myregistrydomain.com

# create new directories to hold the certification
# you need to be root here...
# registry uses port 5000 by defaults
# the name needs to be part of the directory!! why?
sudo -i
mkdir -p /etc/docker/certs.d/myregistrydomain.com:5000
cd  /etc/docker/certs.d/myregistrydomain.com:5000
pwd
/etc/docker/certs.d/myregistrydomain.com:5000

# copy the files over, and the file needs to be owned by root
sudo cp /home/user/certs/dockerrepo.crt /etc/docker/certs.d/myregistrydomain.com:5000/ca.crt

# check to see if our file was copied over
sudo ll /etc/docker/certs.d/myregistrydomain.com:5000
ca.crt

# exit as root
exit

# get the registry
docker pull registry:2

# try and run the registry
# review --entrypoint parameter for future info, runs htpasswd app
# -auth/htpasswd is our OUT directory
# run the container and write out the hashed value for the password to a file
# make sure you are back in the original home dir where folder /dir auth exits
docker run --entrypoint htpasswd registry:2 -Bbn testuser testpassword > auth/htpasswd

cat /auth/htpasswd
HASHEDVALUE

docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
httpd               latest              11426a19f1a2        5 days ago          178MB
ubuntu              latest              735f80812f90        10 days ago         83.5MB
registry            2                   b2b03e9146e1        4 weeks ago         33.3MB

```

## Deploy, Configure, Log Into, Push, and Pull an Image in a Registry

Now that we have the security work done for our private registry, we can deploy and configure it for use. We will test it locally, and then log in and test via a remote system.

```bash

# if any of this is incorrect the container will start and stop
docker run -d -p 5000:5000 -v `pwd`/certs:/certs -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/dockerrepo.crt -e REGISTRY_HTTP_TLS_KEY=/certs/dockerrepo.key -v `pwd`/auth:/auth -e REGISTRY_AUTH=htpasswd -e REGISTRY_AUTH_HTPASSWD_REALM="Registry Realm" -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd --name reg registry:2

87b2f715abd1c148e8b6083710e5debcfe83c75ae95bc6a778ba85d1d098bb61

# if the container is running, you have probably done everything correct
$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                    NAMES
87b2f715abd1        registry:2          "/entrypoint.sh /etc…"   13 seconds ago      Up 12 seconds       0.0.0.0:5000->5000/tcp   reg

# let's get an image and tag it as our own and push to our own registry
docker pull busybox

# tag this image for our own registry
docker tag busybox myregistrydomain.com:5000/my-busybox

# push the image to our registry
docker push myregistrydomain.com:5000/my-busybox
The push refers to repository [myregistrydomain.com:5000/my-busybox]
f9d9e4e6e2f0: Preparing
no basic auth credentials

# ok let's login first
docker login myregistrydomain.com:5000/my-busybox
Username: testuser
Password:
WARNING! Your password will be stored unencrypted in /home/user/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded

# try pushing the file again
docker push myregistrydomain.com:5000/my-busybox
The push refers to repository [myregistrydomain.com:5000/my-busybox]
f9d9e4e6e2f0: Pushed
latest: digest: sha256:5e8e0509e829bb8f990249135a36e81a3ecbe94294e7a185cc14616e5fad96bd size: 527

# remove the original busybox, because we need folks to use private registry one
# perform a test pull
docker rmi busybox
docker rmi myregistrydomain.com:5000/my-busybox

# review the images
docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
ubuntu              latest              735f80812f90        6 days ago          83.5MB
registry            2                   b2b03e9146e1        3 weeks ago         33.3MB
centos              6                   70b5d81549ec        3 months ago        195MB

# pull our private registry busybox image
$ docker pull myregistrydomain.com:5000/my-busybox
Using default tag: latest
latest: Pulling from my-busybox
Digest: sha256:5e8e0509e829bb8f990249135a36e81a3ecbe94294e7a185cc14616e5fad96bd
Status: Downloaded newer image for myregistrydomain.com:5000/my-busybox:latest

# review the results
docker images
REPOSITORY                             TAG                 IMAGE ID            CREATED             SIZE
myregistrydomain.com:5000/my-busybox   latest              e1ddd7948a1c        25 hours ago        1.16MB

```

### using registry from another server

Note every docker host will need to have the certificate copied over from one server to the other server.

```bash
# if you are on another server add the hosts information
cat /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
172.31.43.215 myregistrydomain.com

# copy over the ca.crt file to another server
scp ca.crt user@server.com :/home/user

# on new server
sudo cd /etc/docker/
sudo mkdir certs.d
sudo cd /certs.d
sudo mkdir myregistrydomain.com:5000
cd myregistrydomain.com:5000
# move our cert to this folder
mv /home/user/ca.crt .
# check we moved the file
ls -al
# make the file own root
chown root:root ca.crt
```

```bash
# login first
docker login myregistrydomain.com:5000
Username:
Password:
Login Succeeded

# try again
docker pull myregistry.com:5000/my-busybox
```

## Managing Images in Your Private Repository

Within our private registry, we have to use a little creativity to view what is available. We will take a look at how to take advantage of the registry's RESTful API to do so.

None of this was on the test.

Review the Catalog of Images

```bash

curl --insecure -u testuser:testpassword https://myregistrydomain.com:5000/v2/catalog
["repositories": ["my-busybox", "my-centos"]]

```

See the Tags

```bash

# tag list
curl --insecure -u testuser:testpassword https://myregistrydomain.com:5000/v2/my-busybox/tags/list

# manifest
curl --insecure -u testuser:testpassword https://myregistrydomain.com:5000/v2/my-busybox/manifests/lastest


```

### DTR (Docker Trusted Registry)

This is different, since I can use the Web UI to go in and delete an image.  Deleting an image with API, you have to delete by each layer instead of the image name.

## Container Lifecycles - Setting the Restart Policies

Docker gives you full control over when and how your containers behave when you reboot, stop or restart the service. Let's take a look at how each method behaves under which circumstances.

```bash

# No auto restart of any container no matter what happens out of the box
docker image pull httpd
docker run -d --name testweb httpd
3dc0640167c72aa0daf1a66a3358e1984255e8ec480e68d4a3f79484103f6d18

docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS               NAMES
3dc0640167c7        httpd               "httpd-foreground"   3 seconds ago       Up 2 seconds        80/tcp              testweb

# stop and start the container again
docker stop testweb
docker start testweb
testweb

# container is running again
docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS               NAMES
3dc0640167c7        httpd               "httpd-foreground"   32 seconds ago      Up 1 second         80/tcp              testweb

# what is we restart docker
sudo systemctl restart docker

# look, our container is not running, what we want is for a container to restart when docker restarts right?
$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES

# here is the 
$ docker ps -a
CONTAINER ID        IMAGE               COMMAND              CREATED              STATUS                      PORTS               NAMES
3dc0640167c7        httpd               "httpd-foreground"   About a minute ago   Exited (0) 29 seconds ago                       testweb

docker rm testweb
```

### Three modes for using restart

This was on test and I just forgot it.

| Policy | Result |
|--------|--------|
| no | Do not automatically restart the container when it exits. This is the default.|
| on-failure[:max-retries] | Restart only if the container exits with a non-zero exit status. Optionally, limit the number of restart retries the Docker daemon attempts.|
| unless-stopped| Restart the container unless it is explicitly stopped or Docker itself is stopped or restarted.|
| always| Always restart the container regardless of the exit status. When you specify always, the Docker daemon will try to restart the container indefinitely. The container will also always start on daemon startup, regardless of the current state of the container.|

List of the available parameters for restart

```bash
docker container run -d --name testweb --restart no httpd
docker container run -d --name testweb --restart on-failure:5 httpd
docker container run -d --name testweb --restart unless-stopped httpd
docker container run -d --name testweb --restart always httpd
```

### always

```bash
docker container run -d --name testweb --restart always httpd
a1fd0a8187cb94b166ea6fe1733c24b9b8580036fc4c8e2aaae71a8e0967fb0e

docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS               NAMES
a1fd0a8187cb        httpd               "httpd-foreground"   15 seconds ago      Up 13 seconds       80/tcp              testweb

sudo systemctl restart docker

docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS               NAMES
a1fd0a8187cb        httpd               "httpd-foreground"   35 seconds ago      Up 2 seconds        80/tcp              testweb 

# manually stop the the container
docker stop testweb
testweb

# container has stopped
docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES

# restart docker, and since restart is always the container will restart
sudo systemctl restart docker

docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED              STATUS              PORTS               NAMES
a1fd0a8187cb        httpd               "httpd-foreground"   About a minute ago   Up 3 seconds        80/tcp              testweb 

# clean up
docker rm testweb
testweb

```

### unless-stopped

```bash

# run our container
docker container run -d --name testweb --restart unless-stopped httpd
cc48f68d25dbaa762025cf703959818d145477acf07864e1d94f66d194f63208

# verify
docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS               NAMES
cc48f68d25db        httpd               "httpd-foreground"   3 seconds ago       Up 3 seconds        80/tcp              testweb

# restart docker
sudo systemctl restart docker

# container restarts
docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS               NAMES
cc48f68d25db        httpd               "httpd-foreground"   22 seconds ago      Up 3 seconds        80/tcp              testweb

# stop our container...
$ docker stop testweb
testweb

# verify
$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES

# restart docker, and we don't expect container to restart because we had stopped the container manually
$ sudo systemctl restart docker

# verify, yes the container did not restart
$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES

# start our container
docker start testweb
testweb

# verify
docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS               NAMES
cc48f68d25db        httpd               "httpd-foreground"   2 minutes ago       Up 1 second         80/tcp              testweb 

# restart docker, and expect the container to restart too, since we did not manually stop the container
sudo systemctl restart docker

# verify, yes it worked
docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS               NAMES
cc48f68d25db        httpd               "httpd-foreground"   2 minutes ago       Up 3 seconds        80/tcp              testweb
```