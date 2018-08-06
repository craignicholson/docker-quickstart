# Series of Examples using Dockers deploying Applications

## User docker to deploy a static website

Pull the lastest centos:6 image which we will install several packates and a web application.

> docker pull centos:6

Run the image in interactive mode so we can setup our server.

> docker run -it --name websetup centos:6 /bin/bash

While in interactive mode install the require packages

> yum upgrade -y && yum install httpd -y &&  yum install git -y

Clone your favorite staic web site.

> git clone https://github.com/linuxacademy/content-dockerquest-spacebones

Move the content from the clone folder to /var/www/html

> cp content-dockerquest-spacebones/doge/* /var/www/html

Back up the httdp conf

> mv /etc/httpd/conf.d/welcome.conf /etc/httpd/conf.d/welcome.conf.bak

Turn on httpd

> chkconfig httpd on

Exit out of interactive mode.

> exit

Display our container so we can get the container id.

> docker ps -a

CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                          PORTS               NAMES
a2f4c2459655        centos:6            "/bin/bash"         7 minutes ago       Exited (0) About a minute ago                       websetup

Save our image with our own name.

> docker commit a2f4c2459655 spacebones:thewebsite

Run the container in detached mode.  We need to pass in -DFOREGROUND as the entrypoint so the container continues to run.

> docker run -d --name testweb -p 80:80 spacebones:thewebsite /usr/sbin/apachectl -DFOREGROUND

Check to see if the container is running.

> docker ps

Check the website using curl, or drop the url in your broweser.

> curl http://localhost/


## Node.js App

Learning Activity Guide
close
Instructions
Using the example Dockerfile included in activity instructions, use Docker to build a new Node.js app image using the files under the content-dockerquest-spacebones/nodejs-app subdirectory, named baconator. Be sure to tag the image as dev. Good luck!

Clone the content-dockerquest-spacebones GitHub repo

> git clone https://github.com/linuxacademy/content-dockerquest-spacebones

Move into the nodejs-app subdirectory

> cd ~/content-dockerquest-spacebones/nodejs-app
Use the Dockerfile below to build a new image

```bash
FROM node:7
WORKDIR /app
COPY package.json /app
RUN npm install
COPY . /app
CMD node index.js
EXPOSE 8081
```
build container image

> docker build -t baconator:dev .
(optional) Run the image to verify functionality

> docker run -d -p 80:8081 baconator

## Optimizing Docker Builds with OnBuild

https://docs.docker.com/engine/reference/builder/#onbuild

As the Radar Board prepares to integrate Saltstack with their environment using Docker images, they have requested your aid with preparing a parent image for what will eventually become the master node, using OnBuild. Using the Dockerfile included under ~/content-dockerquest-spacebones/salt-example/salt-master/, create a new parent image for the salt-master build named tablesalt:master that executes all commands against docker-entrypoint.sh on any child images created from the parent image. Good luck!

> git clone https://github.com/linuxacademy/content-dockerquest-spacebones

cd content-dockerquest-spacebones
cd salt-example/
salt-example]$ ls
salt-master  salt-minion
cd salt-master/

cat Dockerfile 

```docker
FROM jarfil/salt-master-mini:debian-stretch

MAINTAINER Jaroslaw Filiochowski <jarfil@gmail.com>

COPY . /

RUN apt-get -y update && \
	apt-get -y upgrade && \
	apt-get -y install \
		salt-minion \
		salt-ssh \
		salt-cloud && \
	apt-get -y autoremove && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/

RUN chmod +x \
	/docker-entrypoint.sh

EXPOSE 4505 4506

CMD /docker-entrypoint.sh
```

Optimize with ONBUILD

```docker
FROM jarfil/salt-master-mini:debian-stretch

MAINTAINER Jaroslaw Filiochowski <jarfil@gmail.com>

COPY . /

RUN apt-get -y update && \
	apt-get -y upgrade && \
	apt-get -y install \
		salt-minion \
		salt-ssh \
		salt-cloud && \
	apt-get -y autoremove && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/

ONBUILD RUN chmod +x \
	/docker-entrypoint.sh

EXPOSE 4505 4506

ONBUILD CMD /docker-entrypoint.sh
```

docker images
REPOSITORY                          TAG                 IMAGE ID            CREATED             SIZE
tablesalt                           master              99032b077f10        8 seconds ago       529 MB

Note we should be all the apt-gets into one layer

docker history tablesalt:master
IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
99032b077f10        2 minutes ago       /bin/sh -c #(nop)  ONBUILD CMD /docker-ent...   0 B                 
a02260f8f4ee        2 minutes ago       /bin/sh -c #(nop)  EXPOSE 4505/tcp 4506/tcp     0 B                 
9b3babcf7f88        2 minutes ago       /bin/sh -c #(nop)  ONBUILD RUN chmod +x  /...   0 B                 
5f2ff1d1606f        2 minutes ago       /bin/sh -c apt-get -y update &&  apt-get -...   179 MB              
f8811b731ff1        3 minutes ago       /bin/sh -c #(nop) COPY dir:7778269fb334120...   1.13 kB             
4e6f8b189482        3 minutes ago       /bin/sh -c #(nop)  MAINTAINER Jaroslaw Fil...   0 B                 
4138c0e46c20        4 months ago        /bin/sh -c #(nop)  CMD ["/bin/sh" "-c" "/d...   0 B                 
<missing>           4 months ago        /bin/sh -c #(nop)  EXPOSE 4505/tcp 4506/tcp     0 B                 
<missing>           4 months ago        /bin/sh -c chmod +x  /docker-entrypoint.sh      54 B                
<missing>           4 months ago        /bin/sh -c apt-get -y update &&  apt-get -...   98.7 MB             
<missing>           4 months ago        /bin/sh -c #(nop) COPY file:4b1fb803999ef8...   54 B                
<missing>           4 months ago        /bin/sh -c #(nop)  MAINTAINER Jaroslaw Fil...   0 B                 
<missing>           4 months ago        /bin/sh -c apt-get -y update &&  apt-get -...   151 MB              
<missing>           4 months ago        /bin/sh -c #(nop)  MAINTAINER Jaroslaw Fil...   0 B                 
<missing>           4 months ago        /bin/sh -c #(nop)  CMD ["bash"]                 0 B                 
<missing>           4 months ago        /bin/sh -c #(nop) ADD file:b380df301ccb5ca...   100 MB  
