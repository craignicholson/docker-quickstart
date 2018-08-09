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
