# CentOS 7 Install

If anything fails check the references at the bottom of the markdown.

## tl;dr

## CentOS script

```bash
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum update -y
yum install docker-ce -y
yum-complete-transaction --cleanup-only
systemctl enable docker && systemctl start docker && systemctl status docker
usermod -aG docker $USER
```

## Docker File

Docker Built to create our on image.

## tl;dr install

```bash
sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine

sudo yum install -y yum-utils device-mapper-persistent-data  lvm2
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce -y

# Check if group docker exists
sudo cat /etc/group | grep docker

# Add docker group is the docker group is missing
sudo groupadd docker
sudo usermod -aG  docker $USER
# Log out and log back in so that your group membership is re-evaluated.
# exit
# log in

#sudo cat /etc/group | grep docker

# Logout and back in...

# Configure docker to run on boot
#sudo systemctl enable docker
#sudo systemctl start docker
#sudo systemctl status docker

sudo systemctl enable docker && sudo systemctl start docker && sudo systemctl status docker
ls -al /var/run/docker.sock
docker images

docker run hello-world
docker pull centos:latest
docker pull centos:6
docker pull ubuntu:14.04
docker pull httpd

```

## Step by Step

1. You will install the 'Docker Community Edition'. Be sure you have removed any previous versions of Docker from the normal repositories.

```bash
yum remove docker
```

1. Before enabling any repositories, be sure that you have installed the necessary required packages to support Docker but are not automatically installed as dependencies.

```bash
[user@craig ~]$ sudo yum install -y yum-utils \
>   device-mapper-persistent-data \
>   lvm2
Loaded plugins: fastestmirror
docker-ce-stable                                                                                                                            | 2.9 kB  00:00:00     
docker-ce-stable/x86_64/primary_db                                                                                                          | 9.3 kB  00:00:00     
Loading mirror speeds from cached hostfile
 * base: linux.cc.lehigh.edu
 * epel: s3-mirror-us-east-1.fedoraproject.org
 * extras: mirrors.advancedhosters.com
 * nux-dextop: mirror.li.nux.ro
 * updates: repos-va.psychz.net
Package yum-utils-1.1.31-42.el7.noarch already installed and latest version
Resolving Dependencies
--> Running transaction check
---> Package device-mapper-persistent-data.x86_64 0:0.7.0-0.1.rc6.el7 will be installed
--> Processing Dependency: libaio.so.1(LIBAIO_0.4)(64bit) for package: device-mapper-persistent-data-0.7.0-0.1.rc6.el7.x86_64

...
[more packages listed here]
...

Dependencies Resolved

===================================================================================================================================================================
 Package                                               Arch                           Version                                   Repository                    Size
===================================================================================================================================================================
Installing:
 device-mapper-persistent-data                         x86_64                         0.7.0-0.1.rc6.el7                         base                         400 k
 lvm2                                                  x86_64                         7:2.02.171-8.el7                          base                         1.3 M
Installing for dependencies:
 device-mapper-event                                   x86_64                         7:1.02.140-8.el7                          base                         180 k
 device-mapper-event-libs                              x86_64                         7:1.02.140-8.el7                          base                         179 k
 libaio                                                x86_64                         0.3.109-13.el7                            base                          24 k
 lvm2-libs                                             x86_64                         7:2.02.171-8.el7                          base                         1.0 M

Transaction Summary
===================================================================================================================================================================
Install  2 Packages (+4 Dependent packages)

Total download size: 3.1 M
Installed size: 7.7 M
Downloading packages:
(1/6): device-mapper-event-1.02.140-8.el7.x86_64.rpm                                                                                        | 180 kB  00:00:00     
(2/6): device-mapper-event-libs-1.02.140-8.el7.x86_64.rpm                                                                                   | 179 kB  00:00:00     
(3/6): lvm2-libs-2.02.171-8.el7.x86_64.rpm                                                                                                  | 1.0 MB  00:00:00     
(4/6): libaio-0.3.109-13.el7.x86_64.rpm                                                                                                     |  24 kB  00:00:00     
(5/6): device-mapper-persistent-data-0.7.0-0.1.rc6.el7.x86_64.rpm                                                                           | 400 kB  00:00:00     
(6/6): lvm2-2.02.171-8.el7.x86_64.rpm                                                                                                       | 1.3 MB  00:00:00     
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
Total                                                                                                                              5.2 MB/s | 3.1 MB  00:00:00     
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Installing : 7:device-mapper-event-libs-1.02.140-8.el7.x86_64                                                                                                1/6 
  Installing : 7:device-mapper-event-1.02.140-8.el7.x86_64                                                                                                     2/6 
  Installing : 7:lvm2-libs-2.02.171-8.el7.x86_64                                                                                                               3/6 
  Installing : libaio-0.3.109-13.el7.x86_64                                                                                                                    4/6 
  ...
  [package installation detail here]
  ...                                                                                                                   6/6

Installed:
  device-mapper-persistent-data.x86_64 0:0.7.0-0.1.rc6.el7                                       lvm2.x86_64 7:2.02.171-8.el7

Dependency Installed:
  device-mapper-event.x86_64 7:1.02.140-8.el7  device-mapper-event-libs.x86_64 7:1.02.140-8.el7  libaio.x86_64 0:0.3.109-13.el7  lvm2-libs.x86_64 7:2.02.171-8.el7 

Complete!
```

1. Using the appropriate yum utility, add the Docker CE repository at https://download.docker.com/linux/centos/docker-ce.repo; update the local yum cache once added.

```bash
[user@craig ~]$ sudo yum-config-manager \
>     --add-repo \
>     https://download.docker.com/linux/centos/docker-ce.repo

[sudo] password for user: 
Loaded plugins: fastestmirror
adding repo from: https://download.docker.com/linux/centos/docker-ce.repo
grabbing file https://download.docker.com/linux/centos/docker-ce.repo to /etc/yum.repos.d/docker-ce.repo
repo saved to /etc/yum.repos.d/docker-ce.repo
```

1. Execute the appropriate command to install the Docker CE application from the newly-configured repository.

```bash
[user@craig ~]$ sudo yum install docker-ce 
Loaded plugins: fastestmirror Loading mirror speeds from cached hostfile 
* base: linux.cc.lehigh.edu * epel: s3-mirror-us-east-1.fedoraproject.org 
* extras: mirrors.advancedhosters.com 
* nux-dextop: mirror.li.nux.ro 
* updates: repos-va.psychz.net 
Resolving Dependencies --> 
Running transaction check ---> 
Package docker-ce.x86_64 0:17.09.0.ce-1.el7.centos will be installed --> 
Processing Dependency: container-selinux >= 2.9 for package: docker-ce-17.09.0.ce-1.el7.centos.x86_64 --> 
Running transaction check ---> 
Package container-selinux.noarch 2:2.21-2.gitba103ac.el7 will be installed --> 
Finished Dependency Resolution Dependencies Resolved 
=================================================================================================================================================================== 
Package Arch Version Repository Size =================================================================================================================================================================== 
Installing: docker-ce x86_64 17.09.0.ce-1.el7.centos docker-ce-stable 21 M 
Installing for dependencies: container-selinux noarch 2:2.21-2.gitba103ac.el7 extras 29 k 
Transaction Summary =================================================================================================================================================================== 
Install 1 Package (+1 Dependent package) Total download size: 21 M Installed size: 76 M 
Is this ok [y/d/N]: y 

Downloading packages: (1/2): container-selinux-2.21-2.gitba103ac.el7.noarch.rpm | 29 kB 00:00:00 
warning: /var/cache/yum/x86_64/7/docker-ce-stable/packages/docker-ce-17.09.0.ce-1.el7.centos.x86_64.rpm: 
Header V4 RSA/SHA512 Signature, key ID 621e9f35: NOKEYETA Public key for docker-ce-17.09.0.ce-1.el7.centos.x86_64.rpm is not installed (2/2): 
docker-ce-17.09.0.ce-1.el7.centos.x86_64.rpm | 21 MB 00:00:00 
------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
Total 26 MB/s | 21 MB 00:00:00 Retrieving key from https://download.docker.com/linux/centos/gpg 
Importing GPG key 0x621E9F35: Userid : "Docker Release (CE rpm) <docker@docker.com>" 
Fingerprint: 060a 61c5 1b55 8a7f 742b 77aa c52f eb6b 621e 9f35 
From : https://download.docker.com/linux/centos/gpg 
Is this ok [y/N]: y 

Running transaction check Running transaction test 
Transaction test succeeded Running transaction 
Installing : 2:container-selinux-2.21-2.gitba103ac.el7.noarch 1/2 
Installing : docker-ce-17.09.0.ce-1.el7.centos.x86_64 2/2 
Verifying : docker-ce-17.09.0.ce-1.el7.centos.x86_64 1/2 
Verifying : 2:container-selinux-2.21-2.gitba103ac.el7.noarch 2/2 
Installed: docker-ce.x86_64 0:17.09.0.ce-1.el7.centos 
Dependency Installed: container-selinux.noarch 2:2.21-2.gitba103ac.el7 Complete! 
```

1. Once installed, verify that the 'docker' group exists on your system. If not, create one. Once verified or created, add the 'user' account to that group so that sudo rights are not necessary to run Docker commands.

```bash
[user@craig ~]$ cat /etc/group | grep docker
docker:x:988:

[user@craig ~]$ cat /etc/group | grep docker
docker:x:988:user

```

1. Using the appropriate service management commands, enable the Docker CE service so that it starts automatically on boot, and then start the Docker CE service. Verify that it is running after. NOTE: You will need to log out and then back in for the new group setting above to work.

```bash
[user@craig ~]$ sudo systemctl enable docker
Created symlink from /etc/systemd/system/multi-user.target.wants/docker.service to /usr/lib/systemd/system/docker.service.
[user@craig ~]$ sudo systemctl start docker
[user@craig ~]$ sudo systemctl status docker
● docker.service - Docker Application Container Engine
   Loaded: loaded (/usr/lib/systemd/system/docker.service; enabled; vendor preset: disabled)
   Active: active (running) since Fri 2017-10-06 15:53:03 UTC; 7s ago
     Docs: https://docs.docker.com
 Main PID: 1771 (dockerd)
   Memory: 16.1M
   CGroup: /system.slice/docker.service
           ├─1771 /usr/bin/dockerd
           └─1774 docker-containerd -l unix:///var/run/docker/libcontainerd/docker-containerd.sock --metrics-interval=0 --start-timeout 2m --state-dir /var/run/...

Oct 06 15:53:02 craig.mylabserver.com dockerd[1771]: time="2017-10-06T15:53:02.980239996Z" level=info msg="Loading containers: start."
Oct 06 15:53:02 craig.mylabserver.com dockerd[1771]: time="2017-10-06T15:53:02.997208429Z" level=warning msg="Running modprobe bridge br_netfilter faile...t found.
Oct 06 15:53:02 craig.mylabserver.com dockerd[1771]: insmod /lib/modules/3.10.0-327.28.2.el7.x86_64/kernel/net/bridge/bridge.ko
Oct 06 15:53:02 craig.mylabserver.com dockerd[1771]: , error: exit status 1"
Oct 06 15:53:03 craig.mylabserver.com dockerd[1771]: time="2017-10-06T15:53:03.793009699Z" level=info msg="Default bridge (docker0) is assigned with an ...address"
Oct 06 15:53:03 craig.mylabserver.com dockerd[1771]: time="2017-10-06T15:53:03.905408599Z" level=info msg="Loading containers: done."
Oct 06 15:53:03 craig.mylabserver.com dockerd[1771]: time="2017-10-06T15:53:03.912302898Z" level=info msg="Docker daemon" commit=afdb6d4 graphdriver(s)=....09.0-ce
Oct 06 15:53:03 craig.mylabserver.com dockerd[1771]: time="2017-10-06T15:53:03.912451551Z" level=info msg="Daemon has completed initialization"
Oct 06 15:53:03 craig.mylabserver.com dockerd[1771]: time="2017-10-06T15:53:03.936379297Z" level=info msg="API listen on /var/run/docker.sock"
Oct 06 15:53:03 craig.mylabserver.com systemd[1]: Started Docker Application Container Engine.
Hint: Some lines were ellipsized, use -l to show in full.

```

1. To test that the service is listening AND Step #4 was correctly completed, pull the default repository image called 'httpd' to your server.

```bash
docker pull httpd

Using default tag: latest
latest: Pulling from library/httpd
aa18ad1a0d33: Pull complete
2b28e4afdec2: Pull complete
802b6cd5ed3b: Pull complete
6f2336b7c318: Pull complete
d7c441746c9e: Pull complete
a36c7f15867a: Pull complete
a0d42b9fc107: Pull complete
Digest: sha256:cf774f082e92e582d02acdb76dc84e61dcf5394a90f99119d1ae39bcecbff075
Status: Downloaded newer image for httpd:latest
```

1. Run the appropriate Docker CE command that will display a list of all images that are locally installed.

```bash

[user@craig ~]$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
httpd               latest              cf6b6d2e8463        42 hours ago        182MB

```

## References

https://docs.docker.com/install/linux/docker-ce/centos/
https://docs.docker.com/install/linux/linux-postinstall/#manage-docker-as-a-non-root-user