# Creating a New Image from a Container

Using the CentOS 6 base image download, start a container based on that image. 

Be sure that container starts connected to the current terminal in interactive mode and runs the bash command so you are logged in to the command prompt on the container once it boots.

Once you are sitting at a command prompt on the running container, execute the update command (installing all updates for the container OS).

Now that updates are complete, install the Apache Web Server. 

Once installed, make sure the web server service will start and verify that the container is listening on port 80 (install other software if needed to do so).

Exit the container. Once the container is stopped, execute the appropriate command to list all stopped containers and locate the name and ID of the container you just exited. Make a note of the name and ID.

Using the name or ID of the container, commit the changes you made within it to a new base image called "newcentos:withapache" and verify that it shows when you list the images on your system.

1. Using the CentOS 6 base image download, start a container based on that image. Be sure that container starts connected to the current terminal in interactive mode and runs the bash command so you are logged in to the command prompt on the container once it boots.

```bash
docker run -it centos:6 /bin/bash
```

1. Once you are sitting at a command prompt on the running container, execute the update command (installing all updates for the container OS).

```bash
yum -y update
```

1. Now that updates are complete, install the Apache Web Server. Once installed, make sure the web server service will start and verify that the container is listening on port 80 (install other software if needed to do so).

```bash
yum install httpd -y

yum install telnet -y

service httpd start
chkconfig --add httpd
chkconfig httpd on
chkconfig --list httpd
--DID NOT WORK

telnet localhost 80

```

1. Exit the container. Once the container is stopped, execute the appropriate command to list all stopped containers and locate the name and ID of the container you just exited. Make a note of the name and ID.

```bash
 exit

docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS               NAMES
cc48f68d25db        httpd               "httpd-foreground"   About an hour ago   Up About an hour    80/tcp              testweb

[user@craig-nicholsoneswlb4 ~]$ docker stop testweb
testweb
[user@craig-nicholsoneswlb4 ~]$ docker ps -a
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS                        PORTS               NAMES
1821b5f6061b        centos:6            "/bin/bash"          6 minutes ago       Exited (127) 40 seconds ago                       gallant_n
ightingale
cc48f68d25db        httpd               "httpd-foreground"   About an hour ago   Exited (0) 4 seconds ago                          testweb
[user@craig-nicholsoneswlb4 ~]$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
[user@craig-nicholsoneswlb4 ~]$ 

```

1. Using the name or ID of the container, commit the changes you made within it to a new base image called "newcentos:withapache" and verify that it shows when you list the images on your system.

```bash
[user@craig-nicholsoneswlb4 ~]$ docker commit cc48f68d25db newcentos:withapache
sha256:508c3692a56c3606acde06fa2c02b7d017dc20dafa21ae27097654cb6a47c30c
[user@craig-nicholsoneswlb4 ~]$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
newcentos           withapache          508c3692a56c        6 seconds ago       178MB
httpd               latest              11426a19f1a2        27 hours ago        178MB
centos              6                   70b5d81549ec        3 months ago        195MB
```

1. Restart this main image and test

```bash
docker run -it newcentos:withapache /bin/bash
#https://stackoverflow.com/questions/21280174/docker-centos-image-does-not-auto-start-httpd

```

```bash
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
ubuntu              latest              735f80812f90        5 days ago          83.5MB
centos              6                   70b5d81549ec        3 months ago        195MB

$ docker run -it centos:6 /bin/bash

[root@844866456de3 /]$ yum -y update

Loaded plugins: fastestmirror, ovl
Setting up Update Process
base                                                                                                                                                      | 3.7 kB     00:00     
base/primary_db                                                                                                                                           | 4.7 MB     00:00     
extras                                                                                                                                                    | 3.4 kB     00:00     
extras/primary_db                                                                                                                                         |  25 kB     00:00     
updates                                                                                                                                                   | 3.4 kB     00:00     
updates/primary_db                                                                                                                                        | 667 kB     00:00     
Resolving Dependencies
--> Running transaction check
---> Package bind-libs.x86_64 32:9.8.2-0.62.rc1.el6_9.5 will be updated
---> Package bind-libs.x86_64 32:9.8.2-0.68.rc1.el6 will be an update
---> Package bind-utils.x86_64 32:9.8.2-0.62.rc1.el6_9.5 will be updated
---> Package bind-utils.x86_64 32:9.8.2-0.68.rc1.el6 will be an update
---> Package binutils.x86_64 0:2.20.51.0.2-5.47.el6_9.1 will be updated
---> Package binutils.x86_64 0:2.20.51.0.2-5.48.el6 will be an update
---> Package ca-certificates.noarch 0:2017.2.14-65.0.1.el6_9 will be updated
---> Package ca-certificates.noarch 0:2018.2.22-65.1.el6 will be an update
---> Package centos-release.x86_64 0:6-9.el6.12.3 will be updated
---> Package centos-release.x86_64 0:6-10.el6.centos.12.3 will be an update
---> Package coreutils.x86_64 0:8.4-46.el6 will be updated
---> Package coreutils.x86_64 0:8.4-47.el6 will be an update
---> Package coreutils-libs.x86_64 0:8.4-46.el6 will be updated
---> Package coreutils-libs.x86_64 0:8.4-47.el6 will be an update
---> Package dbus-libs.x86_64 1:1.2.24-8.el6_6 will be updated
---> Package dbus-libs.x86_64 1:1.2.24-9.el6 will be an update
---> Package glib2.x86_64 0:2.28.8-9.el6 will be updated
---> Package glib2.x86_64 0:2.28.8-10.el6 will be an update
---> Package glibc.x86_64 0:2.12-1.209.el6_9.2 will be updated
---> Package glibc.x86_64 0:2.12-1.212.el6 will be an update
---> Package glibc-common.x86_64 0:2.12-1.209.el6_9.2 will be updated
---> Package glibc-common.x86_64 0:2.12-1.212.el6 will be an update
---> Package gmp.x86_64 0:4.3.1-12.el6 will be updated
---> Package gmp.x86_64 0:4.3.1-13.el6 will be an update
---> Package gnupg2.x86_64 0:2.0.14-8.el6 will be updated
---> Package gnupg2.x86_64 0:2.0.14-9.el6_10 will be an update
---> Package libcom_err.x86_64 0:1.41.12-23.el6 will be updated
---> Package libcom_err.x86_64 0:1.41.12-24.el6 will be an update
---> Package libgcc.x86_64 0:4.4.7-18.el6_9.2 will be updated
---> Package libgcc.x86_64 0:4.4.7-23.el6 will be an update
---> Package libnih.x86_64 0:1.0.1-7.el6 will be updated
---> Package libnih.x86_64 0:1.0.1-8.el6 will be an update
---> Package libstdc++.x86_64 0:4.4.7-18.el6_9.2 will be updated
---> Package libstdc++.x86_64 0:4.4.7-23.el6 will be an update
---> Package nspr.x86_64 0:4.13.1-1.el6 will be updated
---> Package nspr.x86_64 0:4.19.0-1.el6 will be an update
---> Package nss.x86_64 0:3.28.4-4.el6_9 will be updated
---> Package nss.x86_64 0:3.36.0-8.el6 will be an update
---> Package nss-sysinit.x86_64 0:3.28.4-4.el6_9 will be updated
---> Package nss-sysinit.x86_64 0:3.36.0-8.el6 will be an update
---> Package nss-tools.x86_64 0:3.28.4-4.el6_9 will be updated
---> Package nss-tools.x86_64 0:3.36.0-8.el6 will be an update
---> Package nss-util.x86_64 0:3.28.4-1.el6_9 will be updated
---> Package nss-util.x86_64 0:3.36.0-1.el6 will be an update
---> Package procps.x86_64 0:3.2.8-45.el6_9.1 will be updated
---> Package procps.x86_64 0:3.2.8-45.el6_9.3 will be an update
---> Package rpm.x86_64 0:4.8.0-55.el6 will be updated
---> Package rpm.x86_64 0:4.8.0-59.el6 will be an update
---> Package rpm-libs.x86_64 0:4.8.0-55.el6 will be updated
---> Package rpm-libs.x86_64 0:4.8.0-59.el6 will be an update
---> Package rpm-python.x86_64 0:4.8.0-55.el6 will be updated
---> Package rpm-python.x86_64 0:4.8.0-59.el6 will be an update
---> Package tzdata.noarch 0:2018d-1.el6 will be updated
---> Package tzdata.noarch 0:2018e-3.el6 will be an update
---> Package yum-plugin-fastestmirror.noarch 0:1.1.30-40.el6 will be updated
---> Package yum-plugin-fastestmirror.noarch 0:1.1.30-41.el6 will be an update
---> Package yum-plugin-ovl.noarch 0:1.1.30-40.el6 will be updated
---> Package yum-plugin-ovl.noarch 0:1.1.30-41.el6 will be an update
--> Finished Dependency Resolution

Dependencies Resolved

=================================================================================================================================================================================
 Package                                             Arch                              Version                                          Repository                          Size
=================================================================================================================================================================================
Updating:
 bind-libs                                           x86_64                            32:9.8.2-0.68.rc1.el6                            base                               892 k
 bind-utils                                          x86_64                            32:9.8.2-0.68.rc1.el6                            base                               189 k
 binutils                                            x86_64                            2.20.51.0.2-5.48.el6                             base                               2.8 M
 ca-certificates                                     noarch                            2018.2.22-65.1.el6                               base                               930 k
 centos-release                                      x86_64                            6-10.el6.centos.12.3                             base                                22 k
 coreutils                                           x86_64                            8.4-47.el6                                       base                               3.0 M
 coreutils-libs                                      x86_64                            8.4-47.el6                                       base                                52 k
 dbus-libs                                           x86_64                            1:1.2.24-9.el6                                   base                               127 k
 glib2                                               x86_64                            2.28.8-10.el6                                    base                               1.7 M
 glibc                                               x86_64                            2.12-1.212.el6                                   base                               3.8 M
 glibc-common                                        x86_64                            2.12-1.212.el6                                   base                                14 M
 gmp                                                 x86_64                            4.3.1-13.el6                                     base                               207 k
 gnupg2                                              x86_64                            2.0.14-9.el6_10                                  updates                            1.6 M
 libcom_err                                          x86_64                            1.41.12-24.el6                                   base                                38 k
 libgcc                                              x86_64                            4.4.7-23.el6                                     base                               104 k
 libnih                                              x86_64                            1.0.1-8.el6                                      base                               138 k
 libstdc++                                           x86_64                            4.4.7-23.el6                                     base                               296 k
 nspr                                                x86_64                            4.19.0-1.el6                                     base                               114 k
 nss                                                 x86_64                            3.36.0-8.el6                                     base                               865 k
 nss-sysinit                                         x86_64                            3.36.0-8.el6                                     base                                52 k
 nss-tools                                           x86_64                            3.36.0-8.el6                                     base                               460 k
 nss-util                                            x86_64                            3.36.0-1.el6                                     base                                72 k
 procps                                              x86_64                            3.2.8-45.el6_9.3                                 updates                            220 k
 rpm                                                 x86_64                            4.8.0-59.el6                                     base                               906 k
 rpm-libs                                            x86_64                            4.8.0-59.el6                                     base                               318 k
 rpm-python                                          x86_64                            4.8.0-59.el6                                     base                                61 k
 tzdata                                              noarch                            2018e-3.el6                                      base                               495 k
 yum-plugin-fastestmirror                            noarch                            1.1.30-41.el6                                    base                                33 k
 yum-plugin-ovl                                      noarch                            1.1.30-41.el6                                    base                                26 k

Transaction Summary
=================================================================================================================================================================================
Upgrade      29 Package(s)

Total download size: 34 M
Downloading Packages:
(1/29): bind-libs-9.8.2-0.68.rc1.el6.x86_64.rpm                                                                                                           | 892 kB     00:00     
(2/29): bind-utils-9.8.2-0.68.rc1.el6.x86_64.rpm                                                                                                          | 189 kB     00:00     
(3/29): binutils-2.20.51.0.2-5.48.el6.x86_64.rpm                                                                                                          | 2.8 MB     00:00     
(4/29): ca-certificates-2018.2.22-65.1.el6.noarch.rpm                                                                                                     | 930 kB     00:00     
(5/29): centos-release-6-10.el6.centos.12.3.x86_64.rpm                                                                                                    |  22 kB     00:00     
(6/29): coreutils-8.4-47.el6.x86_64.rpm                                                                                                                   | 3.0 MB     00:00     
(7/29): coreutils-libs-8.4-47.el6.x86_64.rpm                                                                                                              |  52 kB     00:00     
(8/29): dbus-libs-1.2.24-9.el6.x86_64.rpm                                                                                                                 | 127 kB     00:00     
(9/29): glib2-2.28.8-10.el6.x86_64.rpm                                                                                                                    | 1.7 MB     00:00     
(10/29): glibc-2.12-1.212.el6.x86_64.rpm                                                                                                                  | 3.8 MB     00:00     
(11/29): glibc-common-2.12-1.212.el6.x86_64.rpm                                                                                                           |  14 MB     00:00     
(12/29): gmp-4.3.1-13.el6.x86_64.rpm                                                                                                                      | 207 kB     00:00     
(13/29): gnupg2-2.0.14-9.el6_10.x86_64.rpm                                                                                                                | 1.6 MB     00:00     
(14/29): libcom_err-1.41.12-24.el6.x86_64.rpm                                                                                                             |  38 kB     00:00     
(15/29): libgcc-4.4.7-23.el6.x86_64.rpm                                                                                                                   | 104 kB     00:00     
(16/29): libnih-1.0.1-8.el6.x86_64.rpm                                                                                                                    | 138 kB     00:00     
(17/29): libstdc++-4.4.7-23.el6.x86_64.rpm                                                                                                                | 296 kB     00:00     
(18/29): nspr-4.19.0-1.el6.x86_64.rpm                                                                                                                     | 114 kB     00:00     
(19/29): nss-3.36.0-8.el6.x86_64.rpm                                                                                                                      | 865 kB     00:00     
(20/29): nss-sysinit-3.36.0-8.el6.x86_64.rpm                                                                                                              |  52 kB     00:00     
(21/29): nss-tools-3.36.0-8.el6.x86_64.rpm                                                                                                                | 460 kB     00:00     
(22/29): nss-util-3.36.0-1.el6.x86_64.rpm                                                                                                                 |  72 kB     00:00     
(23/29): procps-3.2.8-45.el6_9.3.x86_64.rpm                                                                                                               | 220 kB     00:00     
(24/29): rpm-4.8.0-59.el6.x86_64.rpm                                                                                                                      | 906 kB     00:00     
(25/29): rpm-libs-4.8.0-59.el6.x86_64.rpm                                                                                                                 | 318 kB     00:00     
(26/29): rpm-python-4.8.0-59.el6.x86_64.rpm                                                                                                               |  61 kB     00:00     
(27/29): tzdata-2018e-3.el6.noarch.rpm                                                                                                                    | 495 kB     00:00     
(28/29): yum-plugin-fastestmirror-1.1.30-41.el6.noarch.rpm                                                                                                |  33 kB     00:00     
(29/29): yum-plugin-ovl-1.1.30-41.el6.noarch.rpm                                                                                                          |  26 kB     00:00     
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Total                                                                                                                                             17 MB/s |  34 MB     00:01     
warning: rpmts_HdrFromFdno: Header V3 RSA/SHA1 Signature, key ID c105b9de: NOKEY
Retrieving key from file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6
Importing GPG key 0xC105B9DE:
 Userid : CentOS-6 Key (CentOS 6 Official Signing Key) <centos-6-key@centos.org>
 Package: centos-release-6-9.el6.12.3.x86_64 (@CentOS/6.9)
 From   : /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6
Running rpm_check_debug
Running Transaction Test
Transaction Test Succeeded
Running Transaction
  Updating   : libgcc-4.4.7-23.el6.x86_64                                                                                                                                   1/58 
  Updating   : tzdata-2018e-3.el6.noarch                                                                                                                                    2/58 
  Updating   : glibc-2.12-1.212.el6.x86_64                                                                                                                                  3/58 
  Updating   : glibc-common-2.12-1.212.el6.x86_64                                                                                                                           4/58 
  Updating   : nspr-4.19.0-1.el6.x86_64                                                                                                                                     5/58 
  Updating   : nss-util-3.36.0-1.el6.x86_64                                                                                                                                 6/58 
  Updating   : 32:bind-libs-9.8.2-0.68.rc1.el6.x86_64                                                                                                                       7/58 
  Updating   : libstdc++-4.4.7-23.el6.x86_64                                                                                                                                8/58 
  Updating   : gmp-4.3.1-13.el6.x86_64                                                                                                                                      9/58 
  Updating   : coreutils-libs-8.4-47.el6.x86_64                                                                                                                            10/58 
  Updating   : coreutils-8.4-47.el6.x86_64                                                                                                                                 11/58 
  Updating   : nss-3.36.0-8.el6.x86_64                                                                                                                                     12/58 
  Updating   : nss-sysinit-3.36.0-8.el6.x86_64                                                                                                                             13/58 
  Updating   : rpm-libs-4.8.0-59.el6.x86_64                                                                                                                                14/58 
  Updating   : rpm-4.8.0-59.el6.x86_64                                                                                                                                     15/58 
  Updating   : 1:dbus-libs-1.2.24-9.el6.x86_64                                                                                                                             16/58 
  Updating   : libnih-1.0.1-8.el6.x86_64                                                                                                                                   17/58 
  Updating   : rpm-python-4.8.0-59.el6.x86_64                                                                                                                              18/58 
  Updating   : nss-tools-3.36.0-8.el6.x86_64                                                                                                                               19/58 
  Updating   : ca-certificates-2018.2.22-65.1.el6.noarch                                                                                                                   20/58 
  Updating   : 32:bind-utils-9.8.2-0.68.rc1.el6.x86_64                                                                                                                     21/58 
  Updating   : procps-3.2.8-45.el6_9.3.x86_64                                                                                                                              22/58 
  Updating   : glib2-2.28.8-10.el6.x86_64                                                                                                                                  23/58 
  Updating   : gnupg2-2.0.14-9.el6_10.x86_64                                                                                                                               24/58 
install-info: No such file or directory for /usr/share/info/gnupg.info
  Updating   : binutils-2.20.51.0.2-5.48.el6.x86_64                                                                                                                        25/58 
  Updating   : libcom_err-1.41.12-24.el6.x86_64                                                                                                                            26/58 
  Updating   : yum-plugin-fastestmirror-1.1.30-41.el6.noarch                                                                                                               27/58 
  Updating   : centos-release-6-10.el6.centos.12.3.x86_64                                                                                                                  28/58 
  Updating   : yum-plugin-ovl-1.1.30-41.el6.noarch                                                                                                                         29/58 
  Cleanup    : nss-tools-3.28.4-4.el6_9.x86_64                                                                                                                             30/58 
  Cleanup    : rpm-python-4.8.0-55.el6.x86_64                                                                                                                              31/58 
  Cleanup    : rpm-libs-4.8.0-55.el6.x86_64                                                                                                                                32/58 
  Cleanup    : rpm-4.8.0-55.el6.x86_64                                                                                                                                     33/58 
  Cleanup    : nss-sysinit-3.28.4-4.el6_9.x86_64                                                                                                                           34/58 
  Cleanup    : nss-3.28.4-4.el6_9.x86_64                                                                                                                                   35/58 
  Cleanup    : nss-util-3.28.4-1.el6_9.x86_64                                                                                                                              36/58 
  Cleanup    : libnih-1.0.1-7.el6.x86_64                                                                                                                                   37/58 
  Cleanup    : 32:bind-utils-9.8.2-0.62.rc1.el6_9.5.x86_64                                                                                                                 38/58 
  Cleanup    : ca-certificates-2017.2.14-65.0.1.el6_9.noarch                                                                                                               39/58 
  Cleanup    : yum-plugin-fastestmirror-1.1.30-40.el6.noarch                                                                                                               40/58 
  Cleanup    : centos-release-6-9.el6.12.3.x86_64                                                                                                                          41/58 
  Cleanup    : yum-plugin-ovl-1.1.30-40.el6.noarch                                                                                                                         42/58 
  Cleanup    : coreutils-libs-8.4-46.el6.x86_64                                                                                                                            43/58 
  Cleanup    : coreutils-8.4-46.el6.x86_64                                                                                                                                 44/58 
  Cleanup    : gmp-4.3.1-12.el6.x86_64                                                                                                                                     45/58 
  Cleanup    : libstdc++-4.4.7-18.el6_9.2.x86_64                                                                                                                           46/58 
  Cleanup    : 32:bind-libs-9.8.2-0.62.rc1.el6_9.5.x86_64                                                                                                                  47/58 
  Cleanup    : 1:dbus-libs-1.2.24-8.el6_6.x86_64                                                                                                                           48/58 
  Cleanup    : nspr-4.13.1-1.el6.x86_64                                                                                                                                    49/58 
  Cleanup    : libcom_err-1.41.12-23.el6.x86_64                                                                                                                            50/58 
  Cleanup    : binutils-2.20.51.0.2-5.47.el6_9.1.x86_64                                                                                                                    51/58 
  Cleanup    : gnupg2-2.0.14-8.el6.x86_64                                                                                                                                  52/58 
  Cleanup    : glib2-2.28.8-9.el6.x86_64                                                                                                                                   53/58 
  Cleanup    : procps-3.2.8-45.el6_9.1.x86_64                                                                                                                              54/58 
  Cleanup    : glibc-common-2.12-1.209.el6_9.2.x86_64                                                                                                                      55/58 
  Cleanup    : glibc-2.12-1.209.el6_9.2.x86_64                                                                                                                             56/58 
  Cleanup    : tzdata-2018d-1.el6.noarch                                                                                                                                   57/58 
  Cleanup    : libgcc-4.4.7-18.el6_9.2.x86_64                                                                                                                              58/58 
  Verifying  : 32:bind-utils-9.8.2-0.68.rc1.el6.x86_64                                                                                                                      1/58 
  Verifying  : yum-plugin-ovl-1.1.30-41.el6.noarch                                                                                                                          2/58 
  Verifying  : procps-3.2.8-45.el6_9.3.x86_64                                                                                                                               3/58 
  Verifying  : rpm-4.8.0-59.el6.x86_64                                                                                                                                      4/58 
  Verifying  : libnih-1.0.1-8.el6.x86_64                                                                                                                                    5/58 
  Verifying  : tzdata-2018e-3.el6.noarch                                                                                                                                    6/58 
  Verifying  : glib2-2.28.8-10.el6.x86_64                                                                                                                                   7/58 
  Verifying  : gnupg2-2.0.14-9.el6_10.x86_64                                                                                                                                8/58 
  Verifying  : binutils-2.20.51.0.2-5.48.el6.x86_64                                                                                                                         9/58 
  Verifying  : 32:bind-libs-9.8.2-0.68.rc1.el6.x86_64                                                                                                                      10/58 
  Verifying  : glibc-common-2.12-1.212.el6.x86_64                                                                                                                          11/58 
  Verifying  : coreutils-libs-8.4-47.el6.x86_64                                                                                                                            12/58 
  Verifying  : rpm-python-4.8.0-59.el6.x86_64                                                                                                                              13/58 
  Verifying  : nss-3.36.0-8.el6.x86_64                                                                                                                                     14/58 
  Verifying  : nss-util-3.36.0-1.el6.x86_64                                                                                                                                15/58 
  Verifying  : coreutils-8.4-47.el6.x86_64                                                                                                                                 16/58 
  Verifying  : ca-certificates-2018.2.22-65.1.el6.noarch                                                                                                                   17/58 
  Verifying  : rpm-libs-4.8.0-59.el6.x86_64                                                                                                                                18/58 
  Verifying  : nspr-4.19.0-1.el6.x86_64                                                                                                                                    19/58 
  Verifying  : nss-sysinit-3.36.0-8.el6.x86_64                                                                                                                             20/58 
  Verifying  : nss-tools-3.36.0-8.el6.x86_64                                                                                                                               21/58 
  Verifying  : libcom_err-1.41.12-24.el6.x86_64                                                                                                                            22/58 
  Verifying  : centos-release-6-10.el6.centos.12.3.x86_64                                                                                                                  23/58 
  Verifying  : libstdc++-4.4.7-23.el6.x86_64                                                                                                                               24/58 
  Verifying  : gmp-4.3.1-13.el6.x86_64                                                                                                                                     25/58 
  Verifying  : yum-plugin-fastestmirror-1.1.30-41.el6.noarch                                                                                                               26/58 
  Verifying  : glibc-2.12-1.212.el6.x86_64                                                                                                                                 27/58 
  Verifying  : libgcc-4.4.7-23.el6.x86_64                                                                                                                                  28/58 
  Verifying  : 1:dbus-libs-1.2.24-9.el6.x86_64                                                                                                                             29/58 
  Verifying  : binutils-2.20.51.0.2-5.47.el6_9.1.x86_64                                                                                                                    30/58 
  Verifying  : tzdata-2018d-1.el6.noarch                                                                                                                                   31/58 
  Verifying  : libcom_err-1.41.12-23.el6.x86_64                                                                                                                            32/58 
  Verifying  : nss-util-3.28.4-1.el6_9.x86_64                                                                                                                              33/58 
  Verifying  : nspr-4.13.1-1.el6.x86_64                                                                                                                                    34/58 
  Verifying  : glib2-2.28.8-9.el6.x86_64                                                                                                                                   35/58 
  Verifying  : rpm-4.8.0-55.el6.x86_64                                                                                                                                     36/58 
  Verifying  : coreutils-8.4-46.el6.x86_64                                                                                                                                 37/58 
  Verifying  : rpm-python-4.8.0-55.el6.x86_64                                                                                                                              38/58 
  Verifying  : coreutils-libs-8.4-46.el6.x86_64                                                                                                                            39/58 
  Verifying  : procps-3.2.8-45.el6_9.1.x86_64                                                                                                                              40/58 
  Verifying  : rpm-libs-4.8.0-55.el6.x86_64                                                                                                                                41/58 
  Verifying  : libgcc-4.4.7-18.el6_9.2.x86_64                                                                                                                              42/58 
  Verifying  : nss-tools-3.28.4-4.el6_9.x86_64                                                                                                                             43/58 
  Verifying  : yum-plugin-fastestmirror-1.1.30-40.el6.noarch                                                                                                               44/58 
  Verifying  : centos-release-6-9.el6.12.3.x86_64                                                                                                                          45/58 
  Verifying  : nss-3.28.4-4.el6_9.x86_64                                                                                                                                   46/58 
  Verifying  : 1:dbus-libs-1.2.24-8.el6_6.x86_64                                                                                                                           47/58 
  Verifying  : libnih-1.0.1-7.el6.x86_64                                                                                                                                   48/58 
  Verifying  : libstdc++-4.4.7-18.el6_9.2.x86_64                                                                                                                           49/58 
  Verifying  : glibc-2.12-1.209.el6_9.2.x86_64                                                                                                                             50/58 
  Verifying  : glibc-common-2.12-1.209.el6_9.2.x86_64                                                                                                                      51/58 
  Verifying  : ca-certificates-2017.2.14-65.0.1.el6_9.noarch                                                                                                               52/58 
  Verifying  : gnupg2-2.0.14-8.el6.x86_64                                                                                                                                  53/58 
  Verifying  : 32:bind-libs-9.8.2-0.62.rc1.el6_9.5.x86_64                                                                                                                  54/58 
  Verifying  : yum-plugin-ovl-1.1.30-40.el6.noarch                                                                                                                         55/58 
  Verifying  : gmp-4.3.1-12.el6.x86_64                                                                                                                                     56/58 
  Verifying  : 32:bind-utils-9.8.2-0.62.rc1.el6_9.5.x86_64                                                                                                                 57/58 
  Verifying  : nss-sysinit-3.28.4-4.el6_9.x86_64                                                                                                                           58/58 

Updated:
  bind-libs.x86_64 32:9.8.2-0.68.rc1.el6        bind-utils.x86_64 32:9.8.2-0.68.rc1.el6  binutils.x86_64 0:2.20.51.0.2-5.48.el6  ca-certificates.noarch 0:2018.2.22-65.1.el6     
  centos-release.x86_64 0:6-10.el6.centos.12.3  coreutils.x86_64 0:8.4-47.el6            coreutils-libs.x86_64 0:8.4-47.el6      dbus-libs.x86_64 1:1.2.24-9.el6                 
  glib2.x86_64 0:2.28.8-10.el6                  glibc.x86_64 0:2.12-1.212.el6            glibc-common.x86_64 0:2.12-1.212.el6    gmp.x86_64 0:4.3.1-13.el6                       
  gnupg2.x86_64 0:2.0.14-9.el6_10               libcom_err.x86_64 0:1.41.12-24.el6       libgcc.x86_64 0:4.4.7-23.el6            libnih.x86_64 0:1.0.1-8.el6                     
  libstdc++.x86_64 0:4.4.7-23.el6               nspr.x86_64 0:4.19.0-1.el6               nss.x86_64 0:3.36.0-8.el6               nss-sysinit.x86_64 0:3.36.0-8.el6               
  nss-tools.x86_64 0:3.36.0-8.el6               nss-util.x86_64 0:3.36.0-1.el6           procps.x86_64 0:3.2.8-45.el6_9.3        rpm.x86_64 0:4.8.0-59.el6                       
  rpm-libs.x86_64 0:4.8.0-59.el6                rpm-python.x86_64 0:4.8.0-59.el6         tzdata.noarch 0:2018e-3.el6             yum-plugin-fastestmirror.noarch 0:1.1.30-41.el6 
  yum-plugin-ovl.noarch 0:1.1.30-41.el6        

Complete!
[root@844866456de3 /]# yum install httpd -y
Loaded plugins: fastestmirror, ovl
Setting up Install Process
Determining fastest mirrors
 * base: centos.servint.com
 * extras: mirror.math.princeton.edu
 * updates: mirror.wdc1.us.leaseweb.net
Resolving Dependencies
--> Running transaction check
---> Package httpd.x86_64 0:2.2.15-69.el6.centos will be installed
--> Processing Dependency: httpd-tools = 2.2.15-69.el6.centos for package: httpd-2.2.15-69.el6.centos.x86_64
--> Processing Dependency: system-logos >= 7.92.1-1 for package: httpd-2.2.15-69.el6.centos.x86_64
--> Processing Dependency: initscripts >= 8.36 for package: httpd-2.2.15-69.el6.centos.x86_64
--> Processing Dependency: apr-util-ldap for package: httpd-2.2.15-69.el6.centos.x86_64
--> Processing Dependency: /etc/mime.types for package: httpd-2.2.15-69.el6.centos.x86_64
--> Processing Dependency: libaprutil-1.so.0()(64bit) for package: httpd-2.2.15-69.el6.centos.x86_64
--> Processing Dependency: libapr-1.so.0()(64bit) for package: httpd-2.2.15-69.el6.centos.x86_64
--> Running transaction check
---> Package apr.x86_64 0:1.3.9-5.el6_9.1 will be installed
---> Package apr-util.x86_64 0:1.3.9-3.el6_0.1 will be installed
---> Package apr-util-ldap.x86_64 0:1.3.9-3.el6_0.1 will be installed
---> Package httpd-tools.x86_64 0:2.2.15-69.el6.centos will be installed
---> Package initscripts.x86_64 0:9.03.61-1.el6.centos will be installed
--> Processing Dependency: util-linux-ng >= 2.16 for package: initscripts-9.03.61-1.el6.centos.x86_64
--> Processing Dependency: upstart >= 0.6.5-11 for package: initscripts-9.03.61-1.el6.centos.x86_64
--> Processing Dependency: udev >= 125-1 for package: initscripts-9.03.61-1.el6.centos.x86_64
--> Processing Dependency: sysvinit-tools >= 2.87-6 for package: initscripts-9.03.61-1.el6.centos.x86_64
--> Processing Dependency: plymouth for package: initscripts-9.03.61-1.el6.centos.x86_64
--> Processing Dependency: /sbin/pidof for package: initscripts-9.03.61-1.el6.centos.x86_64
--> Processing Dependency: /sbin/ip for package: initscripts-9.03.61-1.el6.centos.x86_64
--> Processing Dependency: /sbin/blkid for package: initscripts-9.03.61-1.el6.centos.x86_64
--> Processing Dependency: /sbin/arping for package: initscripts-9.03.61-1.el6.centos.x86_64
---> Package mailcap.noarch 0:2.1.31-2.el6 will be installed
---> Package redhat-logos.noarch 0:60.0.14-12.el6.centos will be installed
--> Running transaction check
---> Package iproute.x86_64 0:2.6.32-57.el6 will be installed
--> Processing Dependency: iptables >= 1.4.5 for package: iproute-2.6.32-57.el6.x86_64
--> Processing Dependency: libxtables.so.4()(64bit) for package: iproute-2.6.32-57.el6.x86_64
---> Package iputils.x86_64 0:20071127-24.el6 will be installed
---> Package plymouth.x86_64 0:0.8.3-29.el6.centos will be installed
--> Processing Dependency: libdrm_radeon.so.1()(64bit) for package: plymouth-0.8.3-29.el6.centos.x86_64
--> Processing Dependency: libdrm_nouveau.so.1()(64bit) for package: plymouth-0.8.3-29.el6.centos.x86_64
--> Processing Dependency: libdrm_intel.so.1()(64bit) for package: plymouth-0.8.3-29.el6.centos.x86_64
--> Processing Dependency: libdrm.so.2()(64bit) for package: plymouth-0.8.3-29.el6.centos.x86_64
---> Package sysvinit-tools.x86_64 0:2.87-6.dsf.el6 will be installed
---> Package udev.x86_64 0:147-2.73.el6_8.2 will be installed
--> Processing Dependency: hwdata for package: udev-147-2.73.el6_8.2.x86_64
---> Package upstart.x86_64 0:0.6.5-17.el6 will be installed
---> Package util-linux-ng.x86_64 0:2.17.2-12.28.el6_9.2 will be installed
--> Running transaction check
---> Package hwdata.noarch 0:0.233-20.1.el6 will be installed
---> Package iptables.x86_64 0:1.4.7-19.el6 will be installed
--> Processing Dependency: policycoreutils for package: iptables-1.4.7-19.el6.x86_64
---> Package libdrm.x86_64 0:2.4.65-2.el6 will be installed
--> Processing Dependency: libpciaccess.so.0()(64bit) for package: libdrm-2.4.65-2.el6.x86_64
--> Running transaction check
---> Package libpciaccess.x86_64 0:0.13.4-1.el6 will be installed
---> Package policycoreutils.x86_64 0:2.0.83-30.1.el6_8 will be installed
--> Processing Dependency: libdbus-glib-1.so.2()(64bit) for package: policycoreutils-2.0.83-30.1.el6_8.x86_64
--> Running transaction check
---> Package dbus-glib.x86_64 0:0.86-6.el6 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

=================================================================================================================================================================================
 Package                                       Arch                                 Version                                             Repository                          Size
=================================================================================================================================================================================
Installing:
 httpd                                         x86_64                               2.2.15-69.el6.centos                                base                               836 k
Installing for dependencies:
 apr                                           x86_64                               1.3.9-5.el6_9.1                                     base                               124 k
 apr-util                                      x86_64                               1.3.9-3.el6_0.1                                     base                                87 k
 apr-util-ldap                                 x86_64                               1.3.9-3.el6_0.1                                     base                                15 k
 dbus-glib                                     x86_64                               0.86-6.el6                                          base                               170 k
 httpd-tools                                   x86_64                               2.2.15-69.el6.centos                                base                                81 k
 hwdata                                        noarch                               0.233-20.1.el6                                      base                               1.4 M
 initscripts                                   x86_64                               9.03.61-1.el6.centos                                base                               949 k
 iproute                                       x86_64                               2.6.32-57.el6                                       base                               386 k
 iptables                                      x86_64                               1.4.7-19.el6                                        base                               255 k
 iputils                                       x86_64                               20071127-24.el6                                     base                               121 k
 libdrm                                        x86_64                               2.4.65-2.el6                                        base                               136 k
 libpciaccess                                  x86_64                               0.13.4-1.el6                                        base                                24 k
 mailcap                                       noarch                               2.1.31-2.el6                                        base                                27 k
 plymouth                                      x86_64                               0.8.3-29.el6.centos                                 base                                89 k
 policycoreutils                               x86_64                               2.0.83-30.1.el6_8                                   base                               663 k
 redhat-logos                                  noarch                               60.0.14-12.el6.centos                               base                                15 M
 sysvinit-tools                                x86_64                               2.87-6.dsf.el6                                      base                                60 k
 udev                                          x86_64                               147-2.73.el6_8.2                                    base                               358 k
 upstart                                       x86_64                               0.6.5-17.el6                                        base                               177 k
 util-linux-ng                                 x86_64                               2.17.2-12.28.el6_9.2                                base                               1.6 M

Transaction Summary
=================================================================================================================================================================================
Install      21 Package(s)

Total download size: 22 M
Installed size: 44 M
Downloading Packages:
(1/21): apr-1.3.9-5.el6_9.1.x86_64.rpm                                                                                                                    | 124 kB     00:00     
(2/21): apr-util-1.3.9-3.el6_0.1.x86_64.rpm                                                                                                               |  87 kB     00:00     
(3/21): apr-util-ldap-1.3.9-3.el6_0.1.x86_64.rpm                                                                                                          |  15 kB     00:00     
(4/21): dbus-glib-0.86-6.el6.x86_64.rpm                                                                                                                   | 170 kB     00:00     
(5/21): httpd-2.2.15-69.el6.centos.x86_64.rpm                                                                                                             | 836 kB     00:00     
(6/21): httpd-tools-2.2.15-69.el6.centos.x86_64.rpm                                                                                                       |  81 kB     00:00     
(7/21): hwdata-0.233-20.1.el6.noarch.rpm                                                                                                                  | 1.4 MB     00:00     
(8/21): initscripts-9.03.61-1.el6.centos.x86_64.rpm                                                                                                       | 949 kB     00:00     
(9/21): iproute-2.6.32-57.el6.x86_64.rpm                                                                                                                  | 386 kB     00:00     
(10/21): iptables-1.4.7-19.el6.x86_64.rpm                                                                                                                 | 255 kB     00:00     
(11/21): iputils-20071127-24.el6.x86_64.rpm                                                                                                               | 121 kB     00:00     
(12/21): libdrm-2.4.65-2.el6.x86_64.rpm                                                                                                                   | 136 kB     00:00     
(13/21): libpciaccess-0.13.4-1.el6.x86_64.rpm                                                                                                             |  24 kB     00:00     
(14/21): mailcap-2.1.31-2.el6.noarch.rpm                                                                                                                  |  27 kB     00:00     
(15/21): plymouth-0.8.3-29.el6.centos.x86_64.rpm                                                                                                          |  89 kB     00:00     
(16/21): policycoreutils-2.0.83-30.1.el6_8.x86_64.rpm                                                                                                     | 663 kB     00:00     
(17/21): redhat-logos-60.0.14-12.el6.centos.noarch.rpm                                                                                                    |  15 MB     00:00     
(18/21): sysvinit-tools-2.87-6.dsf.el6.x86_64.rpm                                                                                                         |  60 kB     00:00     
(19/21): udev-147-2.73.el6_8.2.x86_64.rpm                                                                                                                 | 358 kB     00:00     
(20/21): upstart-0.6.5-17.el6.x86_64.rpm                                                                                                                  | 177 kB     00:00     
(21/21): util-linux-ng-2.17.2-12.28.el6_9.2.x86_64.rpm                                                                                                    | 1.6 MB     00:00     
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Total                                                                                                                                             25 MB/s |  22 MB     00:00     
Running rpm_check_debug
Running Transaction Test
Transaction Test Succeeded
Running Transaction
  Installing : apr-1.3.9-5.el6_9.1.x86_64                                                                                                                                   1/21 
  Installing : apr-util-1.3.9-3.el6_0.1.x86_64                                                                                                                              2/21 
  Installing : sysvinit-tools-2.87-6.dsf.el6.x86_64                                                                                                                         3/21 
  Installing : redhat-logos-60.0.14-12.el6.centos.noarch                                                                                                                    4/21 
  Installing : hwdata-0.233-20.1.el6.noarch                                                                                                                                 5/21 
  Installing : libpciaccess-0.13.4-1.el6.x86_64                                                                                                                             6/21 
  Installing : httpd-tools-2.2.15-69.el6.centos.x86_64                                                                                                                      7/21 
  Installing : apr-util-ldap-1.3.9-3.el6_0.1.x86_64                                                                                                                         8/21 
  Installing : mailcap-2.1.31-2.el6.noarch                                                                                                                                  9/21 
  Installing : dbus-glib-0.86-6.el6.x86_64                                                                                                                                 10/21 
  Installing : upstart-0.6.5-17.el6.x86_64                                                                                                                                 11/21 
  Installing : policycoreutils-2.0.83-30.1.el6_8.x86_64                                                                                                                    12/21 
  Installing : iptables-1.4.7-19.el6.x86_64                                                                                                                                13/21 
  Installing : iproute-2.6.32-57.el6.x86_64                                                                                                                                14/21 
  Installing : libdrm-2.4.65-2.el6.x86_64                                                                                                                                  15/21 
  Installing : iputils-20071127-24.el6.x86_64                                                                                                                              16/21 
  Installing : plymouth-0.8.3-29.el6.centos.x86_64                                                                                                                         17/21 
  Installing : util-linux-ng-2.17.2-12.28.el6_9.2.x86_64                                                                                                                   18/21 
install-info: No such file or directory for /usr/share/info/ipc.info
  Installing : initscripts-9.03.61-1.el6.centos.x86_64                                                                                                                     19/21 
  Installing : udev-147-2.73.el6_8.2.x86_64                                                                                                                                20/21 
  Installing : httpd-2.2.15-69.el6.centos.x86_64                                                                                                                           21/21 
  Verifying  : plymouth-0.8.3-29.el6.centos.x86_64                                                                                                                          1/21 
  Verifying  : httpd-tools-2.2.15-69.el6.centos.x86_64                                                                                                                      2/21 
  Verifying  : policycoreutils-2.0.83-30.1.el6_8.x86_64                                                                                                                     3/21 
  Verifying  : upstart-0.6.5-17.el6.x86_64                                                                                                                                  4/21 
  Verifying  : udev-147-2.73.el6_8.2.x86_64                                                                                                                                 5/21 
  Verifying  : initscripts-9.03.61-1.el6.centos.x86_64                                                                                                                      6/21 
  Verifying  : iptables-1.4.7-19.el6.x86_64                                                                                                                                 7/21 
  Verifying  : iproute-2.6.32-57.el6.x86_64                                                                                                                                 8/21 
  Verifying  : apr-util-ldap-1.3.9-3.el6_0.1.x86_64                                                                                                                         9/21 
  Verifying  : httpd-2.2.15-69.el6.centos.x86_64                                                                                                                           10/21 
  Verifying  : hwdata-0.233-20.1.el6.noarch                                                                                                                                11/21 
  Verifying  : redhat-logos-60.0.14-12.el6.centos.noarch                                                                                                                   12/21 
  Verifying  : util-linux-ng-2.17.2-12.28.el6_9.2.x86_64                                                                                                                   13/21 
  Verifying  : iputils-20071127-24.el6.x86_64                                                                                                                              14/21 
  Verifying  : sysvinit-tools-2.87-6.dsf.el6.x86_64                                                                                                                        15/21 
  Verifying  : dbus-glib-0.86-6.el6.x86_64                                                                                                                                 16/21 
  Verifying  : apr-1.3.9-5.el6_9.1.x86_64                                                                                                                                  17/21 
  Verifying  : mailcap-2.1.31-2.el6.noarch                                                                                                                                 18/21 
  Verifying  : libpciaccess-0.13.4-1.el6.x86_64                                                                                                                            19/21 
  Verifying  : libdrm-2.4.65-2.el6.x86_64                                                                                                                                  20/21 
  Verifying  : apr-util-1.3.9-3.el6_0.1.x86_64                                                                                                                             21/21 

Installed:
  httpd.x86_64 0:2.2.15-69.el6.centos                                                                                                                                            

Dependency Installed:
  apr.x86_64 0:1.3.9-5.el6_9.1                apr-util.x86_64 0:1.3.9-3.el6_0.1       apr-util-ldap.x86_64 0:1.3.9-3.el6_0.1       dbus-glib.x86_64 0:0.86-6.el6                
  httpd-tools.x86_64 0:2.2.15-69.el6.centos   hwdata.noarch 0:0.233-20.1.el6          initscripts.x86_64 0:9.03.61-1.el6.centos    iproute.x86_64 0:2.6.32-57.el6               
  iptables.x86_64 0:1.4.7-19.el6              iputils.x86_64 0:20071127-24.el6        libdrm.x86_64 0:2.4.65-2.el6                 libpciaccess.x86_64 0:0.13.4-1.el6           
  mailcap.noarch 0:2.1.31-2.el6               plymouth.x86_64 0:0.8.3-29.el6.centos   policycoreutils.x86_64 0:2.0.83-30.1.el6_8   redhat-logos.noarch 0:60.0.14-12.el6.centos  
  sysvinit-tools.x86_64 0:2.87-6.dsf.el6      udev.x86_64 0:147-2.73.el6_8.2          upstart.x86_64 0:0.6.5-17.el6                util-linux-ng.x86_64 0:2.17.2-12.28.el6_9.2  

Complete!
[root@844866456de3 /]# yum install telnet -y
Loaded plugins: fastestmirror, ovl
Setting up Install Process
Loading mirror speeds from cached hostfile
 * base: centos.servint.com
 * extras: mirror.math.princeton.edu
 * updates: mirror.wdc1.us.leaseweb.net
Resolving Dependencies
--> Running transaction check
---> Package telnet.x86_64 1:0.17-48.el6 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

=================================================================================================================================================================================
 Package                                  Arch                                     Version                                          Repository                              Size
=================================================================================================================================================================================
Installing:
 telnet                                   x86_64                                   1:0.17-48.el6                                    base                                    58 k

Transaction Summary
=================================================================================================================================================================================
Install       1 Package(s)

Total download size: 58 k
Installed size: 109 k
Downloading Packages:
telnet-0.17-48.el6.x86_64.rpm                                                                                                                             |  58 kB     00:00     
Running rpm_check_debug
Running Transaction Test
Transaction Test Succeeded
Running Transaction
  Installing : 1:telnet-0.17-48.el6.x86_64                                                                                                                                   1/1 
  Verifying  : 1:telnet-0.17-48.el6.x86_64                                                                                                                                   1/1 

Installed:
  telnet.x86_64 1:0.17-48.el6                                                                                                                                                    

Complete!
[root@844866456de3 /]# service start httpd start
start: unrecognized service
[root@844866456de3 /]# service httpd start      
Starting httpd: httpd: Could not reliably determine the server's fully qualified domain name, using 172.17.0.2 for ServerName
                                                           [  OK  ]
[root@844866456de3 /]# chkconfig --add httpd
[root@844866456de3 /]# chkconfig httpd on
[root@844866456de3 /]# chkconfig --list httpd
httpd          	0:off	1:off	2:on	3:on	4:on	5:on	6:off
[root@844866456de3 /]# telnet localhost 80
Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.
kdjf
HTTP/1.1 400 Bad Request
Date: Wed, 01 Aug 2018 21:29:14 GMT
Server: Apache/2.2.15 (CentOS)
Content-Length: 302
Connection: close
Content-Type: text/html; charset=iso-8859-1

<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
<html><head>
<title>400 Bad Request</title>
</head><body>
<h1>Bad Request</h1>
<p>Your browser sent a request that this server could not understand.<br />
</p>
<hr>
<address>Apache/2.2.15 (CentOS) Server at 172.17.0.2 Port 80</address>
</body></html>
Connection closed by foreign host.
[root@844866456de3 /]# exit
exit

$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES

$ docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                     PORTS               NAMES
844866456de3        centos:6            "/bin/bash"         4 minutes ago       Exited (1) 5 seconds ago                       awesome_hugle

$ docker commit 844866456de3 newcentos:withapached
sha256:18a9ff0a4eb6af169129dbafc51028d6b96057ddc0cab4f6ac3d33e8541d7ec5

$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
newcentos           withapached         18a9ff0a4eb6        7 seconds ago       461MB
ubuntu              latest              735f80812f90        5 days ago          83.5MB
centos              6                   70b5d81549ec        3 months ago        195MB

$ docker run -it newcentos:withapached /bin/bash
[root@265c4c0739b1 /]# telnet localhost 80
Trying 127.0.0.1...
telnet: connect to address 127.0.0.1: Connection refused
Trying ::1...
telnet: connect to address ::1: Network is unreachable
[root@265c4c0739b1 /]# service httpd start
Starting httpd: httpd: Could not reliably determine the server's fully qualified domain name, using 172.17.0.2 for ServerName
                                                           [  OK  ]
[root@265c4c0739b1 /]# 
[root@265c4c0739b1 /]# telnet localhost 80
Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.

HTTP/1.1 400 Bad Request
Date: Wed, 01 Aug 2018 21:31:10 GMT
Server: Apache/2.2.15 (CentOS)
Content-Length: 302
Connection: close
Content-Type: text/html; charset=iso-8859-1

<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
<html><head>
<title>400 Bad Request</title>
</head><body>
<h1>Bad Request</h1>
<p>Your browser sent a request that this server could not understand.<br />
</p>
<hr>
<address>Apache/2.2.15 (CentOS) Server at 172.17.0.2 Port 80</address>
</body></html>

```