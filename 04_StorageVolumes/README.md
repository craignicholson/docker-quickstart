# Storage Drivers

## State Which Graph Driver Should Be Used on Which OS

The idea with containers is you don't want to store data on the container.

Docker Volumes is what you want.

There are some cases when writing to the container stroage layer
is needed and you will need to choose a best storage driver
that is performant and supported on your OS's platform.

- Choose from a priotied list from Docker for your platform. Then stabiliy and performance.
- be aware of docker edition u are using.
- some storage drivers may not be available for you current or desired filesystem types or your OS.

EE
Distribution | Supported Storage Drivers
CentOS | devicemapper
Oracle Linux | devicemapper
RHEL | devicemapper, overlay2
SUSE Linux Enterprise Server | btrfs
Ubuntu | aufs3

CE
Distribution | Supported Storage Drivers
CentOS | devicemapper, vfs
Oracle Linux | devicemapper, overlay2
RHEL | devicemapper, overlay2
SUSE Linux Enterprise Server | btrfs
Debian/Ubuntu | aufs3, devicemapper, overlay2, overlay, vfs
Fedora | devicemapper, overlay2, overlay, vfs

Mac OSX | devicemapper (default only)... i have overlay2
Windows | devicemapper (default only)

### Workload Use Cases

Driver | WOrkload
aufs, overlay, overlay2 | operate file level, more eff. memory use, but container size grows fast
devicemapper, btrfs, ztfs | Operate at block level, allows for better performance in write heavy workloads as the expese of more memory
overlay | for worklads requiring small writes or containers with may or deep file systems, overlay may perform better than overlay2

> /etc/docker/daemon.json

## Summarize How an Image Is Composed of Multiple Layers on the Filesystem

A Docker image is built up, from a series of layers, each representing a single instruction in the image’s Dockerfile. Every layer except for the last, is a read-only layer.
A Dockerfile like:

  FROM centos:latest
  RUN yum update –y
  RUN yum install –y telnet
  ENTRYPOINT echo “This container has finished”

Would create four discrete layers in the construction of the image. Some commands can be chained so that multiple commands actually run, but only build a single layer (‘RUN yum update – y && yum install –y telnet’ for example).


n the case of the ‘httpd:latest’ image depicted to the left from Docker Hub, the image consists of 7 discrete layers.

Each layer represents a command that was run in the assembly of that image. Each layer is only the deltas from the previous image laying on top.

The only writable layer then becomes the ‘Thin R/W Layer’ for each container instantiated on that image’s R/O layers.

The configured Docker Storage Driver handles the details about how the image layers interact. See more information on Storage Driver Use Cases to determine which is supported and optimal for your platform, distribution and work load.
With each container having its own writable container layer, each image can maintain a 1 to N ratio of image storage to container storage (i.e. the image storage layers are never repeated).
As a result of Docker’s storage strategy of ‘Copy-On-Write’, files and directories that exist in lower layers that are needed in higher layers, can be provided read access to them to avoid duplication. If that file needs to be modified, only then is it copied to the higher layer where the changes are stored.
 
 Containers and Deletion
Any time a container is deleted, any data that is written to the container read/write layer that is NOT stored in a data volume, will be deleted along with the container.
Data volumes, since they are NOT controlled by the storage driver (since they represent a file or directory on the host filesystem in the /var/lib/docker directory), are able to bypass the storage driver. As a result, their contents are not affected when a container is removed.
This allows containers to remain portable while providing a method of persistent storage outside of the image and container layered filesystem structure.
 
 ## Describe How Storage and Volumes Can Be Used Across Cluster Nodes for Persistent Storage

 Volumes can be mounted to your container instances from your underlying host systems. In the case of clusters, this can be limiting because there is no built-in mechanism for your swarm to share a single filesystem. In this lesson, we will explore the process of mounting a volume in your swarm, where it is stored locally, and talk about ways we can share storage amongst the cluster nodes.

 docker service create
    we can't support -d or -volumes
    we can't be sure it will exits in a service... 


```bash

docker volume ls
docker volume create my-mount
docker volume inpect my-mount
docker images
docker service create --name testweb - 80:80 --mount source=my-mount,target=/internal-mount --detach=false --replicas 3 http

[user@craig-nicholsoneswlb4 ~]$ docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
3ps71kcghjvq        testweb             replicated          3/3                 httpd:latest        *:80->80/tcp
[user@craig-nicholsoneswlb4 ~]$ docker service rm testweb
testweb
[user@craig-nicholsoneswlb4 ~]$ docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS

[user@craig-nicholsoneswlb4 ~]$ docker service create --name testweb -p 80:80 --mount source=my-mount,target=/internal-mount --detach=false --replicas 3 httpd
hhe8snhkzc3l467ejt0ow0f0r
overall progress: 3 out of 3 tasks 
1/3: running   [==================================================>] 
2/3: running   [==================================================>] 
3/3: running   [==================================================>] 
verify: Service converged 
[user@craig-nicholsoneswlb4 ~]$ docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
hhe8snhkzc3l        testweb             replicated          3/3                 httpd:latest        *:80->80/tcp
[user@craig-nicholsoneswlb4 ~]$ docker service ps testweb
ID                  NAME                IMAGE               NODE                                    DESIRED STATE       CURRENT STATE            ERROR  
             PORTS
lxjxsorddek4        testweb.1           httpd:latest        craig-nicholsoneswlb5.mylabserver.com   Running             Running 17 seconds ago          
             
k18151g5p65s        testweb.2           httpd:latest        craig-nicholsoneswlb4.mylabserver.com   Running             Running 17 seconds ago          
             
ioo591qnftzb        testweb.3           httpd:latest        craig-nicholsoneswlb6.mylabserver.com   Running             Running 17 seconds ago          
             



```

### Node 1 & Manager plyaing with volumes.

craig-nicholsoneswlb4 login: user
Password: 
Last failed login: Fri Aug  3 16:14:56 UTC 2018 from ip49.ip-142-44-158.net on ssh:notty
There were 4 failed login attempts since the last successful login.
Last login: Fri Aug  3 12:15:13 from 108-74-118-125.lightspeed.tukrga.sbcglobal.net
[user@craig-nicholsoneswlb4 ~]$ 
[user@craig-nicholsoneswlb4 ~]$ 
[user@craig-nicholsoneswlb4 ~]$ docker volume ls
DRIVER              VOLUME NAME
[user@craig-nicholsoneswlb4 ~]$ docker volume create my-mount
my-mount
[user@craig-nicholsoneswlb4 ~]$ docker volume inspect my-mount
[
    {
        "CreatedAt": "2018-08-03T19:26:21Z",
        "Driver": "local",
        "Labels": {},
        "Mountpoint": "/var/lib/docker/volumes/my-mount/_data",
        "Name": "my-mount",
        "Options": {},
        "Scope": "local"
    }
]
[user@craig-nicholsoneswlb4 ~]$ docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
3ps71kcghjvq        testweb             replicated          3/3                 httpd:latest        *:80->80/tcp
[user@craig-nicholsoneswlb4 ~]$ docker service rm testweb
testweb
[user@craig-nicholsoneswlb4 ~]$ docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
[user@craig-nicholsoneswlb4 ~]$ docker service create --name testweb - 80:80 --mount source=my-mount,target=/internal-mount --detach=false --replicas 3 
http
Error response from daemon: rpc error: code = InvalidArgument desc = ContainerSpec: "-" is not a valid repository/tag
[user@craig-nicholsoneswlb4 ~]$ docker service create --name testweb - 80:80 --mount source=my-mount,target=/internal-mount --detach=false --replicas 3 
httpd
Error response from daemon: rpc error: code = InvalidArgument desc = ContainerSpec: "-" is not a valid repository/tag
[user@craig-nicholsoneswlb4 ~]$ docker service create --name testweb -p 80:80 --mount source=my-mount,target=/internal-mount --detach=false --replicas 3 httpd
hhe8snhkzc3l467ejt0ow0f0r
overall progress: 3 out of 3 tasks 
1/3: running   [==================================================>] 
2/3: running   [==================================================>] 
3/3: running   [==================================================>] 
verify: Service converged 
[user@craig-nicholsoneswlb4 ~]$ docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
hhe8snhkzc3l        testweb             replicated          3/3                 httpd:latest        *:80->80/tcp
[user@craig-nicholsoneswlb4 ~]$ docker service ps testweb
ID                  NAME                IMAGE               NODE                                    DESIRED STATE       CURRENT STATE            ERROR               PORTS
lxjxsorddek4        testweb.1           httpd:latest        craig-nicholsoneswlb5.mylabserver.com   Running             Running 17 seconds ago                       
k18151g5p65s        testweb.2           httpd:latest        craig-nicholsoneswlb4.mylabserver.com   Running             Running 17 seconds ago                       
ioo591qnftzb        testweb.3           httpd:latest        craig-nicholsoneswlb6.mylabserver.com   Running             Running 17 seconds ago                       
[user@craig-nicholsoneswlb4 ~]$ cd /var/lib/docker/volumes/my-mount/_data
-bash: cd: /var/lib/docker/volumes/my-mount/_data: Permission denied
[user@craig-nicholsoneswlb4 ~]$ sudo /var/lib/docker/volumes/my-mount/_data
[sudo] password for user: 


Sorry, try again.
[sudo] password for user: 
^Csudo: 2 incorrect password attempts
[user@craig-nicholsoneswlb4 ~]$ sudo cd /var/lib/docker/volumes/my-mount/_data
[sudo] password for user: 
[user@craig-nicholsoneswlb4 ~]$ ls
Desktop  VNCHOWTO  xrdp-chansrv.log
[user@craig-nicholsoneswlb4 ~]$ pwd
/home/user
[user@craig-nicholsoneswlb4 ~]$ cd /var/lib/docker/volumes/my-mount/_data
-bash: cd: /var/lib/docker/volumes/my-mount/_data: Permission denied
[user@craig-nicholsoneswlb4 ~]$ 
[user@craig-nicholsoneswlb4 ~]$ sudo -i

Warning: PATH set to RVM ruby but GEM_HOME and/or GEM_PATH not set, see:
    https://github.com/rvm/rvm/issues/3212

Hint: To fix PATH errors try using 'rvmsudo' instead of 'sudo', see:
    https://stackoverflow.com/questions/27784961/received-warning-message-path-set-to-rvm-after-updating-ruby-version-using-rvm/28080063#28080063

[root@craig-nicholsoneswlb4 ~]# cd /var/lib/docker/volumes/my-mount/_data
[root@craig-nicholsoneswlb4 _data]# echo "Hello from the host disk!"
-bash: !": event not found
[root@craig-nicholsoneswlb4 _data]# echo "Hello from the host disk" > hellow.txt
[root@craig-nicholsoneswlb4 _data]# ll
total 4
-rw-r--r--. 1 root root 25 Aug  3 19:31 hellow.txt
[root@craig-nicholsoneswlb4 _data]# cd
[root@craig-nicholsoneswlb4 ~]# docker volume ls
DRIVER              VOLUME NAME
local               my-mount
[root@craig-nicholsoneswlb4 ~]# docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
hhe8snhkzc3l        testweb             replicated          3/3                 httpd:latest        *:80->80/tcp
[root@craig-nicholsoneswlb4 ~]# docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS               NAMES
831171fade63        httpd:latest        "httpd-foreground"   7 minutes ago       Up 7 minutes        80/tcp              testweb.2.k18151g5p65sr3pyoqnr5musq
[root@craig-nicholsoneswlb4 ~]# docker exec -it 831171fade63 /bin/bash
root@831171fade63:/usr/local/apache2# cd/
bash: cd/: No such file or directory
root@831171fade63:/usr/local/apache2# cd /
root@831171fade63:/# ls
bin  boot  dev  etc  home  internal-mount  lib  lib64  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
root@831171fade63:/# ll 
bash: ll: command not found
root@831171fade63:/# ll
bash: ll: command not found
root@831171fade63:/# ls -al
total 32
drwxr-xr-x.  22 root root 4096 Aug  3 19:28 .
drwxr-xr-x.  22 root root 4096 Aug  3 19:28 ..
-rwxr-xr-x.   1 root root    0 Aug  3 19:28 .dockerenv
drwxr-xr-x.   2 root root 4096 Jul 31 16:49 bin
drwxr-xr-x.   2 root root    6 Jun 14 13:03 boot
drwxr-xr-x.   5 root root  340 Aug  3 19:28 dev
drwxr-xr-x.  42 root root 4096 Aug  3 19:28 etc
drwxr-xr-x.   2 root root    6 Jun 14 13:03 home
drwxr-xr-x.   2 root root   23 Aug  3 19:31 internal-mount
drwxr-xr-x.   9 root root 4096 Jul 31 16:49 lib
drwxr-xr-x.   2 root root   34 Jul 16 00:00 lib64
drwxr-xr-x.   2 root root    6 Jul 16 00:00 media
drwxr-xr-x.   2 root root    6 Jul 16 00:00 mnt
drwxr-xr-x.   2 root root    6 Jul 16 00:00 opt
dr-xr-xr-x. 143 root root    0 Aug  3 19:28 proc
drwx------.   2 root root   37 Jul 16 00:00 root
drwxr-xr-x.   3 root root   30 Jul 16 00:00 run
drwxr-xr-x.   2 root root 4096 Jul 16 00:00 sbin
drwxr-xr-x.   2 root root    6 Jul 16 00:00 srv
dr-xr-xr-x.  13 root root    0 Aug  3 19:22 sys
drwxrwxrwt.   2 root root    6 Jul 31 16:49 tmp
drwxr-xr-x.  10 root root 4096 Jul 16 00:00 usr
drwxr-xr-x.  11 root root 4096 Jul 16 00:00 var
root@831171fade63:/# cd internal-mount/
root@831171fade63:/internal-mount# ll
bash: ll: command not found
root@831171fade63:/internal-mount# ls
hellow.txt
root@831171fade63:/internal-mount# cat hellow.txt 
Hello from the host disk
root@831171fade63:/internal-mount# echo "Hello from the container" > container.txt
root@831171fade63:/internal-mount# cd /
root@831171fade63:/# pwd
/
root@831171fade63:/# cd internal-mount/
root@831171fade63:/internal-mount# pwd
/internal-mount
root@831171fade63:/internal-mount# exit
exit
[root@craig-nicholsoneswlb4 ~]# pwd
/root
[root@craig-nicholsoneswlb4 ~]# cd /var/lib/docker/volumes/my-mount/_data
[root@craig-nicholsoneswlb4 _data]# pwd
/var/lib/docker/volumes/my-mount/_data
[root@craig-nicholsoneswlb4 _data]# ls -al
total 8
drwxr-xr-x. 2 root root 43 Aug  3 19:36 .
drwxr-xr-x. 3 root root 18 Aug  3 19:26 ..
-rw-r--r--. 1 root root 25 Aug  3 19:36 container.txt
-rw-r--r--. 1 root root 25 Aug  3 19:31 hellow.txt
[root@craig-nicholsoneswlb4 _data]# cat container.txt 
Hello from the container
[root@craig-nicholsoneswlb4 _data]# 
[root@craig-nicholsoneswlb4 _data]# cd /
[root@craig-nicholsoneswlb4 /]# docker service rm testweb
testweb
[root@craig-nicholsoneswlb4 /]# docker volume ls
DRIVER              VOLUME NAME
local               my-mount
[root@craig-nicholsoneswlb4 /]# docker volume rm my-mount
my-mount
[root@craig-nicholsoneswlb4 /]# cd /var/lib/docker/volumes/
[root@craig-nicholsoneswlb4 volumes]# ls -al
total 28
drwx------.  2 root root    24 Aug  3 19:41 .
drwx--x--x. 15 root root  4096 Aug  3 19:23 ..
-rw-------.  1 root root 32768 Aug  3 19:41 metadata.db
[root@craig-nicholsoneswlb4 volumes]#



### Node 2

drwxr-xr-x.  42 root root 4096 Aug  3 19:28 etc
drwxr-xr-x.   2 root root    6 Jun 14 13:03 home
drwxr-xr-x.   2 root root    6 Aug  3 19:28 internal-mount
drwxr-xr-x.   9 root root 4096 Jul 31 16:49 lib
drwxr-xr-x.   2 root root   34 Jul 16 00:00 lib64
drwxr-xr-x.   2 root root    6 Jul 16 00:00 media
drwxr-xr-x.   2 root root    6 Jul 16 00:00 mnt
drwxr-xr-x.   2 root root    6 Jul 16 00:00 opt
dr-xr-xr-x. 144 root root    0 Aug  3 19:28 proc
drwx------.   2 root root   37 Jul 16 00:00 root
drwxr-xr-x.   3 root root   30 Jul 16 00:00 run
drwxr-xr-x.   2 root root 4096 Jul 16 00:00 sbin
drwxr-xr-x.   2 root root    6 Jul 16 00:00 srv
dr-xr-xr-x.  13 root root    0 Aug  3 19:22 sys
drwxrwxrwt.   2 root root    6 Jul 31 16:49 tmp
drwxr-xr-x.  10 root root 4096 Jul 16 00:00 usr
drwxr-xr-x.  11 root root 4096 Jul 16 00:00 var
root@570ca4d1def1:/# cd internal-mount/
root@570ca4d1def1:/internal-mount# ls -al
total 4
drwxr-xr-x.  2 root root    6 Aug  3 19:28 .
drwxr-xr-x. 22 root root 4096 Aug  3 19:28 ..
root@570ca4d1def1:/internal-mount# echo "2nd node in cluster" > node2.txt
root@570ca4d1def1:/internal-mount# exit
exit
[root@craig-nicholsoneswlb5 _data]# pwd
/var/lib/docker/volumes/my-mount/_data
[root@craig-nicholsoneswlb5 _data]# ls -al
total 4
drwxr-xr-x. 2 root root 22 Aug  3 19:39 .
drwxr-xr-x. 3 root root 18 Aug  3 19:28 ..
-rw-r--r--. 1 root root 20 Aug  3 19:39 node2.txt
[root@craig-nicholsoneswlb5 _data]# cat node2.txt 
2nd node in cluster
[root@craig-nicholsoneswlb5 _data]# 

## Identify the Steps You Would Take to Clean Up Unused Images (and Other Resources) On a File System (CLI)

Clean up all the dead items ... after we have been using docker to do stuff

> docker system prune -a 
> docker system prune --all


docker system prune
WARNING! This will remove:
        - all stopped containers
        - all networks not used by at least one container
        - all dangling images
        - all build cache
Are you sure you want to continue? [y/N] 


[root@craig-nicholsoneswlb4 /]# docker network ls
NETWORK ID          NAME                DRIVER              SCOPE
62dfe3071a82        bridge              bridge              local
62cdcf57695b        docker_gwbridge     bridge              local
a7aa25b5c5e8        host                host                local
dh260ff9qpr9        ingress             overlay             swarm
fedcd5372b53        none                null                local
[root@craig-nicholsoneswlb4 /]# docker system prune --volumes
WARNING! This will remove:
        - all stopped containers
        - all networks not used by at least one container
        - all volumes not used by at least one container
        - all dangling images
        - all build cache
Are you sure you want to continue? [y/N] 

Deleted Images:
untagged: httpd@sha256:8c84e065bdf72b4909bd55a348d5e91fe265e08d6b28ed9104bfdcac9206dcc8
deleted: sha256:11426a19f1a28d6491041aef1e1a7a2dcaa188d0165ae495de7d8fc1bf3e164f
deleted: sha256:e33b7d622c426b3ab06ee35395e2cd7a5fae3ed0a2b7cff4c11b4d66013e74a6
deleted: sha256:e9a8586250bc667d27d148bce538f957bfbe2650e6e55bb92b28a0b936eba760
deleted: sha256:0b8265e0f080ed1e508ce8ef414077e5b8bacaa30dd06f3f291e81db4ca06e0a
deleted: sha256:4adedfbb25455a15a1baaaf2998808265db750f680f84bf4f162f283a1cef3d5
deleted: sha256:3bb19f565a969ad4739925d0dbe06b7b67c35644d0ad3e2f93eeab6bab67424a
deleted: sha256:c522127fde8a4f5e3ac1b1b34461beaecfc8c48672ae117b69f40e264d5d84a0
deleted: sha256:dd1eb1fd7e08dc9bda0cbea31a89196c453cb218bea80ce64eeb19fadc98d262

Total reclaimed space: 177.5MB

[root@craig-nicholsoneswlb4 /]# docker network ls
NETWORK ID          NAME                DRIVER              SCOPE
62dfe3071a82        bridge              bridge              local
62cdcf57695b        docker_gwbridge     bridge              local
a7aa25b5c5e8        host                host                local
dh260ff9qpr9        ingress             overlay             swarm
fedcd5372b53        none                null                local

root@craig-nicholsoneswlb4 /]# docker system prune -a --volumes
WARNING! This will remove:
        - all stopped containers
        - all networks not used by at least one container
        - all volumes not used by at least one container
        - all images without at least one container associated to them
        - all build cache
Are you sure you want to continue? [y/N] y
Total reclaimed space: 0B

REMOVAL IS NOT SWARM AWARE so we go and remove/prune each server.

raig-nicholsoneswlb5 login: user 
Password: 
Last login: Fri Aug  3 19:32:30 on pts/0
[user@craig-nicholsoneswlb5 ~]$ docker system prune -a --volumes
WARNING! This will remove:
        - all stopped containers
        - all networks not used by at least one container
        - all volumes not used by at least one container
        - all images without at least one container associated to them
        - all build cache
Are you sure you want to continue? [y/N] y
Deleted Volumes:
my-mount
Deleted Images:
untagged: httpd@sha256:8c84e065bdf72b4909bd55a348d5e91fe265e08d6b28ed9104bfdcac9206dcc8
deleted: sha256:11426a19f1a28d6491041aef1e1a7a2dcaa188d0165ae495de7d8fc1bf3e164f
deleted: sha256:e33b7d622c426b3ab06ee35395e2cd7a5fae3ed0a2b7cff4c11b4d66013e74a6
deleted: sha256:e9a8586250bc667d27d148bce538f957bfbe2650e6e55bb92b28a0b936eba760
deleted: sha256:0b8265e0f080ed1e508ce8ef414077e5b8bacaa30dd06f3f291e81db4ca06e0a
deleted: sha256:4adedfbb25455a15a1baaaf2998808265db750f680f84bf4f162f283a1cef3d5
deleted: sha256:3bb19f565a969ad4739925d0dbe06b7b67c35644d0ad3e2f93eeab6bab67424a
deleted: sha256:c522127fde8a4f5e3ac1b1b34461beaecfc8c48672ae117b69f40e264d5d84a0
deleted: sha256:dd1eb1fd7e08dc9bda0cbea31a89196c453cb218bea80ce64eeb19fadc98d262
Total reclaimed space: 177.5MB

[user@craig-nicholsoneswlb6 ~]$ docker system prune -a --volumes
WARNING! This will remove:
        - all stopped containers
        - all networks not used by at least one container
        - all volumes not used by at least one container
        - all images without at least one container associated to them
        - all build cache
Are you sure you want to continue? [y/N] y
Deleted Volumes:
my-mount
Deleted Images:
untagged: httpd@sha256:8c84e065bdf72b4909bd55a348d5e91fe265e08d6b28ed9104bfdcac9206dcc8
deleted: sha256:11426a19f1a28d6491041aef1e1a7a2dcaa188d0165ae495de7d8fc1bf3e164f
deleted: sha256:e33b7d622c426b3ab06ee35395e2cd7a5fae3ed0a2b7cff4c11b4d66013e74a6
deleted: sha256:e9a8586250bc667d27d148bce538f957bfbe2650e6e55bb92b28a0b936eba760
deleted: sha256:0b8265e0f080ed1e508ce8ef414077e5b8bacaa30dd06f3f291e81db4ca06e0a
deleted: sha256:4adedfbb25455a15a1baaaf2998808265db750f680f84bf4f162f283a1cef3d5
deleted: sha256:3bb19f565a969ad4739925d0dbe06b7b67c35644d0ad3e2f93eeab6bab67424a
deleted: sha256:c522127fde8a4f5e3ac1b1b34461beaecfc8c48672ae117b69f40e264d5d84a0
deleted: sha256:dd1eb1fd7e08dc9bda0cbea31a89196c453cb218bea80ce64eeb19fadc98d262
