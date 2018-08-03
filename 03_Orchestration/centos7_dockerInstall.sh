# ssh into your server
# run this script, and enter your sudo pwd when prompted
# sudo bash <(curl -s https://raw.githubusercontent.com/craignicholson/docker-quickstart/master/03_Orchestration/centos7_dockerInstall.sh)
sudo yum install -y yum-utils device-mapper-persistent-data  lvm2
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce -y
sudo groupadd docker
sudo usermod -aG  docker $USER
sudo systemctl enable docker && sudo systemctl start docker 
sudo yum-complete-transaction -y
#sudo systemctl status docker
#sudo systemctl disable firewalld && sudo systemctl stop firewalld