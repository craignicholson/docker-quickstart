# Managing Containers (Creating, Starting and Stopping)


1. Create a container from the base image for the latest version of Ubuntu available (if you do not have an Ubuntu base image installed locally, pull the latest one down for your local repository). The container should be started in interactive mode attached to the current terminal and running the bash shell. Once running, shut the container down by exiting.

[user@tcox1 ~]$ sudo docker pull ubuntu:latest
Trying to pull repository docker.io/library/ubuntu ... 
latest: Pulling from docker.io/library/ubuntu

ae79f2514705: Pull complete 
5ad56d5fc149: Pull complete 
170e558760e8: Pull complete 
395460e233f5: Pull complete 
6f01dc62e444: Pull complete 
Digest: sha256:506e2d5852de1d7c90d538c5332bd3cc33b9cbd26f6ca653875899c505c82687
[user@tcox1 ~]$ sudo docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
docker.io/httpd     latest              c24f66af34b4        5 days ago          177.3 MB
docker.io/ubuntu    latest              747cb2d60bbe        7 days ago          122 MB
[user@tcox1 ~]$ sudo docker run -it ubuntu:latest /bin/bash
root@f1d4d12c2c70:/# exit
exit
2. Run the appropriate Docker command to get the name of the previously run container. Issue the appropriate command to restart the container that you obtained the name of. Do NOT create a new container, restart the one we just used.

[user@tcox1 ~]$ sudo docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED              STATUS                          PORTS               NAMES
f1d4d12c2c70        ubuntu:latest       "/bin/bash"         About a minute ago   Exited (0) About a minute ago                       jovial_kilby
[user@tcox1 ~]$ sudo docker restart jovial_kilby
jovial_kilby
[user@tcox1 ~]$ sudo docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
f1d4d12c2c70        ubuntu:latest       "/bin/bash"         2 minutes ago       Up 7 seconds                            jovial_kilby
3. Stop the container. Remove that container from the system completely using the appropriate command.

[user@tcox1 ~]$ sudo docker stop jovial_kilby
jovial_kilby
[user@tcox1 ~]$ sudo docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
[user@tcox1 ~]$ sudo docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                      PORTS               NAMES
f1d4d12c2c70        ubuntu:latest       "/bin/bash"         3 minutes ago       Exited (0) 10 seconds ago                       jovial_kilby
[user@tcox1 ~]$ sudo docker rm jovial_kilby
jovial_kilby
[user@tcox1 ~]$ sudo docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
4. Create (not run) a container called "my_container", create it with parameters that will allow it to run interactively and attached to the local console running the bash shell. Verify that the container is not running.

[user@tcox1 ~]$ sudo docker create -it --name="my-container" ubuntu:latest /bin/bash
c90b35870c09fe63d1bac782342dd734b2edf4ac6abb282690d1585aa259841e
[user@tcox1 ~]$ sudo docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
c90b35870c09        ubuntu:latest       "/bin/bash"         4 seconds ago       Created                                 my-container
5. Start the container and again, verify the container is running. Run the appropriate command to attach your session to the running container so you are logged into the shell.

[user@tcox1 ~]$ sudo docker start my-container
my-container
[user@tcox1 ~]$ sudo docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
c90b35870c09        ubuntu:latest       "/bin/bash"         4 minutes ago       Up 2 minutes                            my-container
[user@tcox1 ~]$ sudo docker attach my-container
root@c90b35870c09:/# 
root@c90b35870c09:/# exit
exit





craig:quickstart05 cn$ ssh user@54.157.237.22
user@54.157.237.22's password: 
Last login: Wed Aug  1 21:15:52 2018 from 108-74-118-125.lightspeed.tukrga.sbcglobal.net
[user@craig-nicholsoneswlb5 ~]$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
newcentos           withapached         18a9ff0a4eb6        18 minutes ago      461MB
ubuntu              latest              735f80812f90        5 days ago          83.5MB
centos              6                   70b5d81549ec        3 months ago        195MB
[user@craig-nicholsoneswlb5 ~]$ docker rmi newcentos:withapached
Error response from daemon: conflict: unable to remove repository reference "newcentos:withapached" (must force) - container 265c4c0739b1 is using its referenced image 18a9ff0a4eb6
[user@craig-nicholsoneswlb5 ~]$ docker ps -a
CONTAINER ID        IMAGE                   COMMAND             CREATED             STATUS                      PORTS               NAMES
265c4c0739b1        newcentos:withapached   "/bin/bash"         18 minutes ago      Exited (0) 6 minutes ago                        elegant_clarke
844866456de3        centos:6                "/bin/bash"         24 minutes ago      Exited (1) 19 minutes ago                       awesome_hugle
[user@craig-nicholsoneswlb5 ~]$ docker rm $(docker ps -a -q)
265c4c0739b1
844866456de3
[user@craig-nicholsoneswlb5 ~]$ docker run -it ubuntu:latest /bin/bash
root@8728d80ac38d:/# exit
exit
[user@craig-nicholsoneswlb5 ~]$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
[user@craig-nicholsoneswlb5 ~]$ docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                     PORTS               NAMES
8728d80ac38d        ubuntu:latest       "/bin/bash"         10 seconds ago      Exited (0) 4 seconds ago                       sleepy_brattain
[user@craig-nicholsoneswlb5 ~]$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
newcentos           withapached         18a9ff0a4eb6        20 minutes ago      461MB
ubuntu              latest              735f80812f90        5 days ago          83.5MB
centos              6                   70b5d81549ec        3 months ago        195MB
[user@craig-nicholsoneswlb5 ~]$ docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                      PORTS               NAMES
8728d80ac38d        ubuntu:latest       "/bin/bash"         42 seconds ago      Exited (0) 36 seconds ago                       sleepy_brattain
[user@craig-nicholsoneswlb5 ~]$ docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                      PORTS               NAMES
8728d80ac38d        ubuntu:latest       "/bin/bash"         25 minutes ago      Exited (0) 25 minutes ago                       sleepy_brattain
[user@craig-nicholsoneswlb5 ~]$ docker restart sleepy_brattain
sleepy_brattain
[user@craig-nicholsoneswlb5 ~]$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
8728d80ac38d        ubuntu:latest       "/bin/bash"         25 minutes ago      Up 2 seconds                            sleepy_brattain
[user@craig-nicholsoneswlb5 ~]$ docker stop sleepy_brattain
sleepy_brattain
[user@craig-nicholsoneswlb5 ~]$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
[user@craig-nicholsoneswlb5 ~]$ docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                     PORTS               NAMES
8728d80ac38d        ubuntu:latest       "/bin/bash"         26 minutes ago      Exited (0) 5 seconds ago                       sleepy_brattain
[user@craig-nicholsoneswlb5 ~]$ sudo docker create -it --name="my-container" ubuntu:latest /bin/bash
[sudo] password for user: 
Sorry, try again.
[sudo] password for user: 
3f363080f890bc0786f86a2f4e11aed9fc48c688cfdb9d34c6ce32ba9be54fa6
[user@craig-nicholsoneswlb5 ~]$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
[user@craig-nicholsoneswlb5 ~]$ docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                          PORTS               NAMES
3f363080f890        ubuntu:latest       "/bin/bash"         10 seconds ago      Created                                             my-container
8728d80ac38d        ubuntu:latest       "/bin/bash"         27 minutes ago      Exited (0) About a minute ago                       sleepy_brattain
[user@craig-nicholsoneswlb5 ~]$ sudo docker start my-container
my-container
[user@craig-nicholsoneswlb5 ~]$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
3f363080f890        ubuntu:latest       "/bin/bash"         37 seconds ago      Up 5 seconds                            my-container
[user@craig-nicholsoneswlb5 ~]$ sudo docker attach my-containe
Error: No such container: my-containe
[user@craig-nicholsoneswlb5 ~]$ ls 
Desktop  VNCHOWTO  xrdp-chansrv.log
[user@craig-nicholsoneswlb5 ~]$ cat xrdp-chansrv.log 
[20160318-18:36:49] [CORE ] main: app started pid 16435(0x00004033)
[user@craig-nicholsoneswlb5 ~]$ exot
-bash: exot: command not found
[user@craig-nicholsoneswlb5 ~]$ exit
logout
Connection to 54.157.237.22 closed.
craig:quickstart05 cn$ 

