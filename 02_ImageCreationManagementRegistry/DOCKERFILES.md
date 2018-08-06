# Docker Files Examples

## Dockerfile

```docker
FROM debian:stable
MAINTAINER latest123 <lastest123@domain.com>

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

```

## Sample Docker File

```docker
FROM centos:latest
LABLE maintainer"myemail@email.com"
RUN yum update -y
```

Sample Build of a Dockerfile to create an image

```bash

$ docker build -t custom_image:v1 .

# output
Sending build context to Docker daemon  2.048kB
Error response from daemon: Dockerfile parse error line 2: unknown instruction: LABLE
craig:quickstart01 cn$ code Dockerfile 
craig:quickstart01 cn$ docker build -t custom_image:v1 .
Sending build context to Docker daemon  2.048kB
Step 1/3 : FROM centos:latest
latest: Pulling from library/centos
7dc0dca2b151: Pull complete 
Digest: sha256:b67d21dfe609ddacf404589e04631d90a342921e81c40aeaf3391f6717fa5322
Status: Downloaded newer image for centos:latest
 ---> 49f7960eb7e4
Step 2/3 : LABEL maintainer="myemail@email.com"
 ---> Running in 3848c1db236c
Removing intermediate container 3848c1db236c
 ---> 658fa350184b
Step 3/3 : RUN yum update -y
 ---> Running in c8962c7e0acb
Loaded plugins: fastestmirror, ovl
Determining fastest mirrors
 * base: repos.dfw.quadranet.com
 * extras: mirror.atlantic.net
 * updates: mirror.cc.columbia.edu
Resolving Dependencies
--> Running transaction check
---> Package binutils.x86_64 0:2.27-27.base.el7 will be updated
---> Package binutils.x86_64 0:2.27-28.base.el7_5.1 will be an update
---> Package gnupg2.x86_64 0:2.0.22-4.el7 will be updated
---> Package gnupg2.x86_64 0:2.0.22-5.el7_5 will be an update
---> Package python.x86_64 0:2.7.5-68.el7 will be updated
---> Package python.x86_64 0:2.7.5-69.el7_5 will be an update
---> Package python-libs.x86_64 0:2.7.5-68.el7 will be updated
---> Package python-libs.x86_64 0:2.7.5-69.el7_5 will be an update
--> Finished Dependency Resolution

Dependencies Resolved

================================================================================
 Package           Arch         Version                     Repository     Size
================================================================================
Updating:
 binutils          x86_64       2.27-28.base.el7_5.1        updates       5.9 M
 gnupg2            x86_64       2.0.22-5.el7_5              updates       1.5 M
 python            x86_64       2.7.5-69.el7_5              updates        93 k
 python-libs       x86_64       2.7.5-69.el7_5              updates       5.6 M

Transaction Summary
================================================================================
Upgrade  4 Packages

Total download size: 13 M
Downloading packages:
Delta RPMs disabled because /usr/bin/applydeltarpm not installed.
warning: /var/cache/yum/x86_64/7/updates/packages/gnupg2-2.0.22-5.el7_5.x86_64.rpm: Header V3 RSA/SHA256 Signature, key ID f4a80eb5: NOKEY
Public key for gnupg2-2.0.22-5.el7_5.x86_64.rpm is not installed
--------------------------------------------------------------------------------
Total                                              8.0 MB/s |  13 MB  00:01     
Retrieving key from file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
Importing GPG key 0xF4A80EB5:
 Userid     : "CentOS-7 Key (CentOS 7 Official Signing Key) <security@centos.org>"
 Fingerprint: 6341 ab27 53d7 8a78 a7c2 7bb1 24c6 a8a7 f4a8 0eb5
 Package    : centos-release-7-5.1804.el7.centos.2.x86_64 (@Updates)
 From       : /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Updating   : python-libs-2.7.5-69.el7_5.x86_64                            1/8 
  Updating   : python-2.7.5-69.el7_5.x86_64                                 2/8 
  Updating   : binutils-2.27-28.base.el7_5.1.x86_64                         3/8 
install-info: No such file or directory for /usr/share/info/as.info.gz
install-info: No such file or directory for /usr/share/info/binutils.info.gz
install-info: No such file or directory for /usr/share/info/gprof.info.gz
install-info: No such file or directory for /usr/share/info/ld.info.gz
install-info: No such file or directory for /usr/share/info/standards.info.gz
  Updating   : gnupg2-2.0.22-5.el7_5.x86_64                                 4/8 
install-info: No such file or directory for /usr/share/info/gnupg.info
  Cleanup    : python-2.7.5-68.el7.x86_64                                   5/8 
  Cleanup    : python-libs-2.7.5-68.el7.x86_64                              6/8 
  Cleanup    : binutils-2.27-27.base.el7.x86_64                             7/8 
  Cleanup    : gnupg2-2.0.22-4.el7.x86_64                                   8/8 
  Verifying  : gnupg2-2.0.22-5.el7_5.x86_64                                 1/8 
  Verifying  : python-libs-2.7.5-69.el7_5.x86_64                            2/8 
  Verifying  : python-2.7.5-69.el7_5.x86_64                                 3/8 
  Verifying  : binutils-2.27-28.base.el7_5.1.x86_64                         4/8 
  Verifying  : python-libs-2.7.5-68.el7.x86_64                              5/8 
  Verifying  : binutils-2.27-27.base.el7.x86_64                             6/8 
  Verifying  : python-2.7.5-68.el7.x86_64                                   7/8 
  Verifying  : gnupg2-2.0.22-4.el7.x86_64                                   8/8 

Updated:
  binutils.x86_64 0:2.27-28.base.el7_5.1   gnupg2.x86_64 0:2.0.22-5.el7_5       
  python.x86_64 0:2.7.5-69.el7_5           python-libs.x86_64 0:2.7.5-69.el7_5  

Complete!
Removing intermediate container c8962c7e0acb
 ---> b6b9b6d8e575
Successfully built b6b9b6d8e575
Successfully tagged custom_image:v1
```

Check for the image

```bash
docker images
REPOSITORY                                 TAG                 IMAGE ID            CREATED             SIZE
custom_image                               v1                  b6b9b6d8e575        2 minutes ago       328MB
```

If we re-run this again it will use the cached containers to build the image

If we edit the docker file, and re-build it that one step or the part you changed 
it will re-build instead of all of the other layers.  You are not rebuilding 
the entire image.

## dockerfiles-quickstart02

Example building from a specific file using the file flag (-f)

```bash

$ cp Dockerfile Dockerfile2
$ docker build -t custom_ubuntu:v1 -f Dockerfile2 .

Sending build context to Docker daemon  3.072kB
Step 1/3 : FROM ubuntu:latest
latest: Pulling from library/ubuntu
c64513b74145: Pull complete 
01b8b12bad90: Pull complete 
c5d85cf7a05f: Pull complete 
b6b268720157: Pull complete 
e12192999ff1: Pull complete 
Digest: sha256:3f119dc0737f57f704ebecac8a6d8477b0f6ca1ca0332c7ee1395ed2c6a82be7
Status: Downloaded newer image for ubuntu:latest
 ---> 735f80812f90
Step 2/3 : LABEL maintainer="myemail@email.com"
 ---> Running in 95b9775619e4
Removing intermediate container 95b9775619e4
 ---> 479e3b9bd94d
Step 3/3 : RUN apt-get update -y
 ---> Running in b193108d5e0d
Get:1 http://security.ubuntu.com/ubuntu bionic-security InRelease [83.2 kB]
Get:2 http://archive.ubuntu.com/ubuntu bionic InRelease [242 kB]
Get:3 http://archive.ubuntu.com/ubuntu bionic-updates InRelease [88.7 kB]
Get:4 http://security.ubuntu.com/ubuntu bionic-security/universe Sources [10.3 kB]
Get:5 http://archive.ubuntu.com/ubuntu bionic-backports InRelease [74.6 kB]
Get:6 http://security.ubuntu.com/ubuntu bionic-security/main amd64 Packages [157 kB]
Get:7 http://archive.ubuntu.com/ubuntu bionic/universe Sources [11.5 MB]
Get:8 http://security.ubuntu.com/ubuntu bionic-security/multiverse amd64 Packages [1364 B]
Get:9 http://security.ubuntu.com/ubuntu bionic-security/universe amd64 Packages [46.3 kB]
Get:10 http://archive.ubuntu.com/ubuntu bionic/universe amd64 Packages [11.3 MB]
Get:11 http://archive.ubuntu.com/ubuntu bionic/main amd64 Packages [1344 kB]
Get:12 http://archive.ubuntu.com/ubuntu bionic/restricted amd64 Packages [13.5 kB]
Get:13 http://archive.ubuntu.com/ubuntu bionic/multiverse amd64 Packages [186 kB]
Get:14 http://archive.ubuntu.com/ubuntu bionic-updates/universe Sources [58.5 kB]
Get:15 http://archive.ubuntu.com/ubuntu bionic-updates/multiverse amd64 Packages [3926 B]
Get:16 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 Packages [343 kB]
Get:17 http://archive.ubuntu.com/ubuntu bionic-updates/universe amd64 Packages [190 kB]
Get:18 http://archive.ubuntu.com/ubuntu bionic-backports/universe amd64 Packages [2807 B]
Fetched 25.7 MB in 6s (4477 kB/s)
Reading package lists...
Removing intermediate container b193108d5e0d
 ---> bda01d26ebc3
Successfully built bda01d26ebc3
Successfully tagged custom_ubuntu:v1

$ docker images

REPOSITORY                                 TAG                 IMAGE ID            CREATED             SIZE
custom_ubuntu                               v1                  bda01d26ebc3        37 seconds ago      125MB

```

## Dockerfile build from github

## Dockerfile build from tar ball

## Sqaush

```bash
$ docker build --pull --no-cache  -t optimized:v1 .

Sending build context to Docker daemon  3.072kB
Step 1/3 : FROM centos:latest
latest: Pulling from library/centos
Digest: sha256:b67d21dfe609ddacf404589e04631d90a342921e81c40aeaf3391f6717fa5322
Status: Image is up to date for centos:latest
 ---> 49f7960eb7e4
Step 2/3 : LABEL maintainer="myemail@email.com"
 ---> Running in 8f521d576c2f
Removing intermediate container 8f521d576c2f
 ---> 4331777c623a
Step 3/3 : RUN yum update -y
 ---> Running in 0340ec756ea2
Loaded plugins: fastestmirror, ovl
Determining fastest mirrors
 * base: mirror.hackingand.coffee
 * extras: mirror.teklinks.com
 * updates: reflector.westga.edu
Resolving Dependencies
--> Running transaction check
---> Package binutils.x86_64 0:2.27-27.base.el7 will be updated
---> Package binutils.x86_64 0:2.27-28.base.el7_5.1 will be an update
---> Package gnupg2.x86_64 0:2.0.22-4.el7 will be updated
---> Package gnupg2.x86_64 0:2.0.22-5.el7_5 will be an update
---> Package python.x86_64 0:2.7.5-68.el7 will be updated
---> Package python.x86_64 0:2.7.5-69.el7_5 will be an update
---> Package python-libs.x86_64 0:2.7.5-68.el7 will be updated
---> Package python-libs.x86_64 0:2.7.5-69.el7_5 will be an update
--> Finished Dependency Resolution

Dependencies Resolved

================================================================================
 Package           Arch         Version                     Repository     Size
================================================================================
Updating:
 binutils          x86_64       2.27-28.base.el7_5.1        updates       5.9 M
 gnupg2            x86_64       2.0.22-5.el7_5              updates       1.5 M
 python            x86_64       2.7.5-69.el7_5              updates        93 k
 python-libs       x86_64       2.7.5-69.el7_5              updates       5.6 M

Transaction Summary
================================================================================
Upgrade  4 Packages

Total download size: 13 M
Downloading packages:
Delta RPMs disabled because /usr/bin/applydeltarpm not installed.
warning: /var/cache/yum/x86_64/7/updates/packages/gnupg2-2.0.22-5.el7_5.x86_64.rpm: Header V3 RSA/SHA256 Signature, key ID f4a80eb5: NOKEY
Public key for gnupg2-2.0.22-5.el7_5.x86_64.rpm is not installed
--------------------------------------------------------------------------------
Total                                               13 MB/s |  13 MB  00:01     
Retrieving key from file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
Importing GPG key 0xF4A80EB5:
 Userid     : "CentOS-7 Key (CentOS 7 Official Signing Key) <security@centos.org>"
 Fingerprint: 6341 ab27 53d7 8a78 a7c2 7bb1 24c6 a8a7 f4a8 0eb5
 Package    : centos-release-7-5.1804.el7.centos.2.x86_64 (@Updates)
 From       : /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Updating   : python-libs-2.7.5-69.el7_5.x86_64                            1/8 
  Updating   : python-2.7.5-69.el7_5.x86_64                                 2/8 
  Updating   : binutils-2.27-28.base.el7_5.1.x86_64                         3/8 
install-info: No such file or directory for /usr/share/info/as.info.gz
install-info: No such file or directory for /usr/share/info/binutils.info.gz
install-info: No such file or directory for /usr/share/info/gprof.info.gz
install-info: No such file or directory for /usr/share/info/ld.info.gz
install-info: No such file or directory for /usr/share/info/standards.info.gz
  Updating   : gnupg2-2.0.22-5.el7_5.x86_64                                 4/8 
install-info: No such file or directory for /usr/share/info/gnupg.info
  Cleanup    : python-2.7.5-68.el7.x86_64                                   5/8 
  Cleanup    : python-libs-2.7.5-68.el7.x86_64                              6/8 
  Cleanup    : binutils-2.27-27.base.el7.x86_64                             7/8 
  Cleanup    : gnupg2-2.0.22-4.el7.x86_64                                   8/8 
  Verifying  : gnupg2-2.0.22-5.el7_5.x86_64                                 1/8 
  Verifying  : python-libs-2.7.5-69.el7_5.x86_64                            2/8 
  Verifying  : python-2.7.5-69.el7_5.x86_64                                 3/8 
  Verifying  : binutils-2.27-28.base.el7_5.1.x86_64                         4/8 
  Verifying  : python-libs-2.7.5-68.el7.x86_64                              5/8 
  Verifying  : binutils-2.27-27.base.el7.x86_64                             6/8 
  Verifying  : python-2.7.5-68.el7.x86_64                                   7/8 
  Verifying  : gnupg2-2.0.22-4.el7.x86_64                                   8/8 

Updated:
  binutils.x86_64 0:2.27-28.base.el7_5.1   gnupg2.x86_64 0:2.0.22-5.el7_5       
  python.x86_64 0:2.7.5-69.el7_5           python-libs.x86_64 0:2.7.5-69.el7_5  

Complete!
Removing intermediate container 0340ec756ea2
 ---> 15a9c7bf8cd0
Successfully built 15a9c7bf8cd0
Successfully tagged optimized:v1
craig:quickstart01 cn$ docker build --pull --no-cache --squash  -t optimized:v1 .
Sending build context to Docker daemon  3.072kB
Step 1/3 : FROM centos:latest
latest: Pulling from library/centos
Digest: sha256:b67d21dfe609ddacf404589e04631d90a342921e81c40aeaf3391f6717fa5322
Status: Image is up to date for centos:latest
 ---> 49f7960eb7e4
Step 2/3 : LABEL maintainer="myemail@email.com"
 ---> Running in 97db17761f6c
Removing intermediate container 97db17761f6c
 ---> 1f489e348631
Step 3/3 : RUN yum update -y
 ---> Running in e9e6fda2f00a
Loaded plugins: fastestmirror, ovl
Determining fastest mirrors
 * base: mirror.hackingand.coffee
 * extras: mirror.teklinks.com
 * updates: reflector.westga.edu
Resolving Dependencies
--> Running transaction check
---> Package binutils.x86_64 0:2.27-27.base.el7 will be updated
---> Package binutils.x86_64 0:2.27-28.base.el7_5.1 will be an update
---> Package gnupg2.x86_64 0:2.0.22-4.el7 will be updated
---> Package gnupg2.x86_64 0:2.0.22-5.el7_5 will be an update
---> Package python.x86_64 0:2.7.5-68.el7 will be updated
---> Package python.x86_64 0:2.7.5-69.el7_5 will be an update
---> Package python-libs.x86_64 0:2.7.5-68.el7 will be updated
---> Package python-libs.x86_64 0:2.7.5-69.el7_5 will be an update
--> Finished Dependency Resolution

Dependencies Resolved

================================================================================
 Package           Arch         Version                     Repository     Size
================================================================================
Updating:
 binutils          x86_64       2.27-28.base.el7_5.1        updates       5.9 M
 gnupg2            x86_64       2.0.22-5.el7_5              updates       1.5 M
 python            x86_64       2.7.5-69.el7_5              updates        93 k
 python-libs       x86_64       2.7.5-69.el7_5              updates       5.6 M

Transaction Summary
================================================================================
Upgrade  4 Packages

Total download size: 13 M
Downloading packages:
Delta RPMs disabled because /usr/bin/applydeltarpm not installed.
warning: /var/cache/yum/x86_64/7/updates/packages/python-2.7.5-69.el7_5.x86_64.rpm: Header V3 RSA/SHA256 Signature, key ID f4a80eb5: NOKEY
Public key for python-2.7.5-69.el7_5.x86_64.rpm is not installed
--------------------------------------------------------------------------------
Total                                              6.7 MB/s |  13 MB  00:01     
Retrieving key from file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
Importing GPG key 0xF4A80EB5:
 Userid     : "CentOS-7 Key (CentOS 7 Official Signing Key) <security@centos.org>"
 Fingerprint: 6341 ab27 53d7 8a78 a7c2 7bb1 24c6 a8a7 f4a8 0eb5
 Package    : centos-release-7-5.1804.el7.centos.2.x86_64 (@Updates)
 From       : /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Updating   : python-libs-2.7.5-69.el7_5.x86_64                            1/8 
  Updating   : python-2.7.5-69.el7_5.x86_64                                 2/8 
  Updating   : binutils-2.27-28.base.el7_5.1.x86_64                         3/8 
install-info: No such file or directory for /usr/share/info/as.info.gz
install-info: No such file or directory for /usr/share/info/binutils.info.gz
install-info: No such file or directory for /usr/share/info/gprof.info.gz
install-info: No such file or directory for /usr/share/info/ld.info.gz
install-info: No such file or directory for /usr/share/info/standards.info.gz
  Updating   : gnupg2-2.0.22-5.el7_5.x86_64                                 4/8 
install-info: No such file or directory for /usr/share/info/gnupg.info
  Cleanup    : python-2.7.5-68.el7.x86_64                                   5/8 
  Cleanup    : python-libs-2.7.5-68.el7.x86_64                              6/8 
  Cleanup    : binutils-2.27-27.base.el7.x86_64                             7/8 
  Cleanup    : gnupg2-2.0.22-4.el7.x86_64                                   8/8 
  Verifying  : gnupg2-2.0.22-5.el7_5.x86_64                                 1/8 
  Verifying  : python-libs-2.7.5-69.el7_5.x86_64                            2/8 
  Verifying  : python-2.7.5-69.el7_5.x86_64                                 3/8 
  Verifying  : binutils-2.27-28.base.el7_5.1.x86_64                         4/8 
  Verifying  : python-libs-2.7.5-68.el7.x86_64                              5/8 
  Verifying  : binutils-2.27-27.base.el7.x86_64                             6/8 
  Verifying  : python-2.7.5-68.el7.x86_64                                   7/8 
  Verifying  : gnupg2-2.0.22-4.el7.x86_64                                   8/8 

Updated:
  binutils.x86_64 0:2.27-28.base.el7_5.1   gnupg2.x86_64 0:2.0.22-5.el7_5
  python.x86_64 0:2.7.5-69.el7_5           python-libs.x86_64 0:2.7.5-69.el7_5  

Complete!
Removing intermediate container e9e6fda2f00a
 ---> f18cf81567d2
Successfully built 8fca7323a784
Successfully tagged optimized:v1
```