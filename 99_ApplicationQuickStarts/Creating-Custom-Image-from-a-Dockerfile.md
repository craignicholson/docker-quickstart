# Creating Custom Image from a Dockerfile

 Although you should be able to run these commands on any Docker version on any Linux Distribution, for the purposes of these exercises, be sure you are running Docker v1.10+ as well as the latest CentOS or Ubuntu distribution. Be sure to have pulled the 'centos:6' and 'ubuntu:latest' images from the Docker Hub (docker pull) before starting this exercise.

1. Create a directory called 'custom' and change to it. In this directory, create an empty file called "Dockerfile".

mkdir custom
cd custom
vim Dockerfile

1. Edit the "Dockerfile" created in Step #1 above. This configuration file should be written to perform the following actions:

Use the base Centos 6 Latest version image from the public repository
Identify you and your email address as the author and maintainer of this image
Update the base OS after initial import of the image
Install the Open-SSH Server
Install Apache Web Server
Expose ports 22 and 80 to support the services installed

```Dockerfile
# Dockerfile that modifies centos:centos6 to update, include Apache Web
# Server and OpenSSH Server, exposing the appropriate ports
FROM centos:centos6
MAINTAINER User Name <username@domain.com>

# Update the server OS
RUN yum -y upgrade

# Install Apache Web Server & openssh-server
RUN yum -y install httpd openssh-server

# Expose the SSH and Web Ports for attachment
EXPOSE 22 80

```

1. Build the custom image from the 'Dockerfile' as created above. Name/tag this new image as "mycustomimg/withservices:v1". Once the image is built, verify the image appears in your list.

docker build -t mycustomimg/withservices:v1 .

docker images