# Storage Drivers

## State Which Graph (STORAGE) Driver Should Be Used on Which OS

The idea with containers is you don't want to store data on the container.

Docker Volumes is what you want.

There are some cases when writing to the container stroage layer
is needed and you will need to choose a best storage driver
that is performant and supported on your OS's platform.

- Choose from a priotied list from Docker for your platform. Then stabiliy and performance.
- be aware of docker edition u are using.
- some storage drivers may not be available for you current or desired filesystem types or your OS.

### EE- MEMORIZE

|Distribution | Supported Storage Drivers|
|-------------|--------------------------|
|      CentOS | devicemapper|
|Oracle Linux | devicemapper|
|      RHEL   | devicemapper, overlay2 |
| SUSE Linux Enterprise Server | btrfs |
|      Ubuntu | aufs3 |

### CE - MEMORIZE

| Distribution | Supported Storage Drivers|
|--------------|--------------------------|
| CentOS | devicemapper, vfs|
| Oracle Linux | devicemapper, overlay2|
| RHEL | devicemapper, overlay2|
| SUSE Linux Enterprise Server | btrfs|
| Debian/Ubuntu | aufs3, devicemapper, overlay2, overlay, vfs|
| Fedora | devicemapper, overlay2, overlay, vfs|

### Development Machines

These are meant to support multiple storage drivers

| Distribution | Supported Storage Drivers|
|--------------|--------------------------|
|Mac OSX | devicemapper (default only)... i have overlay2|
|Windows | devicemapper (default only)|

### Workload Use Cases

| Driver | Workload |
|--------------|--------------------------|
|aufs, overlay, overlay2 | operate file level, more eff. memory use, but container size grows fast|
|devicemapper, btrfs, ztfs | Operate at block level, allows for better performance in write heavy workloads as the expese of more memory|
|overlay | for worklads requiring small writes or containers with may or deep file systems, overlay may perform better than overlay2|

> /etc/docker/daemon.json

## Summarize How an Image Is Composed of Multiple Layers on the Filesystem

A Docker image is built up, from a series of layers, each representing a single instruction in the image’s Dockerfile. 

> Every layer except for the last, is a read-only layer.

This leads to the Copy-On-Write.

A Dockerfile like:

```Dockerfile
  FROM centos:latest
  RUN yum update –y
  RUN yum install –y telnet
  ENTRYPOINT echo “This container has finished”
```

Would create four discrete layers in the construction of the image. Some commands can be chained so that multiple commands actually run, but only build a single layer (‘RUN yum update – y && yum install –y telnet’ for example).

In the case of the ‘httpd:latest’ image depicted to the left from Docker Hub, the image consists of 7 discrete layers.

Each layer represents a command that was run in the assembly of that image. Each layer is only the deltas from the previous image laying on top.

The only writable layer then becomes the ‘Thin R/W Layer’ for each container instantiated on that image’s R/O layers.

The configured Docker Storage Driver handles the details about how the image layers interact.

See more information on Storage Driver Use Cases to determine which is supported and optimal for your platform, distribution and work load.
With each container having its own writable container layer, each image can maintain a 1 to N ratio of image storage to container storage (i.e. the image storage layers are never repeated).

> If we have 100 containers based on same image, they image is not replicated 100 times, only small diffs between the container's present state and image used.

### Copy-On-Write

As a result of Docker’s storage strategy of ‘Copy-On-Write’, files and directories that exist in lower layers that are needed in higher layers, can be provided read access to them to avoid duplication. If that file needs to be modified, only then is it copied to the higher layer where the changes are stored.

### Containers and Deletion

Any time a container is deleted, any data that is written to the container read/write layer that is NOT stored in a data volume, will be deleted along with the container.

Data volumes, since they are NOT controlled by the storage driver (since they represent a file or directory on the host filesystem in the /var/lib/docker directory), are able to bypass the storage driver. As a result, their contents are not affected when a container is removed.
This allows containers to remain portable while providing a method of persistent storage outside of the image and container layered filesystem structure.

Dockerfiles describes this well.

## Describe How Storage and Volumes Can Be Used Across Cluster Nodes for Persistent Storage

 Volumes can be mounted to your container instances from your underlying host systems. In the case of clusters, this can be limiting because there is no built-in mechanism for your swarm to share a single filesystem. 
 
 In this lesson, we will explore the process of mounting a volume in your swarm, where it is stored locally, and talk about ways we can share storage amongst the cluster nodes.

```bash
# create a volume to use in a service on a cluster
docker volume create my-mount

# review the volume
docker volume inspect my-mount
```

```json
[
    {
        "CreatedAt": "2018-08-14T22:45:13Z",
        "Driver": "local",
        "Labels": {},
        "Mountpoint": "/var/lib/docker/volumes/my-mount/_data",
        "Name": "my-mount",
        "Options": {},
        "Scope": "local"
    }
]
```

Note `docker volume inspect my-mount` and `docker inspect my-mount` both work.

```bash
docker inspect my-mount
```

```json
[
    {
        "CreatedAt": "2018-08-14T22:45:13Z",
        "Driver": "local",
        "Labels": {},
        "Mountpoint": "/var/lib/docker/volumes/my-mount/_data",
        "Name": "my-mount",
        "Options": {},
        "Scope": "local"
    }
]
```

Also note the location of the volume on the host.

> "Mountpoint": "/var/lib/docker/volumes/my-mount/_data",

### Create a service to use a volume on the Manager

```bash
# Write out a file to the mount
sudo echo "This is a host file" >> /var/lib/docker/volumes/my-mount/_data/hostfile.txt

# For services -v and --volumes is not supported for services
# only --mount is supported for services
# verify the above statement
docker service create --name testweb -p 80:80 --mount source=my-mount,target=/internal-mount --detach=false --replicas 3 httpd
hhe8snhkzc3l467ejt0ow0f0r
overall progress: 3 out of 3 tasks
1/3: running   [==================================================>]
2/3: running   [==================================================>]
3/3: running   [==================================================>]
verify: Service converged

docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
hhe8snhkzc3l        testweb             replicated          3/3                 httpd:latest        *:80->80/tcp

docker service ps testweb
ID                  NAME                IMAGE               NODE                                    DESIRED STATE       CURRENT STATE            ERROR  
             PORTS
lxjxsorddek4        testweb.1           httpd:latest        craig-nicholsoneswlb5.mylabserver.com   Running             Running 17 seconds ago
k18151g5p65s        testweb.2           httpd:latest        craig-nicholsoneswlb4.mylabserver.com   Running             Running 17 seconds ago
ioo591qnftzb        testweb.3           httpd:latest        craig-nicholsoneswlb6.mylabserver.com   Running             Running 17 seconds ago

```

### Node 1 & Manager using volumes

```bash

# cd into the host's directory and write a file
sudo -i
cd /var/lib/docker/volumes/my-mount/_data
echo "Hello from the host disk" > hello.txt
ll
total 4
-rw-r--r--. 1 root root 25 Aug  3 19:31 hellow.txt
exit

# login to a node
docker exec -it 831171fade63 /bin/bash

# Go look inside the internal_mount dir
root@831171fade63:/usr/local/apache2# cd /
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
...

root@831171fade63:/# cd internal-mount/
root@831171fade63:/internal-mount# ls
hello.txt

root@831171fade63:/internal-mount# cat hello.txt
Hello from the host disk

# while we are inside the container, write a new file
# exit the container
root@831171fade63:/internal-mount# echo "Hello from the container" > container.txt
root@831171fade63:/internal-mount# exit
exit

# back on the host review the data inside /var/lib/docker/volumes/my-mount/_data
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
```

### Node 2

Check Node 2 to see if the internal_mount is there.

```bash
# login to a node
docker exec -it 831171fade63 /bin/bash

root@570ca4d1def1:/# cd internal-mount/
root@570ca4d1def1:/internal-mount# ls -al
total 4
drwxr-xr-x.  2 root root    6 Aug  3 19:28 .
drwxr-xr-x. 22 root root 4096 Aug  3 19:28 ..
root@570ca4d1def1:/internal-mount# echo "2nd node in cluster" > node2.txt
root@570ca4d1def1:/internal-mount# exit
exit

pwd
/var/lib/docker/volumes/my-mount/_data
ls -al
total 4
drwxr-xr-x. 2 root root 22 Aug  3 19:39 .
drwxr-xr-x. 3 root root 18 Aug  3 19:28 ..
-rw-r--r--. 1 root root 20 Aug  3 19:39 node2.txt

cat node2.txt
2nd node in cluster

```

Note, each file exists on the machine we created it on for those Nodes.  There is no replication for the data.

### Clean up

```bash
docker service rm testweb
docker volume rm my-mount
```

Once we do this the data is gone.  You need to back this data up.  All data should be external so you can skip this limitation of the
mount locally in the /var/lib/docker/volumes dir.

## Identify the Steps You Would Take to Clean Up Unused Images (and Other Resources) On a File System (CLI)

When dealing with images (and other resources) on your Docker systems, outside of DTR, you can use the 'docker prune' command to control resources that are not attached to Docker objects and whether they get to 'hang around' or not. Let's see how!

Clean up all the dead items ... after we have been using docker to do stuff

> docker system prune -a
> docker system prune --all

Usage: docker system prune [OPTIONS]

```bash
Options:
  -a, --all             Remove all unused images not just dangling ones
      --filter filter   Provide filter values (e.g. 'label=<key>=<value>')
  -f, --force           Do not prompt for confirmation
      --volumes         Prune volumes
```

### Example of `docker system prune`

```bash
docker system prune
WARNING! This will remove:
        - all stopped containers
        - all networks not used by at least one container
        - all dangling images
        - all build cache
Are you sure you want to continue? [y/N]
```

```bash
docker network ls
NETWORK ID          NAME                DRIVER              SCOPE
62dfe3071a82        bridge              bridge              local
62cdcf57695b        docker_gwbridge     bridge              local
a7aa25b5c5e8        host                host                local
dh260ff9qpr9        ingress             overlay             swarm
fedcd5372b53        none                null                local

docker system prune --volumes
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
```

Review the networks

```bash
[root@craig-nicholsoneswlb4 /]# docker network ls
NETWORK ID          NAME                DRIVER              SCOPE
62dfe3071a82        bridge              bridge              local
62cdcf57695b        docker_gwbridge     bridge              local
a7aa25b5c5e8        host                host                local
dh260ff9qpr9        ingress             overlay             swarm
fedcd5372b53        none                null                local
```

### Do everything all at once `docker system prune -a --volumes`

Set us back to fresh install. Per Machine. To do all nodes in cluster you need to run this across all nodes in cluster.

```bash
docker system prune -a --volumes
WARNING! This will remove:
        - all stopped containers
        - all networks not used by at least one container
        - all volumes not used by at least one container
        - all images without at least one container associated to them
        - all build cache
Are you sure you want to continue? [y/N] y
Total reclaimed space: 0B

# REMOVAL IS NOT SWARM AWARE so we go and remove/prune each server.
```

## Creating and Working With Volumes

```bash
# 1. Using the appropriate Docker command, create a storage volume for use by your containers, call the volume 'test-volume'
docker volume create test-volume
test-volume

#2. Display all the Docker storage volumes that exist on your local system
docker volume ls
DRIVER              VOLUME NAME
local               test-volume

# 3. Execute the Docker command that will allow you to display all the attributes of that newly created 'test-volume'
docker volume inspect test-volume
[
    {
        "CreatedAt": "2017-10-18T19:31:42Z",
        "Driver": "local",
        "Labels": {},
        "Mountpoint": "/var/lib/docker/volumes/test-volume/_data",
        "Name": "test-volume",
        "Options": {},
        "Scope": "local"
    }
]

#4. Display the location on the host file system where that 'test-volume' exists and note the permissions
ls -al /var/lib/docker/volumes/test-volume/_data
ls: cannot access /var/lib/docker/volumes/test-volume/_data: Permission denied
sudo ls -al /var/lib/docker/volumes/test-volume/_data
[sudo] password for user: 
total 0
drwxr-xr-x. 2 root root  6 Oct 18 19:31 .
drwxr-xr-x. 3 root root 18 Oct 18 19:31 ..
sudo ls -al /var/lib/docker/volumes/test-volume/
total 0
drwxr-xr-x. 3 root root 18 Oct 18 19:31 .
drwx------. 3 root root 42 Oct 18 19:31 ..
drwxr-xr-x. 2 root root  6 Oct 18 19:31 _data

# 5. Remove the newly created 'test-volume' and then run the command to verify that the volume has been deleted
docker volume rm test-volume
test-volume
docker volume ls
DRIVER              VOLUME NAME
```

## Using External Volumes Within Your Containers

```bash
# Create a Docker volume called 'http-files' and then list all volumes to confirm it was created
docker volume create http-files
http-files

docker volume ls
DRIVER              VOLUME NAME
local               http-files

# Execute the appropriate Docker command to display ALL information on the 'http-files' volume, make a note of the filesystem location that volume is linked to on your host
docker volume inspect http-files
[
    {
        "CreatedAt": "2017-10-19T21:20:43Z",
        "Driver": "local",
        "Labels": {},
        "Mountpoint": "/var/lib/docker/volumes/http-files/_data",
        "Name": "http-files",
        "Options": {},
        "Scope": "local"
    }
]

# Pull the 'httpd' image from the standard Docker repository and verify it was installed locally
docker pull httpd

docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
httpd               latest              c24f66af34b4        7 days ago          177MB
# Create an 'index.html' file of your choosing and copy it to the HOST directory that your 'http-files' volume is linked to (obtained in Step  2 above)
# NOTE: This command is done as ROOT user
 echo "This is my test website index file" > /var/lib/docker/volumes/http-files/_data/index.html
 cat /var/lib/docker/volumes/http-files/_data/index.html
This is my test website index file

# Start a container based on the 'httpd' image with the following characteristics:
#  - the container should run in the background (i.e. you are not connected to it in the current terminal)
#  - name the container 'test-web'
#  - associate the created volume 'http-files' with the container directory path of /usr/local/apache2/htdocs
docker run -d --name test-web --mount source=http-files,target=/usr/local/apache2/htdocs httpd
09fd2cf1b701287939065cba06d531ae6119b022459b0a865ccfed17e6b28ab0
docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS               NAMES
09fd2cf1b701        httpd               "httpd-foreground"   4 seconds ago       Up 3 seconds        80/tcp              test-web

# Using the appropriate Docker command, find out the container's IP address and note it
docker inspect test-web | grep IPAddress
            "SecondaryIPAddresses": null,
            "IPAddress": "172.17.0.2",
                    "IPAddress": "172.17.0.2",
# Execute the 'curl' command against that IP address to display the Apache website running on the container, verify the output is from your created 'index.html' file
curl http://172.17.0.2
This is my test website index file

#Make a change to the 'index.html' file on the container's host and save the file. Rerun the 'curl' command to verify the container's website is now displaying the new value
#NOTE: These commands are run as ROOT user to access the HOST directory the index file is in
 echo "This is a CHANGED website file" > /var/lib/docker/volumes/http-files/_data/index.html
 curl http://172.17.0.2
This is a CHANGED website file
```

## Creating a Bind Mount to Link Container Filesystem to Host Filesystem

The 'bind' type will allow the container access to the underlying host operating system from the indicated target directory in the container filesystem.

```bash

# Create a directory in your home directory called 'content'. Within this directory, place a file called 'index.html' containing any text you wish.
mkdir content
echo "This is a test web site in a container" > content/index.html
ls -al content
total 8
drwxrwxr-x.  2 user user   23 Dec 21 16:32 .
drwx------. 10 user user 4096 Dec 21 16:31 ..
-rw-rw-r--.  1 user user   39 Dec 21 16:32 index.html

# Using the appropriate Docker CE command, download the image called 'httpd:latest' to your system.
docker pull httpd
Status: Downloaded newer image for httpd:latest

# Instantiate a container on this single host with the following characteristics:
#  * name the container 'testweb'
#  * map container port 80 to the host port 80
#  * create a bind mapping from the container directory of /usr/local/apache2/htdocs to the local host directory you created above using the complete path.  A bind mapping is directly from the host vs using docker create volume, and mount.
#  * base the container on the 'httpd' image downloaded above
#  * run the contained in 'detached' mode
docker run -d --name testweb -p 80:80 --mount type=bind,source=/home/user/content,target=/usr/local/apache2/htdocs httpd
054b6dc6c49aaeb6a7ef7000794c0212eba5ec773b04ba3ff637a402a812220a

# Verify the container is running
docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS                NAMES
054b6dc6c49a        httpd               "httpd-foreground"   29 seconds ago      Up 27 seconds       0.0.0.0:80->80/tcp   testweb

# Use curl to connect to your local IP over port 80 and verify the created index file created above is displayed
curl http://172.31.19.60
#NOTE: Will display the created file in the console browser if commands completed correctly!
```

## Display Details About Your Containers and Control the Display of Output

```bash
# Using the appropriate Docker CE commands, download the latest 'nginx' webserver image from Docker Hub.

docker pull nginx
Status: Downloaded newer image for nginx:latest

# Instantiate a container based on the 'nginx' image from the previous step. This container should have the following characteristics:
#  * when started, the container should run in 'detached' mode
#  * name the container 'nginxtest'
#  * use the appropriate option to allow Docker to map all container service ports to random host ports over 32768
#  * the container is based on the 'nginx' image from step one
docker run -d --name nginxtests -P nginx
590b38619f5db236b2ee77d2594ec23da0d7a041c80a86c7c29ad56abb0f8885

# Verify the container is running and find the host port that is mapped to the web server's port 80
docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                   NAMES
590b38619f5d        nginx               "nginx -g 'daemon ..."   31 seconds ago      Up 30 seconds       0.0.0.0:32768->80/tcp   nginxtests

# Using the appropriate Docker command, find the CONTAINER IP address ONLY (use the aforementioned appropriate command and JUST display the IP address using its built in options)
docker container inspect --format="{{.NetworkSettings.Networks.bridge.IPAddress}}" nginxtests
172.17.0.2
```

## Hands-on Lab: Working with the DeviceMapper Storage Driver

Your development team has been working on their understanding of Docker in general and Docker Swarms in particular. They are experimenting with different ways of understanding and optimizing storage on the underlying hosts. As a result, they have asked for your assistance in comparing traditional host based default storage on a Docker host with the 'devicemapper' storage driver on a second Docker host.

They have provided you with the credentials to connect to two hosts for this activity. You have been asked to install and configure Docker, enabled so that it starts on boot, on both hosts.

On the first host, they would like the default storage subsystem to be left as is. On the second host, they would llike you to change the Docker storage subsystem to the 'devicemapper' driver. This will enable them to compare image and container storage utilization using LVM thin provisioning vs. standard storage.

On each host, once configured, install the following images for their use and then turn the systems over to them once you verify their installation:

- CentOS (Latest)
- HTTPD
- Ubuntu (Latest)

### NODE 1

```bash

ssh cloud_user@52.91.215.104
cloud_user@52.91.215.104\'s password:

# install docker
bash <(curl -s https://raw.githubusercontent.com/craignicholson/docker-quickstart/master/03_Orchestration/centos7_dockerInstall.sh)
[cloud_user@ip-10-0-0-11 ~]$ docker pull httpd
Using default tag: latest
[cloud_user@ip-10-0-0-11 ~]$ exit
logout
Connection to 52.91.215.104 closed.

# logout and back in to make sure local user is in docker group
craig:~ cn$ ssh cloud_user@52.91.215.104
cloud_user@52.91.215.104\'s password:
[cloud_user@ip-10-0-0-11 ~]$ docker pull httpd
Status: Downloaded newer image for httpd:latest

[cloud_user@ip-10-0-0-11 ~]$ sudo ls -al /etc/docker/
[sudo] password for cloud_user:
total 16
drwx------.  2 root root   22 Aug  3 18:19 .
drwxr-xr-x. 78 root root 8192 Aug  3 18:19 ..
-rw-------.  1 root root  244 Aug  3 18:19 key.json
[cloud_user@ip-10-0-0-11 ~]$ sudo cd /etc/docker/
[cloud_user@ip-10-0-0-11 ~]$ pwd
/home/cloud_user
[cloud_user@ip-10-0-0-11 ~]$ cd /etc/docker/
-bash: cd: /etc/docker/: Permission denied
[cloud_user@ip-10-0-0-11 ~]$ sudo cd /etc/docker/
[cloud_user@ip-10-0-0-11 ~]$ pwd
/home/cloud_user

[cloud_user@ip-10-0-0-11 ~] docker info | grep Storage
Storage Driver: overlay2
```

### NODE 2

```bash
# install docker
bash <(curl -s https://raw.githubusercontent.com/craignicholson/docker-quickstart/master/03_Orchestration/centos7_dockerInstall.sh)
[cloud_user@ip-10-0-0-12 ~]$ docker pull httpd
Using default tag: latest
[cloud_user@ip-10-0-0-12 ~]$ exit
logout
Connection to 52.91.215.104 closed.

[cloud_user@ip-10-0-0-12 ~]$ sudo ls -al /etc/docker/
[sudo] password for cloud_user: 
total 16
drwx------.  2 root root   22 Aug  3 18:19 .
drwxr-xr-x. 78 root root 8192 Aug  3 18:19 ..
-rw-------.  1 root root  244 Aug  3 18:19 key.json

[cloud_user@ip-10-0-0-12 ~]$ sudo cd /etc/docker/
[cloud_user@ip-10-0-0-12 ~]$ sudo -i
[root@ip-10-0-0-12 ~] cd /etc/docker/
[root@ip-10-0-0-12 docker]# pwd
/etc/docker
[root@ip-10-0-0-12 docker]# vi daemon.json
[root@ip-10-0-0-12 docker]# cat daemon.json
{
  "storage-driver": "devicemapper"
}

[root@ip-10-0-0-12 docker] systemctl restart docker

[root@ip-10-0-0-12 docker] docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
[root@ip-10-0-0-12 docker] docker info | grep Storage
WARNING: devicemapper: usage of loopback devices is strongly discouraged for production use.
         Use `--storage-opt dm.thinpooldev` to specify a custom block storage device.
Storage Driver: devicemapper

```

## Hands-on Lab: Configuring Containers to Use Host Storage Mounts

In their continuing quest to containerize their new Web-based API, the development team would like to experiment with containers that use the underlying host's storage system in order to be able to do quick site builds without having to recycle the containers themselves.

As a result, you have been provided the credentials and access to a single development server. They have asked that you install Docker CE and configure it so that it starts on boot. Once done, please pull down the latest 'httpd' image from the default repository to the local filesystem and verify it is present.

Create two directories that will be designed to house two separate versions of their test website (call them 'version1' and 'version2' for example, however, you can use whatever name you wish). Once created, for testing, create a simple 'index.html' file in each so that you can easily differentiate each directory when viewed.

Finally, instantiate two containers. Name them 'test-web1' and 'test-web2' that are based on the 'httpd' image installed earlier. Be sure to redirect the underlying directories (version1 and version2 respectively if those are the directories you created), so that each container has access to one of those directories as the default site directory (for this image, that would be '/usr/local/apache2/htdocs') within the container.

Verify that the directories are serving the content of each container using a text based web browser (like 'lynx' or 'elinks'). NOTE: You will have to obtain each container's assigned IP in order to complete your test, so be sure to use the appropriate command to get that information.

Once you have completed that verification, you can turn the server over to your Dev Team for their testing and use.

SERVER 1
Public IP: 184.72.108.229
Private IP: 10.0.0.11

SERVER 2
Public IP: 54.157.227.221
Private IP: 10.0.0.12

SERVER 1
User: cloud_user
Password: dDWvkRwJhV

SERVER 2
User: cloud_user
Password: dDWvkRwJhV

```bash
# install docker
bash <(curl -s https://raw.githubusercontent.com/craignicholson/docker-quickstart/master/03_Orchestration/centos7_dockerInstall.sh)

# open up the firewall
sudo systemctl disable firewalld && sudo systemctl stop firewalld

# make some dir to put a .html file to serve up to the web services
mkdir -p content/version1
echo "Verions 1" > /version1/index.html

# make some dir to put a .html file to serve up to the web services
mkdir -p content/version2
echo "Verions Two" > /content/version1/index.html

# edit the hosts file so our servers can communicate with each other
sudo vim /etc/hosts
10.0.0.11 manager
10.0.0.12 node1

# run a test container
docker run -d --name test-web1 --mount type=bind,source=/home/cloud_user/content/version1,target=/usr/local/apache2/htdocs httpd

# verify container is up
docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS               NAMES
6c2c4174272a        httpd               "httpd-foreground"   16 seconds ago      Up 15 seconds       80/tcp              test-web1

# check the IPAddress for the container
[cloud_user@ip-10-0-0-11 version2]$ docker inspect 6c2c4174272a | grep IPAddress
            "SecondaryIPAddresses": null,
            "IPAddress": "172.17.0.2",
                    "IPAddress": "172.17.0.2",

# run the second web server
docker run -d --name test-web2 --mount type=bind,source=/home/cloud_user/content/version2,target=/usr/local/apache2/htdocs httpd

# verify 2nd container is up and running
docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED              STATUS              PORTS               NAMES
dbb9e4b0dd0c        httpd               "httpd-foreground"   About a minute ago   Up About a minute   80/tcp              test-web2
6c2c4174272a        httpd               "httpd-foreground"   2 minutes ago        Up 2 minutes        80/tcp              test-web1
[cloud_user@ip-10-0-0-11 version2]$ docker inspect dbb9e4b0dd0c | grep IPAddress
            "SecondaryIPAddresses": null,
            "IPAddress": "172.17.0.3",
                    "IPAddress": "172.17.0.3",

# review the data in test-web2
[cloud_user@ip-10-0-0-11 version2]$ curl 172.17.0.3
Verions Two
```

### Create a Swarm

```bash
# 10.0.0.11 - init the swarm on the manager
docker swarm init advertise-addr 10.0.0.11

# 10.0.0.12 - Join the node to the swarm
docker swarm join --token SWMTKN-1-4i84gml66ct6knzk65me463hgwa4a7d3yxvjtuuqjdyu24ag62-8fnma9qgdsfu52sj8valekmtg 10.0.0.11:2377

# 10.0.0.11 - create a service for testweb1, remember -v and --volumes is not supported on services
# here we are mounting directly to the server and not a volume as well.
docker service create --name test-web1 -p 80:80 --mount type=bind,source=/home/cloud_user/content/version1,target=/usr/local/apache2/htdocs --detach=false --replicas 2 httpd

# verify that the service is up
[cloud_user@ip-10-0-0-11 home]$ docker service ps test-web1
ID                  NAME                IMAGE               NODE                        DESIRED STATE       CURRENT STATE            ERROR                              PORTS
l5nmv4jk2j0r        test-web1.1         httpd:latest        ip-10-0-0-11.ec2.internal   Running             Running 2 minutes ago
t6hyjk3v8mec         \_ test-web1.1     httpd:latest        ip-10-0-0-12.ec2.internal   Shutdown            Rejected 2 minutes ago   "error creating external conne…"
xklvt6x8d646         \_ test-web1.1     httpd:latest        ip-10-0-0-12.ec2.internal   Shutdown            Rejected 2 minutes ago   "error creating external conne…"
p204y5n272ub         \_ test-web1.1     httpd:latest        ip-10-0-0-12.ec2.internal   Shutdown            Rejected 2 minutes ago   "error creating external conne…"
qnvnxm9usirt         \_ test-web1.1     httpd:latest        ip-10-0-0-12.ec2.internal   Shutdown            Rejected 2 minutes ago   "error creating external conne…"
ropwpgz4ekmc        test-web1.2         httpd:latest        ip-10-0-0-11.ec2.internal   Running             Running 2 minutes ago
[cloud_user@ip-10-0-0-11 home]$ curl ip-10-0-0-11.ec2.internal
Verions 1

# create the 2nd service for test-web2
docker service create --name test-web2 --mount type=bind,source=/home/cloud_user/content/version2,target=/usr/local/apache2/htdocs --detach=false --replicas 3 httpd

[cloud_user@ip-10-0-0-11 home]$ docker service ps test-web2
ID                  NAME                IMAGE               NODE                        DESIRED STATE       CURRENT STATE            ERROR               PORTS
orhdp8vci6hj        test-web2.1         httpd:latest        ip-10-0-0-12.ec2.internal   Running             Running 19 seconds ago
rcj0jcy38e4x        test-web2.2         httpd:latest        ip-10-0-0-11.ec2.internal   Running             Running 19 seconds ago
v0rgxvzz7t18        test-web2.3         httpd:latest        ip-10-0-0-12.ec2.internal   Running             Running 19 seconds ago


# check the status of the web pages
[cloud_user@ip-10-0-0-11 home]$ curl ip-10-0-0-11.ec2.internal:81
Verions Two
[cloud_user@ip-10-0-0-11 home]$ curl ip-10-0-0-11.ec2.internal:81
Verions Two
[cloud_user@ip-10-0-0-11 home]$ curl ip-10-0-0-11.ec2.internal:80
Verions 1
[cloud_user@ip-10-0-0-11 home]$ 


# https://docs.docker.com/engine/reference/commandline/service_ps/#filtering
# I have lots of failing workers... idk let's filter them
[cloud_user@ip-10-0-0-11 home]$ docker service ps -f "desired-state=running" test-web1
ID                  NAME                IMAGE               NODE                        DESIRED STATE       CURRENT STATE           ERROR               PORTS
l5nmv4jk2j0r        test-web1.1         httpd:latest        ip-10-0-0-11.ec2.internal   Running             Running 9 minutes ago
ropwpgz4ekmc        test-web1.2         httpd:latest        ip-10-0-0-11.ec2.internal   Running             Running 9 minutes ago
[cloud_user@ip-10-0-0-11 home]$ docker service ps -f "desired-state=running" test-web2
ID                  NAME                IMAGE               NODE                        DESIRED STATE       CURRENT STATE           ERROR               PORTS
smgbehaue4gf        test-web2.1         httpd:latest        ip-10-0-0-11.ec2.internal   Running             Running 3 minutes ago
5sr3iiz7fuw1        test-web2.2         httpd:latest        ip-10-0-0-11.ec2.internal   Running             Running 3 minutes ago
e8jkgen22v1c        test-web2.3         httpd:latest        ip-10-0-0-11.ec2.internal   Running             Running 3 minutes ago

```