sudo yum install -y yum-utils device-mapper-persistent-data  lvm2
sudo yum-complete-transaction -y
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce -y
sudo groupadd docker
sudo usermod -aG  docker $USER
sudo systemctl enable docker && sudo systemctl start docker && sudo systemctl status docker
#sudo systemctl disable firewalld && sudo systemctl stop firewalld