FROM debian:stable

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