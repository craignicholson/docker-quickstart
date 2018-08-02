#  Dockerfile Options, Structure, and Efficiencies

craig:quickstart02 cn$ docker build -t  mywebserver:v1 .
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
craig:quickstart02 cn$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
craig:quickstart02 cn$ docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
craig:quickstart02 cn$ docker images
REPOSITORY                                 TAG                 IMAGE ID            CREATED             SIZE
mywebserver                                v1                  b056ac4655b2        6 hours ago         362MB
optimied_image                             v1                  284874186ae5        7 hours ago         328MB
custom_image                               v1                  223aac856154        7 hours ago         328MB
optimized                                  v1                  8fca7323a784        7 hours ago         328MB
httpd                                      latest              11426a19f1a2        9 hours ago         178MB
ubuntu                                     latest              735f80812f90        5 days ago          83.5MB
hello-world                                latest              2cb0d9787c4d        3 weeks ago         1.85kB
hello-world                                linux               2cb0d9787c4d        3 weeks ago         1.85kB
multistage                                 latest              45f0135d3b1a        6 weeks ago         210MB
psweb                                      latest              c5d9c54d4154        6 weeks ago         70.4MB
maven                                      latest              878388a112cc        6 weeks ago         635MB
redis                                      latest              b8398957eeef        6 weeks ago         107MB
node                                       latest              4df1f3e94ef9        7 weeks ago         674MB
nginx                                      latest              cd5239a0906a        8 weeks ago         109MB
centos                                     latest              49f7960eb7e4        8 weeks ago         200MB
docker/kube-compose-controller             v0.3.5              59d8ccaa8b0c        2 months ago        29.9MB
docker/kube-compose-api-server             v0.3.5              d32222ae0cf5        2 months ago        42.5MB
k8s.gcr.io/kube-proxy-amd64                v1.10.3             4261d315109d        2 months ago        97.1MB
k8s.gcr.io/kube-scheduler-amd64            v1.10.3             353b8f1d102e        2 months ago        50.4MB
k8s.gcr.io/kube-apiserver-amd64            v1.10.3             e03746fe22c3        2 months ago        225MB
k8s.gcr.io/kube-controller-manager-amd64   v1.10.3             40c8d10b2d11        2 months ago        148MB
centos                                     6                   70b5d81549ec        3 months ago        195MB
k8s.gcr.io/etcd-amd64                      3.1.12              52920ad46f5b        4 months ago        193MB
alpine                                     latest              3fd9065eaf02        6 months ago        4.15MB
k8s.gcr.io/k8s-dns-dnsmasq-nanny-amd64     1.14.8              c2ce1ffb51ed        6 months ago        41MB
k8s.gcr.io/k8s-dns-sidecar-amd64           1.14.8              6f7f2dc7fab5        6 months ago        42.2MB
k8s.gcr.io/k8s-dns-kube-dns-amd64          1.14.8              80cc5ea4b547        6 months ago        50.5MB
k8s.gcr.io/pause-amd64                     3.1                 da86e6ba6ca1        7 months ago        742kB
java                                       8-jdk-alpine        3fd9dd82815c        17 months ago       145MB
cnicholson/simplehttp_autobuild            latest              460d754285d3        3 years ago         523MB
cnicholson/simplehttp                      1.0                 611deadb3a88        3 years ago         523MB
craig:quickstart02 cn$ docker build -t  mywebserver:v1 .
craig:quickstart02 cn$ docker run -d --name testweb1 --rm mywebsrver:v1
Unable to find image 'mywebsrver:v1' locally
docker: Error response from daemon: pull access denied for mywebsrver, repository does not exist or may require 'docker login'.
See 'docker run --help'.
craig:quickstart02 cn$ docker run -d --name testweb1 --rm mywebserver:v1
cf7abd66a977ed0c55a795c3b3cb95e9ff42f2102e7736155583d95326c145d0
craig:quickstart02 cn$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
cf7abd66a977        mywebserver:v1      "/bin/sh -c 'apachec…"   3 seconds ago       Up 2 seconds        80/tcp              testweb1
craig:quickstart02 cn$ docker inspect testweb1 | grep IPAddress
            "SecondaryIPAddresses": null,
            "IPAddress": "172.17.0.2",
                    "IPAddress": "172.17.0.2",
craig:quickstart02 cn$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
cf7abd66a977        mywebserver:v1      "/bin/sh -c 'apachec…"   3 minutes ago       Up 3 minutes        80/tcp              testweb1
craig:quickstart02 cn$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
cf7abd66a977        mywebserver:v1      "/bin/sh -c 'apachec…"   4 minutes ago       Up 3 minutes        80/tcp              testweb1
craig:quickstart02 cn$ ping 172.17.0.2
PING 172.17.0.2 (172.17.0.2): 56 data bytes
Request timeout for icmp_seq 0
Request timeout for icmp_seq 1
Request timeout for icmp_seq 2
Request timeout for icmp_seq 3
^C
--- 172.17.0.2 ping statistics ---
5 packets transmitted, 0 packets received, 100.0% packet loss
craig:quickstart02 cn$ docker stop testweb1
testweb1
craig:quickstart02 cn$ docker history mywebserver:v1 | wc -l
      12
craig:quickstart02 cn$ docker build -t mywebserver:v2 .
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
craig:quickstart02 cn$ docker history mywebserver:v2 | wc -l
      10
craig:quickstart02 cn$ 


# SQUASH A FILE
craig:quickstart02 cn$ docker image history mywebserver:v4
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

craig:quickstart02 cn$ docker run mywebserver:v4
26
craig:quickstart02 cn$ docker ps -a
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                    PORTS               NAMES
41349ad76c1c        mywebserver:v4      "/bin/sh -c 'ls -al …"   3 seconds ago       Exited (0) 1 second ago                       mystifying_wright
craig:quickstart02 cn$ docker export mystifying_wright > mywebserver4.tar
craig:quickstart02 cn$ 


craig:quickstart02 cn$ ls -al
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
craig:quickstart02 cn$ 

craig:quickstart02 cn$ docker import mywebserver4.tar mywebserver:v5
sha256:ceab9e68c0a74c2e32d2e472eafdd5c056e4432a1ce914e60f038159569b46c4
craig:quickstart02 cn$ docker images
REPOSITORY                                 TAG                 IMAGE ID            CREATED             SIZE
mywebserver                                v5                  ceab9e68c0a7        4 seconds ago       360MB
mywebserver                                v4                  a2e257123a3d        About an hour ago   464MB

craig:quickstart02 cn$ docker image history mywebserver:v5
IMAGE               CREATED              CREATED BY          SIZE                COMMENT
ceab9e68c0a7        About a minute ago                       360MB               Imported from -
craig:quickstart02 cn$ docker image history mywebserver:v4
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

## Prepare for a Secure Docker Registry

$ sudo yum install openssl
$ mkdir certs
$ mkdir auth
$ mkdir /home/user/certs

$ openssl req -newkey rsa:4096 -nodes -sha256 -keyout dockerrepo.key -x509 -days 365 -out certs/dockerrepo.crt CN=myregistrydomain.com
$ openssl req -newkey rsa:4096 -nodes -sha256 -keyout certs/dockerrepo.key -x509 -days 365 -out certs/dockerrepo.crt -subj /CN=myregistrydomain.com

$ cd certs/
$ ll
total 8
-rw-rw-r--. 1 user user 1818 Aug  1 23:04 dockerrepo.crt
-rw-rw-r--. 1 user user 3272 Aug  1 23:04 dockerrepo.key

[user@craig-nicholsoneswlb4 certs]$ ifconfig
docker0: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
        inet 172.17.0.1  netmask 255.255.0.0  broadcast 172.17.255.255
        ether 02:42:3a:2f:88:1c  txqueuelen 0  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 9001
        inet 172.31.32.86  netmask 255.255.240.0  broadcast 172.31.47.255
        inet6 fe80::8b4:20ff:fec7:5dee  prefixlen 64  scopeid 0x20<link>
        ether 0a:b4:20:c7:5d:ee  txqueuelen 1000  (Ethernet)
        RX packets 75224  bytes 95734804 (91.2 MiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 32576  bytes 3953015 (3.7 MiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 150  bytes 13180 (12.8 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 150  bytes 13180 (12.8 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
[user@craig-nicholsoneswlb4 certs]$ sudo vim /etc/hosts
[sudo] password for user: 
[user@craig-nicholsoneswlb4 certs]$ cat /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
172.31.43.215 myregistrydomain.com


-- this failed for me i had to create by hand
$ mkdir -p /etc/docker/certs.d/myregistrydomain.com:5000

$ sudo cp /home/user/certs/dockerrepo.crt /etc/docker/certs.d/myregistrydomain.com:5000/ca.crt

$ sudo ll /etc/docker/certs.d/myregistrydomain.com:5000
ca.crt

$ docker run --entrypoint htpasswd registry:2 -Bbn testuser testpassword > auth/htpasswd

$ docker pull registry:2


## Deploy, Configure, Log Into, Push, and Pull an Image in a Registry

docker run -d -p 5000:5000 -v `pwd`/certs:/certs -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/dockerrepo.crt -e REGISTRY_HTTP_TLS_KEY=/certs/dockerrepo.key -v `pwd`/auth:/auth -e REGISTRY_AUTH=htpasswd -e REGISTRY_AUTH_HTPASSWD_REALM="Registry Realm" -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd --name reg registry:2

$ docker run -d -p 5000:5000 -v `pwd`/certs:/certs -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/dockerrepo.crt -e REGISTRY_HTTP_TLS_KEY=/certs/dockerrepo.key -v `pwd`/auth:/auth -e REGISTRY_AUTH=htpasswd -e REGISTRY_AUTH_HTPASSWD_REALM="Registry Realm" -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd --name reg registry:2
87b2f715abd1c148e8b6083710e5debcfe83c75ae95bc6a778ba85d1d098bb61

$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                    NAMES
87b2f715abd1        registry:2          "/entrypoint.sh /etc…"   13 seconds ago      Up 12 seconds       0.0.0.0:5000->5000/tcp   reg

$ docker pull busybox

$ docker tag busybox myregistrydomain.com:5000/my-busybox

docker push myregistrydomain.com:5000/my-busybox
The push refers to repository [myregistrydomain.com:5000/my-busybox]
f9d9e4e6e2f0: Preparing 
no basic auth credentials

$ docker login myregistrydomain.com:5000/my-busybox
Username: testuser
Password:
Error response from daemon: login attempt to https://myregistrydomain.com:5000/v2/ failed with status: 400 Bad Request
IF YOU GET THIS YOU MISSED A STEP SOMEWHERE MOST LIKELY :
  docker run --entrypoint htpasswd registry:2 -Bbn testuser testpassword > auth/htpasswd


$ docker login myregistrydomain.com:5000/my-busybox
Username: testuser
Password: 
WARNING! Your password will be stored unencrypted in /home/user/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded

$ docker push myregistrydomain.com:5000/my-busybox
The push refers to repository [myregistrydomain.com:5000/my-busybox]
f9d9e4e6e2f0: Pushed 
latest: digest: sha256:5e8e0509e829bb8f990249135a36e81a3ecbe94294e7a185cc14616e5fad96bd size: 527

$ docker rmi myregistrydomain.com:5000/my-busybox 
Untagged: myregistrydomain.com:5000/my-busybox:latest
Untagged: myregistrydomain.com:5000/my-busybox@sha256:5e8e0509e829bb8f990249135a36e81a3ecbe94294e7a185cc14616e5fad96bd

$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
busybox             latest              e1ddd7948a1c        25 hours ago        1.16MB
ubuntu              latest              735f80812f90        6 days ago          83.5MB
registry            2                   b2b03e9146e1        3 weeks ago         33.3MB
centos              6                   70b5d81549ec        3 months ago        195MB

$ docker pull myregistrydomain.com:5000/my-busybox 

Using default tag: latest
latest: Pulling from my-busybox
Digest: sha256:5e8e0509e829bb8f990249135a36e81a3ecbe94294e7a185cc14616e5fad96bd
Status: Downloaded newer image for myregistrydomain.com:5000/my-busybox:latest
[user@craig-nicholsoneswlb5 ~]$ docker images
REPOSITORY                             TAG                 IMAGE ID            CREATED             SIZE
busybox                                latest              e1ddd7948a1c        25 hours ago        1.16MB
myregistrydomain.com:5000/my-busybox   latest              e1ddd7948a1c        25 hours ago        1.16MB
ubuntu                                 latest              735f80812f90        6 days ago          83.5MB
registry                               2                   b2b03e9146e1        3 weeks ago         33.3MB
centos                                 6                   70b5d81549ec        3 months ago        195MB

## Managing Images in Your Private Repository

UCP comes in a later editon

## Container Lifecycles - Setting the Restart Policies

When and how to managed when containers need to restart

$ docker run -d --name testweb httpd
3dc0640167c72aa0daf1a66a3358e1984255e8ec480e68d4a3f79484103f6d18

$ docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS               NAMES
3dc0640167c7        httpd               "httpd-foreground"   3 seconds ago       Up 2 seconds        80/tcp              testweb

$ docker stop testweb

$ docker start testweb
testweb

$ docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS               NAMES
3dc0640167c7        httpd               "httpd-foreground"   32 seconds ago      Up 1 second         80/tcp              testweb

$ sudo systemctl restart docker

$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES

$ docker ps -a
CONTAINER ID        IMAGE               COMMAND              CREATED              STATUS                      PORTS               NAMES
3dc0640167c7        httpd               "httpd-foreground"   About a minute ago   Exited (0) 29 seconds ago                       testweb

$ docker container run -d --name testweb --restart always httpd

$ docker container run -d --name testweb --restart always httpd
a1fd0a8187cb94b166ea6fe1733c24b9b8580036fc4c8e2aaae71a8e0967fb0e

$ docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS               NAMES
a1fd0a8187cb        httpd               "httpd-foreground"   15 seconds ago      Up 13 seconds       80/tcp              testweb

$ sudo systemctl restart docker

$ docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS               NAMES
a1fd0a8187cb        httpd               "httpd-foreground"   35 seconds ago      Up 2 seconds        80/tcp              testweb 

$ docker stop testweb
testweb

$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES

$ sudo systemctl restart docker

$ docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED              STATUS              PORTS               NAMES
a1fd0a8187cb        httpd               "httpd-foreground"   About a minute ago   Up 3 seconds        80/tcp              testweb 

$ docker rm testweb
testweb

$ docker container run -d --name testweb --restart unless-stopped httpd
cc48f68d25dbaa762025cf703959818d145477acf07864e1d94f66d194f63208

$ docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS               NAMES
cc48f68d25db        httpd               "httpd-foreground"   3 seconds ago       Up 3 seconds        80/tcp              testweb

$ sudo systemctl restart docker

$ docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS               NAMES
cc48f68d25db        httpd               "httpd-foreground"   22 seconds ago      Up 3 seconds        80/tcp              testweb

$ docker stop testweb
testweb

$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES

$ sudo systemctl restart docker

$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES

SINCE we are missing the always it does not restart...!!!!!!!

$ docker start testweb
testweb

$ docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS               NAMES
cc48f68d25db        httpd               "httpd-foreground"   2 minutes ago       Up 1 second         80/tcp              testweb 

$ sudo systemctl restart docker

$ docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS               NAMES
cc48f68d25db        httpd               "httpd-foreground"   2 minutes ago       Up 3 seconds        80/tcp              testweb