# Quick Starts

## Exercise: Creating and Working With Volumes

1. Using the appropriate Docker command, create a storage volume for use by your containers, call the volume 'test-volume'

docker volume create test-volume
test-volume

2. Display all the Docker storage volumes that exist on your local system

docker volume ls
DRIVER              VOLUME NAME
local               test-volume

3. Execute the Docker command that will allow you to display all the attributes of that newly created 'test-volume'

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

4. Display the location on the host file system where that 'test-volume' exists and note the permissions

ls -al /var/lib/docker/volumes/

[user@tcox2 ~]$ ls -al /var/lib/docker/volumes/test-volume/_data
ls: cannot access /var/lib/docker/volumes/test-volume/_data: Permission denied
[user@tcox2 ~]$ sudo ls -al /var/lib/docker/volumes/test-volume/_data
[sudo] password for user: 
total 0
drwxr-xr-x. 2 root root  6 Oct 18 19:31 .
drwxr-xr-x. 3 root root 18 Oct 18 19:31 ..
[user@tcox2 ~]$ sudo ls -al /var/lib/docker/volumes/test-volume/
total 0
drwxr-xr-x. 3 root root 18 Oct 18 19:31 .
drwx------. 3 root root 42 Oct 18 19:31 ..
drwxr-xr-x. 2 root root  6 Oct 18 19:31 _data


5. Remove the newly created 'test-volume' and then run the command to verify that the volume has been deleted

docker volume rm test-volume

docker volume ls
DRIVER              VOLUME NAME

## Using External Volumes Within Your Containers - mount to docker volume

1. Create a Docker volume called 'http-files' and then list all volumes to confirm it was created

docker volume create http-files

2. Execute the appropriate Docker command to display ALL information on the 'http-files' volume, make a note of the filesystem location that volume is linked to on your host

docker volume ls

3. Pull the 'httpd' image from the standard Docker repository and verify it was installed locally

docker pull httpd

docker images

4. Create an 'index.html' file of your choosing and copy it to the HOST directory that your 'http-files' volume is linked to (obtained in Step #2 above)

sudo - i

[root@tcox3 ~]# echo "This is my test website index file" > /var/lib/docker/volumes/http-files/_data/index.html
[root@tcox3 ~]# cat /var/lib/docker/volumes/http-files/_data/index.html 
This is my test website index file

5. Start a container based on the 'httpd' image with the following characteristics:

  - the container should run in the background (i.e. you are not connected to it in the current terminal)

  - name the container 'test-web'

  - associate the created volume 'http-files' with the container directory path of /usr/local/apache2/htdocs

[root@craig-nicholsoneswlb6 ~]# docker run -d --name test-web -p 80:80 --mount source=http-files,target=/usr/local/apache2/htdocs httpd
e238825ac169053acf5a1ce4827e05bbd3645d31b6835103e059f5d01acfd71e

6. Using the appropriate Docker command, find out the container's IP address and note it

[root@craig-nicholsoneswlb6 ~]# curl localhost
This is my test website index file
[root@craig-nicholsoneswlb6 ~]# 

LOL

[root@craig-nicholsoneswlb6 ~]# docker inspect e238825ac169 | grep IPAddress
            "SecondaryIPAddresses": null,
            "IPAddress": "172.17.0.2",
                    "IPAddress": "172.17.0.2",
[root@craig-nicholsoneswlb6 ~]# 

7. Execute the 'curl' command against that IP address to display the Apache website running on the container, verify the output is from your created 'index.html' file

[root@craig-nicholsoneswlb6 ~]# curl 172.17.0.2
This is my test website index file
[root@craig-nicholsoneswlb6 ~]# 

8. Make a change to the 'index.html' file on the container's host and save the file. Rerun the 'curl' command to verify the container's website is now displaying the new value

[root@craig-nicholsoneswlb6 ~]# echo "This is a CHANGED website file" > /var/lib/docker/volumes/http-files/_data/index.html 
[root@craig-nicholsoneswlb6 ~]# curl 172.17.0.2
This is a CHANGED website file

## Creating a Bind Mount to Link Container Filesystem to Host Filesystem - using type=bind

1. Create a directory in your home directory called 'content'. Within this directory, place a file called 'index.html' containing any text you wish.

```bash
[user@tcox6 ~]$ mkdir content
[user@tcox6 ~]$ echo "This is a test web site in a container" > content/index.html
[user@tcox6 ~]$ ls -al content
total 8
drwxrwxr-x.  2 user user   23 Dec 21 16:32 .
drwx------. 10 user user 4096 Dec 21 16:31 ..
-rw-rw-r--.  1 user user   39 Dec 21 16:32 index.html
```

2. Using the appropriate Docker CE command, download the image called 'httpd:latest' to your system.

```bash
[user@tcox6 ~]$ docker pull httpd
Using default tag: latest
latest: Pulling from library/httpd
f49cf87b52c1: Pull complete 
02ca099fb6cd: Pull complete 
de7acb18da57: Pull complete 
770c8edb393d: Pull complete 
0e252730aeae: Pull complete 
6e6ca341873f: Pull complete 
2daffd0a6144: Pull complete 
Digest: sha256:b5f21641a9d7bbb59dc94fb6a663c43fbf3f56270ce7c7d51801ac74d2e70046
Status: Downloaded newer image for httpd:latest
```

3. Install the 'elinks' web browser to complete testing of your site 

```bash
[user@tcox6 ~]$ sudo yum install elinks
[sudo] password for user: 
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
 * base: mirror.lax.hugeserver.com
 * epel: s3-mirror-us-west-2.fedoraproject.org
 * extras: mirrors.xmission.com
 * nux-dextop: mirror.li.nux.ro
 * updates: mirrors.syringanetworks.net
Resolving Dependencies
--> Running transaction check
---> Package elinks.x86_64 0:0.12-0.36.pre6.el7 will be installed
--> Processing Dependency: libnss_compat_ossl.so.0()(64bit) for package: elinks-0.12-0.36.pre6.el7.x86_64
--> Processing Dependency: libmozjs185.so.1.0()(64bit) for package: elinks-0.12-0.36.pre6.el7.x86_64
--> Running transaction check
---> Package js.x86_64 1:1.8.5-19.el7 will be installed
---> Package nss_compat_ossl.x86_64 0:0.9.6-8.el7 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

====================================================================================================================================================================================================================
 Package                                                Arch                                          Version                                                     Repository                                   Size
====================================================================================================================================================================================================================
Installing:
 elinks                                                 x86_64                                        0.12-0.36.pre6.el7                                          base                                        882 k
Installing for dependencies:
 js                                                     x86_64                                        1:1.8.5-19.el7                                              base                                        2.3 M
 nss_compat_ossl                                        x86_64                                        0.9.6-8.el7                                                 base                                         37 k

Transaction Summary
====================================================================================================================================================================================================================
Install  1 Package (+2 Dependent packages)

Total download size: 3.2 M
Installed size: 9.6 M
Is this ok [y/d/N]: y
Downloading packages:
(1/3): elinks-0.12-0.36.pre6.el7.x86_64.rpm... truncated here...
```

4. Instantiate a container on this single host with the following characteristics:

  * name the container 'testweb'

  * map container port 80 to the host port 80

  * create a bind mapping from the container directory of /usr/local/apache2/htdocs to the local host directory you created above using the complete path

  * base the container on the 'httpd' image downloaded above

  * run the contained in 'detached' mode

```bash
docker run -d --name testweb -p 80:80 --mount type=bind,source=/home/user/content,target=/usr/local/apache2/htdocs httpd
docker run -d --name testweb -p 80:80 --mount type=bind,source=/home/user/content,target=/usr/local/apache2/htdocs httpd
054b6dc6c49aaeb6a7ef7000794c0212eba5ec773b04ba3ff637a402a812220a
```

5. Verify the container is running

[user@tcox6 ~]$ docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS                NAMES
054b6dc6c49a        httpd               "httpd-foreground"   29 seconds ago      Up 27 seconds       0.0.0.0:80->80/tcp   testweb

6. Use 'elinks' to connect to your local IP over port 80 and verify the created index file created above is displayed

[user@craig-nicholsoneswlb6 ~]$ curl localhost
This is a test web site in a container

## Exercise: Display Details About Your Containers and Control the Display of Output

1. Using the appropriate Docker CE commands, download the latest 'nginx' webserver image from Docker Hub.

2. Instantiate a container based on the 'nginx' image from the previous step. This container should have the following characteristics:

  * when started, the container should run in 'detached' mode

  * name the container 'nginxtest'

  * use the appropriate option to allow Docker to map all container service ports to random host ports over 32768

  * the container is based on the 'nginx' image from step one

[user@craig-nicholsoneswlb6 ~]$ docker run -d --name nginxtests -P nginx
c1652432a0c38c9b850c4185995e42963e425711e6eddda0690a9611ca1a990f

REVIEW -P is that all PORTS

[user@craig-nicholsoneswlb6 ~]$ docker inspect nginxtests | grep Port
            "PortBindings": {},
            "PublishAllPorts": true,
            "ExposedPorts": {
            "Ports": {
                        "HostPort": "32768"
[user@craig-nicholsoneswlb6 ~]$ docker inspect nginxtests | grep Ports
            "PublishAllPorts": true,
            "ExposedPorts": {
            "Ports": {
[user@craig-nicholsoneswlb6 ~]$

3. Using the appropriate Docker command, find the CONTAINER IP address ONLY (use the aforementioned appropriate command and JUST display the IP address using its built in options)

user@craig-nicholsoneswlb6 ~]$ docker inspect nginxtests | grep IPAddress
            "SecondaryIPAddresses": null,
            "IPAddress": "172.17.0.3",
                    "IPAddress": "172.17.0.3",

[user@craig-nicholsoneswlb6 ~]$ docker container inspect --format="{{.NetworkSettings.Networks.bridge.IPAddress}}" nginxtests
172.17.0.3

## Working with the DeviceMapper Storage Driver - Scenario

Your development team has been working on their understanding of Docker in general and Docker Swarms in particular. They are experimenting with different ways of understanding and optimizing storage on the underlying hosts. As a result, they have asked for your assistance in comparing traditional host based default storage on a Docker host with the 'devicemapper' storage driver on a second Docker host.

Comparing

- traditional host based default storage on a Docker host node1
- 'devicemapper' storage driver on a second Docker host node2

They have provided you with the credentials to connect to two hosts for this activity. You have been asked to install and configure Docker, enabled so that it starts on boot, on both hosts.

On the first host, they would like the default storage subsystem to be left as is. On the second host, they would llike you to change the Docker storage subsystem to the 'devicemapper' driver. This will enable them to compare image and container storage utilization using LVM thin provisioning vs. standard storage.

On each host, once configured, install the following images for their use and then turn the systems over to them once you verify their installation:


### NODE 1
Last login: Fri Aug  3 11:40:17 on ttys008
craig:~ cn$ ssh cloud_user@52.91.215.104
The authenticity of host '52.91.215.104 (52.91.215.104)' can't be established.
ECDSA key fingerprint is SHA256:UE+sN0+iPQ+7cJesmyoddnAcwghjsZn0B3BTNl81sDM.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '52.91.215.104' (ECDSA) to the list of known hosts.
cloud_user@52.91.215.104's password: 
Last login: Tue Mar 27 14:51:34 2018 from 75-142-56-142.static.mtpk.ca.charter.com
[cloud_user@ip-10-0-0-11 ~]$ bash <(curl -s https://raw.githubusercontent.com/craignicholson/docker-quickstart/master/03_Orchestration/centos7_dockerInstall.sh)
[sudo] password for cloud_user: 
Sorry, try again.
[sudo] password for cloud_user: 
Loaded plugins: fastestmirror
base                                                     | 3.6 kB     00:00     
extras                                                   | 3.4 kB     00:00     
updates                                                  | 3.4 kB     00:00     
(1/4): base/7/x86_64/group_gz                              | 166 kB   00:00     
(2/4): extras/7/x86_64/primary_db                          | 173 kB   00:00     
(3/4): updates/7/x86_64/primary_db                         | 4.3 MB   00:00     
(4/4): base/7/x86_64/primary_db                            | 5.9 MB   00:00     
Determining fastest mirrors
 * base: mirrors.advancedhosters.com
 * extras: www.gtlib.gatech.edu
 * updates: mirror.vcu.edu
Resolving Dependencies
--> Running transaction check
---> Package device-mapper-persistent-data.x86_64 0:0.7.3-3.el7 will be installed
--> Processing Dependency: libaio.so.1(LIBAIO_0.4)(64bit) for package: device-mapper-persistent-data-0.7.3-3.el7.x86_64
--> Processing Dependency: libaio.so.1(LIBAIO_0.1)(64bit) for package: device-mapper-persistent-data-0.7.3-3.el7.x86_64
--> Processing Dependency: libaio.so.1()(64bit) for package: device-mapper-persistent-data-0.7.3-3.el7.x86_64
---> Package lvm2.x86_64 7:2.02.177-4.el7 will be installed
--> Processing Dependency: lvm2-libs = 7:2.02.177-4.el7 for package: 7:lvm2-2.02.177-4.el7.x86_64
--> Processing Dependency: liblvm2app.so.2.2(Base)(64bit) for package: 7:lvm2-2.02.177-4.el7.x86_64
--> Processing Dependency: libdevmapper.so.1.02(DM_1_02_141)(64bit) for package: 7:lvm2-2.02.177-4.el7.x86_64
--> Processing Dependency: libdevmapper-event.so.1.02(Base)(64bit) for package: 7:lvm2-2.02.177-4.el7.x86_64
--> Processing Dependency: liblvm2app.so.2.2()(64bit) for package: 7:lvm2-2.02.177-4.el7.x86_64
--> Processing Dependency: libdevmapper-event.so.1.02()(64bit) for package: 7:lvm2-2.02.177-4.el7.x86_64
---> Package yum-utils.noarch 0:1.1.31-46.el7_5 will be installed
--> Processing Dependency: python-kitchen for package: yum-utils-1.1.31-46.el7_5.noarch
--> Processing Dependency: libxml2-python for package: yum-utils-1.1.31-46.el7_5.noarch
--> Running transaction check
---> Package device-mapper-event-libs.x86_64 7:1.02.146-4.el7 will be installed
---> Package device-mapper-libs.x86_64 7:1.02.140-8.el7 will be updated
--> Processing Dependency: device-mapper-libs = 7:1.02.140-8.el7 for package: 7:device-mapper-1.02.140-8.el7.x86_64
---> Package device-mapper-libs.x86_64 7:1.02.146-4.el7 will be an update
---> Package libaio.x86_64 0:0.3.109-13.el7 will be installed
---> Package libxml2-python.x86_64 0:2.9.1-6.el7_2.3 will be installed
---> Package lvm2-libs.x86_64 7:2.02.177-4.el7 will be installed
--> Processing Dependency: device-mapper-event = 7:1.02.146-4.el7 for package: 7:lvm2-libs-2.02.177-4.el7.x86_64
---> Package python-kitchen.noarch 0:1.1.1-5.el7 will be installed
--> Running transaction check
---> Package device-mapper.x86_64 7:1.02.140-8.el7 will be updated
---> Package device-mapper.x86_64 7:1.02.146-4.el7 will be an update
---> Package device-mapper-event.x86_64 7:1.02.146-4.el7 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

================================================================================
 Package                         Arch     Version               Repository
                                                                           Size
================================================================================
Installing:
 device-mapper-persistent-data   x86_64   0.7.3-3.el7           base      405 k
 lvm2                            x86_64   7:2.02.177-4.el7      base      1.3 M
 yum-utils                       noarch   1.1.31-46.el7_5       updates   120 k
Installing for dependencies:
 device-mapper-event             x86_64   7:1.02.146-4.el7      base      185 k
 device-mapper-event-libs        x86_64   7:1.02.146-4.el7      base      184 k
 libaio                          x86_64   0.3.109-13.el7        base       24 k
 libxml2-python                  x86_64   2.9.1-6.el7_2.3       base      247 k
 lvm2-libs                       x86_64   7:2.02.177-4.el7      base      1.0 M
 python-kitchen                  noarch   1.1.1-5.el7           base      267 k
Updating for dependencies:
 device-mapper                   x86_64   7:1.02.146-4.el7      base      289 k
 device-mapper-libs              x86_64   7:1.02.146-4.el7      base      316 k

Transaction Summary
================================================================================
Install  3 Packages (+6 Dependent packages)
Upgrade             ( 2 Dependent packages)

Total download size: 4.3 M
Downloading packages:
Delta RPMs disabled because /usr/bin/applydeltarpm not installed.
(1/11): device-mapper-event-1.02.146-4.el7.x86_64.rpm      | 185 kB   00:00     
(2/11): device-mapper-1.02.146-4.el7.x86_64.rpm            | 289 kB   00:00     
(3/11): device-mapper-event-libs-1.02.146-4.el7.x86_64.rpm | 184 kB   00:00     
(4/11): device-mapper-libs-1.02.146-4.el7.x86_64.rpm       | 316 kB   00:00     
(5/11): libaio-0.3.109-13.el7.x86_64.rpm                   |  24 kB   00:00     
(6/11): libxml2-python-2.9.1-6.el7_2.3.x86_64.rpm          | 247 kB   00:00     
(7/11): lvm2-2.02.177-4.el7.x86_64.rpm                     | 1.3 MB   00:00     
(8/11): device-mapper-persistent-data-0.7.3-3.el7.x86_64.r | 405 kB   00:00     
(9/11): lvm2-libs-2.02.177-4.el7.x86_64.rpm                | 1.0 MB   00:00     
(10/11): python-kitchen-1.1.1-5.el7.noarch.rpm             | 267 kB   00:00     
(11/11): yum-utils-1.1.31-46.el7_5.noarch.rpm              | 120 kB   00:00     
--------------------------------------------------------------------------------
Total                                              7.5 MB/s | 4.3 MB  00:00     
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Updating   : 7:device-mapper-libs-1.02.146-4.el7.x86_64                  1/13 
  Updating   : 7:device-mapper-1.02.146-4.el7.x86_64                       2/13 
  Installing : 7:device-mapper-event-libs-1.02.146-4.el7.x86_64            3/13 
  Installing : 7:device-mapper-event-1.02.146-4.el7.x86_64                 4/13 
  Installing : 7:lvm2-libs-2.02.177-4.el7.x86_64                           5/13 
  Installing : libaio-0.3.109-13.el7.x86_64                                6/13 
  Installing : device-mapper-persistent-data-0.7.3-3.el7.x86_64            7/13 
  Installing : python-kitchen-1.1.1-5.el7.noarch                           8/13 
  Installing : libxml2-python-2.9.1-6.el7_2.3.x86_64                       9/13 
  Installing : yum-utils-1.1.31-46.el7_5.noarch                           10/13 
  Installing : 7:lvm2-2.02.177-4.el7.x86_64                               11/13 
Created symlink from /etc/systemd/system/sysinit.target.wants/lvm2-lvmpolld.socket to /usr/lib/systemd/system/lvm2-lvmpolld.socket.
  Cleanup    : 7:device-mapper-libs-1.02.140-8.el7.x86_64                 12/13 
  Cleanup    : 7:device-mapper-1.02.140-8.el7.x86_64                      13/13 
  Verifying  : device-mapper-persistent-data-0.7.3-3.el7.x86_64            1/13 
  Verifying  : 7:lvm2-2.02.177-4.el7.x86_64                                2/13 
  Verifying  : yum-utils-1.1.31-46.el7_5.noarch                            3/13 
  Verifying  : 7:device-mapper-1.02.146-4.el7.x86_64                       4/13 
  Verifying  : 7:device-mapper-event-1.02.146-4.el7.x86_64                 5/13 
  Verifying  : libxml2-python-2.9.1-6.el7_2.3.x86_64                       6/13 
  Verifying  : python-kitchen-1.1.1-5.el7.noarch                           7/13 
  Verifying  : 7:device-mapper-event-libs-1.02.146-4.el7.x86_64            8/13 
  Verifying  : 7:lvm2-libs-2.02.177-4.el7.x86_64                           9/13 
  Verifying  : libaio-0.3.109-13.el7.x86_64                               10/13 
  Verifying  : 7:device-mapper-libs-1.02.146-4.el7.x86_64                 11/13 
  Verifying  : 7:device-mapper-1.02.140-8.el7.x86_64                      12/13 
  Verifying  : 7:device-mapper-libs-1.02.140-8.el7.x86_64                 13/13 

Installed:
  device-mapper-persistent-data.x86_64 0:0.7.3-3.el7                            
  lvm2.x86_64 7:2.02.177-4.el7                                                  
  yum-utils.noarch 0:1.1.31-46.el7_5                                            

Dependency Installed:
  device-mapper-event.x86_64 7:1.02.146-4.el7                                   
  device-mapper-event-libs.x86_64 7:1.02.146-4.el7                              
  libaio.x86_64 0:0.3.109-13.el7                                                
  libxml2-python.x86_64 0:2.9.1-6.el7_2.3                                       
  lvm2-libs.x86_64 7:2.02.177-4.el7                                             
  python-kitchen.noarch 0:1.1.1-5.el7                                           

Dependency Updated:
  device-mapper.x86_64 7:1.02.146-4.el7                                         
  device-mapper-libs.x86_64 7:1.02.146-4.el7                                    

Complete!
Loaded plugins: fastestmirror
adding repo from: https://download.docker.com/linux/centos/docker-ce.repo
grabbing file https://download.docker.com/linux/centos/docker-ce.repo to /etc/yum.repos.d/docker-ce.repo
repo saved to /etc/yum.repos.d/docker-ce.repo
Loaded plugins: fastestmirror
docker-ce-stable                                         | 2.9 kB     00:00     
docker-ce-stable/x86_64/primary_db                         |  14 kB   00:00     
Loading mirror speeds from cached hostfile
 * base: mirrors.advancedhosters.com
 * extras: www.gtlib.gatech.edu
 * updates: mirror.vcu.edu
Resolving Dependencies
--> Running transaction check
---> Package docker-ce.x86_64 0:18.06.0.ce-3.el7 will be installed
--> Processing Dependency: container-selinux >= 2.9 for package: docker-ce-18.06.0.ce-3.el7.x86_64
--> Processing Dependency: libltdl.so.7()(64bit) for package: docker-ce-18.06.0.ce-3.el7.x86_64
--> Running transaction check
---> Package container-selinux.noarch 2:2.66-1.el7 will be installed
--> Processing Dependency: selinux-policy-targeted >= 3.13.1-192 for package: 2:container-selinux-2.66-1.el7.noarch
--> Processing Dependency: selinux-policy-base >= 3.13.1-192 for package: 2:container-selinux-2.66-1.el7.noarch
--> Processing Dependency: selinux-policy >= 3.13.1-192 for package: 2:container-selinux-2.66-1.el7.noarch
---> Package libtool-ltdl.x86_64 0:2.4.2-22.el7_3 will be installed
--> Running transaction check
---> Package selinux-policy.noarch 0:3.13.1-166.el7_4.9 will be updated
---> Package selinux-policy.noarch 0:3.13.1-192.el7_5.4 will be an update
--> Processing Dependency: policycoreutils >= 2.5-18 for package: selinux-policy-3.13.1-192.el7_5.4.noarch
---> Package selinux-policy-targeted.noarch 0:3.13.1-166.el7_4.9 will be updated
---> Package selinux-policy-targeted.noarch 0:3.13.1-192.el7_5.4 will be an update
--> Running transaction check
---> Package policycoreutils.x86_64 0:2.5-17.1.el7 will be updated
--> Processing Dependency: policycoreutils = 2.5-17.1.el7 for package: policycoreutils-python-2.5-17.1.el7.x86_64
---> Package policycoreutils.x86_64 0:2.5-22.el7 will be an update
--> Processing Dependency: libsepol >= 2.5-8 for package: policycoreutils-2.5-22.el7.x86_64
--> Processing Dependency: libselinux-utils >= 2.5-12 for package: policycoreutils-2.5-22.el7.x86_64
--> Running transaction check
---> Package libselinux-utils.x86_64 0:2.5-11.el7 will be updated
---> Package libselinux-utils.x86_64 0:2.5-12.el7 will be an update
--> Processing Dependency: libselinux(x86-64) = 2.5-12.el7 for package: libselinux-utils-2.5-12.el7.x86_64
---> Package libsepol.i686 0:2.5-6.el7 will be updated
---> Package libsepol.x86_64 0:2.5-6.el7 will be updated
---> Package libsepol.i686 0:2.5-8.1.el7 will be an update
---> Package libsepol.x86_64 0:2.5-8.1.el7 will be an update
---> Package policycoreutils-python.x86_64 0:2.5-17.1.el7 will be updated
---> Package policycoreutils-python.x86_64 0:2.5-22.el7 will be an update
--> Processing Dependency: setools-libs >= 3.3.8-2 for package: policycoreutils-python-2.5-22.el7.x86_64
--> Processing Dependency: libsemanage-python >= 2.5-9 for package: policycoreutils-python-2.5-22.el7.x86_64
--> Running transaction check
---> Package libselinux.i686 0:2.5-11.el7 will be updated
---> Package libselinux.x86_64 0:2.5-11.el7 will be updated
--> Processing Dependency: libselinux(x86-64) = 2.5-11.el7 for package: libselinux-python-2.5-11.el7.x86_64
---> Package libselinux.i686 0:2.5-12.el7 will be an update
---> Package libselinux.x86_64 0:2.5-12.el7 will be an update
---> Package libsemanage-python.x86_64 0:2.5-8.el7 will be updated
---> Package libsemanage-python.x86_64 0:2.5-11.el7 will be an update
--> Processing Dependency: libsemanage = 2.5-11.el7 for package: libsemanage-python-2.5-11.el7.x86_64
---> Package setools-libs.x86_64 0:3.3.8-1.1.el7 will be updated
---> Package setools-libs.x86_64 0:3.3.8-2.el7 will be an update
--> Running transaction check
---> Package libselinux-python.x86_64 0:2.5-11.el7 will be updated
---> Package libselinux-python.x86_64 0:2.5-12.el7 will be an update
---> Package libsemanage.x86_64 0:2.5-8.el7 will be updated
---> Package libsemanage.x86_64 0:2.5-11.el7 will be an update
--> Finished Dependency Resolution

Dependencies Resolved

================================================================================
 Package                  Arch    Version               Repository         Size
================================================================================
Installing:
 docker-ce                x86_64  18.06.0.ce-3.el7      docker-ce-stable   41 M
Installing for dependencies:
 container-selinux        noarch  2:2.66-1.el7          extras             35 k
 libtool-ltdl             x86_64  2.4.2-22.el7_3        base               49 k
Updating for dependencies:
 libselinux               i686    2.5-12.el7            base              166 k
 libselinux               x86_64  2.5-12.el7            base              162 k
 libselinux-python        x86_64  2.5-12.el7            base              235 k
 libselinux-utils         x86_64  2.5-12.el7            base              151 k
 libsemanage              x86_64  2.5-11.el7            base              150 k
 libsemanage-python       x86_64  2.5-11.el7            base              112 k
 libsepol                 i686    2.5-8.1.el7           base              293 k
 libsepol                 x86_64  2.5-8.1.el7           base              297 k
 policycoreutils          x86_64  2.5-22.el7            base              867 k
 policycoreutils-python   x86_64  2.5-22.el7            base              454 k
 selinux-policy           noarch  3.13.1-192.el7_5.4    updates           453 k
 selinux-policy-targeted  noarch  3.13.1-192.el7_5.4    updates           6.6 M
 setools-libs             x86_64  3.3.8-2.el7           base              619 k

Transaction Summary
================================================================================
Install  1 Package  (+ 2 Dependent packages)
Upgrade             ( 13 Dependent packages)

Total download size: 51 M
Downloading packages:
Delta RPMs disabled because /usr/bin/applydeltarpm not installed.
(1/16): libselinux-2.5-12.el7.x86_64.rpm                   | 162 kB   00:00     
(2/16): libselinux-2.5-12.el7.i686.rpm                     | 166 kB   00:00     
(3/16): libselinux-utils-2.5-12.el7.x86_64.rpm             | 151 kB   00:00     
(4/16): libselinux-python-2.5-12.el7.x86_64.rpm            | 235 kB   00:00     
(5/16): libsemanage-2.5-11.el7.x86_64.rpm                  | 150 kB   00:00     
(6/16): libsepol-2.5-8.1.el7.i686.rpm                      | 293 kB   00:00     
(7/16): libsepol-2.5-8.1.el7.x86_64.rpm                    | 297 kB   00:00     
(8/16): libtool-ltdl-2.4.2-22.el7_3.x86_64.rpm             |  49 kB   00:00     
(9/16): libsemanage-python-2.5-11.el7.x86_64.rpm           | 112 kB   00:00     
(10/16): container-selinux-2.66-1.el7.noarch.rpm           |  35 kB   00:00     
(11/16): policycoreutils-2.5-22.el7.x86_64.rpm             | 867 kB   00:00     
(12/16): policycoreutils-python-2.5-22.el7.x86_64.rpm      | 454 kB   00:00     
(13/16): setools-libs-3.3.8-2.el7.x86_64.rpm               | 619 kB   00:00     
(14/16): selinux-policy-3.13.1-192.el7_5.4.noarch.rpm      | 453 kB   00:00     
(15/16): selinux-policy-targeted-3.13.1-192.el7_5.4.noarch | 6.6 MB   00:00     
warning: /var/cache/yum/x86_64/7/docker-ce-stable/packages/docker-ce-18.06.0.ce-3.el7.x86_64.rpm: Header V4 RSA/SHA512 Signature, key ID 621e9f35: NOKEY
Public key for docker-ce-18.06.0.ce-3.el7.x86_64.rpm is not installed
(16/16): docker-ce-18.06.0.ce-3.el7.x86_64.rpm             |  41 MB   00:01     
--------------------------------------------------------------------------------
Total                                               33 MB/s |  51 MB  00:01     
Retrieving key from https://download.docker.com/linux/centos/gpg
Importing GPG key 0x621E9F35:
 Userid     : "Docker Release (CE rpm) <docker@docker.com>"
 Fingerprint: 060a 61c5 1b55 8a7f 742b 77aa c52f eb6b 621e 9f35
 From       : https://download.docker.com/linux/centos/gpg
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Updating   : libsepol-2.5-8.1.el7.x86_64                                 1/29 
  Updating   : libselinux-2.5-12.el7.x86_64                                2/29 
  Updating   : libsemanage-2.5-11.el7.x86_64                               3/29 
  Updating   : libselinux-utils-2.5-12.el7.x86_64                          4/29 
  Updating   : policycoreutils-2.5-22.el7.x86_64                           5/29 
  Updating   : selinux-policy-3.13.1-192.el7_5.4.noarch                    6/29 
  Updating   : selinux-policy-targeted-3.13.1-192.el7_5.4.noarch           7/29 
  Updating   : libsemanage-python-2.5-11.el7.x86_64                        8/29 
  Updating   : libselinux-python-2.5-12.el7.x86_64                         9/29 
  Updating   : setools-libs-3.3.8-2.el7.x86_64                            10/29 
  Updating   : policycoreutils-python-2.5-22.el7.x86_64                   11/29 
  Installing : 2:container-selinux-2.66-1.el7.noarch                      12/29 
  Installing : libtool-ltdl-2.4.2-22.el7_3.x86_64                         13/29 
  Updating   : libsepol-2.5-8.1.el7.i686                                  14/29 
  Installing : docker-ce-18.06.0.ce-3.el7.x86_64                          15/29 
  Updating   : libselinux-2.5-12.el7.i686                                 16/29 
  Cleanup    : selinux-policy-targeted-3.13.1-166.el7_4.9.noarch          17/29 
  Cleanup    : policycoreutils-python-2.5-17.1.el7.x86_64                 18/29 
  Cleanup    : selinux-policy-3.13.1-166.el7_4.9.noarch                   19/29 
  Cleanup    : libselinux-2.5-11.el7                                      20/29 
  Cleanup    : policycoreutils-2.5-17.1.el7.x86_64                        21/29 
  Cleanup    : libselinux-utils-2.5-11.el7.x86_64                         22/29 
  Cleanup    : setools-libs-3.3.8-1.1.el7.x86_64                          23/29 
  Cleanup    : libselinux-python-2.5-11.el7.x86_64                        24/29 
  Cleanup    : libsemanage-python-2.5-8.el7.x86_64                        25/29 
  Cleanup    : libsepol-2.5-6.el7                                         26/29 
  Cleanup    : libsemanage-2.5-8.el7.x86_64                               27/29 
  Cleanup    : libselinux-2.5-11.el7                                      28/29 
  Cleanup    : libsepol-2.5-6.el7                                         29/29 
  Verifying  : libselinux-python-2.5-12.el7.x86_64                         1/29 
  Verifying  : selinux-policy-3.13.1-192.el7_5.4.noarch                    2/29 
  Verifying  : setools-libs-3.3.8-2.el7.x86_64                             3/29 
  Verifying  : libsemanage-python-2.5-11.el7.x86_64                        4/29 
  Verifying  : policycoreutils-2.5-22.el7.x86_64                           5/29 
  Verifying  : libsepol-2.5-8.1.el7.i686                                   6/29 
  Verifying  : libsemanage-2.5-11.el7.x86_64                               7/29 
  Verifying  : selinux-policy-targeted-3.13.1-192.el7_5.4.noarch           8/29 
  Verifying  : policycoreutils-python-2.5-22.el7.x86_64                    9/29 
  Verifying  : libtool-ltdl-2.4.2-22.el7_3.x86_64                         10/29 
  Verifying  : 2:container-selinux-2.66-1.el7.noarch                      11/29 
  Verifying  : libselinux-2.5-12.el7.i686                                 12/29 
  Verifying  : docker-ce-18.06.0.ce-3.el7.x86_64                          13/29 
  Verifying  : libsepol-2.5-8.1.el7.x86_64                                14/29 
  Verifying  : libselinux-2.5-12.el7.x86_64                               15/29 
  Verifying  : libselinux-utils-2.5-12.el7.x86_64                         16/29 
  Verifying  : libselinux-utils-2.5-11.el7.x86_64                         17/29 
  Verifying  : libsepol-2.5-6.el7.i686                                    18/29 
  Verifying  : libselinux-2.5-11.el7.x86_64                               19/29 
  Verifying  : libsepol-2.5-6.el7.x86_64                                  20/29 
  Verifying  : policycoreutils-python-2.5-17.1.el7.x86_64                 21/29 
  Verifying  : selinux-policy-targeted-3.13.1-166.el7_4.9.noarch          22/29 
  Verifying  : policycoreutils-2.5-17.1.el7.x86_64                        23/29 
  Verifying  : selinux-policy-3.13.1-166.el7_4.9.noarch                   24/29 
  Verifying  : libsemanage-python-2.5-8.el7.x86_64                        25/29 
  Verifying  : libselinux-2.5-11.el7.i686                                 26/29 
  Verifying  : libsemanage-2.5-8.el7.x86_64                               27/29 
  Verifying  : libselinux-python-2.5-11.el7.x86_64                        28/29 
  Verifying  : setools-libs-3.3.8-1.1.el7.x86_64                          29/29 

Installed:
  docker-ce.x86_64 0:18.06.0.ce-3.el7                                           

Dependency Installed:
  container-selinux.noarch 2:2.66-1.el7   libtool-ltdl.x86_64 0:2.4.2-22.el7_3  

Dependency Updated:
  libselinux.i686 0:2.5-12.el7                                                  
  libselinux.x86_64 0:2.5-12.el7                                                
  libselinux-python.x86_64 0:2.5-12.el7                                         
  libselinux-utils.x86_64 0:2.5-12.el7                                          
  libsemanage.x86_64 0:2.5-11.el7                                               
  libsemanage-python.x86_64 0:2.5-11.el7                                        
  libsepol.i686 0:2.5-8.1.el7                                                   
  libsepol.x86_64 0:2.5-8.1.el7                                                 
  policycoreutils.x86_64 0:2.5-22.el7                                           
  policycoreutils-python.x86_64 0:2.5-22.el7                                    
  selinux-policy.noarch 0:3.13.1-192.el7_5.4                                    
  selinux-policy-targeted.noarch 0:3.13.1-192.el7_5.4                           
  setools-libs.x86_64 0:3.3.8-2.el7                                             

Complete!
groupadd: group 'docker' already exists
Created symlink from /etc/systemd/system/multi-user.target.wants/docker.service to /usr/lib/systemd/system/docker.service.
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
 * base: mirrors.advancedhosters.com
 * extras: www.gtlib.gatech.edu
 * updates: mirror.vcu.edu
No unfinished transactions left.
[cloud_user@ip-10-0-0-11 ~]$ docker pull httpd
Using default tag: latest
Warning: failed to get default registry endpoint from daemon (Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Get http://%2Fvar%2Frun%2Fdocker.sock/v1.38/info: dial unix /var/run/docker.sock: connect: permission denied). Using system default: https://index.docker.io/v1/
Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Post http://%2Fvar%2Frun%2Fdocker.sock/v1.38/images/create?fromImage=httpd&tag=latest: dial unix /var/run/docker.sock: connect: permission denied
[cloud_user@ip-10-0-0-11 ~]$ exit
logout
Connection to 52.91.215.104 closed.
craig:~ cn$ ssh cloud_user@52.91.215.104
cloud_user@52.91.215.104's password: 
Last login: Fri Aug  3 18:17:11 2018 from 108-74-118-125.lightspeed.tukrga.sbcglobal.net
[cloud_user@ip-10-0-0-11 ~]$ docker pull httpd
Using default tag: latest
latest: Pulling from library/httpd
d660b1f15b9b: Pull complete 
aa1c79a2fa37: Pull complete 
f5f6514c0aff: Pull complete 
676d3dd26040: Pull complete 
4fdddf845a1b: Pull complete 
520c4b04fe88: Pull complete 
5387b1b7893c: Pull complete 
Digest: sha256:8c84e065bdf72b4909bd55a348d5e91fe265e08d6b28ed9104bfdcac9206dcc8
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
[cloud_user@ip-10-0-0-11 ~]$ sudo -1
sudo: invalid option -- '1'
usage: sudo -h | -K | -k | -V
usage: sudo -v [-AknS] [-g group] [-h host] [-p prompt] [-u user]
usage: sudo -l [-AknS] [-g group] [-h host] [-p prompt] [-U user] [-u user]
            [command]
usage: sudo [-AbEHknPS] [-r role] [-t type] [-C num] [-g group] [-h host] [-p
            prompt] [-u user] [VAR=value] [-i|-s] [<command>]
usage: sudo -e [-AknS] [-r role] [-t type] [-C num] [-g group] [-h host] [-p
            prompt] [-u user] file ...
[cloud_user@ip-10-0-0-11 ~]$ sudo -i
[root@ip-10-0-0-11 ~]# cd /etc/docker/
[root@ip-10-0-0-11 docker]# pwd
/etc/docker
[root@ip-10-0-0-11 docker]# 
[root@ip-10-0-0-11 docker]# 
[root@ip-10-0-0-11 docker]# docker info | grep Storage
Storage Driver: overlay2
[root@ip-10-0-0-11 docker]# 

### NODE 2

Last login: Fri Aug  3 18:16:47 on ttys000
craig:~ cn$ ssh cloud_user@34.227.197.208
The authenticity of host '34.227.197.208 (34.227.197.208)' can't be established.
ECDSA key fingerprint is SHA256:UE+sN0+iPQ+7cJesmyoddnAcwghjsZn0B3BTNl81sDM.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '34.227.197.208' (ECDSA) to the list of known hosts.
cloud_user@34.227.197.208's password: 
Last login: Tue Mar 27 14:51:34 2018 from 75-142-56-142.static.mtpk.ca.charter.com
[cloud_user@ip-10-0-0-12 ~]$ bash <(curl -s https://raw.githubusercontent.com/craignicholson/docker-quickstart/master/03_Orchestration/centos7_dockerInstall.sh)
[sudo] password for cloud_user: 
Sorry, try again.
[sudo] password for cloud_user: 
Loaded plugins: fastestmirror
base                                                     | 3.6 kB     00:00     
extras                                                   | 3.4 kB     00:00     
updates                                                  | 3.4 kB     00:00     
(1/4): base/7/x86_64/group_gz                              | 166 kB   00:00     
(2/4): updates/7/x86_64/primary_db                         | 4.3 MB   00:00     
(3/4): base/7/x86_64/primary_db                            | 5.9 MB   00:00     
(4/4): extras/7/x86_64/primary_db                          | 173 kB   00:01     
Determining fastest mirrors
 * base: mirror.umd.edu
 * extras: www.gtlib.gatech.edu
 * updates: mirror.vcu.edu
Resolving Dependencies
--> Running transaction check
---> Package device-mapper-persistent-data.x86_64 0:0.7.3-3.el7 will be installed
--> Processing Dependency: libaio.so.1(LIBAIO_0.4)(64bit) for package: device-mapper-persistent-data-0.7.3-3.el7.x86_64
--> Processing Dependency: libaio.so.1(LIBAIO_0.1)(64bit) for package: device-mapper-persistent-data-0.7.3-3.el7.x86_64
--> Processing Dependency: libaio.so.1()(64bit) for package: device-mapper-persistent-data-0.7.3-3.el7.x86_64
---> Package lvm2.x86_64 7:2.02.177-4.el7 will be installed
--> Processing Dependency: lvm2-libs = 7:2.02.177-4.el7 for package: 7:lvm2-2.02.177-4.el7.x86_64
--> Processing Dependency: liblvm2app.so.2.2(Base)(64bit) for package: 7:lvm2-2.02.177-4.el7.x86_64
--> Processing Dependency: libdevmapper.so.1.02(DM_1_02_141)(64bit) for package: 7:lvm2-2.02.177-4.el7.x86_64
--> Processing Dependency: libdevmapper-event.so.1.02(Base)(64bit) for package: 7:lvm2-2.02.177-4.el7.x86_64
--> Processing Dependency: liblvm2app.so.2.2()(64bit) for package: 7:lvm2-2.02.177-4.el7.x86_64
--> Processing Dependency: libdevmapper-event.so.1.02()(64bit) for package: 7:lvm2-2.02.177-4.el7.x86_64
---> Package yum-utils.noarch 0:1.1.31-46.el7_5 will be installed
--> Processing Dependency: python-kitchen for package: yum-utils-1.1.31-46.el7_5.noarch
--> Processing Dependency: libxml2-python for package: yum-utils-1.1.31-46.el7_5.noarch
--> Running transaction check
---> Package device-mapper-event-libs.x86_64 7:1.02.146-4.el7 will be installed
---> Package device-mapper-libs.x86_64 7:1.02.140-8.el7 will be updated
--> Processing Dependency: device-mapper-libs = 7:1.02.140-8.el7 for package: 7:device-mapper-1.02.140-8.el7.x86_64
---> Package device-mapper-libs.x86_64 7:1.02.146-4.el7 will be an update
---> Package libaio.x86_64 0:0.3.109-13.el7 will be installed
---> Package libxml2-python.x86_64 0:2.9.1-6.el7_2.3 will be installed
---> Package lvm2-libs.x86_64 7:2.02.177-4.el7 will be installed
--> Processing Dependency: device-mapper-event = 7:1.02.146-4.el7 for package: 7:lvm2-libs-2.02.177-4.el7.x86_64
---> Package python-kitchen.noarch 0:1.1.1-5.el7 will be installed
--> Running transaction check
---> Package device-mapper.x86_64 7:1.02.140-8.el7 will be updated
---> Package device-mapper.x86_64 7:1.02.146-4.el7 will be an update
---> Package device-mapper-event.x86_64 7:1.02.146-4.el7 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

================================================================================
 Package                         Arch     Version               Repository
                                                                           Size
================================================================================
Installing:
 device-mapper-persistent-data   x86_64   0.7.3-3.el7           base      405 k
 lvm2                            x86_64   7:2.02.177-4.el7      base      1.3 M
 yum-utils                       noarch   1.1.31-46.el7_5       updates   120 k
Installing for dependencies:
 device-mapper-event             x86_64   7:1.02.146-4.el7      base      185 k
 device-mapper-event-libs        x86_64   7:1.02.146-4.el7      base      184 k
 libaio                          x86_64   0.3.109-13.el7        base       24 k
 libxml2-python                  x86_64   2.9.1-6.el7_2.3       base      247 k
 lvm2-libs                       x86_64   7:2.02.177-4.el7      base      1.0 M
 python-kitchen                  noarch   1.1.1-5.el7           base      267 k
Updating for dependencies:
 device-mapper                   x86_64   7:1.02.146-4.el7      base      289 k
 device-mapper-libs              x86_64   7:1.02.146-4.el7      base      316 k

Transaction Summary
================================================================================
Install  3 Packages (+6 Dependent packages)
Upgrade             ( 2 Dependent packages)

Total download size: 4.3 M
Downloading packages:
Delta RPMs disabled because /usr/bin/applydeltarpm not installed.
(1/11): device-mapper-1.02.146-4.el7.x86_64.rpm            | 289 kB   00:00     
(2/11): device-mapper-event-1.02.146-4.el7.x86_64.rpm      | 185 kB   00:00     
(3/11): device-mapper-event-libs-1.02.146-4.el7.x86_64.rpm | 184 kB   00:00     
(4/11): device-mapper-libs-1.02.146-4.el7.x86_64.rpm       | 316 kB   00:00     
(5/11): device-mapper-persistent-data-0.7.3-3.el7.x86_64.r | 405 kB   00:00     
(6/11): libaio-0.3.109-13.el7.x86_64.rpm                   |  24 kB   00:00     
(7/11): libxml2-python-2.9.1-6.el7_2.3.x86_64.rpm          | 247 kB   00:00     
(8/11): lvm2-2.02.177-4.el7.x86_64.rpm                     | 1.3 MB   00:00     
(9/11): lvm2-libs-2.02.177-4.el7.x86_64.rpm                | 1.0 MB   00:00     
(10/11): python-kitchen-1.1.1-5.el7.noarch.rpm             | 267 kB   00:00     
(11/11): yum-utils-1.1.31-46.el7_5.noarch.rpm              | 120 kB   00:00     
--------------------------------------------------------------------------------
Total                                              8.4 MB/s | 4.3 MB  00:00     
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Updating   : 7:device-mapper-libs-1.02.146-4.el7.x86_64                  1/13 
  Updating   : 7:device-mapper-1.02.146-4.el7.x86_64                       2/13 
  Installing : 7:device-mapper-event-libs-1.02.146-4.el7.x86_64            3/13 
  Installing : 7:device-mapper-event-1.02.146-4.el7.x86_64                 4/13 
  Installing : 7:lvm2-libs-2.02.177-4.el7.x86_64                           5/13 
  Installing : libaio-0.3.109-13.el7.x86_64                                6/13 
  Installing : device-mapper-persistent-data-0.7.3-3.el7.x86_64            7/13 
  Installing : python-kitchen-1.1.1-5.el7.noarch                           8/13 
  Installing : libxml2-python-2.9.1-6.el7_2.3.x86_64                       9/13 
  Installing : yum-utils-1.1.31-46.el7_5.noarch                           10/13 
  Installing : 7:lvm2-2.02.177-4.el7.x86_64                               11/13 
Created symlink from /etc/systemd/system/sysinit.target.wants/lvm2-lvmpolld.socket to /usr/lib/systemd/system/lvm2-lvmpolld.socket.
  Cleanup    : 7:device-mapper-libs-1.02.140-8.el7.x86_64                 12/13 
  Cleanup    : 7:device-mapper-1.02.140-8.el7.x86_64                      13/13 
  Verifying  : device-mapper-persistent-data-0.7.3-3.el7.x86_64            1/13 
  Verifying  : 7:lvm2-2.02.177-4.el7.x86_64                                2/13 
  Verifying  : yum-utils-1.1.31-46.el7_5.noarch                            3/13 
  Verifying  : 7:device-mapper-1.02.146-4.el7.x86_64                       4/13 
  Verifying  : 7:device-mapper-event-1.02.146-4.el7.x86_64                 5/13 
  Verifying  : libxml2-python-2.9.1-6.el7_2.3.x86_64                       6/13 
  Verifying  : python-kitchen-1.1.1-5.el7.noarch                           7/13 
  Verifying  : 7:device-mapper-event-libs-1.02.146-4.el7.x86_64            8/13 
  Verifying  : 7:lvm2-libs-2.02.177-4.el7.x86_64                           9/13 
  Verifying  : libaio-0.3.109-13.el7.x86_64                               10/13 
  Verifying  : 7:device-mapper-libs-1.02.146-4.el7.x86_64                 11/13 
  Verifying  : 7:device-mapper-1.02.140-8.el7.x86_64                      12/13 
  Verifying  : 7:device-mapper-libs-1.02.140-8.el7.x86_64                 13/13 

Installed:
  device-mapper-persistent-data.x86_64 0:0.7.3-3.el7                            
  lvm2.x86_64 7:2.02.177-4.el7                                                  
  yum-utils.noarch 0:1.1.31-46.el7_5                                            

Dependency Installed:
  device-mapper-event.x86_64 7:1.02.146-4.el7                                   
  device-mapper-event-libs.x86_64 7:1.02.146-4.el7                              
  libaio.x86_64 0:0.3.109-13.el7                                                
  libxml2-python.x86_64 0:2.9.1-6.el7_2.3                                       
  lvm2-libs.x86_64 7:2.02.177-4.el7                                             
  python-kitchen.noarch 0:1.1.1-5.el7                                           

Dependency Updated:
  device-mapper.x86_64 7:1.02.146-4.el7                                         
  device-mapper-libs.x86_64 7:1.02.146-4.el7                                    

Complete!
Loaded plugins: fastestmirror
adding repo from: https://download.docker.com/linux/centos/docker-ce.repo
grabbing file https://download.docker.com/linux/centos/docker-ce.repo to /etc/yum.repos.d/docker-ce.repo
repo saved to /etc/yum.repos.d/docker-ce.repo
Loaded plugins: fastestmirror
docker-ce-stable                                         | 2.9 kB     00:00     
docker-ce-stable/x86_64/primary_db                         |  14 kB   00:00     
Loading mirror speeds from cached hostfile
 * base: mirror.umd.edu
 * extras: www.gtlib.gatech.edu
 * updates: mirror.vcu.edu
Resolving Dependencies
--> Running transaction check
---> Package docker-ce.x86_64 0:18.06.0.ce-3.el7 will be installed
--> Processing Dependency: container-selinux >= 2.9 for package: docker-ce-18.06.0.ce-3.el7.x86_64
--> Processing Dependency: libltdl.so.7()(64bit) for package: docker-ce-18.06.0.ce-3.el7.x86_64
--> Running transaction check
---> Package container-selinux.noarch 2:2.66-1.el7 will be installed
--> Processing Dependency: selinux-policy-targeted >= 3.13.1-192 for package: 2:container-selinux-2.66-1.el7.noarch
--> Processing Dependency: selinux-policy-base >= 3.13.1-192 for package: 2:container-selinux-2.66-1.el7.noarch
--> Processing Dependency: selinux-policy >= 3.13.1-192 for package: 2:container-selinux-2.66-1.el7.noarch
---> Package libtool-ltdl.x86_64 0:2.4.2-22.el7_3 will be installed
--> Running transaction check
---> Package selinux-policy.noarch 0:3.13.1-166.el7_4.9 will be updated
---> Package selinux-policy.noarch 0:3.13.1-192.el7_5.4 will be an update
--> Processing Dependency: policycoreutils >= 2.5-18 for package: selinux-policy-3.13.1-192.el7_5.4.noarch
---> Package selinux-policy-targeted.noarch 0:3.13.1-166.el7_4.9 will be updated
---> Package selinux-policy-targeted.noarch 0:3.13.1-192.el7_5.4 will be an update
--> Running transaction check
---> Package policycoreutils.x86_64 0:2.5-17.1.el7 will be updated
--> Processing Dependency: policycoreutils = 2.5-17.1.el7 for package: policycoreutils-python-2.5-17.1.el7.x86_64
---> Package policycoreutils.x86_64 0:2.5-22.el7 will be an update
--> Processing Dependency: libsepol >= 2.5-8 for package: policycoreutils-2.5-22.el7.x86_64
--> Processing Dependency: libselinux-utils >= 2.5-12 for package: policycoreutils-2.5-22.el7.x86_64
--> Running transaction check
---> Package libselinux-utils.x86_64 0:2.5-11.el7 will be updated
---> Package libselinux-utils.x86_64 0:2.5-12.el7 will be an update
--> Processing Dependency: libselinux(x86-64) = 2.5-12.el7 for package: libselinux-utils-2.5-12.el7.x86_64
---> Package libsepol.i686 0:2.5-6.el7 will be updated
---> Package libsepol.x86_64 0:2.5-6.el7 will be updated
---> Package libsepol.i686 0:2.5-8.1.el7 will be an update
---> Package libsepol.x86_64 0:2.5-8.1.el7 will be an update
---> Package policycoreutils-python.x86_64 0:2.5-17.1.el7 will be updated
---> Package policycoreutils-python.x86_64 0:2.5-22.el7 will be an update
--> Processing Dependency: setools-libs >= 3.3.8-2 for package: policycoreutils-python-2.5-22.el7.x86_64
--> Processing Dependency: libsemanage-python >= 2.5-9 for package: policycoreutils-python-2.5-22.el7.x86_64
--> Running transaction check
---> Package libselinux.i686 0:2.5-11.el7 will be updated
---> Package libselinux.x86_64 0:2.5-11.el7 will be updated
--> Processing Dependency: libselinux(x86-64) = 2.5-11.el7 for package: libselinux-python-2.5-11.el7.x86_64
---> Package libselinux.i686 0:2.5-12.el7 will be an update
---> Package libselinux.x86_64 0:2.5-12.el7 will be an update
---> Package libsemanage-python.x86_64 0:2.5-8.el7 will be updated
---> Package libsemanage-python.x86_64 0:2.5-11.el7 will be an update
--> Processing Dependency: libsemanage = 2.5-11.el7 for package: libsemanage-python-2.5-11.el7.x86_64
---> Package setools-libs.x86_64 0:3.3.8-1.1.el7 will be updated
---> Package setools-libs.x86_64 0:3.3.8-2.el7 will be an update
--> Running transaction check
---> Package libselinux-python.x86_64 0:2.5-11.el7 will be updated
---> Package libselinux-python.x86_64 0:2.5-12.el7 will be an update
---> Package libsemanage.x86_64 0:2.5-8.el7 will be updated
---> Package libsemanage.x86_64 0:2.5-11.el7 will be an update
--> Finished Dependency Resolution

Dependencies Resolved

================================================================================
 Package                  Arch    Version               Repository         Size
================================================================================
Installing:
 docker-ce                x86_64  18.06.0.ce-3.el7      docker-ce-stable   41 M
Installing for dependencies:
 container-selinux        noarch  2:2.66-1.el7          extras             35 k
 libtool-ltdl             x86_64  2.4.2-22.el7_3        base               49 k
Updating for dependencies:
 libselinux               i686    2.5-12.el7            base              166 k
 libselinux               x86_64  2.5-12.el7            base              162 k
 libselinux-python        x86_64  2.5-12.el7            base              235 k
 libselinux-utils         x86_64  2.5-12.el7            base              151 k
 libsemanage              x86_64  2.5-11.el7            base              150 k
 libsemanage-python       x86_64  2.5-11.el7            base              112 k
 libsepol                 i686    2.5-8.1.el7           base              293 k
 libsepol                 x86_64  2.5-8.1.el7           base              297 k
 policycoreutils          x86_64  2.5-22.el7            base              867 k
 policycoreutils-python   x86_64  2.5-22.el7            base              454 k
 selinux-policy           noarch  3.13.1-192.el7_5.4    updates           453 k
 selinux-policy-targeted  noarch  3.13.1-192.el7_5.4    updates           6.6 M
 setools-libs             x86_64  3.3.8-2.el7           base              619 k

Transaction Summary
================================================================================
Install  1 Package  (+ 2 Dependent packages)
Upgrade             ( 13 Dependent packages)

Total download size: 51 M
Downloading packages:
Delta RPMs disabled because /usr/bin/applydeltarpm not installed.
(1/16): libselinux-2.5-12.el7.x86_64.rpm                   | 162 kB   00:00     
(2/16): libselinux-2.5-12.el7.i686.rpm                     | 166 kB   00:00     
(3/16): libselinux-utils-2.5-12.el7.x86_64.rpm             | 151 kB   00:00     
(4/16): container-selinux-2.66-1.el7.noarch.rpm            |  35 kB   00:00     
(5/16): libselinux-python-2.5-12.el7.x86_64.rpm            | 235 kB   00:00     
(6/16): libsemanage-2.5-11.el7.x86_64.rpm                  | 150 kB   00:00     
(7/16): libsemanage-python-2.5-11.el7.x86_64.rpm           | 112 kB   00:00     
(8/16): libsepol-2.5-8.1.el7.i686.rpm                      | 293 kB   00:00     
(9/16): libsepol-2.5-8.1.el7.x86_64.rpm                    | 297 kB   00:00     
(10/16): libtool-ltdl-2.4.2-22.el7_3.x86_64.rpm            |  49 kB   00:00     
(11/16): policycoreutils-python-2.5-22.el7.x86_64.rpm      | 454 kB   00:00     
(12/16): policycoreutils-2.5-22.el7.x86_64.rpm             | 867 kB   00:00     
(13/16): setools-libs-3.3.8-2.el7.x86_64.rpm               | 619 kB   00:00     
(14/16): selinux-policy-3.13.1-192.el7_5.4.noarch.rpm      | 453 kB   00:00     
(15/16): selinux-policy-targeted-3.13.1-192.el7_5.4.noarch | 6.6 MB   00:00     
warning: /var/cache/yum/x86_64/7/docker-ce-stable/packages/docker-ce-18.06.0.ce-3.el7.x86_64.rpm: Header V4 RSA/SHA512 Signature, key ID 621e9f35: NOKEY
Public key for docker-ce-18.06.0.ce-3.el7.x86_64.rpm is not installed
(16/16): docker-ce-18.06.0.ce-3.el7.x86_64.rpm             |  41 MB   00:01     
--------------------------------------------------------------------------------
Total                                               38 MB/s |  51 MB  00:01     
Retrieving key from https://download.docker.com/linux/centos/gpg
Importing GPG key 0x621E9F35:
 Userid     : "Docker Release (CE rpm) <docker@docker.com>"
 Fingerprint: 060a 61c5 1b55 8a7f 742b 77aa c52f eb6b 621e 9f35
 From       : https://download.docker.com/linux/centos/gpg
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Updating   : libsepol-2.5-8.1.el7.x86_64                                 1/29 
  Updating   : libselinux-2.5-12.el7.x86_64                                2/29 
  Updating   : libsemanage-2.5-11.el7.x86_64                               3/29 
  Updating   : libselinux-utils-2.5-12.el7.x86_64                          4/29 
  Updating   : policycoreutils-2.5-22.el7.x86_64                           5/29 
  Updating   : selinux-policy-3.13.1-192.el7_5.4.noarch                    6/29 
  Updating   : selinux-policy-targeted-3.13.1-192.el7_5.4.noarch           7/29 
  Updating   : libsemanage-python-2.5-11.el7.x86_64                        8/29 
  Updating   : libselinux-python-2.5-12.el7.x86_64                         9/29 
  Updating   : setools-libs-3.3.8-2.el7.x86_64                            10/29 
  Updating   : policycoreutils-python-2.5-22.el7.x86_64                   11/29 
  Installing : 2:container-selinux-2.66-1.el7.noarch                      12/29 
  Installing : libtool-ltdl-2.4.2-22.el7_3.x86_64                         13/29 
  Updating   : libsepol-2.5-8.1.el7.i686                                  14/29 
  Installing : docker-ce-18.06.0.ce-3.el7.x86_64                          15/29 
  Updating   : libselinux-2.5-12.el7.i686                                 16/29 
  Cleanup    : selinux-policy-targeted-3.13.1-166.el7_4.9.noarch          17/29 
  Cleanup    : policycoreutils-python-2.5-17.1.el7.x86_64                 18/29 
  Cleanup    : selinux-policy-3.13.1-166.el7_4.9.noarch                   19/29 
  Cleanup    : libselinux-2.5-11.el7                                      20/29 
  Cleanup    : policycoreutils-2.5-17.1.el7.x86_64                        21/29 
  Cleanup    : libselinux-utils-2.5-11.el7.x86_64                         22/29 
  Cleanup    : setools-libs-3.3.8-1.1.el7.x86_64                          23/29 
  Cleanup    : libselinux-python-2.5-11.el7.x86_64                        24/29 
  Cleanup    : libsemanage-python-2.5-8.el7.x86_64                        25/29 
  Cleanup    : libsepol-2.5-6.el7                                         26/29 
  Cleanup    : libsemanage-2.5-8.el7.x86_64                               27/29 
  Cleanup    : libselinux-2.5-11.el7                                      28/29 
  Cleanup    : libsepol-2.5-6.el7                                         29/29 
  Verifying  : libselinux-python-2.5-12.el7.x86_64                         1/29 
  Verifying  : selinux-policy-3.13.1-192.el7_5.4.noarch                    2/29 
  Verifying  : setools-libs-3.3.8-2.el7.x86_64                             3/29 
  Verifying  : libsemanage-python-2.5-11.el7.x86_64                        4/29 
  Verifying  : policycoreutils-2.5-22.el7.x86_64                           5/29 
  Verifying  : libsepol-2.5-8.1.el7.i686                                   6/29 
  Verifying  : libsemanage-2.5-11.el7.x86_64                               7/29 
  Verifying  : selinux-policy-targeted-3.13.1-192.el7_5.4.noarch           8/29 
  Verifying  : policycoreutils-python-2.5-22.el7.x86_64                    9/29 
  Verifying  : libtool-ltdl-2.4.2-22.el7_3.x86_64                         10/29 
  Verifying  : 2:container-selinux-2.66-1.el7.noarch                      11/29 
  Verifying  : libselinux-2.5-12.el7.i686                                 12/29 
  Verifying  : docker-ce-18.06.0.ce-3.el7.x86_64                          13/29 
  Verifying  : libsepol-2.5-8.1.el7.x86_64                                14/29 
  Verifying  : libselinux-2.5-12.el7.x86_64                               15/29 
  Verifying  : libselinux-utils-2.5-12.el7.x86_64                         16/29 
  Verifying  : libselinux-utils-2.5-11.el7.x86_64                         17/29 
  Verifying  : libsepol-2.5-6.el7.i686                                    18/29 
  Verifying  : libselinux-2.5-11.el7.x86_64                               19/29 
  Verifying  : libsepol-2.5-6.el7.x86_64                                  20/29 
  Verifying  : policycoreutils-python-2.5-17.1.el7.x86_64                 21/29 
  Verifying  : selinux-policy-targeted-3.13.1-166.el7_4.9.noarch          22/29 
  Verifying  : policycoreutils-2.5-17.1.el7.x86_64                        23/29 
  Verifying  : selinux-policy-3.13.1-166.el7_4.9.noarch                   24/29 
  Verifying  : libsemanage-python-2.5-8.el7.x86_64                        25/29 
  Verifying  : libselinux-2.5-11.el7.i686                                 26/29 
  Verifying  : libsemanage-2.5-8.el7.x86_64                               27/29 
  Verifying  : libselinux-python-2.5-11.el7.x86_64                        28/29 
  Verifying  : setools-libs-3.3.8-1.1.el7.x86_64                          29/29 

Installed:
  docker-ce.x86_64 0:18.06.0.ce-3.el7                                           

Dependency Installed:
  container-selinux.noarch 2:2.66-1.el7   libtool-ltdl.x86_64 0:2.4.2-22.el7_3  

Dependency Updated:
  libselinux.i686 0:2.5-12.el7                                                  
  libselinux.x86_64 0:2.5-12.el7                                                
  libselinux-python.x86_64 0:2.5-12.el7                                         
  libselinux-utils.x86_64 0:2.5-12.el7                                          
  libsemanage.x86_64 0:2.5-11.el7                                               
  libsemanage-python.x86_64 0:2.5-11.el7                                        
  libsepol.i686 0:2.5-8.1.el7                                                   
  libsepol.x86_64 0:2.5-8.1.el7                                                 
  policycoreutils.x86_64 0:2.5-22.el7                                           
  policycoreutils-python.x86_64 0:2.5-22.el7                                    
  selinux-policy.noarch 0:3.13.1-192.el7_5.4                                    
  selinux-policy-targeted.noarch 0:3.13.1-192.el7_5.4                           
  setools-libs.x86_64 0:3.3.8-2.el7                                             

Complete!
groupadd: group 'docker' already exists
Created symlink from /etc/systemd/system/multi-user.target.wants/docker.service to /usr/lib/systemd/system/docker.service.
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
 * base: mirror.umd.edu
 * extras: www.gtlib.gatech.edu
 * updates: mirror.vcu.edu
No unfinished transactions left.
[cloud_user@ip-10-0-0-12 ~]$ exit
logout
Connection to 34.227.197.208 closed.
craig:~ cn$ ssh cloud_user@34.227.197.208
cloud_user@34.227.197.208's password: 
Last login: Fri Aug  3 18:17:40 2018 from 108-74-118-125.lightspeed.tukrga.sbcglobal.net
[cloud_user@ip-10-0-0-12 ~]$ docker pull httpd
Using default tag: latest
latest: Pulling from library/httpd
d660b1f15b9b: Pull complete 
aa1c79a2fa37: Pull complete 
f5f6514c0aff: Pull complete 
676d3dd26040: Pull complete 
4fdddf845a1b: Pull complete 
520c4b04fe88: Pull complete 
5387b1b7893c: Pull complete 
Digest: sha256:8c84e065bdf72b4909bd55a348d5e91fe265e08d6b28ed9104bfdcac9206dcc8
Status: Downloaded newer image for httpd:latest
[cloud_user@ip-10-0-0-12 ~]$ sudo ls -al /etc/docker/
[sudo] password for cloud_user: 
total 16
drwx------.  2 root root   22 Aug  3 18:19 .
drwxr-xr-x. 78 root root 8192 Aug  3 18:19 ..
-rw-------.  1 root root  244 Aug  3 18:19 key.json
[cloud_user@ip-10-0-0-12 ~]$ sudo cd /etc/docker/
[cloud_user@ip-10-0-0-12 ~]$ sudo -i
[root@ip-10-0-0-12 ~]# cd /etc/docker/
[root@ip-10-0-0-12 docker]# pwd
/etc/docker
[root@ip-10-0-0-12 docker]# vi daemon.json
[root@ip-10-0-0-12 docker]# vi daemon.json
[root@ip-10-0-0-12 docker]# cat daemon.json 
{
  "storage-driver": "devicemapper"
} 
[root@ip-10-0-0-12 docker]# systemctl restart docker
[root@ip-10-0-0-12 docker]# docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
[root@ip-10-0-0-12 docker]# docker info | grep Storage
WARNING: devicemapper: usage of loopback devices is strongly discouraged for production use.
         Use `--storage-opt dm.thinpooldev` to specify a custom block storage device.
Storage Driver: devicemapper
[root@ip-10-0-0-12 docker]# 

## Configuring Containers to Use Host Storage Mounts

CENARIOS
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
bash <(curl -s https://raw.githubusercontent.com/craignicholson/docker-quickstart/master/03_Orchestration/centos7_dockerInstall.sh)

sudo systemctl disable firewalld && sudo systemctl stop firewalld

mkdir -p content/version1
echo "Verions 1" > /version1/index.html

mkdir -p content/version2
echo "Verions Two" > /content/version1/index.html

sudo vim /etc/hosts

10.0.0.11 manager
10.0.0.12 node1



docker run -d --name test-web1 --mount type=bind,source=/home/cloud_user/content/version1,target=/usr/local/apache2/htdocs httpd

[cloud_user@ip-10-0-0-11 version2]$ docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS               NAMES
6c2c4174272a        httpd               "httpd-foreground"   16 seconds ago      Up 15 seconds       80/tcp              test-web1
[cloud_user@ip-10-0-0-11 version2]$ docker inspect 6c2c4174272a | grep IPAddress
            "SecondaryIPAddresses": null,
            "IPAddress": "172.17.0.2",
                    "IPAddress": "172.17.0.2",
[cloud_user@ip-10-0-0-11 version2]$ 


docker run -d --name test-web2 --mount type=bind,source=/home/cloud_user/content/version2,target=/usr/local/apache2/htdocs httpd

[cloud_user@ip-10-0-0-11 version2]$ docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED              STATUS              PORTS               NAMES
dbb9e4b0dd0c        httpd               "httpd-foreground"   About a minute ago   Up About a minute   80/tcp              test-web2
6c2c4174272a        httpd               "httpd-foreground"   2 minutes ago        Up 2 minutes        80/tcp              test-web1
[cloud_user@ip-10-0-0-11 version2]$ docker inspect dbb9e4b0dd0c | grep IPAddress
            "SecondaryIPAddresses": null,
            "IPAddress": "172.17.0.3",
                    "IPAddress": "172.17.0.3",
[cloud_user@ip-10-0-0-11 version2]$ curl 172.17.0.3
Verions Two


OR _ NONE OF THIS WORKED>>>>> Never MIND - I GOT IT WORKING...

10.0.0.11
docker swarm init

10.0.0.12
docker swarm join-token ...

docker service create --name test-web1 -p 80:80 --mount type=bind,source=/home/cloud_user/content/version1,target=/usr/local/apache2/htdocs --detach=false --replicas 2 httpd

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



docker service create --name test-web2 --mount type=bind,source=/home/cloud_user/content/version2,target=/usr/local/apache2/htdocs --detach=false --replicas 3 httpd

[cloud_user@ip-10-0-0-11 home]$ docker service ps test-web2
ID                  NAME                IMAGE               NODE                        DESIRED STATE       CURRENT STATE            ERROR               PORTS
orhdp8vci6hj        test-web2.1         httpd:latest        ip-10-0-0-12.ec2.internal   Running             Running 19 seconds ago                       
rcj0jcy38e4x        test-web2.2         httpd:latest        ip-10-0-0-11.ec2.internal   Running             Running 19 seconds ago                       
v0rgxvzz7t18        test-web2.3         httpd:latest        ip-10-0-0-12.ec2.internal   Running             Running 19 seconds ago                       
[cloud_user@ip-10-0-0-11 home]$ 


[cloud_user@ip-10-0-0-11 home]$ curl ip-10-0-0-11.ec2.internal:81
Verions Two
[cloud_user@ip-10-0-0-11 home]$ curl ip-10-0-0-11.ec2.internal:81
Verions Two
[cloud_user@ip-10-0-0-11 home]$ curl ip-10-0-0-11.ec2.internal:80
Verions 1
[cloud_user@ip-10-0-0-11 home]$ 


MAYBE IT DID WORK ONLY ON THE MANAGER

FILTER

https://docs.docker.com/engine/reference/commandline/service_ps/#filtering

[cloud_user@ip-10-0-0-11 home]$ docker service ps -f "desired-state=running" test-web1
ID                  NAME                IMAGE               NODE                        DESIRED STATE       CURRENT STATE           ERROR               PORTS
l5nmv4jk2j0r        test-web1.1         httpd:latest        ip-10-0-0-11.ec2.internal   Running             Running 9 minutes ago                       
ropwpgz4ekmc        test-web1.2         httpd:latest        ip-10-0-0-11.ec2.internal   Running             Running 9 minutes ago                       
[cloud_user@ip-10-0-0-11 home]$ docker service ps -f "desired-state=running" test-web2
ID                  NAME                IMAGE               NODE                        DESIRED STATE       CURRENT STATE           ERROR               PORTS
smgbehaue4gf        test-web2.1         httpd:latest        ip-10-0-0-11.ec2.internal   Running             Running 3 minutes ago                       
5sr3iiz7fuw1        test-web2.2         httpd:latest        ip-10-0-0-11.ec2.internal   Running             Running 3 minutes ago                       
e8jkgen22v1c        test-web2.3         httpd:latest        ip-10-0-0-11.ec2.internal   Running             Running 3 minutes ago                       
[cloud_user@ip-10-0-0-11 home]$ 



------------------------ CLEAN UP

Last login: Fri Aug  3 19:24:10 on ttys000
craig:~ cn$ ssh cloud_user@184.72.108.229
The authenticity of host '184.72.108.229 (184.72.108.229)' can't be established.
ECDSA key fingerprint is SHA256:UE+sN0+iPQ+7cJesmyoddnAcwghjsZn0B3BTNl81sDM.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '184.72.108.229' (ECDSA) to the list of known hosts.
cloud_user@184.72.108.229's password: 
Last login: Tue Mar 27 14:51:34 2018 from 75-142-56-142.static.mtpk.ca.charter.com
[cloud_user@ip-10-0-0-11 ~]$ bash <(curl -s https://raw.githubusercontent.com/craignicholson/docker-quickstart/master/03
_Orchestration/centos7_dockerInstall.sh)
[sudo] password for cloud_user: 
Loaded plugins: fastestmirror
base                                                                                              | 3.6 kB  00:00:00     
extras                                                                                            | 3.4 kB  00:00:00     
updates                                                                                           | 3.4 kB  00:00:00     
(1/4): base/7/x86_64/group_gz                                                                     | 166 kB  00:00:00     
(2/4): extras/7/x86_64/primary_db                                                                 | 173 kB  00:00:00     
(3/4): updates/7/x86_64/primary_db                                                                | 4.3 MB  00:00:00     
(4/4): base/7/x86_64/primary_db                                                                   | 5.9 MB  00:00:03     
Determining fastest mirrors
 * base: centos2.zswap.net
 * extras: mirror.math.princeton.edu
 * updates: linux.cc.lehigh.edu
Resolving Dependencies
--> Running transaction check
---> Package device-mapper-persistent-data.x86_64 0:0.7.3-3.el7 will be installed
--> Processing Dependency: libaio.so.1(LIBAIO_0.4)(64bit) for package: device-mapper-persistent-data-0.7.3-3.el7.x86_64
--> Processing Dependency: libaio.so.1(LIBAIO_0.1)(64bit) for package: device-mapper-persistent-data-0.7.3-3.el7.x86_64
--> Processing Dependency: libaio.so.1()(64bit) for package: device-mapper-persistent-data-0.7.3-3.el7.x86_64
---> Package lvm2.x86_64 7:2.02.177-4.el7 will be installed
--> Processing Dependency: lvm2-libs = 7:2.02.177-4.el7 for package: 7:lvm2-2.02.177-4.el7.x86_64
--> Processing Dependency: liblvm2app.so.2.2(Base)(64bit) for package: 7:lvm2-2.02.177-4.el7.x86_64
--> Processing Dependency: libdevmapper.so.1.02(DM_1_02_141)(64bit) for package: 7:lvm2-2.02.177-4.el7.x86_64
--> Processing Dependency: libdevmapper-event.so.1.02(Base)(64bit) for package: 7:lvm2-2.02.177-4.el7.x86_64
--> Processing Dependency: liblvm2app.so.2.2()(64bit) for package: 7:lvm2-2.02.177-4.el7.x86_64
--> Processing Dependency: libdevmapper-event.so.1.02()(64bit) for package: 7:lvm2-2.02.177-4.el7.x86_64
---> Package yum-utils.noarch 0:1.1.31-46.el7_5 will be installed
--> Processing Dependency: python-kitchen for package: yum-utils-1.1.31-46.el7_5.noarch
--> Processing Dependency: libxml2-python for package: yum-utils-1.1.31-46.el7_5.noarch
--> Running transaction check
---> Package device-mapper-event-libs.x86_64 7:1.02.146-4.el7 will be installed
---> Package device-mapper-libs.x86_64 7:1.02.140-8.el7 will be updated
--> Processing Dependency: device-mapper-libs = 7:1.02.140-8.el7 for package: 7:device-mapper-1.02.140-8.el7.x86_64
---> Package device-mapper-libs.x86_64 7:1.02.146-4.el7 will be an update
---> Package libaio.x86_64 0:0.3.109-13.el7 will be installed
---> Package libxml2-python.x86_64 0:2.9.1-6.el7_2.3 will be installed
---> Package lvm2-libs.x86_64 7:2.02.177-4.el7 will be installed
--> Processing Dependency: device-mapper-event = 7:1.02.146-4.el7 for package: 7:lvm2-libs-2.02.177-4.el7.x86_64
---> Package python-kitchen.noarch 0:1.1.1-5.el7 will be installed
--> Running transaction check
---> Package device-mapper.x86_64 7:1.02.140-8.el7 will be updated
---> Package device-mapper.x86_64 7:1.02.146-4.el7 will be an update
---> Package device-mapper-event.x86_64 7:1.02.146-4.el7 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

=========================================================================================================================
 Package                                    Arch                Version                       Repository            Size
=========================================================================================================================
Installing:
 device-mapper-persistent-data              x86_64              0.7.3-3.el7                   base                 405 k
 lvm2                                       x86_64              7:2.02.177-4.el7              base                 1.3 M
 yum-utils                                  noarch              1.1.31-46.el7_5               updates              120 k
Installing for dependencies:
 device-mapper-event                        x86_64              7:1.02.146-4.el7              base                 185 k
 device-mapper-event-libs                   x86_64              7:1.02.146-4.el7              base                 184 k
 libaio                                     x86_64              0.3.109-13.el7                base                  24 k
 libxml2-python                             x86_64              2.9.1-6.el7_2.3               base                 247 k
 lvm2-libs                                  x86_64              7:2.02.177-4.el7              base                 1.0 M
 python-kitchen                             noarch              1.1.1-5.el7                   base                 267 k
Updating for dependencies:
 device-mapper                              x86_64              7:1.02.146-4.el7              base                 289 k
 device-mapper-libs                         x86_64              7:1.02.146-4.el7              base                 316 k

Transaction Summary
=========================================================================================================================
Install  3 Packages (+6 Dependent packages)
Upgrade             ( 2 Dependent packages)

Total download size: 4.3 M
Downloading packages:
Delta RPMs disabled because /usr/bin/applydeltarpm not installed.
(1/11): device-mapper-event-1.02.146-4.el7.x86_64.rpm                                             | 185 kB  00:00:00     
(2/11): libaio-0.3.109-13.el7.x86_64.rpm                                                          |  24 kB  00:00:00     
(3/11): libxml2-python-2.9.1-6.el7_2.3.x86_64.rpm                                                 | 247 kB  00:00:00     
(4/11): lvm2-2.02.177-4.el7.x86_64.rpm                                                            | 1.3 MB  00:00:00     
(5/11): lvm2-libs-2.02.177-4.el7.x86_64.rpm                                                       | 1.0 MB  00:00:00     
(6/11): python-kitchen-1.1.1-5.el7.noarch.rpm                                                     | 267 kB  00:00:00     
(7/11): device-mapper-libs-1.02.146-4.el7.x86_64.rpm                                              | 316 kB  00:00:00     
(8/11): yum-utils-1.1.31-46.el7_5.noarch.rpm                                                      | 120 kB  00:00:00     
(9/11): device-mapper-event-libs-1.02.146-4.el7.x86_64.rpm                                        | 184 kB  00:00:00     
(10/11): device-mapper-1.02.146-4.el7.x86_64.rpm                                                  | 289 kB  00:00:01     
(11/11): device-mapper-persistent-data-0.7.3-3.el7.x86_64.rpm                                     | 405 kB  00:00:01     
-------------------------------------------------------------------------------------------------------------------------
Total                                                                                    3.6 MB/s | 4.3 MB  00:00:01     
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Updating   : 7:device-mapper-libs-1.02.146-4.el7.x86_64                                                           1/13 
  Updating   : 7:device-mapper-1.02.146-4.el7.x86_64                                                                2/13 
  Installing : 7:device-mapper-event-libs-1.02.146-4.el7.x86_64                                                     3/13 
  Installing : 7:device-mapper-event-1.02.146-4.el7.x86_64                                                          4/13 
  Installing : 7:lvm2-libs-2.02.177-4.el7.x86_64                                                                    5/13 
  Installing : libaio-0.3.109-13.el7.x86_64                                                                         6/13 
  Installing : device-mapper-persistent-data-0.7.3-3.el7.x86_64                                                     7/13 
  Installing : python-kitchen-1.1.1-5.el7.noarch                                                                    8/13 
  Installing : libxml2-python-2.9.1-6.el7_2.3.x86_64                                                                9/13 
  Installing : yum-utils-1.1.31-46.el7_5.noarch                                                                    10/13 
  Installing : 7:lvm2-2.02.177-4.el7.x86_64                                                                        11/13 
Created symlink from /etc/systemd/system/sysinit.target.wants/lvm2-lvmpolld.socket to /usr/lib/systemd/system/lvm2-lvmpolld.socket.
  Cleanup    : 7:device-mapper-libs-1.02.140-8.el7.x86_64                                                          12/13 
  Cleanup    : 7:device-mapper-1.02.140-8.el7.x86_64                                                               13/13 
  Verifying  : device-mapper-persistent-data-0.7.3-3.el7.x86_64                                                     1/13 
  Verifying  : 7:lvm2-2.02.177-4.el7.x86_64                                                                         2/13 
  Verifying  : yum-utils-1.1.31-46.el7_5.noarch                                                                     3/13 
  Verifying  : 7:device-mapper-1.02.146-4.el7.x86_64                                                                4/13 
  Verifying  : 7:device-mapper-event-1.02.146-4.el7.x86_64                                                          5/13 
  Verifying  : libxml2-python-2.9.1-6.el7_2.3.x86_64                                                                6/13 
  Verifying  : python-kitchen-1.1.1-5.el7.noarch                                                                    7/13 
  Verifying  : 7:device-mapper-event-libs-1.02.146-4.el7.x86_64                                                     8/13 
  Verifying  : 7:lvm2-libs-2.02.177-4.el7.x86_64                                                                    9/13 
  Verifying  : libaio-0.3.109-13.el7.x86_64                                                                        10/13 
  Verifying  : 7:device-mapper-libs-1.02.146-4.el7.x86_64                                                          11/13 
  Verifying  : 7:device-mapper-1.02.140-8.el7.x86_64                                                               12/13 
  Verifying  : 7:device-mapper-libs-1.02.140-8.el7.x86_64                                                          13/13 

Installed:
  device-mapper-persistent-data.x86_64 0:0.7.3-3.el7  lvm2.x86_64 7:2.02.177-4.el7  yum-utils.noarch 0:1.1.31-46.el7_5 

Dependency Installed:
  device-mapper-event.x86_64 7:1.02.146-4.el7              device-mapper-event-libs.x86_64 7:1.02.146-4.el7             
  libaio.x86_64 0:0.3.109-13.el7                           libxml2-python.x86_64 0:2.9.1-6.el7_2.3                      
  lvm2-libs.x86_64 7:2.02.177-4.el7                        python-kitchen.noarch 0:1.1.1-5.el7                          

Dependency Updated:
  device-mapper.x86_64 7:1.02.146-4.el7                    device-mapper-libs.x86_64 7:1.02.146-4.el7                   

Complete!
Loaded plugins: fastestmirror
adding repo from: https://download.docker.com/linux/centos/docker-ce.repo
grabbing file https://download.docker.com/linux/centos/docker-ce.repo to /etc/yum.repos.d/docker-ce.repo
repo saved to /etc/yum.repos.d/docker-ce.repo
Loaded plugins: fastestmirror
docker-ce-stable                                                                                  | 2.9 kB  00:00:00     
docker-ce-stable/x86_64/primary_db                                                                |  14 kB  00:00:00     
Loading mirror speeds from cached hostfile
 * base: centos2.zswap.net
 * extras: mirror.math.princeton.edu
 * updates: linux.cc.lehigh.edu
Resolving Dependencies
--> Running transaction check
---> Package docker-ce.x86_64 0:18.06.0.ce-3.el7 will be installed
--> Processing Dependency: container-selinux >= 2.9 for package: docker-ce-18.06.0.ce-3.el7.x86_64
--> Processing Dependency: libltdl.so.7()(64bit) for package: docker-ce-18.06.0.ce-3.el7.x86_64
--> Running transaction check
---> Package container-selinux.noarch 2:2.66-1.el7 will be installed
--> Processing Dependency: selinux-policy-targeted >= 3.13.1-192 for package: 2:container-selinux-2.66-1.el7.noarch
--> Processing Dependency: selinux-policy-base >= 3.13.1-192 for package: 2:container-selinux-2.66-1.el7.noarch
--> Processing Dependency: selinux-policy >= 3.13.1-192 for package: 2:container-selinux-2.66-1.el7.noarch
---> Package libtool-ltdl.x86_64 0:2.4.2-22.el7_3 will be installed
--> Running transaction check
---> Package selinux-policy.noarch 0:3.13.1-166.el7_4.9 will be updated
---> Package selinux-policy.noarch 0:3.13.1-192.el7_5.4 will be an update
--> Processing Dependency: policycoreutils >= 2.5-18 for package: selinux-policy-3.13.1-192.el7_5.4.noarch
---> Package selinux-policy-targeted.noarch 0:3.13.1-166.el7_4.9 will be updated
---> Package selinux-policy-targeted.noarch 0:3.13.1-192.el7_5.4 will be an update
--> Running transaction check
---> Package policycoreutils.x86_64 0:2.5-17.1.el7 will be updated
--> Processing Dependency: policycoreutils = 2.5-17.1.el7 for package: policycoreutils-python-2.5-17.1.el7.x86_64
---> Package policycoreutils.x86_64 0:2.5-22.el7 will be an update
--> Processing Dependency: libsepol >= 2.5-8 for package: policycoreutils-2.5-22.el7.x86_64
--> Processing Dependency: libselinux-utils >= 2.5-12 for package: policycoreutils-2.5-22.el7.x86_64
--> Running transaction check
---> Package libselinux-utils.x86_64 0:2.5-11.el7 will be updated
---> Package libselinux-utils.x86_64 0:2.5-12.el7 will be an update
--> Processing Dependency: libselinux(x86-64) = 2.5-12.el7 for package: libselinux-utils-2.5-12.el7.x86_64
---> Package libsepol.i686 0:2.5-6.el7 will be updated
---> Package libsepol.x86_64 0:2.5-6.el7 will be updated
---> Package libsepol.i686 0:2.5-8.1.el7 will be an update
---> Package libsepol.x86_64 0:2.5-8.1.el7 will be an update
---> Package policycoreutils-python.x86_64 0:2.5-17.1.el7 will be updated
---> Package policycoreutils-python.x86_64 0:2.5-22.el7 will be an update
--> Processing Dependency: setools-libs >= 3.3.8-2 for package: policycoreutils-python-2.5-22.el7.x86_64
--> Processing Dependency: libsemanage-python >= 2.5-9 for package: policycoreutils-python-2.5-22.el7.x86_64
--> Running transaction check
---> Package libselinux.i686 0:2.5-11.el7 will be updated
---> Package libselinux.x86_64 0:2.5-11.el7 will be updated
--> Processing Dependency: libselinux(x86-64) = 2.5-11.el7 for package: libselinux-python-2.5-11.el7.x86_64
---> Package libselinux.i686 0:2.5-12.el7 will be an update
---> Package libselinux.x86_64 0:2.5-12.el7 will be an update
---> Package libsemanage-python.x86_64 0:2.5-8.el7 will be updated
---> Package libsemanage-python.x86_64 0:2.5-11.el7 will be an update
--> Processing Dependency: libsemanage = 2.5-11.el7 for package: libsemanage-python-2.5-11.el7.x86_64
---> Package setools-libs.x86_64 0:3.3.8-1.1.el7 will be updated
---> Package setools-libs.x86_64 0:3.3.8-2.el7 will be an update
--> Running transaction check
---> Package libselinux-python.x86_64 0:2.5-11.el7 will be updated
---> Package libselinux-python.x86_64 0:2.5-12.el7 will be an update
---> Package libsemanage.x86_64 0:2.5-8.el7 will be updated
---> Package libsemanage.x86_64 0:2.5-11.el7 will be an update
--> Finished Dependency Resolution

Dependencies Resolved

=========================================================================================================================
 Package                            Arch              Version                          Repository                   Size
=========================================================================================================================
Installing:
 docker-ce                          x86_64            18.06.0.ce-3.el7                 docker-ce-stable             41 M
Installing for dependencies:
 container-selinux                  noarch            2:2.66-1.el7                     extras                       35 k
 libtool-ltdl                       x86_64            2.4.2-22.el7_3                   base                         49 k
Updating for dependencies:
 libselinux                         i686              2.5-12.el7                       base                        166 k
 libselinux                         x86_64            2.5-12.el7                       base                        162 k
 libselinux-python                  x86_64            2.5-12.el7                       base                        235 k
 libselinux-utils                   x86_64            2.5-12.el7                       base                        151 k
 libsemanage                        x86_64            2.5-11.el7                       base                        150 k
 libsemanage-python                 x86_64            2.5-11.el7                       base                        112 k
 libsepol                           i686              2.5-8.1.el7                      base                        293 k
 libsepol                           x86_64            2.5-8.1.el7                      base                        297 k
 policycoreutils                    x86_64            2.5-22.el7                       base                        867 k
 policycoreutils-python             x86_64            2.5-22.el7                       base                        454 k
 selinux-policy                     noarch            3.13.1-192.el7_5.4               updates                     453 k
 selinux-policy-targeted            noarch            3.13.1-192.el7_5.4               updates                     6.6 M
 setools-libs                       x86_64            3.3.8-2.el7                      base                        619 k

Transaction Summary
=========================================================================================================================
Install  1 Package  (+ 2 Dependent packages)
Upgrade             ( 13 Dependent packages)

Total download size: 51 M
Downloading packages:
Delta RPMs disabled because /usr/bin/applydeltarpm not installed.
(1/16): container-selinux-2.66-1.el7.noarch.rpm                                                   |  35 kB  00:00:00     
(2/16): libselinux-2.5-12.el7.x86_64.rpm                                                          | 162 kB  00:00:00     
(3/16): libselinux-2.5-12.el7.i686.rpm                                                            | 166 kB  00:00:00     
(4/16): libselinux-utils-2.5-12.el7.x86_64.rpm                                                    | 151 kB  00:00:00     
(5/16): libselinux-python-2.5-12.el7.x86_64.rpm                                                   | 235 kB  00:00:00     
(6/16): libsemanage-2.5-11.el7.x86_64.rpm                                                         | 150 kB  00:00:00     
(7/16): libsepol-2.5-8.1.el7.i686.rpm                                                             | 293 kB  00:00:00     
(8/16): libsepol-2.5-8.1.el7.x86_64.rpm                                                           | 297 kB  00:00:00     
(9/16): libtool-ltdl-2.4.2-22.el7_3.x86_64.rpm                                                    |  49 kB  00:00:00     
(10/16): libsemanage-python-2.5-11.el7.x86_64.rpm                                                 | 112 kB  00:00:00     
(11/16): policycoreutils-python-2.5-22.el7.x86_64.rpm                                             | 454 kB  00:00:00     
(12/16): setools-libs-3.3.8-2.el7.x86_64.rpm                                                      | 619 kB  00:00:00     
(13/16): policycoreutils-2.5-22.el7.x86_64.rpm                                                    | 867 kB  00:00:00     
(14/16): selinux-policy-3.13.1-192.el7_5.4.noarch.rpm                                             | 453 kB  00:00:00     
warning: /var/cache/yum/x86_64/7/docker-ce-stable/packages/docker-ce-18.06.0.ce-3.el7.x86_64.rpm: Header V4 RSA/SHA512 Signature, key ID 621e9f35: NOKEY
Public key for docker-ce-18.06.0.ce-3.el7.x86_64.rpm is not installed
(15/16): docker-ce-18.06.0.ce-3.el7.x86_64.rpm                                                    |  41 MB  00:00:01     
(16/16): selinux-policy-targeted-3.13.1-192.el7_5.4.noarch.rpm                                    | 6.6 MB  00:00:01     
-------------------------------------------------------------------------------------------------------------------------
Total                                                                                     25 MB/s |  51 MB  00:00:02     
Retrieving key from https://download.docker.com/linux/centos/gpg
Importing GPG key 0x621E9F35:
 Userid     : "Docker Release (CE rpm) <docker@docker.com>"
 Fingerprint: 060a 61c5 1b55 8a7f 742b 77aa c52f eb6b 621e 9f35
 From       : https://download.docker.com/linux/centos/gpg
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Updating   : libsepol-2.5-8.1.el7.x86_64                                                                          1/29 
  Updating   : libselinux-2.5-12.el7.x86_64                                                                         2/29 
  Updating   : libsemanage-2.5-11.el7.x86_64                                                                        3/29 
  Updating   : libselinux-utils-2.5-12.el7.x86_64                                                                   4/29 
  Updating   : policycoreutils-2.5-22.el7.x86_64                                                                    5/29 
  Updating   : selinux-policy-3.13.1-192.el7_5.4.noarch                                                             6/29 
  Updating   : selinux-policy-targeted-3.13.1-192.el7_5.4.noarch                                                    7/29 
  Updating   : libsemanage-python-2.5-11.el7.x86_64                                                                 8/29 
  Updating   : libselinux-python-2.5-12.el7.x86_64                                                                  9/29 
  Updating   : setools-libs-3.3.8-2.el7.x86_64                                                                     10/29 
  Updating   : policycoreutils-python-2.5-22.el7.x86_64                                                            11/29 
  Installing : 2:container-selinux-2.66-1.el7.noarch                                                               12/29 
  Installing : libtool-ltdl-2.4.2-22.el7_3.x86_64                                                                  13/29 
  Updating   : libsepol-2.5-8.1.el7.i686                                                                           14/29 
  Installing : docker-ce-18.06.0.ce-3.el7.x86_64                                                                   15/29 
  Updating   : libselinux-2.5-12.el7.i686                                                                          16/29 
  Cleanup    : selinux-policy-targeted-3.13.1-166.el7_4.9.noarch                                                   17/29 
  Cleanup    : policycoreutils-python-2.5-17.1.el7.x86_64                                                          18/29 
  Cleanup    : selinux-policy-3.13.1-166.el7_4.9.noarch                                                            19/29 
  Cleanup    : libselinux-2.5-11.el7                                                                               20/29 
  Cleanup    : policycoreutils-2.5-17.1.el7.x86_64                                                                 21/29 
  Cleanup    : libselinux-utils-2.5-11.el7.x86_64                                                                  22/29 
  Cleanup    : setools-libs-3.3.8-1.1.el7.x86_64                                                                   23/29 
  Cleanup    : libselinux-python-2.5-11.el7.x86_64                                                                 24/29 
  Cleanup    : libsemanage-python-2.5-8.el7.x86_64                                                                 25/29 
  Cleanup    : libsepol-2.5-6.el7                                                                                  26/29 
  Cleanup    : libsemanage-2.5-8.el7.x86_64                                                                        27/29 
  Cleanup    : libselinux-2.5-11.el7                                                                               28/29 
  Cleanup    : libsepol-2.5-6.el7                                                                                  29/29 
  Verifying  : libselinux-python-2.5-12.el7.x86_64                                                                  1/29 
  Verifying  : selinux-policy-3.13.1-192.el7_5.4.noarch                                                             2/29 
  Verifying  : setools-libs-3.3.8-2.el7.x86_64                                                                      3/29 
  Verifying  : libsemanage-python-2.5-11.el7.x86_64                                                                 4/29 
  Verifying  : policycoreutils-2.5-22.el7.x86_64                                                                    5/29 
  Verifying  : libsepol-2.5-8.1.el7.i686                                                                            6/29 
  Verifying  : libsemanage-2.5-11.el7.x86_64                                                                        7/29 
  Verifying  : selinux-policy-targeted-3.13.1-192.el7_5.4.noarch                                                    8/29 
  Verifying  : policycoreutils-python-2.5-22.el7.x86_64                                                             9/29 
  Verifying  : libtool-ltdl-2.4.2-22.el7_3.x86_64                                                                  10/29 
  Verifying  : 2:container-selinux-2.66-1.el7.noarch                                                               11/29 
  Verifying  : libselinux-2.5-12.el7.i686                                                                          12/29 
  Verifying  : docker-ce-18.06.0.ce-3.el7.x86_64                                                                   13/29 
  Verifying  : libsepol-2.5-8.1.el7.x86_64                                                                         14/29 
  Verifying  : libselinux-2.5-12.el7.x86_64                                                                        15/29 
  Verifying  : libselinux-utils-2.5-12.el7.x86_64                                                                  16/29 
  Verifying  : libselinux-utils-2.5-11.el7.x86_64                                                                  17/29 
  Verifying  : libsepol-2.5-6.el7.i686                                                                             18/29 
  Verifying  : libselinux-2.5-11.el7.x86_64                                                                        19/29 
  Verifying  : libsepol-2.5-6.el7.x86_64                                                                           20/29 
  Verifying  : policycoreutils-python-2.5-17.1.el7.x86_64                                                          21/29 
  Verifying  : selinux-policy-targeted-3.13.1-166.el7_4.9.noarch                                                   22/29 
  Verifying  : policycoreutils-2.5-17.1.el7.x86_64                                                                 23/29 
  Verifying  : selinux-policy-3.13.1-166.el7_4.9.noarch                                                            24/29 
  Verifying  : libsemanage-python-2.5-8.el7.x86_64                                                                 25/29 
  Verifying  : libselinux-2.5-11.el7.i686                                                                          26/29 
  Verifying  : libsemanage-2.5-8.el7.x86_64                                                                        27/29 
  Verifying  : libselinux-python-2.5-11.el7.x86_64                                                                 28/29 
  Verifying  : setools-libs-3.3.8-1.1.el7.x86_64                                                                   29/29 

Installed:
  docker-ce.x86_64 0:18.06.0.ce-3.el7                                                                                    

Dependency Installed:
  container-selinux.noarch 2:2.66-1.el7                       libtool-ltdl.x86_64 0:2.4.2-22.el7_3                      

Dependency Updated:
  libselinux.i686 0:2.5-12.el7                           libselinux.x86_64 0:2.5-12.el7                                 
  libselinux-python.x86_64 0:2.5-12.el7                  libselinux-utils.x86_64 0:2.5-12.el7                           
  libsemanage.x86_64 0:2.5-11.el7                        libsemanage-python.x86_64 0:2.5-11.el7                         
  libsepol.i686 0:2.5-8.1.el7                            libsepol.x86_64 0:2.5-8.1.el7                                  
  policycoreutils.x86_64 0:2.5-22.el7                    policycoreutils-python.x86_64 0:2.5-22.el7                     
  selinux-policy.noarch 0:3.13.1-192.el7_5.4             selinux-policy-targeted.noarch 0:3.13.1-192.el7_5.4            
  setools-libs.x86_64 0:3.3.8-2.el7                     

Complete!
groupadd: group 'docker' already exists
  eated symlink from /etc/systemd/system/multi-user.target.wants/docker.service to /usr/lib/systemd/system/docker.service.
▽oaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
 * base: centos2.zswap.net
 * extras: mirror.math.princeton.edu
 * updates: linux.cc.lehigh.edu
No unfinished transactions left.
[cloud_user@ip-10-0-0-11 ~]$ docker images
Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Get http://%2Fvar%2Frun%2Fdocker.sock/v1.38/images/json: dial unix /var/run/docker.sock: connect: permission denied
[cloud_user@ip-10-0-0-11 ~]$ exit
logout
Connection to 184.72.108.229 closed.
craig:~ cn$ ssh cloud_user@184.72.108.229
cloud_user@184.72.108.229's password: 
Last login: Fri Aug  3 19:24:33 2018 from 108-74-118-125.lightspeed.tukrga.sbcglobal.net
[cloud_user@ip-10-0-0-11 ~]$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
[cloud_user@ip-10-0-0-11 ~]$ sudo vim /etc/hosts
[sudo] password for cloud_user: 

127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

10.0.0.11 manager
10.0.0.12 node1
~                                                                                                                                                         
~                                                                                                                                                         
~                                                                                                                                                         
~                                                                                                                                                         
~                                                                                                                                                         
~                                                                                                                                                         
~                                                                                                                                                         
~                                                                                                                                                         
~                                                                                                                                                         
~                                                                                                                                                         
~                                                                                                                                                         
~                                                                                                                                                         
~                                                                                                                                                         
~                                                                                                                                                         
~                                                                                                                                                         
"/etc/hosts" 5L, 193C written                                                                                                           
[cloud_user@ip-10-0-0-11 ~]$ cat /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

10.0.0.11 manager
10.0.0.12 node1
[cloud_user@ip-10-0-0-11 ~]$ docker swarm init
Swarm initialized: current node (7xqchws2qjlleyucc3r4gwwhf) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join --token SWMTKN-1-0a5tiz6kedq9m2kzyoi9v4jfuybtabrnyg6ydfkqrwtcbdnzb6-6efr860ck6cnkzhx6o4bm7j26 10.0.0.11:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.

[cloud_user@ip-10-0-0-11 ~]$ sudo systemctl disable firewalld && sudo systemctl stop firewalld
Removed symlink /etc/systemd/system/dbus-org.fedoraproject.FirewallD1.service.
Removed symlink /etc/systemd/system/basic.target.wants/firewalld.service.
[cloud_user@ip-10-0-0-11 ~]$ mkdir -p content/version1
[cloud_user@ip-10-0-0-11 ~]$ echo "Verions 1" > /content/version1/index.html
-bash: /content/version1/index.html: No such file or directory
[cloud_user@ip-10-0-0-11 ~]$ pwd
/home/cloud_user
[cloud_user@ip-10-0-0-11 ~]$ ls -al
total 20
drwx------. 5 cloud_user cloud_user  138 Aug  3 19:29 .
drwxr-xr-x. 4 root       root         38 Feb  4  2017 ..
-rw-------. 1 cloud_user cloud_user  626 Aug  3 19:26 .bash_history
-rw-r--r--. 1 cloud_user cloud_user   18 Aug  2  2016 .bash_logout
-rw-r--r--. 1 cloud_user cloud_user  193 Aug  2  2016 .bash_profile
-rw-r--r--. 1 cloud_user cloud_user  231 Aug  2  2016 .bashrc
drwxrwxr-x. 3 cloud_user cloud_user   22 Aug  3 19:29 content
drwxrw----. 3 cloud_user cloud_user   19 Aug  3 19:25 .pki
drwx------. 2 cloud_user cloud_user   29 Jan  3  2018 .ssh
-rw-------. 1 cloud_user cloud_user 1086 Jan  3  2018 .viminfo
[cloud_user@ip-10-0-0-11 ~]$ cd content/
[cloud_user@ip-10-0-0-11 content]$ ls
version1
[cloud_user@ip-10-0-0-11 content]$ mkdir version1
mkdir: cannot create directory ‘version1’: File exists
[cloud_user@ip-10-0-0-11 content]$ mkdir version3
[cloud_user@ip-10-0-0-11 content]$ mkdir version2
[cloud_user@ip-10-0-0-11 content]$ rm -rf version3
[cloud_user@ip-10-0-0-11 content]$ ls
version1  version2
[cloud_user@ip-10-0-0-11 content]$ ls -al
total 0
drwxrwxr-x. 4 cloud_user cloud_user  38 Aug  3 19:30 .
drwx------. 5 cloud_user cloud_user 138 Aug  3 19:29 ..
drwxrwxr-x. 2 cloud_user cloud_user   6 Aug  3 19:29 version1
drwxrwxr-x. 2 cloud_user cloud_user   6 Aug  3 19:30 version2
[cloud_user@ip-10-0-0-11 content]$ echo "Verions 1" > /version1/index.html
-bash: /version1/index.html: No such file or directory
[cloud_user@ip-10-0-0-11 content]$ echo "Verions 1" > version1/index.html
[cloud_user@ip-10-0-0-11 content]$ echo "Verions Two" > version2/index.html
[cloud_user@ip-10-0-0-11 content]$ cat version1/index.html 
Verions 1
[cloud_user@ip-10-0-0-11 content]$ cat version2/index.html 
Verions Two
[cloud_user@ip-10-0-0-11 content]$ docker pull httpd
Using default tag: latest
latest: Pulling from library/httpd
d660b1f15b9b: Pull complete 
aa1c79a2fa37: Pull complete 
f5f6514c0aff: Pull complete 
676d3dd26040: Pull complete 
4fdddf845a1b: Pull complete 
520c4b04fe88: Pull complete 
5387b1b7893c: Pull complete 
Digest: sha256:8c84e065bdf72b4909bd55a348d5e91fe265e08d6b28ed9104bfdcac9206dcc8
Status: Downloaded newer image for httpd:latest
[cloud_user@ip-10-0-0-11 content]$ cd version1
[cloud_user@ip-10-0-0-11 version1]$ pwd
/home/cloud_user/content/version1
[cloud_user@ip-10-0-0-11 version1]$ cd..
-bash: cd..: command not found
[cloud_user@ip-10-0-0-11 version1]$ cd ..
[cloud_user@ip-10-0-0-11 content]$ cd version2
[cloud_user@ip-10-0-0-11 version2]$ pwd
/home/cloud_user/content/version2
[cloud_user@ip-10-0-0-11 version2]$ docker service create --name test-web1 -p 8081:80 --mount type=bind,source=/home/cloud_user/content/version1,target=/
usr/local/apache2/htdocs --detach=false --replicas 3
"docker service create" requires at least 1 argument.
See 'docker service create --help'.

Usage:  docker service create [OPTIONS] IMAGE [COMMAND] [ARG...]

Create a new service
[cloud_user@ip-10-0-0-11 version2]$ docker service create --name test-web1 -p 8081:80 --mount type=bind,source=/home/cloud_user/content/version1,target=/
usr/local/apache2/htdocs --detach=false --replicas 3 httpd
y34ahn9t5325n0h2p3xq26yyz
overall progress: 3 out of 3 tasks 
1/3: running   [==================================================>] 
2/3: running   [==================================================>] 
3/3: running   [==================================================>] 
verify: Service converged 
[cloud_user@ip-10-0-0-11 version2]$ curl localhost:8081
^C
[cloud_user@ip-10-0-0-11 version2]$ docker service ps test-web1
ID                  NAME                IMAGE               NODE                        DESIRED STATE       CURRENT STATE                 ERROR                              PORTS
jfrl9232zwjt        test-web1.1         httpd:latest        ip-10-0-0-11.ec2.internal   Running             Running about a minute ago                                       
rho1zh4qklz2        test-web1.2         httpd:latest        ip-10-0-0-11.ec2.internal   Running             Running about a minute ago                                       
uuzrnxtoad7v         \_ test-web1.2     httpd:latest        ip-10-0-0-12.ec2.internal   Shutdown            Rejected about a minute ago   "error creating external conne…"   
uyarz1p4pry0        test-web1.3         httpd:latest        ip-10-0-0-11.ec2.internal   Running             Running 47 seconds ago                                           
9jxlbq0ti4am         \_ test-web1.3     httpd:latest        ip-10-0-0-12.ec2.internal   Shutdown            Rejected 57 seconds ago       "error creating external conne…"   
upc0xzucuct8         \_ test-web1.3     httpd:latest        ip-10-0-0-12.ec2.internal   Shutdown            Rejected about a minute ago   "error creating external conne…"   
17f9kjenik80         \_ test-web1.3     httpd:latest        ip-10-0-0-12.ec2.internal   Shutdown            Rejected about a minute ago   "error creating external conne…"   
r3m6k7y4pfcy         \_ test-web1.3     httpd:latest        ip-10-0-0-12.ec2.internal   Shutdown            Rejected about a minute ago   "invalid mount config for type…"   
[cloud_user@ip-10-0-0-11 version2]$ curl 10-0-0-11:8081
curl: (6) Could not resolve host: 10-0-0-11; Name or service not known
[cloud_user@ip-10-0-0-11 version2]$ curl 10-0-0-11
curl: (6) Could not resolve host: 10-0-0-11; Name or service not known
[cloud_user@ip-10-0-0-11 version2]$ docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED              STATUS              PORTS               NAMES
e14c8c7f8fd7        httpd:latest        "httpd-foreground"   About a minute ago   Up About a minute   80/tcp              test-web1.3.uyarz1p4pry0lo5wtpv6drygm
13e9ea51047c        httpd:latest        "httpd-foreground"   2 minutes ago        Up 2 minutes        80/tcp              test-web1.2.rho1zh4qklz2zf0tqpepi26da
a3cd5c91d26d        httpd:latest        "httpd-foreground"   2 minutes ago        Up 2 minutes        80/tcp              test-web1.1.jfrl9232zwjtjvqryvd8dtalq
[cloud_user@ip-10-0-0-11 version2]$ docker container e14c8c7f8fd7 info

Usage:	docker container COMMAND

Manage containers

Commands:
  attach      Attach local standard input, output, and error streams to a running container
  commit      Create a new image from a container's changes
  cp          Copy files/folders between a container and the local filesystem
  create      Create a new container
  diff        Inspect changes to files or directories on a container's filesystem
  exec        Run a command in a running container
  export      Export a container's filesystem as a tar archive
  inspect     Display detailed information on one or more containers
  kill        Kill one or more running containers
  logs        Fetch the logs of a container
  ls          List containers
  pause       Pause all processes within one or more containers
  port        List port mappings or a specific mapping for the container
  prune       Remove all stopped containers
  rename      Rename a container
  restart     Restart one or more containers
  rm          Remove one or more containers
  run         Run a command in a new container
  start       Start one or more stopped containers
  stats       Display a live stream of container(s) resource usage statistics
  stop        Stop one or more running containers
  top         Display the running processes of a container
  unpause     Unpause all processes within one or more containers
  update      Update configuration of one or more containers
  wait        Block until one or more containers stop, then print their exit codes

Run 'docker container COMMAND --help' for more information on a command.
[cloud_user@ip-10-0-0-11 version2]$ docker container inspect e14c8c7f8fd7 | grep IPAddress
            "SecondaryIPAddresses": null,
            "IPAddress": "",
                    "IPAddress": "10.255.0.12",
[cloud_user@ip-10-0-0-11 version2]$ docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS               NAMES
e14c8c7f8fd7        httpd:latest        "httpd-foreground"   3 minutes ago       Up 3 minutes        80/tcp              test-web1.3.uyarz1p4pry0lo5wtpv6drygm
13e9ea51047c        httpd:latest        "httpd-foreground"   3 minutes ago       Up 3 minutes        80/tcp              test-web1.2.rho1zh4qklz2zf0tqpepi26da
a3cd5c91d26d        httpd:latest        "httpd-foreground"   3 minutes ago       Up 3 minutes        80/tcp              test-web1.1.jfrl9232zwjtjvqryvd8dtalq
[cloud_user@ip-10-0-0-11 version2]$ curl 10.255.0.12
^C
[cloud_user@ip-10-0-0-11 version2]$ 
[cloud_user@ip-10-0-0-11 version2]$ 
[cloud_user@ip-10-0-0-11 version2]$ docker service rm test-web1
test-web1
[cloud_user@ip-10-0-0-11 version2]$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
[cloud_user@ip-10-0-0-11 version2]$ docker run -d --name test-web1 -p 8081:80 --mount type=bind,source=/home/cloud_user/content/version1,target=/usr/local/apach
e2/htdocs httpd
34e6ae4bab4642d0abbee8820f97cf5fa439b30c30594287f60f6e350f3254e1
docker: Error response from daemon: driver failed programming external connectivity on endpoint test-web1 (31552ae13eb1743b92af987cdffe21211c114fe476b0c900261a81f04e669765):  (iptables failed: iptables --wait -t nat -A DOCKER -p tcp -d 0/0 --dport 8081 -j DNAT --to-destination 172.17.0.2:80 ! -i docker0: iptables: No chain/target/match by that name.
 (exit status 1)).
[cloud_user@ip-10-0-0-11 version2]$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
[cloud_user@ip-10-0-0-11 version2]$ docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
[cloud_user@ip-10-0-0-11 version2]$ docker node ls
ID                            HOSTNAME                    STATUS              AVAILABILITY        MANAGER STATUS      ENGINE VERSION
7xqchws2qjlleyucc3r4gwwhf *   ip-10-0-0-11.ec2.internal   Ready               Active              Leader              18.06.0-ce
9lpngo9mpqmi8ek6wbd28lmeh     ip-10-0-0-12.ec2.internal   Ready               Active                                  18.06.0-ce
[cloud_user@ip-10-0-0-11 version2]$ docker run -d --name test-web1 --mount type=bind,source=/home/cloud_user/content/version1,target=/usr/local/apache2/htdocs h
ttpd
docker: Error response from daemon: Conflict. The container name "/test-web1" is already in use by container "34e6ae4bab4642d0abbee8820f97cf5fa439b30c30594287f60f6e350f3254e1". You have to remove (or rename) that container to be able to reuse that name.
See 'docker run --help'.
[cloud_user@ip-10-0-0-11 version2]$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
[cloud_user@ip-10-0-0-11 version2]$ docker ps -a
CONTAINER ID        IMAGE               COMMAND              CREATED              STATUS              PORTS               NAMES
34e6ae4bab46        httpd               "httpd-foreground"   About a minute ago   Created                                 test-web1
[cloud_user@ip-10-0-0-11 version2]$ docker rm 34e6ae4bab46
34e6ae4bab46
[cloud_user@ip-10-0-0-11 version2]$ docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
[cloud_user@ip-10-0-0-11 version2]$ docker run -d --name test-web1 --mount type=bind,source=/home/cloud_user/content/version1,target=/usr/local/apache2/htdocs h
ttpd
6c2c4174272a1de7907c9071bf531229cff7df81edb0516ad165ab4dfadb340d
[cloud_user@ip-10-0-0-11 version2]$ docker inpect docker run -d --name test-web1 --mount type=bind,source=/home/cloud_user/content/version1,target=/usr/local/ap
ache2/htdocs httpd
unknown shorthand flag: 'd' in -d
See 'docker --help'.

Usage:	docker [OPTIONS] COMMAND

A self-sufficient runtime for containers

Options:
      --config string      Location of client config files (default "/home/cloud_user/.docker")
  -D, --debug              Enable debug mode
  -H, --host list          Daemon socket(s) to connect to
  -l, --log-level string   Set the logging level ("debug"|"info"|"warn"|"error"|"fatal") (default "info")
      --tls                Use TLS; implied by --tlsverify
      --tlscacert string   Trust certs signed only by this CA (default "/home/cloud_user/.docker/ca.pem")
      --tlscert string     Path to TLS certificate file (default "/home/cloud_user/.docker/cert.pem")
      --tlskey string      Path to TLS key file (default "/home/cloud_user/.docker/key.pem")
      --tlsverify          Use TLS and verify the remote
  -v, --version            Print version information and quit

Management Commands:
  checkpoint  Manage checkpoints
  config      Manage Docker configs
  container   Manage containers
  image       Manage images
  manifest    Manage Docker image manifests and manifest lists
  network     Manage networks
  node        Manage Swarm nodes
  plugin      Manage plugins
  secret      Manage Docker secrets
  service     Manage services
  stack       Manage Docker stacks
  swarm       Manage Swarm
  system      Manage Docker
  trust       Manage trust on Docker images
  volume      Manage volumes

Commands:
  attach      Attach local standard input, output, and error streams to a running container
  build       Build an image from a Dockerfile
  commit      Create a new image from a container's changes
  cp          Copy files/folders between a container and the local filesystem
  create      Create a new container
  deploy      Deploy a new stack or update an existing stack
  diff        Inspect changes to files or directories on a container's filesystem
  events      Get real time events from the server
  exec        Run a command in a running container
  export      Export a container's filesystem as a tar archive
  history     Show the history of an image
  images      List images
  import      Import the contents from a tarball to create a filesystem image
  info        Display system-wide information
  inspect     Return low-level information on Docker objects
  kill        Kill one or more running containers
  load        Load an image from a tar archive or STDIN
  login       Log in to a Docker registry
  logout      Log out from a Docker registry
  logs        Fetch the logs of a container
  pause       Pause all processes within one or more containers
  port        List port mappings or a specific mapping for the container
  ps          List containers
  pull        Pull an image or a repository from a registry
  push        Push an image or a repository to a registry
  rename      Rename a container
  restart     Restart one or more containers
  rm          Remove one or more containers
  rmi         Remove one or more images
  run         Run a command in a new container
  save        Save one or more images to a tar archive (streamed to STDOUT by default)
  search      Search the Docker Hub for images
  start       Start one or more stopped containers
  stats       Display a live stream of container(s) resource usage statistics
  stop        Stop one or more running containers
  tag         Create a tag TARGET_IMAGE that refers to SOURCE_IMAGE
  top         Display the running processes of a container
  unpause     Unpause all processes within one or more containers
  update      Update configuration of one or more containers
  version     Show the Docker version information
  wait        Block until one or more containers stop, then print their exit codes

Run 'docker COMMAND --help' for more information on a command.

[cloud_user@ip-10-0-0-11 version2]$ 
[cloud_user@ip-10-0-0-11 version2]$ 
[cloud_user@ip-10-0-0-11 version2]$ docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS               NAMES
6c2c4174272a        httpd               "httpd-foreground"   16 seconds ago      Up 15 seconds       80/tcp              test-web1
[cloud_user@ip-10-0-0-11 version2]$ docker inspect 6c2c4174272a | grep IPAddress
            "SecondaryIPAddresses": null,
            "IPAddress": "172.17.0.2",
                    "IPAddress": "172.17.0.2",
[cloud_user@ip-10-0-0-11 version2]$ curl 172.17.0.2
Verions 1
[cloud_user@ip-10-0-0-11 version2]$ docker run -d --name test-web2 --mount type=bind,source=/home/cloud_user/content/version2,target=/usr/local/apache2/htdocs h
ttpd
dbb9e4b0dd0cf90255f68010a1ab6bfa0fd16a397b5becea3edee26917b44e84
[cloud_user@ip-10-0-0-11 version2]$ docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED              STATUS              PORTS               NAMES
dbb9e4b0dd0c        httpd               "httpd-foreground"   3 seconds ago        Up 2 seconds        80/tcp              test-web2
6c2c4174272a        httpd               "httpd-foreground"   About a minute ago   Up About a minute   80/tcp              test-web1
[cloud_user@ip-10-0-0-11 version2]$ docker inpect dbb9e4b0dd0c | grep IPAddress
[cloud_user@ip-10-0-0-11 version2]$ docker inpect dbb9e4b0dd0c | grep IPAddress
[cloud_user@ip-10-0-0-11 version2]$ docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED              STATUS              PORTS               NAMES
dbb9e4b0dd0c        httpd               "httpd-foreground"   About a minute ago   Up About a minute   80/tcp              test-web2
6c2c4174272a        httpd               "httpd-foreground"   2 minutes ago        Up 2 minutes        80/tcp              test-web1
[cloud_user@ip-10-0-0-11 version2]$ docker inspect dbb9e4b0dd0c | grep IPAddress
            "SecondaryIPAddresses": null,
            "IPAddress": "172.17.0.3",
                    "IPAddress": "172.17.0.3",
[cloud_user@ip-10-0-0-11 version2]$ curl 172.17.0.3
Verions Two
[cloud_user@ip-10-0-0-11 version2]$ docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS               NAMES
dbb9e4b0dd0c        httpd               "httpd-foreground"   9 minutes ago       Up 9 minutes        80/tcp              test-web2
6c2c4174272a        httpd               "httpd-foreground"   10 minutes ago      Up 10 minutes       80/tcp              test-web1
[cloud_user@ip-10-0-0-11 version2]$ docker stop dbb
dbb
[cloud_user@ip-10-0-0-11 version2]$ docker stop 6c2
6c2
[cloud_user@ip-10-0-0-11 version2]$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
[cloud_user@ip-10-0-0-11 version2]$ docker ps -1
unknown shorthand flag: '1' in -1
See 'docker ps --help'.
[cloud_user@ip-10-0-0-11 version2]$ docker ps -a
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS                      PORTS               NAMES
dbb9e4b0dd0c        httpd               "httpd-foreground"   10 minutes ago      Exited (0) 12 seconds ago                       test-web2
6c2c4174272a        httpd               "httpd-foreground"   11 minutes ago      Exited (0) 7 seconds ago                        test-web1
[cloud_user@ip-10-0-0-11 version2]$ docker rm $(docker ps -a -q)
dbb9e4b0dd0c
6c2c4174272a
[cloud_user@ip-10-0-0-11 version2]$ cd ..
[cloud_user@ip-10-0-0-11 content]$ cd /
[cloud_user@ip-10-0-0-11 /]$ pwd
/
[cloud_user@ip-10-0-0-11 /]$ cd home/
[cloud_user@ip-10-0-0-11 home]$ ls
centos  cloud_user
[cloud_user@ip-10-0-0-11 home]$ docker service create --name test-web1 -p 80:80 --mount type=bind,source=/home/cloud_user/content/version1,target=/usr/local/apa
che2/htdocs --detach=false --replicas 2 httpd
aluxvtecd05wwt8kpx23vog09
overall progress: 2 out of 2 tasks 
1/2: running   [==================================================>] 
2/2: running   [==================================================>] 
verify: Service converged 
[cloud_user@ip-10-0-0-11 home]$ docker node ls
ID                            HOSTNAME                    STATUS              AVAILABILITY        MANAGER STATUS      ENGINE VERSION
7xqchws2qjlleyucc3r4gwwhf *   ip-10-0-0-11.ec2.internal   Ready               Active              Leader              18.06.0-ce
9lpngo9mpqmi8ek6wbd28lmeh     ip-10-0-0-12.ec2.internal   Ready               Active                                  18.06.0-ce
[cloud_user@ip-10-0-0-11 home]$ docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS               NAMES
a001867f1b33        httpd:latest        "httpd-foreground"   15 seconds ago      Up 13 seconds       80/tcp              test-web1.1.l5nmv4jk2j0r7mzu54qrfhwqo
e6c63c783b50        httpd:latest        "httpd-foreground"   36 seconds ago      Up 34 seconds       80/tcp              test-web1.2.ropwpgz4ekmcds4ka3v4t3x21
[cloud_user@ip-10-0-0-11 home]$ docker container inspect a001867f1b33 | grep IPAddress
            "SecondaryIPAddresses": null,
            "IPAddress": "",
                    "IPAddress": "10.255.0.21",
[cloud_user@ip-10-0-0-11 home]$ curl 10.255.0.21
^C
[cloud_user@ip-10-0-0-11 home]$ docker exec it a001867f1b33 /bin/bash
Error: No such container: it
[cloud_user@ip-10-0-0-11 home]$ curl localhost
^C
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
[cloud_user@ip-10-0-0-11 home]$ docker service create --name test-web2 --mount type=bind,source=/home/cloud_user/content/version2,target=/usr/local/apache2/htdo
cs --detach=false --replicas 3 httpd
lg9wpqooj9xs5my1tbmwk6chi
overall progress: 3 out of 3 tasks 
1/3: running   [==================================================>] 
2/3: running   [==================================================>] 
3/3: running   [==================================================>] 
verify: Service converged 
[cloud_user@ip-10-0-0-11 home]$ docker service ps test-web2
ID                  NAME                IMAGE               NODE                        DESIRED STATE       CURRENT STATE            ERROR               PORTS
orhdp8vci6hj        test-web2.1         httpd:latest        ip-10-0-0-12.ec2.internal   Running             Running 19 seconds ago                       
rcj0jcy38e4x        test-web2.2         httpd:latest        ip-10-0-0-11.ec2.internal   Running             Running 19 seconds ago                       
v0rgxvzz7t18        test-web2.3         httpd:latest        ip-10-0-0-12.ec2.internal   Running             Running 19 seconds ago                       
[cloud_user@ip-10-0-0-11 home]$ curl ip-10-0-0-12.ec2.internal
curl: (7) Failed connect to ip-10-0-0-12.ec2.internal:80; Connection refused
[cloud_user@ip-10-0-0-11 home]$ curl ip-10-0-0-11.ec2.internal
Verions 1
[cloud_user@ip-10-0-0-11 home]$ curl ip-10-0-0-11.ec2.internal
Verions 1
[cloud_user@ip-10-0-0-11 home]$ 
[cloud_user@ip-10-0-0-11 home]$ 
[cloud_user@ip-10-0-0-11 home]$ docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
aluxvtecd05w        test-web1           replicated          2/2                 httpd:latest        *:80->80/tcp
lg9wpqooj9xs        test-web2           replicated          3/3                 httpd:latest        
[cloud_user@ip-10-0-0-11 home]$ docker service rm test-web2
test-web2
[cloud_user@ip-10-0-0-11 home]$ docker service create --name test-web2 -p 81:80 --mount type=bind,source=/home/cloud_user/content/version2,target=/usr/local/apa
che2/htdocs --detach=false --replicas 3 httpd
lh0eiaff6lwnj0zlkeg1njopg
overall progress: 3 out of 3 tasks 
1/3: running   [==================================================>] 
2/3: running   [==================================================>] 
3/3: running   [==================================================>] 
verify: Service converged 
[cloud_user@ip-10-0-0-11 home]$ docker service ps test-web2
ID                  NAME                IMAGE               NODE                        DESIRED STATE       CURRENT STATE             ERROR                              PORTS
smgbehaue4gf        test-web2.1         httpd:latest        ip-10-0-0-11.ec2.internal   Running             Running 13 seconds ago                                       
8igeeypf2stf         \_ test-web2.1     httpd:latest        ip-10-0-0-12.ec2.internal   Shutdown            Failed 18 seconds ago     "error creating external conne…"   
xp1unlzt2n0c         \_ test-web2.1     httpd:latest        ip-10-0-0-12.ec2.internal   Shutdown            Rejected 28 seconds ago   "error creating external conne…"   
tj251ai4pg9g         \_ test-web2.1     httpd:latest        ip-10-0-0-12.ec2.internal   Shutdown            Failed 29 seconds ago     "starting container failed: fa…"   
5sr3iiz7fuw1        test-web2.2         httpd:latest        ip-10-0-0-11.ec2.internal   Running             Running 29 seconds ago                                       
e8jkgen22v1c        test-web2.3         httpd:latest        ip-10-0-0-11.ec2.internal   Running             Running 12 seconds ago                                       
72brtm4un37c         \_ test-web2.3     httpd:latest        ip-10-0-0-12.ec2.internal   Shutdown            Rejected 23 seconds ago   "error creating external conne…"   
keeoqi4bqfo7         \_ test-web2.3     httpd:latest        ip-10-0-0-12.ec2.internal   Shutdown            Failed 23 seconds ago     "error creating external conne…"   
5l4z9kv1a00d         \_ test-web2.3     httpd:latest        ip-10-0-0-12.ec2.internal   Shutdown            Rejected 29 seconds ago   "error creating external conne…"   
[cloud_user@ip-10-0-0-11 home]$ curl ip-10-0-0-11.ec2.internal:81
Verions Two
[cloud_user@ip-10-0-0-11 home]$ curl ip-10-0-0-11.ec2.internal:81
Verions Two
[cloud_user@ip-10-0-0-11 home]$ curl ip-10-0-0-11.ec2.internal:80
Verions 1
[cloud_user@ip-10-0-0-11 home]$ 
[cloud_user@ip-10-0-0-11 home]$ 
[cloud_user@ip-10-0-0-11 home]$ 
[cloud_user@ip-10-0-0-11 home]$ docker service ps -f "desired-state=running" test-web1
ID                  NAME                IMAGE               NODE                        DESIRED STATE       CURRENT STATE           ERROR               PORTS
l5nmv4jk2j0r        test-web1.1         httpd:latest        ip-10-0-0-11.ec2.internal   Running             Running 9 minutes ago                       
ropwpgz4ekmc        test-web1.2         httpd:latest        ip-10-0-0-11.ec2.internal   Running             Running 9 minutes ago                       
[cloud_user@ip-10-0-0-11 home]$ docker service ps -f "desired-state=running" test-web2
ID                  NAME                IMAGE               NODE                        DESIRED STATE       CURRENT STATE           ERROR               PORTS
smgbehaue4gf        test-web2.1         httpd:latest        ip-10-0-0-11.ec2.internal   Running             Running 3 minutes ago                       
5sr3iiz7fuw1        test-web2.2         httpd:latest        ip-10-0-0-11.ec2.internal   Running             Running 3 minutes ago                       
e8jkgen22v1c        test-web2.3         httpd:latest        ip-10-0-0-11.ec2.internal   Running             Running 3 minutes ago                       
[cloud_user@ip-10-0-0-11 home]$ 


