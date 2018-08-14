# This is our first Dockerfile
# create centos apache web server from scratch
FROM centos:latest

LABEL maintainer="latest@email.com"

# run creates a new layer so we should have 3 layers
# from RUN here...
# httpd apache web service
# net-tools is for what?
#RUN yum update -y && yum install httpd net-tools -y

# make our http dir, supporting dir for apache we server
#RUN mkdir -p /run/httpd

# clear out anything in the directories
#RUN rm -rf /run/http/* /tmp/httpd*

# COMBINED LINE
RUN yum update -y && \
    yum install httpd net-tools -y && \
    mkdir -p /run/httpd && \
    rm -rf /run/http/* /tmp/httpd*

# run a command
# ONLY one CMD per docker file
# provides CMD to run when container starts
# or provide parameters to the entry point
# https://nickjanetakis.com/blog/docker-tip-63-difference-between-an-array-and-string-based-cmd
# Difference between an Array and String Based CMD
# Shell form sounds better in theory, but it can mess with signal processing. 
# It also means the shell process ends up being PID 1 instead of whatever binary you’re running in your CMD.
CMD ["echo","remember to check your container IP address"]

# Create env var for our use
ENV ENVIRONMENT="production"

# Expose some ports...
# expose TCP or ports and protocol
# this does not map it from container to localhost
# ... it just lets you
# know what ports should be open... right
# this was in plurialsight
# documnetation of what ports
EXPOSE 80

# JSON Array or a string
# 
ENTRYPOINT apachectl "-DFOREGROUND"

