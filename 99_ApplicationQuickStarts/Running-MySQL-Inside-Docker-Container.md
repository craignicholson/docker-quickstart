# Running MySQL Inside a Docker Container

1.Install Docker and configure the service so that it is running.

```bash
sudo -su
sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine

bash  <(https://raw.githubusercontent.com/craignicholson/docker-quickstart/master/01_InstallationConfiguration/centos7_dockerInstall.sh)

# logout and back in to make sure we run command with @USER acccount
hostname server1
hostname server2


```

2.Pull the MySQL Docker container from Docker Hub.

```bash
docker pull mysql:latest
```

3.Instantiate a container from that image, called 'test1-mysql', check the MySQL documentation from the Docker Hub instance to be sure it is started with the necessary parameters.

```bash
docker run -d --name test_mysql --env="MYSQL_ROOT_PASSWORD=mypassword" mysql
0f02c8585327e0a5c50459caf1db95a424488d45c7119fad25bf722fef7fa574


```

4.Verify the container is running using the appropriate Docker commands.

```bash
[linuxacademy@localhost ~]$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                 NAMES
0f02c8585327        mysql               "docker-entrypoint.s…"   2 seconds ago       Up 2 seconds        3306/tcp, 33060/tcp   test_mysql

```

5.Note the IP address of the container using the appropriate Docker commands.

```bash
[linuxacademy@localhost ~]$ docker inspect test_mysql | grep IPAddress
            "SecondaryIPAddresses": null,
            "IPAddress": "172.17.0.2",
                    "IPAddress": "172.17.0.2",
[linuxacademy@localhost ~]$ docker inspect test_mysql --format="{{.NetworkingSettings.Networks.bridge.IPAddress}}"

Template parsing error: template: :1:21: executing "" at <.NetworkingSettings....>: map has no entry for key "NetworkingSettings"
[linuxacademy@localhost ~]$ docker inspect test_mysql --format="{{ .NetworkingSettings.Networks.bridge.IPAddress}}"

Template parsing error: template: :1:22: executing "" at <.NetworkingSettings....>: map has no entry for key "NetworkingSettings"
[linuxacademy@localhost ~]$ docker inspect test_mysql --format="{{ .NetworkSettings.Networks.bridge.IPAddress}}"
172.17.0.2

```

6.Install the MySQL client on the underlying host system (lab server).

```bash
sudo yum install -y mysql
```

7.Connect to the MySQL container instance via the MySQL client and log in.

```bash
https://downloads.mariadb.org/mariadb/repositories/#mirror=rackspace&distro=CentOS&distro_release=centos7-ppc64le--centos7&version=10.3

[linuxacademy@localhost ~]$ mysql -h 172.17.0.2 
ERROR 2059 (HY000): Authentication plugin 'caching_sha2_password' cannot be loaded: /usr/lib64/mysql/plugin/caching_sha2_password.so: cannot open shared object file: No such file or directory
[linuxacademy@localhost ~]$ mysql -h 172.17.0.2 -p mypassword
Enter password: 
ERROR 2059 (HY000): Authentication plugin 'caching_sha2_password' cannot be loaded: /usr/lib64/mysql/plugin/caching_sha2_password.so: cannot open shared object file: No such file or directory

mysql -h MYSQL-DB-SERVER-IP-ADDRESS-HERE -p

```

8.List the databases in the container using the MySQL client to verify functionality.

```bash
msql show databases;
```

9.Stop the container instance, and verify it has stopped.

```bash
docker stop test_mysql
```

10.Delete the MySQL container completely from the host system.

```bash
docker rm test_mysql
```

11.List all stopped containers to verify it has been removed.

```bash
docker ps
```
