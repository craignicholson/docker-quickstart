# Dockerfile Options, Structure, and Efficiencies

Building from a Dockerfile 'Dockerfile' using the tag flag (-t) to give our image it's own tag.

```bash

$ docker build -t  mywebserver:v1 .

Sending build context to Docker daemon   2.56kB
Step 1/9 : FROM centos:latest
 ---> 49f7960eb7e4
Step 2/9 : LABEL maintainer="latest@email.com"
 ---> Running in fb27ccf579dc
Removing intermediate container fb27ccf579dc
 ---> aeb79fc8db5c
Step 3/9 : RUN yum update -y && yum install httpd net-tools -y
 ---> Running in bcb910c1232f
Loaded plugins: fastestmirror, ovl
Determining fastest mirrors
 * base: mirror.atlantic.net
 * extras: mirror.teklinks.com
 * updates: repos-va.psychz.net
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
Total                                              9.1 MB/s |  13 MB  00:01     
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
Loaded plugins: fastestmirror, ovl
Loading mirror speeds from cached hostfile
 * base: mirror.atlantic.net
 * extras: mirror.teklinks.com
 * updates: repos-va.psychz.net
Resolving Dependencies
--> Running transaction check
---> Package httpd.x86_64 0:2.4.6-80.el7.centos.1 will be installed
--> Processing Dependency: httpd-tools = 2.4.6-80.el7.centos.1 for package: httpd-2.4.6-80.el7.centos.1.x86_64
--> Processing Dependency: system-logos >= 7.92.1-1 for package: httpd-2.4.6-80.el7.centos.1.x86_64
--> Processing Dependency: /etc/mime.types for package: httpd-2.4.6-80.el7.centos.1.x86_64
--> Processing Dependency: libaprutil-1.so.0()(64bit) for package: httpd-2.4.6-80.el7.centos.1.x86_64
--> Processing Dependency: libapr-1.so.0()(64bit) for package: httpd-2.4.6-80.el7.centos.1.x86_64
---> Package net-tools.x86_64 0:2.0-0.22.20131004git.el7 will be installed
--> Running transaction check
---> Package apr.x86_64 0:1.4.8-3.el7_4.1 will be installed
---> Package apr-util.x86_64 0:1.5.2-6.el7 will be installed
---> Package centos-logos.noarch 0:70.0.6-3.el7.centos will be installed
---> Package httpd-tools.x86_64 0:2.4.6-80.el7.centos.1 will be installed
---> Package mailcap.noarch 0:2.1.41-2.el7 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

================================================================================
 Package           Arch        Version                       Repository    Size
================================================================================
Installing:
 httpd             x86_64      2.4.6-80.el7.centos.1         updates      2.7 M
 net-tools         x86_64      2.0-0.22.20131004git.el7      base         305 k
Installing for dependencies:
 apr               x86_64      1.4.8-3.el7_4.1               base         103 k
 apr-util          x86_64      1.5.2-6.el7                   base          92 k
 centos-logos      noarch      70.0.6-3.el7.centos           base          21 M
 httpd-tools       x86_64      2.4.6-80.el7.centos.1         updates       90 k
 mailcap           noarch      2.1.41-2.el7                  base          31 k

Transaction Summary
================================================================================
Install  2 Packages (+5 Dependent packages)

Total download size: 25 M
Installed size: 32 M
Downloading packages:
--------------------------------------------------------------------------------
Total                                              2.2 MB/s |  25 MB  00:11     
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Installing : apr-1.4.8-3.el7_4.1.x86_64                                   1/7 
  Installing : apr-util-1.5.2-6.el7.x86_64                                  2/7 
  Installing : httpd-tools-2.4.6-80.el7.centos.1.x86_64                     3/7 
  Installing : centos-logos-70.0.6-3.el7.centos.noarch                      4/7 
  Installing : mailcap-2.1.41-2.el7.noarch                                  5/7 
  Installing : httpd-2.4.6-80.el7.centos.1.x86_64                           6/7 
  Installing : net-tools-2.0-0.22.20131004git.el7.x86_64                    7/7 
  Verifying  : httpd-tools-2.4.6-80.el7.centos.1.x86_64                     1/7 
  Verifying  : mailcap-2.1.41-2.el7.noarch                                  2/7 
  Verifying  : net-tools-2.0-0.22.20131004git.el7.x86_64                    3/7 
  Verifying  : apr-util-1.5.2-6.el7.x86_64                                  4/7 
  Verifying  : httpd-2.4.6-80.el7.centos.1.x86_64                           5/7 
  Verifying  : apr-1.4.8-3.el7_4.1.x86_64                                   6/7 
  Verifying  : centos-logos-70.0.6-3.el7.centos.noarch                      7/7 

Installed:
  httpd.x86_64 0:2.4.6-80.el7.centos.1                                          
  net-tools.x86_64 0:2.0-0.22.20131004git.el7                                   

Dependency Installed:
  apr.x86_64 0:1.4.8-3.el7_4.1                                                  
  apr-util.x86_64 0:1.5.2-6.el7                                                 
  centos-logos.noarch 0:70.0.6-3.el7.centos                                     
  httpd-tools.x86_64 0:2.4.6-80.el7.centos.1                                    
  mailcap.noarch 0:2.1.41-2.el7                                                 

Complete!
Removing intermediate container bcb910c1232f
 ---> eb4f458a7b9f
Step 4/9 : RUN mkdir -p /run/httpd
 ---> Running in f04b8b962858
Removing intermediate container f04b8b962858
 ---> e86292ff9f5e
Step 5/9 : RUN rm -rf /run/http/* /tmp/httpd*
 ---> Running in af2f63bfb45e
Removing intermediate container af2f63bfb45e
 ---> a85b34a7a2a0
Step 6/9 : CMD echo "remember to check your container IP address"
 ---> Running in 7b152c69a70d
Removing intermediate container 7b152c69a70d
 ---> 3dafc6d42542
Step 7/9 : ENV ENVIRONMENT="production"
 ---> Running in a638ec3ef51e
Removing intermediate container a638ec3ef51e
 ---> f66d668e202d
Step 8/9 : EXPOSE 80
 ---> Running in 80da3ae8418d
Removing intermediate container 80da3ae8418d
 ---> 8af531f90cda
Step 9/9 : ENTRYPOINT apachectl "-DFOREGROUND"
 ---> Running in dd4059f83f36
Removing intermediate container dd4059f83f36
 ---> b056ac4655b2
Successfully built b056ac4655b2
Successfully tagged mywebserver:v1
```

Check the build for the image

```bash
$ docker images
REPOSITORY                                 TAG                 IMAGE ID            CREATED             SIZE
mywebserver                                v1                  b056ac4655b2        6 hours ago         362MB

$ docker run -d --name testweb1 --rm mywebserver:v1
cf7abd66a977ed0c55a795c3b3cb95e9ff42f2102e7736155583d95326c145d0

$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
cf7abd66a977        mywebserver:v1      "/bin/sh -c 'apachec…"   3 seconds ago       Up 2 seconds        80/tcp              testweb1

$ docker inspect testweb1 | grep IPAddress
            "SecondaryIPAddresses": null,
            "IPAddress": "172.17.0.2",
                    "IPAddress": "172.17.0.2",
$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
cf7abd66a977        mywebserver:v1      "/bin/sh -c 'apachec…"   3 minutes ago       Up 3 minutes        80/tcp              testweb1

$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
cf7abd66a977        mywebserver:v1      "/bin/sh -c 'apachec…"   4 minutes ago       Up 3 minutes        80/tcp              testweb1

$ docker stop testweb1
testweb1
```

## Review the build history

```bash

$ docker history mywebserver:v1

# get a count of the layers created
$ docker history mywebserver:v1 | wc -l
12

```

## Re-build the image, and notice we use the cached images

Efficiencies

```bash
$ docker build -t mywebserver:v2 .

Sending build context to Docker daemon  3.072kB
Step 1/7 : FROM centos:latest
 ---> 49f7960eb7e4
Step 2/7 : LABEL maintainer="latest@email.com"
 ---> Using cache
 ---> aeb79fc8db5c
Step 3/7 : RUN yum update -y &&     yum install httpd net-tools -y &&     mkdir -p /run/httpd &&     rm -rf /run/http/* /tmp/httpd*
 ---> Running in ff09090156b4
Loaded plugins: fastestmirror, ovl
Determining fastest mirrors
 * base: repos-va.psychz.net
 * extras: mirror.cs.vt.edu
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
Total                                               14 MB/s |  13 MB  00:00     
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
Loaded plugins: fastestmirror, ovl
Loading mirror speeds from cached hostfile
 * base: repos-va.psychz.net
 * extras: mirror.cs.vt.edu
 * updates: reflector.westga.edu
Resolving Dependencies
--> Running transaction check
---> Package httpd.x86_64 0:2.4.6-80.el7.centos.1 will be installed
--> Processing Dependency: httpd-tools = 2.4.6-80.el7.centos.1 for package: httpd-2.4.6-80.el7.centos.1.x86_64
--> Processing Dependency: system-logos >= 7.92.1-1 for package: httpd-2.4.6-80.el7.centos.1.x86_64
--> Processing Dependency: /etc/mime.types for package: httpd-2.4.6-80.el7.centos.1.x86_64
--> Processing Dependency: libaprutil-1.so.0()(64bit) for package: httpd-2.4.6-80.el7.centos.1.x86_64
--> Processing Dependency: libapr-1.so.0()(64bit) for package: httpd-2.4.6-80.el7.centos.1.x86_64
---> Package net-tools.x86_64 0:2.0-0.22.20131004git.el7 will be installed
--> Running transaction check
---> Package apr.x86_64 0:1.4.8-3.el7_4.1 will be installed
---> Package apr-util.x86_64 0:1.5.2-6.el7 will be installed
---> Package centos-logos.noarch 0:70.0.6-3.el7.centos will be installed
---> Package httpd-tools.x86_64 0:2.4.6-80.el7.centos.1 will be installed
---> Package mailcap.noarch 0:2.1.41-2.el7 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

================================================================================
 Package           Arch        Version                       Repository    Size
================================================================================
Installing:
 httpd             x86_64      2.4.6-80.el7.centos.1         updates      2.7 M
 net-tools         x86_64      2.0-0.22.20131004git.el7      base         305 k
Installing for dependencies:
 apr               x86_64      1.4.8-3.el7_4.1               base         103 k
 apr-util          x86_64      1.5.2-6.el7                   base          92 k
 centos-logos      noarch      70.0.6-3.el7.centos           base          21 M
 httpd-tools       x86_64      2.4.6-80.el7.centos.1         updates       90 k
 mailcap           noarch      2.1.41-2.el7                  base          31 k

Transaction Summary
================================================================================
Install  2 Packages (+5 Dependent packages)

Total download size: 25 M
Installed size: 32 M
Downloading packages:
--------------------------------------------------------------------------------
Total                                               16 MB/s |  25 MB  00:01     
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Installing : apr-1.4.8-3.el7_4.1.x86_64                                   1/7 
  Installing : apr-util-1.5.2-6.el7.x86_64                                  2/7 
  Installing : httpd-tools-2.4.6-80.el7.centos.1.x86_64                     3/7 
  Installing : centos-logos-70.0.6-3.el7.centos.noarch                      4/7 
  Installing : mailcap-2.1.41-2.el7.noarch                                  5/7 
  Installing : httpd-2.4.6-80.el7.centos.1.x86_64                           6/7 
  Installing : net-tools-2.0-0.22.20131004git.el7.x86_64                    7/7 
  Verifying  : httpd-tools-2.4.6-80.el7.centos.1.x86_64                     1/7 
  Verifying  : mailcap-2.1.41-2.el7.noarch                                  2/7 
  Verifying  : net-tools-2.0-0.22.20131004git.el7.x86_64                    3/7 
  Verifying  : apr-util-1.5.2-6.el7.x86_64                                  4/7 
  Verifying  : httpd-2.4.6-80.el7.centos.1.x86_64                           5/7 
  Verifying  : apr-1.4.8-3.el7_4.1.x86_64                                   6/7 
  Verifying  : centos-logos-70.0.6-3.el7.centos.noarch                      7/7 

Installed:
  httpd.x86_64 0:2.4.6-80.el7.centos.1                                          
  net-tools.x86_64 0:2.0-0.22.20131004git.el7                                   

Dependency Installed:
  apr.x86_64 0:1.4.8-3.el7_4.1                                                  
  apr-util.x86_64 0:1.5.2-6.el7                                                 
  centos-logos.noarch 0:70.0.6-3.el7.centos                                     
  httpd-tools.x86_64 0:2.4.6-80.el7.centos.1                                    
  mailcap.noarch 0:2.1.41-2.el7                                                 

Complete!
Removing intermediate container ff09090156b4
 ---> a8e4a44ba012
Step 4/7 : CMD echo "remember to check your container IP address"
 ---> Running in 1a32235819e2
Removing intermediate container 1a32235819e2
 ---> fb9bd0df5993
Step 5/7 : ENV ENVIRONMENT="production"
 ---> Running in 8d363505f666
Removing intermediate container 8d363505f666
 ---> 8faad17b5d71
Step 6/7 : EXPOSE 80
 ---> Running in 9c67cc1211b9
Removing intermediate container 9c67cc1211b9
 ---> 966b32b7ea3c
Step 7/7 : ENTRYPOINT apachectl "-DFOREGROUND"
 ---> Running in 0c19331417a8
Removing intermediate container 0c19331417a8
 ---> 6aa5b7f1a8d9
Successfully built 6aa5b7f1a8d9
Successfully tagged mywebserver:v2
```

Review the history

```bash
$ docker history mywebserver:v2 | wc -l
      10
```

# SQUASH A FILE

```bash

$ docker image history mywebserver:v4
IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
a2e257123a3d        About an hour ago   /bin/sh -c #(nop)  ENTRYPOINT ["/bin/sh" "-c…   0B                  
234ab3c4d99b        About an hour ago   /bin/sh -c #(nop)  EXPOSE 80                    0B                  
b096e9311fce        About an hour ago   /bin/sh -c #(nop)  VOLUME [/mymount]            0B                  
df94e6bdae5c        About an hour ago   /bin/sh -c #(nop)  ENV ENVIRONMENT=production   0B                  
20cc00cce859        About an hour ago   /bin/sh -c #(nop) COPY file:ca82fdef2f64acb5…   12B                 
6ad91629c66c        About an hour ago   /bin/sh -c yum update -y &&     yum install …   270MB               
5ebb9e2d4706        About an hour ago   /bin/sh -c #(nop)  LABEL maintainer=latest@e…   0B                  
70b5d81549ec        3 months ago        /bin/sh -c #(nop)  CMD ["/bin/bash"]            0B                  
<missing>           3 months ago        /bin/sh -c #(nop)  LABEL name=CentOS Base Im…   0B                  
<missing>           3 months ago        /bin/sh -c #(nop) ADD file:2a39fb46f860e75d7…   195MB  

$ docker run mywebserver:v4
26
$ docker ps -a
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                    PORTS               NAMES
41349ad76c1c        mywebserver:v4      "/bin/sh -c 'ls -al …"   3 seconds ago       Exited (0) 1 second ago                       mystifying_wright
$ docker export mystifying_wright > mywebserver4.tar
$ 


$ ls -al
total 754024
drwxr-xr-x  10 cn  staff        320 Aug  1 10:22 .
drwxr-xr-x   4 cn  staff        128 Jul 31 15:40 ..
-rw-r--r--   1 cn  staff       1510 Jul 31 22:20 Dockerfile
-rw-r--r--   1 cn  staff        495 Aug  1 08:52 Dockerfile3
-rw-r--r--   1 cn  staff        418 Aug  1 09:14 Dockerfile4
-rw-r--r--   1 cn  staff       1510 Jul 31 22:26 DockerfileCombined
-rw-r--r--   1 cn  staff       1510 Jul 31 22:28 Dockerfilev2
-rw-r--r--   1 cn  staff      27045 Aug  1 10:19 README.md
-rw-r--r--   1 cn  staff         12 Aug  1 08:53 index.html
-rw-r--r--   1 cn  staff  369484800 Aug  1 10:22 mywebserver4.tar
$ 

$ docker import mywebserver4.tar mywebserver:v5
sha256:ceab9e68c0a74c2e32d2e472eafdd5c056e4432a1ce914e60f038159569b46c4
$ docker images
REPOSITORY                                 TAG                 IMAGE ID            CREATED             SIZE
mywebserver                                v5                  ceab9e68c0a7        4 seconds ago       360MB
mywebserver                                v4                  a2e257123a3d        About an hour ago   464MB

$ docker image history mywebserver:v5
IMAGE               CREATED              CREATED BY          SIZE                COMMENT
ceab9e68c0a7        About a minute ago                       360MB               Imported from -
$ docker image history mywebserver:v4
IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
a2e257123a3d        About an hour ago   /bin/sh -c #(nop)  ENTRYPOINT ["/bin/sh" "-c…   0B                  
234ab3c4d99b        About an hour ago   /bin/sh -c #(nop)  EXPOSE 80                    0B                  
b096e9311fce        About an hour ago   /bin/sh -c #(nop)  VOLUME [/mymount]            0B                  
df94e6bdae5c        About an hour ago   /bin/sh -c #(nop)  ENV ENVIRONMENT=production   0B                  
20cc00cce859        About an hour ago   /bin/sh -c #(nop) COPY file:ca82fdef2f64acb5…   12B                 
6ad91629c66c        About an hour ago   /bin/sh -c yum update -y &&     yum install …   270MB               
5ebb9e2d4706        2 hours ago         /bin/sh -c #(nop)  LABEL maintainer=latest@e…   0B                  
70b5d81549ec        3 months ago        /bin/sh -c #(nop)  CMD ["/bin/bash"]            0B                  
<missing>           3 months ago        /bin/sh -c #(nop)  LABEL name=CentOS Base Im…   0B                  
<missing>           3 months ago        /bin/sh -c #(nop) ADD file:2a39fb46f860e75d7…   195MB   
```

