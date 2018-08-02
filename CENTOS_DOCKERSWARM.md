# Docker Swarm Example

- Install Docker on 2 servers on same network (10.0.0.11, 10.0.0.12)
- Open Firewall
- Initiate Docker Swarm
- Add Manager to 10.0.0.11
- Add Node to 10.0.0.12
- Review on Manager

```bash
sudo yum install -y yum-utils device-mapper-persistent-data  lvm2
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce -y
sudo groupadd docker
sudo usermod -aG  docker $USER
sudo systemctl enable docker && sudo systemctl start docker && sudo systemctl status docker

# we are using the private ips for this lab only, external requires more work
# we need to disable the firewall so our docker manager and node can communicate.
sudo systemctl disable firewalld && sudo systemctl stop firewalld

# name the hosts on both 10.0.0.11 and 10.0.0.12 using the private ips
vi /etc/hosts

10.0.0.11 mgr01
10.0.0.12 node01


[cloud_user@ip-10-0-0-11 ~]$ cat /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

10.0.0.11 mgr01
10.0.0.12 node01

# ifconfig to get the IP address
docker swarm init --advertise-addr 10.0.0.11

Swarm initialized: current node (zs1ksnxaramjrogmb6ec2k312) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join --token SWMTKN-1-0qoxmfm6mgh5e6rxagt97vf3jhawgt7vtmbiyyutv5xd7qmjle-2wcu7pibtr8e43617ejm93vxw 10.0.0.11:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.

#$ 10.0.0.12
docker swarm join --token SWMTKN-1-0qoxmfm6mgh5e6rxagt97vf3jhawgt7vtmbiyyutv5xd7qmjle-2wcu7pibtr8e43617ejm93vxw 10.0.0.11:2377

# 10.0.0.11
docker node ls

```