# Ignoring Files During Docker Build

As our resident Docker expert, President Squawk & the Radar Board have requested your aid in "ignoring" a few configuration files in the ~/content-dockerquest-spacebones/salt-example/salt-master/ directory. Populate the included .dockerignore file to prevent docker build from including incorrect or unneeded files in the build. Once complete, only docker-entrypoint.sh should live on the new image.

Once you have populated .dockerignore, build a new Docker container image named salt-master with the tag :deb.

Login

> ssh cloud_user@18.209.214.210

```bash
The authenticity of host '18.209.214.210 (18.209.214.210)' can't be established.
ECDSA key fingerprint is SHA256:UE+sN0+iPQ+7cJesmyoddnAcwghjsZn0B3BTNl81sDM.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '18.209.214.210' (ECDSA) to the list of known hosts.
cloud_user@18.209.214.210's password:
```

Clone the respository if it does not exist

> git clone https://github.com/linuxacademy/content-dockerquest-spacebones

Revie the contents of the folder

> cd content-dockerquest-spacebones/
> ls

```bash
act1-redo.sh  docker-ce.repo  doge  nodejs-app  README  salt-example  volume
```

Review the contetns of salt-master

> cd salt-master
> ll
total 24
-rw-r--r--. 1 cloud_user cloud_user 133 Aug  8 07:41 badscript.sh
-rw-r--r--. 1 cloud_user cloud_user  84 Aug  8 07:41 docker-entrypoint.sh
-rw-r--r--. 1 cloud_user cloud_user 389 Aug  8 07:41 Dockerfile
-rw-r--r--. 1 cloud_user cloud_user  36 Aug  8 07:41 README.md
-rw-r--r--. 1 cloud_user cloud_user 180 Aug  8 07:41 supervisor-salt.conf
-rw-r--r--. 1 cloud_user cloud_user 184 Aug  8 07:41 supervisor-salt-orig.conf

## Review the contents of the Dockerfile

> cat Dockerfile

```Dockerfile
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

## Add the .dockerignore file

Create a .dockerignore file and add files to be ignored.

> vim .dockerignore

Review the .dockerignore file.

> cat .dockerignore

```bash
badscript.sh
*.conf
README.md
```

Run or image build

> docker build -t salt-master:deb .
