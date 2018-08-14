# Docker Files Examples

## Dockerfile

```docker
FROM debian:stable
MAINTAINER latest123 <lastest123@domain.com>

RUN apt-get update && apt-get upgrade -y && apt-get install -y apache2 telnet elinks openssh-server

# You can view the environment var by attaching with 
# docker exec -it CONTAINERNAME /bin/bach
# echo $MYVALUE
ENV MYVALUE my-value

# This just exposes the servers port
# it does not re-map this port to the host running the docker container
EXPOSE 80

# anything after run
#  will be run when creating base image

# anything after cmd
#  will be things to run after the container is instantiated.
CMD ["usr/sbin/apache2ctl", "-D", "FOREGROUND"]

```

## Sample Docker File

```docker
FROM centos:latest
LABLE maintainer"myemail@email.com"
RUN yum update -y
```

Sample Build of a Dockerfile to create an image

```bash
docker build -t custom_image:v1 .

docker images
REPOSITORY                                 TAG                 IMAGE ID            CREATED             SIZE
custom_ubuntu                               v1                  bda01d26ebc3        37 seconds ago      125MB

```

## Dockerfile build from github

## Dockerfile build from tar ball

## Sqaush

```bash
docker build --pull --no-cache  -t optimized:v1 .
```