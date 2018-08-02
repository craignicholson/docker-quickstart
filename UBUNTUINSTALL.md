# Ubunutu Install

If anything fails check the references at the bottom of the markdown.

## Docker File

Docker Built to create our on image.

## tl;dr install

```bash
sudo apt-get remove docker docker-engine docker.io
sudo apt-get update
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install docker-ce

sudo cat /etc/group | grep docker
sudo groupadd docker
sudo usermod -aG  docker $USER

# Log out and log back in so that your group membership is re-evaluated.
sudo docker run hello-world
sudo docker pull httpd

# is this needed on ubuntu???
# Configure docker to run on boot
# sudo systemctl enable docker

# Configure docker to not run on boot
#sudo systemctl disable docker

```

## tl;dr uninstall

```bash
# I should stop docker first... right
sudo apt-get purge docker-ce
sudo rm -rf /var/lib/docker
```

File Here:

```bash

curl -fsSL get.docker.com -o get-docker.sh
sudo sh get-docker.sh

```

## Step by Step

## References

https://docs.docker.com/install/linux/docker-ce/ubuntu/
