1. Install Docker and configure it so that it is running and will automatically start on boot.

[user@tcox4 ~]$ sudo yum install docker -y
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
 * base: centos.mirrors.tds.net
 * epel: fedora-epel.mirrors.tds.net
 * extras: mirrors.tripadvisor.com
 * nux-dextop: li.nux.ro
 * updates: mirror.net.cen.ct.gov
Resolving Dependencies
--> Running transaction check
---> Package docker.x86_64 2:1.12.6-55.gitc4618fb.el7.centos will be installed

[... more YUM stuff here ...]

Installed:
  docker.x86_64 2:1.12.6-55.gitc4618fb.el7.centos                                                                                                          

Dependency Installed:
  container-selinux.noarch 2:2.21-2.gitba103ac.el7                             container-storage-setup.noarch 0:0.6.0-1.gite67c964.el7                    
  device-mapper-event.x86_64 7:1.02.140-8.el7                                  device-mapper-event-libs.x86_64 7:1.02.140-8.el7                           
  device-mapper-persistent-data.x86_64 0:0.7.0-0.1.rc6.el7                     docker-client.x86_64 2:1.12.6-55.gitc4618fb.el7.centos                     
  docker-common.x86_64 2:1.12.6-55.gitc4618fb.el7.centos                       libaio.x86_64 0:0.3.109-13.el7                                             
  lvm2.x86_64 7:2.02.171-8.el7                                                 lvm2-libs.x86_64 7:2.02.171-8.el7                                          
  oci-register-machine.x86_64 1:0-3.11.1.gitdd0daef.el7                        oci-systemd-hook.x86_64 1:0.1.12-1.git1e84754.el7                          
  oci-umount.x86_64 2:1.12.6-55.gitc4618fb.el7.centos                          skopeo-containers.x86_64 1:0.1.23-1.git1bbd87f.el7                         
  yajl.x86_64 0:2.0.4-4.el7                                                   

Complete!
[user@tcox4 ~]$ 
sudo systemctl enable docker && sudo systemctl start docker
[sudo] password for user: 
Created symlink from /etc/systemd/system/multi-user.target.wants/docker.service to /usr/lib/systemd/system/docker.service.

2. Using the appropriate Docker commands pull the latest 'Ubuntu' image from the repository so that it is available for container instantiation on your local system.

[user@tcox4 ~]$ sudo docker pull ubuntu:latest
Trying to pull repository docker.io/library/ubuntu ... 
latest: Pulling from docker.io/library/ubuntu

ae79f2514705: Pull complete 
5ad56d5fc149: Pull complete 
170e558760e8: Pull complete 
395460e233f5: Pull complete 
6f01dc62e444: Pull complete 
Digest: sha256:506e2d5852de1d7c90d538c5332bd3cc33b9cbd26f6ca653875899c505c82687
3. Display the images currently installed on the local system to confirm that the 'Ubuntu' image is available from the prior step.

[user@tcox4 ~]$ sudo docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
docker.io/ubuntu    latest              747cb2d60bbe        7 days ago          122 MB
4. Tag the 'ubuntu:latest' image that you have downloaded so that you can refer to it with a shorter name. Choose to tag the image with the name and tag 'my:ubuntu'

[user@tcox4 ~]$ sudo docker tag ubuntu:latest my:ubuntu
5. Display the resulting image list on your system to confirm the previous command

[user@tcox4 ~]$ sudo docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
docker.io/ubuntu    latest              747cb2d60bbe        7 days ago          122 MB
my                  ubuntu              747cb2d60bbe        7 days ago          122 MB