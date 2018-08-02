# Managing Containers (Creating, Starting and Stopping)

1. Create a container from the base image for the latest version of Ubuntu available (if you do not have an Ubuntu base image installed locally, pull the latest one down for your local repository). The container should be started in interactive mode attached to the current terminal and running the bash shell. Once running, shut the container down by exiting.

```bash
$ sudo docker pull ubuntu:latest
Trying to pull repository docker.io/library/ubuntu ... 
latest: Pulling from docker.io/library/ubuntu

ae79f2514705: Pull complete 
5ad56d5fc149: Pull complete 
170e558760e8: Pull complete 
395460e233f5: Pull complete 
6f01dc62e444: Pull complete 
Digest: sha256:506e2d5852de1d7c90d538c5332bd3cc33b9cbd26f6ca653875899c505c82687
```

```bash
$ sudo docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
docker.io/httpd     latest              c24f66af34b4        5 days ago          177.3 MB
docker.io/ubuntu    latest              747cb2d60bbe        7 days ago          122 MB
$ sudo docker run -it ubuntu:latest /bin/bash
root@f1d4d12c2c70:/# exit
exit
```

1. Run the appropriate Docker command to get the name of the previously run container. Issue the appropriate command to restart the container that you obtained the name of. Do NOT create a new container, restart the one we just used.

```bash

$ sudo docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED              STATUS                          PORTS               NAMES
f1d4d12c2c70        ubuntu:latest       "/bin/bash"         About a minute ago   Exited (0) About a minute ago                       jovial_kilby

$ sudo docker restart jovial_kilby
jovial_kilby

$ sudo docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
f1d4d12c2c70        ubuntu:latest       "/bin/bash"         2 minutes ago       Up 7 seconds                            jovial_kilby
```

1. Stop the container. Remove that container from the system completely using the appropriate command.

```bash
$ sudo docker stop jovial_kilby
jovial_kilby

$ sudo docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES

$ sudo docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                      PORTS               NAMES
f1d4d12c2c70        ubuntu:latest       "/bin/bash"         3 minutes ago       Exited (0) 10 seconds ago                       jovial_kilby

$ sudo docker rm jovial_kilby
jovial_kilby

$ sudo docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
```

1. Create (not run) a container called "my_container", create it with parameters that will allow it to run interactively and attached to the local console running the bash shell. Verify that the container is not running.

```bash
$ sudo docker create -it --name="my-container" ubuntu:latest /bin/bash
c90b35870c09fe63d1bac782342dd734b2edf4ac6abb282690d1585aa259841e

$ sudo docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
c90b35870c09        ubuntu:latest       "/bin/bash"         4 seconds ago       Created                                 my-container
```

1. Start the container and again, verify the container is running. Run the appropriate command to attach your session to the running container so you are logged into the shell.

```bash
$ sudo docker start my-container
my-container

$ sudo docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
c90b35870c09        ubuntu:latest       "/bin/bash"         4 minutes ago       Up 2 minutes                            my-container

# Log into the container again, a detached container
$ sudo docker attach my-container
root@c90b35870c09:/$
root@c90b35870c09:/$ exit
exit
```

Review the newcentos:withapached container

```bash
$ ssh user@54.157.237.22
user@54.157.237.22 password:
Last login: Wed Aug  1 21:15:52 2018 from 108-74-118-125.lightspeed.tukrga.sbcglobal.net

$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
newcentos           withapached         18a9ff0a4eb6        18 minutes ago      461MB
ubuntu              latest              735f80812f90        5 days ago          83.5MB
centos              6                   70b5d81549ec        3 months ago        195MB

$ docker rmi newcentos:withapached
Error response from daemon: conflict: unable to remove repository reference "newcentos:withapached" (must force) - container 265c4c0739b1 is using its referenced image 18a9ff0a4eb6

$ docker ps -a
CONTAINER ID        IMAGE                   COMMAND             CREATED             STATUS                      PORTS               NAMES
265c4c0739b1        newcentos:withapached   "/bin/bash"         18 minutes ago      Exited (0) 6 minutes ago                        elegant_clarke
844866456de3        centos:6                "/bin/bash"         24 minutes ago      Exited (1) 19 minutes ago                       awesome_hugle

$ docker rm $(docker ps -a -q)
265c4c0739b1
844866456de3

$ docker run -it ubuntu:latest /bin/bash
root@8728d80ac38d:/# exit
exit

$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES

$ docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                     PORTS               NAMES
8728d80ac38d        ubuntu:latest       "/bin/bash"         10 seconds ago      Exited (0) 4 seconds ago                       sleepy_brattain

$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
newcentos           withapached         18a9ff0a4eb6        20 minutes ago      461MB
ubuntu              latest              735f80812f90        5 days ago          83.5MB
centos              6                   70b5d81549ec        3 months ago        195MB

$ docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                      PORTS               NAMES
8728d80ac38d        ubuntu:latest       "/bin/bash"         42 seconds ago      Exited (0) 36 seconds ago                       sleepy_brattain

$ docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                      PORTS               NAMES
8728d80ac38d        ubuntu:latest       "/bin/bash"         25 minutes ago      Exited (0) 25 minutes ago                       sleepy_brattain

$ docker restart sleepy_brattain
sleepy_brattain

$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
8728d80ac38d        ubuntu:latest       "/bin/bash"         25 minutes ago      Up 2 seconds                            sleepy_brattain

$ docker stop sleepy_brattain
sleepy_brattain

$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES

$ docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                     PORTS               NAMES
8728d80ac38d        ubuntu:latest       "/bin/bash"         26 minutes ago      Exited (0) 5 seconds ago                       sleepy_brattain

$ sudo docker create -it --name="my-container" ubuntu:latest /bin/bash
3f363080f890bc0786f86a2f4e11aed9fc48c688cfdb9d34c6ce32ba9be54fa6

$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES

$ docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                          PORTS               NAMES
3f363080f890        ubuntu:latest       "/bin/bash"         10 seconds ago      Created                                             my-container
8728d80ac38d        ubuntu:latest       "/bin/bash"         27 minutes ago      Exited (0) About a minute ago                       sleepy_brattain

$ sudo docker start my-container
my-container

$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
3f363080f890        ubuntu:latest       "/bin/bash"         37 seconds ago      Up 5 seconds                            my-container

$ exit
logout
Connection to 54.157.237.22 closed.
```