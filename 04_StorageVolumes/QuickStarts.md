# Quick Starts

## Map volume from mac os to nginx 

docker run -d --name testweb -p 80:80 -v /Users/cn:/usr/share/nginx/html  nginx
echo "Docker Volume Example" > /Users/cn/index.html
curl http://localhost/

What to do with this... 

echo "Docker Volume Example" > /Users/cn/www/development/index.html
echo "Docker Volume Example" > /Users/cn/www/production/index.html
echo "Docker Volume Example" > /Users/cn/www/qa/index.html

docker run -d --name testweb -p 8080:80 -v /Users/cn/www/development:/usr/share/nginx/html  nginx
docker run -d --name testweb -p 80:80 -v /Users/cn:/www/production:usr/share/nginx/html  nginx
docker run -d --name testweb -p 8082:80 -v /Users/cn/www/qa:/usr/share/nginx/html  nginx


## Exercise: Creating and Working With Volumes

1. Using the appropriate Docker command, create a storage volume for use by your containers, call the volume 'test-volume'

docker volume create test-volume
test-volume

2. Display all the Docker storage volumes that exist on your local system

docker volume ls
DRIVER              VOLUME NAME
local               test-volume

3. Execute the Docker command that will allow you to display all the attributes of that newly created 'test-volume'

docker volume inspect test-volume
[
    {
        "CreatedAt": "2017-10-18T19:31:42Z",
        "Driver": "local",
        "Labels": {},
        "Mountpoint": "/var/lib/docker/volumes/test-volume/_data",
        "Name": "test-volume",
        "Options": {},
        "Scope": "local"
    }
]

4. Display the location on the host file system where that 'test-volume' exists and note the permissions

ls -al /var/lib/docker/volumes/

[user@tcox2 ~]$ ls -al /var/lib/docker/volumes/test-volume/_data
ls: cannot access /var/lib/docker/volumes/test-volume/_data: Permission denied
[user@tcox2 ~]$ sudo ls -al /var/lib/docker/volumes/test-volume/_data
[sudo] password for user: 
total 0
drwxr-xr-x. 2 root root  6 Oct 18 19:31 .
drwxr-xr-x. 3 root root 18 Oct 18 19:31 ..
[user@tcox2 ~]$ sudo ls -al /var/lib/docker/volumes/test-volume/
total 0
drwxr-xr-x. 3 root root 18 Oct 18 19:31 .
drwx------. 3 root root 42 Oct 18 19:31 ..
drwxr-xr-x. 2 root root  6 Oct 18 19:31 _data


5. Remove the newly created 'test-volume' and then run the command to verify that the volume has been deleted

docker volume rm test-volume

docker volume ls
DRIVER              VOLUME NAME

## Using External Volumes Within Your Containers - mount to docker volume

1. Create a Docker volume called 'http-files' and then list all volumes to confirm it was created

docker volume create http-files

2. Execute the appropriate Docker command to display ALL information on the 'http-files' volume, make a note of the filesystem location that volume is linked to on your host

docker volume ls

3. Pull the 'httpd' image from the standard Docker repository and verify it was installed locally

docker pull httpd

docker images

4. Create an 'index.html' file of your choosing and copy it to the HOST directory that your 'http-files' volume is linked to (obtained in Step #2 above)

sudo - i

[root@tcox3 ~]# echo "This is my test website index file" > /var/lib/docker/volumes/http-files/_data/index.html
[root@tcox3 ~]# cat /var/lib/docker/volumes/http-files/_data/index.html 
This is my test website index file

5. Start a container based on the 'httpd' image with the following characteristics:

  - the container should run in the background (i.e. you are not connected to it in the current terminal)

  - name the container 'test-web'

  - associate the created volume 'http-files' with the container directory path of /usr/local/apache2/htdocs

[root@craig-nicholsoneswlb6 ~]# docker run -d --name test-web -p 80:80 --mount source=http-files,target=/usr/local/apache2/htdocs httpd
e238825ac169053acf5a1ce4827e05bbd3645d31b6835103e059f5d01acfd71e

6. Using the appropriate Docker command, find out the container's IP address and note it

[root@craig-nicholsoneswlb6 ~]# curl localhost
This is my test website index file
[root@craig-nicholsoneswlb6 ~]# 

LOL

[root@craig-nicholsoneswlb6 ~]# docker inspect e238825ac169 | grep IPAddress
            "SecondaryIPAddresses": null,
            "IPAddress": "172.17.0.2",
                    "IPAddress": "172.17.0.2",
[root@craig-nicholsoneswlb6 ~]# 

7. Execute the 'curl' command against that IP address to display the Apache website running on the container, verify the output is from your created 'index.html' file

[root@craig-nicholsoneswlb6 ~]# curl 172.17.0.2
This is my test website index file
[root@craig-nicholsoneswlb6 ~]# 

8. Make a change to the 'index.html' file on the container's host and save the file. Rerun the 'curl' command to verify the container's website is now displaying the new value

[root@craig-nicholsoneswlb6 ~]# echo "This is a CHANGED website file" > /var/lib/docker/volumes/http-files/_data/index.html 
[root@craig-nicholsoneswlb6 ~]# curl 172.17.0.2
This is a CHANGED website file

## Creating a Bind Mount to Link Container Filesystem to Host Filesystem - using type=bind

1. Create a directory in your home directory called 'content'. Within this directory, place a file called 'index.html' containing any text you wish.

```bash
[user@tcox6 ~]$ mkdir content
[user@tcox6 ~]$ echo "This is a test web site in a container" > content/index.html
[user@tcox6 ~]$ ls -al content
total 8
drwxrwxr-x.  2 user user   23 Dec 21 16:32 .
drwx------. 10 user user 4096 Dec 21 16:31 ..
-rw-rw-r--.  1 user user   39 Dec 21 16:32 index.html
```

2. Using the appropriate Docker CE command, download the image called 'httpd:latest' to your system.

```bash
[user@tcox6 ~]$ docker pull httpd
Using default tag: latest
latest: Pulling from library/httpd
f49cf87b52c1: Pull complete 
02ca099fb6cd: Pull complete 
de7acb18da57: Pull complete 
770c8edb393d: Pull complete 
0e252730aeae: Pull complete 
6e6ca341873f: Pull complete 
2daffd0a6144: Pull complete 
Digest: sha256:b5f21641a9d7bbb59dc94fb6a663c43fbf3f56270ce7c7d51801ac74d2e70046
Status: Downloaded newer image for httpd:latest
```

3. Install the 'elinks' web browser to complete testing of your site 

```bash
[user@tcox6 ~]$ sudo yum install elinks
[sudo] password for user: 
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
 * base: mirror.lax.hugeserver.com
 * epel: s3-mirror-us-west-2.fedoraproject.org
 * extras: mirrors.xmission.com
 * nux-dextop: mirror.li.nux.ro
 * updates: mirrors.syringanetworks.net
Resolving Dependencies
--> Running transaction check
---> Package elinks.x86_64 0:0.12-0.36.pre6.el7 will be installed
--> Processing Dependency: libnss_compat_ossl.so.0()(64bit) for package: elinks-0.12-0.36.pre6.el7.x86_64
--> Processing Dependency: libmozjs185.so.1.0()(64bit) for package: elinks-0.12-0.36.pre6.el7.x86_64
--> Running transaction check
---> Package js.x86_64 1:1.8.5-19.el7 will be installed
---> Package nss_compat_ossl.x86_64 0:0.9.6-8.el7 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

====================================================================================================================================================================================================================
 Package                                                Arch                                          Version                                                     Repository                                   Size
====================================================================================================================================================================================================================
Installing:
 elinks                                                 x86_64                                        0.12-0.36.pre6.el7                                          base                                        882 k
Installing for dependencies:
 js                                                     x86_64                                        1:1.8.5-19.el7                                              base                                        2.3 M
 nss_compat_ossl                                        x86_64                                        0.9.6-8.el7                                                 base                                         37 k

Transaction Summary
====================================================================================================================================================================================================================
Install  1 Package (+2 Dependent packages)

Total download size: 3.2 M
Installed size: 9.6 M
Is this ok [y/d/N]: y
Downloading packages:
(1/3): elinks-0.12-0.36.pre6.el7.x86_64.rpm... truncated here...
```

4. Instantiate a container on this single host with the following characteristics:

  * name the container 'testweb'

  * map container port 80 to the host port 80

  * create a bind mapping from the container directory of /usr/local/apache2/htdocs to the local host directory you created above using the complete path

  * base the container on the 'httpd' image downloaded above

  * run the contained in 'detached' mode

```bash
docker run -d --name testweb -p 80:80 --mount type=bind,source=/home/user/content,target=/usr/local/apache2/htdocs httpd
docker run -d --name testweb -p 80:80 --mount type=bind,source=/home/user/content,target=/usr/local/apache2/htdocs httpd
054b6dc6c49aaeb6a7ef7000794c0212eba5ec773b04ba3ff637a402a812220a
```

5. Verify the container is running

[user@tcox6 ~]$ docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS                NAMES
054b6dc6c49a        httpd               "httpd-foreground"   29 seconds ago      Up 27 seconds       0.0.0.0:80->80/tcp   testweb

6. Use 'elinks' to connect to your local IP over port 80 and verify the created index file created above is displayed

[user@craig-nicholsoneswlb6 ~]$ curl localhost
This is a test web site in a container

## Exercise: Display Details About Your Containers and Control the Display of Output

1. Using the appropriate Docker CE commands, download the latest 'nginx' webserver image from Docker Hub.

2. Instantiate a container based on the 'nginx' image from the previous step. This container should have the following characteristics:

  * when started, the container should run in 'detached' mode

  * name the container 'nginxtest'

  * use the appropriate option to allow Docker to map all container service ports to random host ports over 32768

  * the container is based on the 'nginx' image from step one

[user@craig-nicholsoneswlb6 ~]$ docker run -d --name nginxtests -P nginx
c1652432a0c38c9b850c4185995e42963e425711e6eddda0690a9611ca1a990f

REVIEW -P is that all PORTS

[user@craig-nicholsoneswlb6 ~]$ docker inspect nginxtests | grep Port
            "PortBindings": {},
            "PublishAllPorts": true,
            "ExposedPorts": {
            "Ports": {
                        "HostPort": "32768"
[user@craig-nicholsoneswlb6 ~]$ docker inspect nginxtests | grep Ports
            "PublishAllPorts": true,
            "ExposedPorts": {
            "Ports": {
[user@craig-nicholsoneswlb6 ~]$

3. Using the appropriate Docker command, find the CONTAINER IP address ONLY (use the aforementioned appropriate command and JUST display the IP address using its built in options)

user@craig-nicholsoneswlb6 ~]$ docker inspect nginxtests | grep IPAddress
            "SecondaryIPAddresses": null,
            "IPAddress": "172.17.0.3",
                    "IPAddress": "172.17.0.3",

[user@craig-nicholsoneswlb6 ~]$ docker container inspect --format="{{.NetworkSettings.Networks.bridge.IPAddress}}" nginxtests
172.17.0.3

## Working with the DeviceMapper Storage Driver - Scenario

Your development team has been working on their understanding of Docker in general and Docker Swarms in particular. They are experimenting with different ways of understanding and optimizing storage on the underlying hosts. As a result, they have asked for your assistance in comparing traditional host based default storage on a Docker host with the 'devicemapper' storage driver on a second Docker host.

Comparing

- traditional host based default storage on a Docker host node1
- 'devicemapper' storage driver on a second Docker host node2

They have provided you with the credentials to connect to two hosts for this activity. You have been asked to install and configure Docker, enabled so that it starts on boot, on both hosts.

On the first host, they would like the default storage subsystem to be left as is. On the second host, they would llike you to change the Docker storage subsystem to the 'devicemapper' driver. This will enable them to compare image and container storage utilization using LVM thin provisioning vs. standard storage.

On each host, once configured, install the following images for their use and then turn the systems over to them once you verify their installation:













## Configuring Containers to Use Host Storage Mounts

CENARIOS
In their continuing quest to containerize their new Web-based API, the development team would like to experiment with containers that use the underlying host's storage system in order to be able to do quick site builds without having to recycle the containers themselves.

As a result, you have been provided the credentials and access to a single development server. They have asked that you install Docker CE and configure it so that it starts on boot. Once done, please pull down the latest 'httpd' image from the default repository to the local filesystem and verify it is present.

Create two directories that will be designed to house two separate versions of their test website (call them 'version1' and 'version2' for example, however, you can use whatever name you wish). Once created, for testing, create a simple 'index.html' file in each so that you can easily differentiate each directory when viewed.

Finally, instantiate two containers. Name them 'test-web1' and 'test-web2' that are based on the 'httpd' image installed earlier. Be sure to redirect the underlying directories (version1 and version2 respectively if those are the directories you created), so that each container has access to one of those directories as the default site directory (for this image, that would be '/usr/local/apache2/htdocs') within the container.

Verify that the directories are serving the content of each container using a text based web browser (like 'lynx' or 'elinks'). NOTE: You will have to obtain each container's assigned IP in order to complete your test, so be sure to use the appropriate command to get that information.

Once you have completed that verification, you can turn the server over to your Dev Team for their testing and use.

