# docker-quickstarts

## Outline

- [CentOS 7 Install Notes](CENTOSINSTALL.md)
- [Ubuntu 16.04 Install Notes](UBUNTUINSTALL.md)

## CentOS setup

sudu -s


1  bash script.sh
    3  yum install -y yum-utils device-mapper-persistent-data lvm2
    5  yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    6  yum update
    7  yum install docker-ce
    8  yum-complete-transaction --cleanup-only
   18  systemctl enable docker && systemctl start docker && systemctl status docker
   19  cd /var/run/
   20  ls -al
   21  ls -al docker.sock
   22  usermod -aG docker user
   23  docker images
   25  exit
   
  
   
[user@craig-nicholsoneswlb1 ~]$ history
    1  ls
    2  womai
    3  whoami
    4  sudo -su
    5  sudo 
    6  sudo -u
    7  whoami
    8  sudo su
    9  logout
   10  docker images
   11  docker info
   12  docker info | grep Storage
   13  history
   14  sudo si
   15  sudo -s
   16  history
[user@craig-nicholsoneswlb1 ~]$ 

## CentOs Change Storage Driver
Storage Drivers - for volumes???
depending on docker-ce or docker-ee and which OS the storage driver picked will allow for efficeinties
CentOS Support - DeviceMapper
BlockStorage Device - actual DISK
How do you tell what your docker storage adapter is?
docker info
docker info | grep Storage
overlay2
on mac
ee supports devicemapper
sudo su - cd /etc/docker
look for key.json
vi daemon.json
{ "storage driver": "devicemapper"}
now we have to restart docker
you should do this before you create or import images
systemctl stop docker
sysmctl start docker
cd /var/lib/docker
ls -ll
cd devicemapper


[user@craig-nicholsoneswlb1 ~]$ docker info | grep Storage
WARNING: devicemapper: usage of loopback devices is strongly discouraged for production use.
         Use `--storage-opt dm.thinpooldev` to specify a custom block storage device.
Storage Driver: devicemapper
[user@craig-nicholsoneswlb1 ~]$ 

[root@craig-nicholsoneswlb1 user]# ls -al /var/lib/docker/
total 8
drwx--x--x. 15 root root 4096 Jul 22 00:53 .
drwxr-xr-x. 49 root root 4096 Jul 21 22:19 ..
drwx------.  2 root root   23 Jul 21 22:19 builder
drwx------.  4 root root   87 Jul 21 22:19 buildkit
drwx------.  3 root root   19 Jul 21 22:19 containerd
drwx------.  2 root root    6 Jul 21 22:19 containers
drwx------.  4 root root   40 Jul 21 22:19 devicemapper
drwx------.  3 root root   25 Jul 21 22:19 image
drwxr-x---.  3 root root   18 Jul 21 22:19 network
drwx------.  4 root root   30 Jul 21 22:19 plugins
drwx------.  2 root root    6 Jul 22 00:53 runtimes
drwx------.  2 root root    6 Jul 21 22:19 swarm
drwx------.  2 root root    6 Jul 22 00:53 tmp
drwx------.  2 root root    6 Jul 21 22:19 trust
drwx------.  2 root root   24 Jul 21 22:19 volumes

[root@craig-nicholsoneswlb1 user]# ls -al /var/lib/docker/devicemapper/
total 4
drwx------.  4 root root   40 Jul 21 22:19 .
drwx--x--x. 15 root root 4096 Jul 22 00:53 ..
drwx------.  2 root root   32 Jul 21 22:19 devicemapper
drwx------.  2 root root   69 Jul 22 00:52 metadata
[root@craig-nicholsoneswlb1 user]# ls -al /var/lib/docker/devicemapper/devicemapper/
total 11336
drwx------. 2 root root           32 Jul 21 22:19 .
drwx------. 4 root root           40 Jul 21 22:19 ..
-rw-------. 1 root root 107374182400 Jul 21 22:19 data
-rw-------. 1 root root   2147483648 Jul 22 00:54 metadata
[root@craig-nicholsoneswlb1 user]# ls -al /var/lib/docker/devicemapper/devicemapper/data 
-rw-------. 1 root root 107374182400 Jul 21 22:19 /var/lib/docker/devicemapper/devicemapper/data
[root@craig-nicholsoneswlb1 user]# 

root@craig-nicholsoneswlb1 docker]# docker image pull httpd
Using default tag: latest
latest: Pulling from library/httpd
d660b1f15b9b: Pull complete 
aa1c79a2fa37: Pull complete 
f5f6514c0aff: Pull complete 
676d3dd26040: Pull complete 
4fdddf845a1b: Pull complete 
28ecdadc5f88: Pull complete 
5d882098e42b: Pull complete 
Digest: sha256:2edbf09d0dbdf2a3e21e4cb52f3385ad916c01dc2528868bc3499111cc54e937
Status: Downloaded newer image for httpd:latest
[root@craig-nicholsoneswlb1 docker]# docker container run -d httpd testweb
96007e40dc4ecc7ee4ba759ea7eceee3842a8194feff636d01d27d3268d864f1
docker: Error response from daemon: OCI runtime create failed: container_linux.go:348: starting container process caused "exec: \"testweb\": executable file not found in $PATH": unknown.
[root@craig-nicholsoneswlb1 docker]# docker container run -d --name testweb httpd
372d863f15556126e5b4b6cf11fc35faa1cf47f8551203c64c770a90d7d88f04
[root@craig-nicholsoneswlb1 docker]# docker container inspect | grep IPAd
"docker container inspect" requires at least 1 argument.
See 'docker container inspect --help'.
Usage:  docker container inspect [OPTIONS] CONTAINER [CONTAINER...]
Display detailed information on one or more containers
[root@craig-nicholsoneswlb1 docker]# docker container inspect | grep IPAddr
"docker container inspect" requires at least 1 argument.
See 'docker container inspect --help'.
Usage:  docker container inspect [OPTIONS] CONTAINER [CONTAINER...]
Display detailed information on one or more containers
[root@craig-nicholsoneswlb1 docker]# docker container inspect testweb | grep IPAddr
            "SecondaryIPAddresses": null,
            "IPAddress": "172.17.0.2",
                    "IPAddress": "172.17.0.2",
[root@craig-nicholsoneswlb1 docker]# yum install telnet elinks
Loaded plugins: fastestmirror

root@craig-nicholsoneswlb1 docker]# yum install telnet elinks
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
 * base: mirror.keystealth.org
 * epel: mirrors.cat.pdx.edu
 * extras: centos.s.uw.edu
 * nux-dextop: mirror.li.nux.ro
 * updates: centos.s.uw.edu
Resolving Dependencies
--> Running transaction check
---> Package elinks.x86_64 0:0.12-0.37.pre6.el7 will be installed
--> Processing Dependency: libnss_compat_ossl.so.0()(64bit) for package: elinks-0.12-0.37.pre6.el7.x86_64
--> Processing Dependency: libmozjs185.so.1.0()(64bit) for package: elinks-0.12-0.37.pre6.el7.x86_64
---> Package telnet.x86_64 1:0.17-64.el7 will be installed
--> Running transaction check
---> Package js.x86_64 1:1.8.5-20.el7 will be installed
---> Package nss_compat_ossl.x86_64 0:0.9.6-8.el7 will be installed
--> Finished Dependency Resolution
Dependencies Resolved
==========================================================================================================================================================
 Package                                  Arch                            Version                                     Repository                     Size
==========================================================================================================================================================
 55  yum install telnet elinks
   56  docker container inspect testweb | grep IPAddr
   57  elinks 172.17.0.2
   58  clear
   59  history
[root@craig-nicholsoneswlb1 docker]# 

[root@craig-nicholsoneswlb1 etc]# vi rsyslog.conf

Uncomment 2 lines

# Provides TCP syslog reception
#$ModLoad imtcp
#$InputTCPServerRun 514


[root@craig-nicholsoneswlb1 etc]# systemctl start rsyslog
[root@craig-nicholsoneswlb1 etc]# systemctl status rsyslog
● rsyslog.service - System Logging Service
   Loaded: loaded (/usr/lib/systemd/system/rsyslog.service; enabled; vendor preset: enabled)
   Active: active (running) since Sun 2018-07-22 00:53:07 UTC; 25min ago
     Docs: man:rsyslogd(8)
           http://www.rsyslog.com/doc/
 Main PID: 1104 (rsyslogd)
    Tasks: 3
   Memory: 2.9M
   CGroup: /system.slice/rsyslog.service
           └─1104 /usr/sbin/rsyslogd -n
Jul 22 00:53:07 craig-nicholsoneswlb1.mylabserver.com systemd[1]: Starting System Logging Service...
Jul 22 00:53:07 craig-nicholsoneswlb1.mylabserver.com rsyslogd[1104]:  [origin software="rsyslogd" swVersion="8.24.0" x-pid="1104" x-info="http:/... start
Jul 22 00:53:07 craig-nicholsoneswlb1.mylabserver.com systemd[1]: Started System Logging Service.
Hint: Some lines were ellipsized, use -l to show in full.
[root@craig-nicholsoneswlb1 etc]# cd docker/
[root@craig-nicholsoneswlb1 docker]# ls
key.json
[root@craig-nicholsoneswlb1 docker]# vim daemon.json
[root@craig-nicholsoneswlb1 docker]# 







daemon.json
{
        "log-driver" : "syslog",
        "log-opts": {
                "syslog-address" : "udp://172.31.113.224:514"
        }
}


[root@craig-nicholsoneswlb1 etc]# cd docker/
[root@craig-nicholsoneswlb1 docker]# cat daemon.json 
{
        "log-driver" : "syslog",
        "log-opts": {
                "syslog-address" : "udp://172.31.113.224:514"
        }
}
[root@craig-nicholsoneswlb1 docker]# systemctl restart docker
[root@craig-nicholsoneswlb1 docker]# docker info | grep Logging
WARNING: devicemapper: usage of loopback devices is strongly discouraged for production use.
         Use `--storage-opt dm.thinpooldev` to specify a custom block storage device.
Logging Driver: syslog

Jul 22 01:39:15 craig-nicholsoneswlb1 dockerd: time="2018-07-22T01:39:15.339810481Z" level=error msg="Handler for GET /v1.38/containers/testweb/logs retur
ned error: configured logging driver does not support reading"

[root@craig-nicholsoneswlb1 user]# docker logs testweb
Error response from daemon: configured logging driver does not support reading
[root@craig-nicholsoneswlb1 user]# curl GET http://localhost
curl: (6) Could not resolve host: GET; Unknown error
<html><body><h1>It works!</h1></body></html>
[root@craig-nicholsoneswlb1 user]# curl -X  http://localhost
curl: no URL specified!
curl: try 'curl --help' or 'curl --manual' for more information
[root@craig-nicholsoneswlb1 user]# curl  http://localhost
<html><body><h1>It works!</h1></body></html>
[root@craig-nicholsoneswlb1 user]# curl  http://localhost:80
<html><body><h1>It works!</h1></body></html>
[root@craig-nicholsoneswlb1 user]# docker stop testweb
testweb
[root@craig-nicholsoneswlb1 user]# docker rm testweb
testweb
[root@craig-nicholsoneswlb1 user]# docker container run -d --name testjson --log-driver json-file httpd
f6209c6fe44c57a448f656dc4850b812db718231d8ec1ab95116d6fd4dc676f6
[root@craig-nicholsoneswlb1 user]# docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS               NAMES
f6209c6fe44c        httpd               "httpd-foreground"   5 seconds ago       Up 4 seconds        80/tcp              testjson
[root@craig-nicholsoneswlb1 user]# docker logs
"docker logs" requires exactly 1 argument.
See 'docker logs --help'.
Usage:  docker logs [OPTIONS] CONTAINER
Fetch the logs of a container
[root@craig-nicholsoneswlb1 user]# docker logs testjson
AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 172.17.0.2. Set the 'ServerName' directive globally to suppre
ss this message
AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 172.17.0.2. Set the 'ServerName' directive globally to suppre
ss this message
[Sun Jul 22 01:43:18.975697 2018] [mpm_event:notice] [pid 1:tid 140311907870592] AH00489: Apache/2.4.34 (Unix) configured -- resuming normal operations
[Sun Jul 22 01:43:18.982186 2018] [core:notice] [pid 1:tid 140311907870592] AH00094: Command line: 'httpd -D FOREGROUND'
[root@craig-nicholsoneswlb1 user]# 







## SWARM


