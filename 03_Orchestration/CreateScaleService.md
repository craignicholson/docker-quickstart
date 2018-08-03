# Quick Examples

## Create a swarm cluster

bash script
Install docker on 3 servers.
Update /etc/hosts on each server
Initiatlize a swarm
join the 2 nodes.

## Start a Service and Scale It Within Your Swarm

Execute the appropriate command on your manager to display the current manager and node list in your swarm cluster

```bash
docker node ls
ID                            HOSTNAME                                STATUS              AVAILABILITY        MANAGER STATUS      ENGINE VERSION
snuv4c6j0c1fhjoyyzlk9kfd8 *   craig-nicholsoneswlb4.mylabserver.com   Ready               Active              Leader              18.06.0-ce
ny86k7pdofcjjzfhkk533ipet     craig-nicholsoneswlb5.mylabserver.com   Ready               Active                                  18.06.0-ce
```

Create a service in your swarm cluster with the following attributes:

Name the application "devweb"
Remap/Redirect the underlying host environment's port 80 to the service application port 80
Base the service off of the default 'httpd' image that is available on the Docker Hub (default repository)

```bash
docker service create --name devweb --publish 80:80 httpd
docker service create --name devweb -p 80:80 httpd
```

Display the current services that are running on your cluster with the number of replicas each has

```bash
docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
scfic6w0paa0        devweb              replicated          1/1                 httpd:latest        *:80->80/tcp
```

Execute the command that will tell you which node the service is currently running on

```bash
docker service ps devweb
ID                  NAME                IMAGE               NODE                                    DESIRED STATE       CURRENT STATE           ERROR               PORTS
ebt6n9p6hdob        devweb.1            httpd:latest        craig-nicholsoneswlb4.mylabserver.com   Running             Running 4 minutes ago            ```


Scale up your service so that it is running THREE replicas and verify by listing the nodes that the service is running on in your environment

```bash

docker service update --replicas 3 --detach=false devweb

docker service update --replicas 3 devweb
devweb
overall progress: 3 out of 3 tasks 
1/3: running   [==================================================>] 
2/3: running   [==================================================>] 
3/3: running   [==================================================>] 
verify: Service converged 
[user@craig-nicholsoneswlb4 ~]$ docker service ps devweb
ID                  NAME                IMAGE               NODE                                    DESIRED STATE       CURRENT STATE                ERROR               PORTS
ebt6n9p6hdob        devweb.1            httpd:latest        craig-nicholsoneswlb4.mylabserver.com   Running             Running 15 minutes ago                           
n9xc3mfcb089        devweb.2            httpd:latest        craig-nicholsoneswlb6.mylabserver.com   Running             Running about a minute ago                       
luba2kiy78yq        devweb.3            httpd:latest        craig-nicholsoneswlb5.mylabserver.com   Running             Running about a minute ago                 


docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
scfic6w0paa0        devweb              replicated          3/3                 httpd:latest        *:80->80/tcp
[user@craig-nicholsoneswlb4 ~]$ docker service ps devweb
ID                  NAME                IMAGE               NODE                                    DESIRED STATE       CURRENT STATE            ERROR               PORTS
ebt6n9p6hdob        devweb.1            httpd:latest        craig-nicholsoneswlb4.mylabserver.com   Running             Running 16 minutes ago                       
n9xc3mfcb089        devweb.2            httpd:latest        craig-nicholsoneswlb6.mylabserver.com   Running             Running 2 minutes ago                        
luba2kiy78yq        devweb.3            httpd:latest        craig-nicholsoneswlb5.mylabserver.com   Running             Running 2 minutes ago 

```

Scale back down your service so that it is running TWO replicas and verify by listing the nodes that the service is running on in your environment

```bash
[user@craig-nicholsoneswlb4 ~]$ docker service update --replicas 2 devweb --detach=false
devweb
overall progress: 2 out of 2 tasks 
1/2: running   [==================================================>] 
2/2: running   [==================================================>] 
verify: Service converged 
[user@craig-nicholsoneswlb4 ~]$ docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
scfic6w0paa0        devweb              replicated          2/2                 httpd:latest        *:80->80/tcp
[user@craig-nicholsoneswlb4 ~]$ docker service ps devweb
ID                  NAME                IMAGE               NODE                                    DESIRED STATE       CURRENT STATE            ERROR               PORTS
ebt6n9p6hdob        devweb.1            httpd:latest        craig-nicholsoneswlb4.mylabserver.com   Running             Running 17 minutes ago                       
n9xc3mfcb089        devweb.2            httpd:latest        craig-nicholsoneswlb6.mylabserver.com   Running             Running 2 minutes ago    

```

Another way to scale

```bash

sudo docker service scale devweb=3
sudo docker service scale devweb=5
[sudo] password for user: 
[user@craig-nicholsoneswlb4 ~]$ docker service scale devweb=5
devweb scaled to 5
overall progress: 5 out of 5 tasks 
1/5: running   [==================================================>] 
2/5: running   [==================================================>] 
3/5: running   [==================================================>] 
4/5: running   [==================================================>] 
5/5: running   [==================================================>] 
verify: Service converged 
[user@craig-nicholsoneswlb4 ~]$ docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
scfic6w0paa0        devweb              replicated          5/5                 httpd:latest        *:80->80/tcp
[user@craig-nicholsoneswlb4 ~]$ docker service ps devweb
ID                  NAME                IMAGE               NODE                                    DESIRED STATE       CURRENT STATE            ERROR               PORTS
ebt6n9p6hdob        devweb.1            httpd:latest        craig-nicholsoneswlb4.mylabserver.com   Running             Running 20 minutes ago                       
n9xc3mfcb089        devweb.2            httpd:latest        craig-nicholsoneswlb6.mylabserver.com   Running             Running 5 minutes ago                        
qs0bwztssl9l        devweb.3            httpd:latest        craig-nicholsoneswlb5.mylabserver.com   Running             Running 23 seconds ago                       
pult24bhxwpg        devweb.4            httpd:latest        craig-nicholsoneswlb5.mylabserver.com   Running             Running 24 seconds ago                       
hl3qn3awkts3        devweb.5            httpd:latest        craig-nicholsoneswlb6.mylabserver.com   Running             Running 24 seconds ago    

```

ANOTEHER WAY to scale down

```bash

docker service scale devweb=2
devweb scaled to 2
overall progress: 2 out of 2 tasks 
1/2: running   [==================================================>] 
2/2: running   [==================================================>] 
verify: Service converged 
[user@craig-nicholsoneswlb4 ~]$ docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
scfic6w0paa0        devweb              replicated          2/2                 httpd:latest        *:80->80/tcp
[user@craig-nicholsoneswlb4 ~]$ docker service ps devweb
ID                  NAME                IMAGE               NODE                                    DESIRED STATE       CURRENT STATE            ERROR               PORTS
ebt6n9p6hdob        devweb.1            httpd:latest        craig-nicholsoneswlb4.mylabserver.com   Running             Running 20 minutes ago                       
n9xc3mfcb089        devweb.2            httpd:latest        craig-nicholsoneswlb6.mylabserver.com   Running             Running 6 minutes ago                        
[user@craig-nicholsoneswlb4 ~]$ 

[user@craig-nicholsoneswlb4 ~]$ docker service rm devweb
devweb
[user@craig-nicholsoneswlb4 ~]$ docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
[user@craig-nicholsoneswlb4 ~]$ docker service ps devweb
no such service: devweb
[user@craig-nicholsoneswlb4 ~]$ 

```bash

## Demonstrate How Failure Affects Service Replicas in a Swarm

1. Using the appropriate command, pull the latest 'httpd' image from Docker Hub.

```bash

docker pull httpd
docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
httpd               <none>              11426a19f1a2        2 days ago          178MB

```

2. Create a service on your cluster that meets the following requirements:

  * name the service 'testweb'

  * map the service web port of 80 to the underlying service hosts port of 80

  * base it on the 'httpd' service above

  * initialize the service with three replicas

```bash

docker service create --name testweb -p 80:80 --replicas 3 --detach=false httpd

[user@craig-nicholsoneswlb4 ~]$ docker service create --name testweb -p 80:80 --replicas 3 --detach=false httpd
3ps71kcghjvqntgf2astla6qz
overall progress: 3 out of 3 tasks 
1/3: running   [==================================================>] 
2/3: running   [==================================================>] 
3/3: running   [==================================================>] 
verify: Service converged 

```


3. Verify the service is running

```bash

docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
3ps71kcghjvq        testweb             replicated          3/3                 httpd:latest        *:80->80/tcp

```


4. List the all nodes and verify replicas are running on all three

```bash

[user@craig-nicholsoneswlb4 ~]$ docker service ps testweb
ID                  NAME                IMAGE               NODE                                    DESIRED STATE       CURRENT STATE            ERROR               PORTS
ax9nzbqbzf0g        testweb.1           httpd:latest        craig-nicholsoneswlb5.mylabserver.com   Running             Running 40 seconds ago                       
mfsikbq69ka4        testweb.2           httpd:latest        craig-nicholsoneswlb6.mylabserver.com   Running             Running 40 seconds ago                       
yzbt6rosm5fj        testweb.3           httpd:latest        craig-nicholsoneswlb4.mylabserver.com   Running             Running 40 seconds ago     

```

5. STOP the Docker service completely on the third node

```bash
sudo systemctl stop docker

[user@craig-nicholsoneswlb4 ~]$ docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
3ps71kcghjvq        testweb             replicated          3/3                 httpd:latest        *:80->80/tcp
[user@craig-nicholsoneswlb4 ~]$ docker service ps testweb
ID                  NAME                IMAGE               NODE                                    DESIRED STATE       CURRENT STATE                ERROR               PORTS
ax9nzbqbzf0g        testweb.1           httpd:latest        craig-nicholsoneswlb5.mylabserver.com   Running             Running 3 minutes ago                            
umz58nbbscp4        testweb.2           httpd:latest        craig-nicholsoneswlb4.mylabserver.com   Running             Running about a minute ago                       
mfsikbq69ka4         \_ testweb.2       httpd:latest        craig-nicholsoneswlb6.mylabserver.com   Shutdown            Running about a minute ago                       
yzbt6rosm5fj        testweb.3           httpd:latest        craig-nicholsoneswlb4.mylabserver.com   Running             Running 3 minutes ago                            
[user@craig-nicholsoneswlb4 ~]$ 

```

## Reassign a Swarm Worker to Manager


1. On ONE of the worker nodes, force the node to leave the swarm

Node 2

```bash

sudo systemctl start docker
[sudo] password for user: 
[user@craig-nicholsoneswlb6 ~]$ 


[user@craig-nicholsoneswlb4 ~]$ docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
3ps71kcghjvq        testweb             replicated          5/5                 httpd:latest        *:80->80/tcp
[user@craig-nicholsoneswlb4 ~]$ docker service ps testweb
ID                  NAME                IMAGE               NODE                                    DESIRED STATE       CURRENT STATE                 ERROR               PORTS
ax9nzbqbzf0g        testweb.1           httpd:latest        craig-nicholsoneswlb5.mylabserver.com   Running             Running 11 minutes ago                            
umz58nbbscp4        testweb.2           httpd:latest        craig-nicholsoneswlb4.mylabserver.com   Running             Running 9 minutes ago                             
mfsikbq69ka4         \_ testweb.2       httpd:latest        craig-nicholsoneswlb6.mylabserver.com   Shutdown            Shutdown about a minute ago                       
yzbt6rosm5fj        testweb.3           httpd:latest        craig-nicholsoneswlb4.mylabserver.com   Running             Running 11 minutes ago                            
f7bq5jkqoxb3        testweb.4           httpd:latest        craig-nicholsoneswlb6.mylabserver.com   Running             Running 19 seconds ago                            
msrwowgx69al        testweb.5           httpd:latest        craig-nicholsoneswlb6.mylabserver.com   Running             Running 19 seconds ago                            
[user@craig-nicholsoneswlb4 ~]$ 

[user@craig-nicholsoneswlb4 ~]$ docker service scale testweb=3
testweb scaled to 3
overall progress: 3 out of 3 tasks 
1/3: running   [==================================================>] 
2/3: running   [==================================================>] 
3/3: running   [==================================================>] 
verify: Service converged 
[user@craig-nicholsoneswlb4 ~]$ docker service ps testweb
ID                  NAME                IMAGE               NODE                                    DESIRED STATE       CURRENT STATE                ERROR               PORTS
ax9nzbqbzf0g        testweb.1           httpd:latest        craig-nicholsoneswlb5.mylabserver.com   Running             Running 12 minutes ago                           
umz58nbbscp4        testweb.2           httpd:latest        craig-nicholsoneswlb4.mylabserver.com   Running             Running 10 minutes ago                           
mfsikbq69ka4         \_ testweb.2       httpd:latest        craig-nicholsoneswlb6.mylabserver.com   Shutdown            Shutdown 2 minutes ago                           
f7bq5jkqoxb3        testweb.4           httpd:latest        craig-nicholsoneswlb6.mylabserver.com   Running             Running about a minute ago                       
[user@craig-nicholsoneswlb4 ~]$ 
```


```bash

docker swarm leave
[user@craig-nicholsoneswlb6 ~]$ docker swarm leave
Node left the swarm.

[user@craig-nicholsoneswlb4 ~]$ docker service ps testweb
ID                  NAME                IMAGE               NODE                                    DESIRED STATE       CURRENT STATE            ERROR               PORTS
ax9nzbqbzf0g        testweb.1           httpd:latest        craig-nicholsoneswlb5.mylabserver.com   Running             Running 13 minutes ago                       
umz58nbbscp4        testweb.2           httpd:latest        craig-nicholsoneswlb4.mylabserver.com   Running             Running 10 minutes ago                       
mfsikbq69ka4         \_ testweb.2       httpd:latest        craig-nicholsoneswlb6.mylabserver.com   Shutdown            Shutdown 3 minutes ago                       
zqnjy9vgjup8        testweb.4           httpd:latest        craig-nicholsoneswlb4.mylabserver.com   Running             Running 1 second ago                         
f7bq5jkqoxb3         \_ testweb.4       httpd:latest        craig-nicholsoneswlb6.mylabserver.com   Shutdown            Running 17 seconds ago 

```

2. Find the command and token on the manager node to allow other managers to join the swarm

```bash

docker swarm join-token manager
    docker swarm join --token SWMTKN-1-2xlq6phfbb61ystzvmnjflsbzs8fgrzzg0gdebka97wq4z7lbl-3eqp4hknwltbvlvw4h0coe9q8 172.31.97.54:2377

```

3. Execute the command in the previous step so that your swarm will have an additional manager node

```bash

    docker swarm join --token SWMTKN-1-2xlq6phfbb61ystzvmnjflsbzs8fgrzzg0gdebka97wq4z7lbl-3eqp4hknwltbvlvw4h0coe9q8 172.31.97.54:2377

```

```bash

[user@craig-nicholsoneswlb6 ~]$     docker swarm join --token SWMTKN-1-2xlq6phfbb61ystzvmnjflsbzs8fgrzzg0gdebka97wq4z7lbl-3eqp4hknwltbvlvw4h0coe9q8 172.31.97.54:2377
This node joined a swarm as a manager.

```

4. Verify the node has been promoted to manager and is reporting as such in the cluster information

```bash

docker node ls
ID                            HOSTNAME                                STATUS              AVAILABILITY        MANAGER STATUS      ENGINE VERSION
snuv4c6j0c1fhjoyyzlk9kfd8     craig-nicholsoneswlb4.mylabserver.com   Ready               Active              Leader              18.06.0-ce
ny86k7pdofcjjzfhkk533ipet     craig-nicholsoneswlb5.mylabserver.com   Ready               Active                                  18.06.0-ce
r5x2dj69h7jamdbtau5qrp0u6     craig-nicholsoneswlb6.mylabserver.com   Down                Active                                  18.06.0-ce
wcqqwcmh5x8s0omsqlc89il89 *   craig-nicholsoneswlb6.mylabserver.com   Ready               Active              Reachable           18.06.0-ce

[user@craig-nicholsoneswlb4 ~]$ docker node ls
ID                            HOSTNAME                                STATUS              AVAILABILITY        MANAGER STATUS      ENGINE VERSION
snuv4c6j0c1fhjoyyzlk9kfd8 *   craig-nicholsoneswlb4.mylabserver.com   Ready               Active              Leader              18.06.0-ce
ny86k7pdofcjjzfhkk533ipet     craig-nicholsoneswlb5.mylabserver.com   Ready               Active                                  18.06.0-ce
r5x2dj69h7jamdbtau5qrp0u6     craig-nicholsoneswlb6.mylabserver.com   Down                Active                                  18.06.0-ce
wcqqwcmh5x8s0omsqlc89il89     craig-nicholsoneswlb6.mylabserver.com   Ready               Active              Reachable           18.06.0-ce

```

## Final Lap Use Case

Your development team is now working on a new web application service and needs a basic cluster of web servers that they can throw load against in order to test performance.

As a result, you have been asked to provide a basic cluster that encompasses one management node and one client node. You will need to create the manager and join the client to the cluster and confirm they are all registered appropriately.

You have found a basic HTTPD image available on Docker Hub that is fine for this purpose called 'httpd'. Using that image, create a service called 'our_api' that runs across the cluster, making sure to redirect service HTTP port 80 to the underlying swarm port 80, using at least two replicas. 

Once you confirm that two replicas are running, increase the replica count to four to be sure your cluster has sufficient capacity to scale. Once confirmed the replicas are running as expected, reduce the replica count back to two and you can turn the environment back over the development team to begin their work.

### Manager Setup 10.0.0.11

```bash

craig:~ cn$ ssh cloud_user@34.230.2.97
The authenticity of host '34.230.2.97 (34.230.2.97)' can't be established.
ECDSA key fingerprint is SHA256:UE+sN0+iPQ+7cJesmyoddnAcwghjsZn0B3BTNl81sDM.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '34.230.2.97' (ECDSA) to the list of known hosts.
cloud_user@34.230.2.97's password:
[cloud_user@ip-10-0-0-11 ~]$ bash <(curl -s https://raw.githubusercontent.com/craignicholson/docker-quickstart/master/03_Orchestration/centos7_dockerInstall.sh)
[sudo] password for cloud_user: 
Loaded plugins: fastestmirror
base                                                     | 3.6 kB     00:00     
extras                                                   | 3.4 kB     00:00     
updates                                                  | 3.4 kB     00:00     
(1/4): extras/7/x86_64/primary_db                          | 173 kB   00:00     
(2/4): updates/7/x86_64/primary_db                         | 4.3 MB   00:00     
(3/4): base/7/x86_64/group_gz                              | 166 kB   00:02     
(4/4): base/7/x86_64/primary_db                            | 5.9 MB   00:09     
Determining fastest mirrors
 * base: distro.ibiblio.org
 * extras: mirror.vcu.edu
 * updates: repo1.ash.innoscale.net
Resolving Dependencies
--> Running transaction check
---> Package device-mapper-persistent-data.x86_64 0:0.7.3-3.el7 will be installed
--> Processing Dependency: libaio.so.1(LIBAIO_0.4)(64bit) for package: device-mapper-persistent-data-0.7.3-3.el7.x86_64
--> Processing Dependency: libaio.so.1(LIBAIO_0.1)(64bit) for package: device-mapper-persistent-data-0.7.3-3.el7.x86_64
--> Processing Dependency: libaio.so.1()(64bit) for package: device-mapper-persistent-data-0.7.3-3.el7.x86_64
---> Package lvm2.x86_64 7:2.02.177-4.el7 will be installed
--> Processing Dependency: lvm2-libs = 7:2.02.177-4.el7 for package: 7:lvm2-2.02.177-4.el7.x86_64
--> Processing Dependency: liblvm2app.so.2.2(Base)(64bit) for package: 7:lvm2-2.02.177-4.el7.x86_64
--> Processing Dependency: libdevmapper.so.1.02(DM_1_02_141)(64bit) for package: 7:lvm2-2.02.177-4.el7.x86_64
--> Processing Dependency: libdevmapper-event.so.1.02(Base)(64bit) for package: 7:lvm2-2.02.177-4.el7.x86_64
--> Processing Dependency: liblvm2app.so.2.2()(64bit) for package: 7:lvm2-2.02.177-4.el7.x86_64
--> Processing Dependency: libdevmapper-event.so.1.02()(64bit) for package: 7:lvm2-2.02.177-4.el7.x86_64
---> Package yum-utils.noarch 0:1.1.31-46.el7_5 will be installed
--> Processing Dependency: python-kitchen for package: yum-utils-1.1.31-46.el7_5.noarch
--> Processing Dependency: libxml2-python for package: yum-utils-1.1.31-46.el7_5.noarch
--> Running transaction check
---> Package device-mapper-event-libs.x86_64 7:1.02.146-4.el7 will be installed
---> Package device-mapper-libs.x86_64 7:1.02.140-8.el7 will be updated
--> Processing Dependency: device-mapper-libs = 7:1.02.140-8.el7 for package: 7:device-mapper-1.02.140-8.el7.x86_64
---> Package device-mapper-libs.x86_64 7:1.02.146-4.el7 will be an update
---> Package libaio.x86_64 0:0.3.109-13.el7 will be installed
---> Package libxml2-python.x86_64 0:2.9.1-6.el7_2.3 will be installed
---> Package lvm2-libs.x86_64 7:2.02.177-4.el7 will be installed
--> Processing Dependency: device-mapper-event = 7:1.02.146-4.el7 for package: 7:lvm2-libs-2.02.177-4.el7.x86_64
---> Package python-kitchen.noarch 0:1.1.1-5.el7 will be installed
--> Running transaction check
---> Package device-mapper.x86_64 7:1.02.140-8.el7 will be updated
---> Package device-mapper.x86_64 7:1.02.146-4.el7 will be an update
---> Package device-mapper-event.x86_64 7:1.02.146-4.el7 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

================================================================================
 Package                         Arch     Version               Repository
                                                                           Size
================================================================================
Installing:
 device-mapper-persistent-data   x86_64   0.7.3-3.el7           base      405 k
 lvm2                            x86_64   7:2.02.177-4.el7      base      1.3 M
 yum-utils                       noarch   1.1.31-46.el7_5       updates   120 k
Installing for dependencies:
 device-mapper-event             x86_64   7:1.02.146-4.el7      base      185 k
 device-mapper-event-libs        x86_64   7:1.02.146-4.el7      base      184 k
 libaio                          x86_64   0.3.109-13.el7        base       24 k
 libxml2-python                  x86_64   2.9.1-6.el7_2.3       base      247 k
 lvm2-libs                       x86_64   7:2.02.177-4.el7      base      1.0 M
 python-kitchen                  noarch   1.1.1-5.el7           base      267 k
Updating for dependencies:
 device-mapper                   x86_64   7:1.02.146-4.el7      base      289 k
 device-mapper-libs              x86_64   7:1.02.146-4.el7      base      316 k

Transaction Summary
================================================================================
Install  3 Packages (+6 Dependent packages)
Upgrade             ( 2 Dependent packages)

Total download size: 4.3 M
Downloading packages:
Delta RPMs disabled because /usr/bin/applydeltarpm not installed.
(1/11): device-mapper-event-1.02.146-4.el7.x86_64.rpm      | 185 kB   00:00     
(2/11): device-mapper-1.02.146-4.el7.x86_64.rpm            | 289 kB   00:00     
(3/11): libaio-0.3.109-13.el7.x86_64.rpm                   |  24 kB   00:00     
(4/11): libxml2-python-2.9.1-6.el7_2.3.x86_64.rpm          | 247 kB   00:00     
(5/11): device-mapper-persistent-data-0.7.3-3.el7.x86_64.r | 405 kB   00:00     
(6/11): python-kitchen-1.1.1-5.el7.noarch.rpm              | 267 kB   00:00     
(7/11): lvm2-libs-2.02.177-4.el7.x86_64.rpm                | 1.0 MB   00:00     
(8/11): device-mapper-event-libs-1.02.146-4.el7.x86_64.rpm | 184 kB   00:00     
(9/11): device-mapper-libs-1.02.146-4.el7.x86_64.rpm       | 316 kB   00:00     
(10/11): yum-utils-1.1.31-46.el7_5.noarch.rpm              | 120 kB   00:00     
(11/11): lvm2-2.02.177-4.el7.x86_64.rpm                    | 1.3 MB   00:04     
--------------------------------------------------------------------------------
Total                                              952 kB/s | 4.3 MB  00:04     
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Updating   : 7:device-mapper-libs-1.02.146-4.el7.x86_64                  1/13 
  Updating   : 7:device-mapper-1.02.146-4.el7.x86_64                       2/13 
  Installing : 7:device-mapper-event-libs-1.02.146-4.el7.x86_64            3/13 
  Installing : 7:device-mapper-event-1.02.146-4.el7.x86_64                 4/13 
  Installing : 7:lvm2-libs-2.02.177-4.el7.x86_64                           5/13 
  Installing : libaio-0.3.109-13.el7.x86_64                                6/13 
  Installing : device-mapper-persistent-data-0.7.3-3.el7.x86_64            7/13 
  Installing : python-kitchen-1.1.1-5.el7.noarch                           8/13 
  Installing : libxml2-python-2.9.1-6.el7_2.3.x86_64                       9/13 
  Installing : yum-utils-1.1.31-46.el7_5.noarch                           10/13 
  Installing : 7:lvm2-2.02.177-4.el7.x86_64                               11/13 
Created symlink from /etc/systemd/system/sysinit.target.wants/lvm2-lvmpolld.socket to /usr/lib/systemd/system/lvm2-lvmpolld.socket.
  Cleanup    : 7:device-mapper-libs-1.02.140-8.el7.x86_64                 12/13 
  Cleanup    : 7:device-mapper-1.02.140-8.el7.x86_64                      13/13 
  Verifying  : device-mapper-persistent-data-0.7.3-3.el7.x86_64            1/13 
  Verifying  : 7:lvm2-2.02.177-4.el7.x86_64                                2/13 
  Verifying  : yum-utils-1.1.31-46.el7_5.noarch                            3/13 
  Verifying  : 7:device-mapper-1.02.146-4.el7.x86_64                       4/13 
  Verifying  : 7:device-mapper-event-1.02.146-4.el7.x86_64                 5/13 
  Verifying  : libxml2-python-2.9.1-6.el7_2.3.x86_64                       6/13 
  Verifying  : python-kitchen-1.1.1-5.el7.noarch                           7/13 
  Verifying  : 7:device-mapper-event-libs-1.02.146-4.el7.x86_64            8/13 
  Verifying  : 7:lvm2-libs-2.02.177-4.el7.x86_64                           9/13 
  Verifying  : libaio-0.3.109-13.el7.x86_64                               10/13 
  Verifying  : 7:device-mapper-libs-1.02.146-4.el7.x86_64                 11/13 
  Verifying  : 7:device-mapper-1.02.140-8.el7.x86_64                      12/13 
  Verifying  : 7:device-mapper-libs-1.02.140-8.el7.x86_64                 13/13 

Installed:
  device-mapper-persistent-data.x86_64 0:0.7.3-3.el7                            
  lvm2.x86_64 7:2.02.177-4.el7                                                  
  yum-utils.noarch 0:1.1.31-46.el7_5                                            

Dependency Installed:
  device-mapper-event.x86_64 7:1.02.146-4.el7                                   
  device-mapper-event-libs.x86_64 7:1.02.146-4.el7                              
  libaio.x86_64 0:0.3.109-13.el7                                                
  libxml2-python.x86_64 0:2.9.1-6.el7_2.3                                       
  lvm2-libs.x86_64 7:2.02.177-4.el7                                             
  python-kitchen.noarch 0:1.1.1-5.el7                                           

Dependency Updated:
  device-mapper.x86_64 7:1.02.146-4.el7                                         
  device-mapper-libs.x86_64 7:1.02.146-4.el7                                    

Complete!
Loaded plugins: fastestmirror
adding repo from: https://download.docker.com/linux/centos/docker-ce.repo
grabbing file https://download.docker.com/linux/centos/docker-ce.repo to /etc/yum.repos.d/docker-ce.repo
repo saved to /etc/yum.repos.d/docker-ce.repo
Loaded plugins: fastestmirror
docker-ce-stable                                         | 2.9 kB     00:00     
docker-ce-stable/x86_64/primary_db                         |  14 kB   00:00     
Loading mirror speeds from cached hostfile
 * base: distro.ibiblio.org
 * extras: mirror.vcu.edu
 * updates: repo1.ash.innoscale.net
Resolving Dependencies
--> Running transaction check
---> Package docker-ce.x86_64 0:18.06.0.ce-3.el7 will be installed
--> Processing Dependency: container-selinux >= 2.9 for package: docker-ce-18.06.0.ce-3.el7.x86_64
--> Processing Dependency: libltdl.so.7()(64bit) for package: docker-ce-18.06.0.ce-3.el7.x86_64
--> Running transaction check
---> Package container-selinux.noarch 2:2.66-1.el7 will be installed
--> Processing Dependency: selinux-policy-targeted >= 3.13.1-192 for package: 2:container-selinux-2.66-1.el7.noarch
--> Processing Dependency: selinux-policy-base >= 3.13.1-192 for package: 2:container-selinux-2.66-1.el7.noarch
--> Processing Dependency: selinux-policy >= 3.13.1-192 for package: 2:container-selinux-2.66-1.el7.noarch
---> Package libtool-ltdl.x86_64 0:2.4.2-22.el7_3 will be installed
--> Running transaction check
---> Package selinux-policy.noarch 0:3.13.1-166.el7_4.9 will be updated
---> Package selinux-policy.noarch 0:3.13.1-192.el7_5.4 will be an update
--> Processing Dependency: policycoreutils >= 2.5-18 for package: selinux-policy-3.13.1-192.el7_5.4.noarch
---> Package selinux-policy-targeted.noarch 0:3.13.1-166.el7_4.9 will be updated
---> Package selinux-policy-targeted.noarch 0:3.13.1-192.el7_5.4 will be an update
--> Running transaction check
---> Package policycoreutils.x86_64 0:2.5-17.1.el7 will be updated
--> Processing Dependency: policycoreutils = 2.5-17.1.el7 for package: policycoreutils-python-2.5-17.1.el7.x86_64
---> Package policycoreutils.x86_64 0:2.5-22.el7 will be an update
--> Processing Dependency: libsepol >= 2.5-8 for package: policycoreutils-2.5-22.el7.x86_64
--> Processing Dependency: libselinux-utils >= 2.5-12 for package: policycoreutils-2.5-22.el7.x86_64
--> Running transaction check
---> Package libselinux-utils.x86_64 0:2.5-11.el7 will be updated
---> Package libselinux-utils.x86_64 0:2.5-12.el7 will be an update
--> Processing Dependency: libselinux(x86-64) = 2.5-12.el7 for package: libselinux-utils-2.5-12.el7.x86_64
---> Package libsepol.i686 0:2.5-6.el7 will be updated
---> Package libsepol.x86_64 0:2.5-6.el7 will be updated
---> Package libsepol.i686 0:2.5-8.1.el7 will be an update
---> Package libsepol.x86_64 0:2.5-8.1.el7 will be an update
---> Package policycoreutils-python.x86_64 0:2.5-17.1.el7 will be updated
---> Package policycoreutils-python.x86_64 0:2.5-22.el7 will be an update
--> Processing Dependency: setools-libs >= 3.3.8-2 for package: policycoreutils-python-2.5-22.el7.x86_64
--> Processing Dependency: libsemanage-python >= 2.5-9 for package: policycoreutils-python-2.5-22.el7.x86_64
--> Running transaction check
---> Package libselinux.i686 0:2.5-11.el7 will be updated
---> Package libselinux.x86_64 0:2.5-11.el7 will be updated
--> Processing Dependency: libselinux(x86-64) = 2.5-11.el7 for package: libselinux-python-2.5-11.el7.x86_64
---> Package libselinux.i686 0:2.5-12.el7 will be an update
---> Package libselinux.x86_64 0:2.5-12.el7 will be an update
---> Package libsemanage-python.x86_64 0:2.5-8.el7 will be updated
---> Package libsemanage-python.x86_64 0:2.5-11.el7 will be an update
--> Processing Dependency: libsemanage = 2.5-11.el7 for package: libsemanage-python-2.5-11.el7.x86_64
---> Package setools-libs.x86_64 0:3.3.8-1.1.el7 will be updated
---> Package setools-libs.x86_64 0:3.3.8-2.el7 will be an update
--> Running transaction check
---> Package libselinux-python.x86_64 0:2.5-11.el7 will be updated
---> Package libselinux-python.x86_64 0:2.5-12.el7 will be an update
---> Package libsemanage.x86_64 0:2.5-8.el7 will be updated
---> Package libsemanage.x86_64 0:2.5-11.el7 will be an update
--> Finished Dependency Resolution

Dependencies Resolved

================================================================================
 Package                  Arch    Version               Repository         Size
================================================================================
Installing:
 docker-ce                x86_64  18.06.0.ce-3.el7      docker-ce-stable   41 M
Installing for dependencies:
 container-selinux        noarch  2:2.66-1.el7          extras             35 k
 libtool-ltdl             x86_64  2.4.2-22.el7_3        base               49 k
Updating for dependencies:
 libselinux               i686    2.5-12.el7            base              166 k
 libselinux               x86_64  2.5-12.el7            base              162 k
 libselinux-python        x86_64  2.5-12.el7            base              235 k
 libselinux-utils         x86_64  2.5-12.el7            base              151 k
 libsemanage              x86_64  2.5-11.el7            base              150 k
 libsemanage-python       x86_64  2.5-11.el7            base              112 k
 libsepol                 i686    2.5-8.1.el7           base              293 k
 libsepol                 x86_64  2.5-8.1.el7           base              297 k
 policycoreutils          x86_64  2.5-22.el7            base              867 k
 policycoreutils-python   x86_64  2.5-22.el7            base              454 k
 selinux-policy           noarch  3.13.1-192.el7_5.4    updates           453 k
 selinux-policy-targeted  noarch  3.13.1-192.el7_5.4    updates           6.6 M
 setools-libs             x86_64  3.3.8-2.el7           base              619 k

Transaction Summary
================================================================================
Install  1 Package  (+ 2 Dependent packages)
Upgrade             ( 13 Dependent packages)

Total download size: 51 M
Downloading packages:
Delta RPMs disabled because /usr/bin/applydeltarpm not installed.
(1/16): container-selinux-2.66-1.el7.noarch.rpm            |  35 kB   00:00     
(2/16): libselinux-2.5-12.el7.i686.rpm                     | 166 kB   00:00     
(3/16): libselinux-python-2.5-12.el7.x86_64.rpm            | 235 kB   00:00     
(4/16): libselinux-2.5-12.el7.x86_64.rpm                   | 162 kB   00:00     
(5/16): libselinux-utils-2.5-12.el7.x86_64.rpm             | 151 kB   00:00     
(6/16): libsemanage-python-2.5-11.el7.x86_64.rpm           | 112 kB   00:00     
(7/16): libsemanage-2.5-11.el7.x86_64.rpm                  | 150 kB   00:00     
(8/16): libsepol-2.5-8.1.el7.i686.rpm                      | 293 kB   00:00     
(9/16): libtool-ltdl-2.4.2-22.el7_3.x86_64.rpm             |  49 kB   00:00     
(10/16): libsepol-2.5-8.1.el7.x86_64.rpm                   | 297 kB   00:00     
(11/16): policycoreutils-2.5-22.el7.x86_64.rpm             | 867 kB   00:00     
(12/16): setools-libs-3.3.8-2.el7.x86_64.rpm               | 619 kB   00:00     
(13/16): policycoreutils-python-2.5-22.el7.x86_64.rpm      | 454 kB   00:00     
(14/16): selinux-policy-3.13.1-192.el7_5.4.noarch.rpm      | 453 kB   00:00     
warning: /var/cache/yum/x86_64/7/docker-ce-stable/packages/docker-ce-18.06.0.ce-3.el7.x86_64.rpm: Header V4 RSA/SHA512 Signature, key ID 621e9f35: NOKEY
Public key for docker-ce-18.06.0.ce-3.el7.x86_64.rpm is not installed
(15/16): docker-ce-18.06.0.ce-3.el7.x86_64.rpm             |  41 MB   00:01     
(16/16): selinux-policy-targeted-3.13.1-192.el7_5.4.noarch | 6.6 MB   00:00     
--------------------------------------------------------------------------------
Total                                               35 MB/s |  51 MB  00:01     
Retrieving key from https://download.docker.com/linux/centos/gpg
Importing GPG key 0x621E9F35:
 Userid     : "Docker Release (CE rpm) <docker@docker.com>"
 Fingerprint: 060a 61c5 1b55 8a7f 742b 77aa c52f eb6b 621e 9f35
 From       : https://download.docker.com/linux/centos/gpg
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Updating   : libsepol-2.5-8.1.el7.x86_64                                 1/29 
  Updating   : libselinux-2.5-12.el7.x86_64                                2/29 
  Updating   : libsemanage-2.5-11.el7.x86_64                               3/29 
  Updating   : libselinux-utils-2.5-12.el7.x86_64                          4/29 
  Updating   : policycoreutils-2.5-22.el7.x86_64                           5/29 
  Updating   : selinux-policy-3.13.1-192.el7_5.4.noarch                    6/29 
  Updating   : selinux-policy-targeted-3.13.1-192.el7_5.4.noarch           7/29 
  Updating   : libsemanage-python-2.5-11.el7.x86_64                        8/29 
  Updating   : libselinux-python-2.5-12.el7.x86_64                         9/29 
  Updating   : setools-libs-3.3.8-2.el7.x86_64                            10/29 
  Updating   : policycoreutils-python-2.5-22.el7.x86_64                   11/29 
  Installing : 2:container-selinux-2.66-1.el7.noarch                      12/29 
  Installing : libtool-ltdl-2.4.2-22.el7_3.x86_64                         13/29 
  Updating   : libsepol-2.5-8.1.el7.i686                                  14/29 
  Installing : docker-ce-18.06.0.ce-3.el7.x86_64                          15/29 
  Updating   : libselinux-2.5-12.el7.i686                                 16/29 
  Cleanup    : selinux-policy-targeted-3.13.1-166.el7_4.9.noarch          17/29 
  Cleanup    : policycoreutils-python-2.5-17.1.el7.x86_64                 18/29 
  Cleanup    : selinux-policy-3.13.1-166.el7_4.9.noarch                   19/29 
  Cleanup    : libselinux-2.5-11.el7                                      20/29 
  Cleanup    : policycoreutils-2.5-17.1.el7.x86_64                        21/29 
  Cleanup    : libselinux-utils-2.5-11.el7.x86_64                         22/29 
  Cleanup    : setools-libs-3.3.8-1.1.el7.x86_64                          23/29 
  Cleanup    : libselinux-python-2.5-11.el7.x86_64                        24/29 
  Cleanup    : libsemanage-python-2.5-8.el7.x86_64                        25/29 
  Cleanup    : libsepol-2.5-6.el7                                         26/29 
  Cleanup    : libsemanage-2.5-8.el7.x86_64                               27/29 
  Cleanup    : libselinux-2.5-11.el7                                      28/29 
  Cleanup    : libsepol-2.5-6.el7                                         29/29 
  Verifying  : libselinux-python-2.5-12.el7.x86_64                         1/29 
  Verifying  : selinux-policy-3.13.1-192.el7_5.4.noarch                    2/29 
  Verifying  : setools-libs-3.3.8-2.el7.x86_64                             3/29 
  Verifying  : libsemanage-python-2.5-11.el7.x86_64                        4/29 
  Verifying  : policycoreutils-2.5-22.el7.x86_64                           5/29 
  Verifying  : libsepol-2.5-8.1.el7.i686                                   6/29 
  Verifying  : libsemanage-2.5-11.el7.x86_64                               7/29 
  Verifying  : selinux-policy-targeted-3.13.1-192.el7_5.4.noarch           8/29 
  Verifying  : policycoreutils-python-2.5-22.el7.x86_64                    9/29 
  Verifying  : libtool-ltdl-2.4.2-22.el7_3.x86_64                         10/29 
  Verifying  : 2:container-selinux-2.66-1.el7.noarch                      11/29 
  Verifying  : libselinux-2.5-12.el7.i686                                 12/29 
  Verifying  : docker-ce-18.06.0.ce-3.el7.x86_64                          13/29 
  Verifying  : libsepol-2.5-8.1.el7.x86_64                                14/29 
  Verifying  : libselinux-2.5-12.el7.x86_64                               15/29 
  Verifying  : libselinux-utils-2.5-12.el7.x86_64                         16/29 
  Verifying  : libselinux-utils-2.5-11.el7.x86_64                         17/29 
  Verifying  : libsepol-2.5-6.el7.i686                                    18/29 
  Verifying  : libselinux-2.5-11.el7.x86_64                               19/29 
  Verifying  : libsepol-2.5-6.el7.x86_64                                  20/29 
  Verifying  : policycoreutils-python-2.5-17.1.el7.x86_64                 21/29 
  Verifying  : selinux-policy-targeted-3.13.1-166.el7_4.9.noarch          22/29 
  Verifying  : policycoreutils-2.5-17.1.el7.x86_64                        23/29 
  Verifying  : selinux-policy-3.13.1-166.el7_4.9.noarch                   24/29 
  Verifying  : libsemanage-python-2.5-8.el7.x86_64                        25/29 
  Verifying  : libselinux-2.5-11.el7.i686                                 26/29 
  Verifying  : libsemanage-2.5-8.el7.x86_64                               27/29 
  Verifying  : libselinux-python-2.5-11.el7.x86_64                        28/29 
  Verifying  : setools-libs-3.3.8-1.1.el7.x86_64                          29/29 

Installed:
  docker-ce.x86_64 0:18.06.0.ce-3.el7                                           

Dependency Installed:
  container-selinux.noarch 2:2.66-1.el7   libtool-ltdl.x86_64 0:2.4.2-22.el7_3  

Dependency Updated:
  libselinux.i686 0:2.5-12.el7                                                  
  libselinux.x86_64 0:2.5-12.el7                                                
  libselinux-python.x86_64 0:2.5-12.el7                                         
  libselinux-utils.x86_64 0:2.5-12.el7                                          
▽ libsemanage.x86_64 0:2.5-11.el7                                               
  libsemanage-python.x86_64 0:2.5-11.el7                                        
  libsepol.i686 0:2.5-8.1.el7                                                   
  libsepol.x86_64 0:2.5-8.1.el7                                                 
  policycoreutils.x86_64 0:2.5-22.el7                                           
  policycoreutils-python.x86_64 0:2.5-22.el7                                    
  selinux-policy.noarch 0:3.13.1-192.el7_5.4                                    
  selinux-policy-targeted.noarch 0:3.13.1-192.el7_5.4                           
  setools-libs.x86_64 0:3.3.8-2.el7                                             

Complete!
groupadd: group 'docker' already exists
Created symlink from /etc/systemd/system/multi-user.target.wants/docker.service to /usr/lib/systemd/system/docker.service.
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
 * base: distro.ibiblio.org
 * extras: mirror.vcu.edu
 * updates: repo1.ash.innoscale.net
No unfinished transactions left.

[cloud_user@ip-10-0-0-11 ~]$ docker images
Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Get http://%2Fvar%2Frun%2Fdocker.sock/v1.38/images/json: dial unix /var/run/docker.sock: connect: permission denied

[cloud_user@ip-10-0-0-11 ~]$ exit
logout
Connection to 34.230.2.97 closed.

craig:~ cn$ ssh cloud_user@34.230.2.97
cloud_user@34.230.2.97's password: 
Last login: Fri Aug  3 11:39:32 2018 from 108-74-118-125.lightspeed.tukrga.sbcglobal.net

[cloud_user@ip-10-0-0-11 ~]$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
[cloud_user@ip-10-0-0-11 ~]$ sudo vim /etc/hosts
[sudo] password for cloud_user: 

127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

10.0.0.11 manager
10.0.0.12 node1

"/etc/hosts" 5L, 193C written"

[cloud_user@ip-10-0-0-11 ~]$ docker swarm init
Swarm initialized: current node (xr45xfphabllgriw0760ulekw) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join --token SWMTKN-1-3cni1469xirj0sykjtp8jlvmsw1i3lbo9t1lhb9dza3xeo03a8-8h72iqqx5m6oayh1wpfbdi5uh 10.0.0.11:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.

[cloud_user@ip-10-0-0-11 ~]$ sudo systemctl disable firewalld && sudo systemctl stop firewalld
Removed symlink /etc/systemd/system/dbus-org.fedoraproject.FirewallD1.service.
Removed symlink /etc/systemd/system/basic.target.wants/firewalld.service.

[cloud_user@ip-10-0-0-11 ~]$ docker node ls
ID                            HOSTNAME                    STATUS              AVAILABILITY        MANAGER STATUS      ENGINE VERSION
xr45xfphabllgriw0760ulekw *   ip-10-0-0-11.ec2.internal   Ready               Active              Leader              18.06.0-ce
y4cggx5ams98dyajfoe85240q     ip-10-0-0-12.ec2.internal   Ready               Active                                  18.06.0-ce

[cloud_user@ip-10-0-0-11 ~]$ docker pull httpd
Using default tag: latest
latest: Pulling from library/httpd
d660b1f15b9b: Pull complete 
aa1c79a2fa37: Pull complete 
f5f6514c0aff: Pull complete 
676d3dd26040: Pull complete 
4fdddf845a1b: Pull complete 
520c4b04fe88: Pull complete 
5387b1b7893c: Pull complete 
Digest: sha256:8c84e065bdf72b4909bd55a348d5e91fe265e08d6b28ed9104bfdcac9206dcc8
Status: Downloaded newer image for httpd:latest

[cloud_user@ip-10-0-0-11 ~]$ docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
nja7r3xfg10m        our_api             replicated          0/1                 p:latest            

[cloud_user@ip-10-0-0-11 ~]$ docker service create --name our_api -p 80:80  httpd
png9lwynji17lwumpyp1wczej
overall progress: 1 out of 1 tasks 
1/1: running   [==================================================>] 
verify: Service converged 

[cloud_user@ip-10-0-0-11 ~]$ docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
png9lwynji17        our_api             replicated          1/1                 httpd:latest        *:80->80/tcp

[cloud_user@ip-10-0-0-11 ~]$ docker service scale our_api=2
our_api scaled to 2
overall progress: 2 out of 2 tasks 
1/2: running   [==================================================>] 
2/2: running   [==================================================>] 
verify: Service converged 

[cloud_user@ip-10-0-0-11 ~]$ docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
png9lwynji17        our_api             replicated          2/2                 httpd:latest        *:80->80/tcp

[cloud_user@ip-10-0-0-11 ~]$ docker service ps our_api
ID                  NAME                IMAGE               NODE                        DESIRED STATE       CURRENT STATE             ERROR                              PORTS
pkhr8jqkrh6w        our_api.1           httpd:latest        ip-10-0-0-11.ec2.internal   Running             Running 2 minutes ago                                        
73reja4m188s        our_api.2           httpd:latest        ip-10-0-0-11.ec2.internal   Running             Running 18 seconds ago                                       
o5zaaqw4me3w         \_ our_api.2       httpd:latest        ip-10-0-0-12.ec2.internal   Shutdown            Rejected 32 seconds ago   "error creating external conne…"   
ljezxh875elr         \_ our_api.2       httpd:latest        ip-10-0-0-12.ec2.internal   Shutdown            Rejected 37 seconds ago   "error creating external conne…"   
gqk5tza5sepa         \_ our_api.2       httpd:latest        ip-10-0-0-12.ec2.internal   Shutdown            Rejected 42 seconds ago   "error creating external conne…"   
s27vbkk38fdq         \_ our_api.2       httpd:latest        ip-10-0-0-12.ec2.internal   Shutdown            Rejected 43 seconds ago   "error creating external conne…"   
[cloud_user@ip-10-0-0-11 ~]$ docker service scale our_api=4
our_api scaled to 4
overall progress: 4 out of 4 tasks 
1/4: running   [==================================================>] 
2/4: running   [==================================================>] 
3/4: running   [==================================================>] 
4/4: running   [==================================================>] 
verify: Service converged 

[cloud_user@ip-10-0-0-11 ~]$ docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
png9lwynji17        our_api             replicated          4/4                 httpd:latest        *:80->80/tcp

[cloud_user@ip-10-0-0-11 ~]$ docker service ps our_api
ID                  NAME                IMAGE               NODE                        DESIRED STATE       CURRENT STATE                ERROR                              PORTS
pkhr8jqkrh6w        our_api.1           httpd:latest        ip-10-0-0-11.ec2.internal   Running             Running 4 minutes ago                                           
73reja4m188s        our_api.2           httpd:latest        ip-10-0-0-11.ec2.internal   Running             Running about a minute ago                                      
o5zaaqw4me3w         \_ our_api.2       httpd:latest        ip-10-0-0-12.ec2.internal   Shutdown            Rejected 2 minutes ago       "error creating external conne…"   
ljezxh875elr         \_ our_api.2       httpd:latest        ip-10-0-0-12.ec2.internal   Shutdown            Rejected 2 minutes ago       "error creating external conne…"   
gqk5tza5sepa         \_ our_api.2       httpd:latest        ip-10-0-0-12.ec2.internal   Shutdown            Rejected 2 minutes ago       "error creating external conne…"   
s27vbkk38fdq         \_ our_api.2       httpd:latest        ip-10-0-0-12.ec2.internal   Shutdown            Rejected 2 minutes ago       "error creating external conne…"   
pkolu9rvpipl        our_api.3           httpd:latest        ip-10-0-0-11.ec2.internal   Running             Running 40 seconds ago                                          
8m04j5v71owv         \_ our_api.3       httpd:latest        ip-10-0-0-12.ec2.internal   Shutdown            Rejected 50 seconds ago      "error creating external conne…"   
buu210ue9jhk         \_ our_api.3       httpd:latest        ip-10-0-0-12.ec2.internal   Shutdown            Failed 50 seconds ago        "error creating external conne…"   
g736gk0ph4lg        our_api.4           httpd:latest        ip-10-0-0-11.ec2.internal   Running             Running 42 seconds ago                                          
54nusd5z0dfo         \_ our_api.4       httpd:latest        ip-10-0-0-12.ec2.internal   Shutdown            Rejected 51 seconds ago      "error creating external conne…"   
xt0gtl3ixsd9         \_ our_api.4       httpd:latest        ip-10-0-0-12.ec2.internal   Shutdown            Rejected 56 seconds ago      "error creating external conne…"   
tjo92dqwcb2s         \_ our_api.4       httpd:latest        ip-10-0-0-12.ec2.internal   Shutdown            Rejected 58 seconds ago      "error creating external conne…"   
[cloud_user@ip-10-0-0-11 ~]$ docker node ls
ID                            HOSTNAME                    STATUS              AVAILABILITY        MANAGER STATUS      ENGINE VERSION
xr45xfphabllgriw0760ulekw *   ip-10-0-0-11.ec2.internal   Ready               Active              Leader              18.06.0-ce
y4cggx5ams98dyajfoe85240q     ip-10-0-0-12.ec2.internal   Ready               Active                                  18.06.0-ce

[cloud_user@ip-10-0-0-11 ~]$ docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
png9lwynji17        our_api             replicated          4/4                 httpd:latest        *:80->80/tcp

[cloud_user@ip-10-0-0-11 ~]$ docker service scale our_api=2
our_api scaled to 2
overall progress: 2 out of 2 tasks 
1/2: running   [==================================================>] 
2/2: error creating external connectivity network: Failed to Setup IP tables: U… 
verify: Service converged 

[cloud_user@ip-10-0-0-11 ~]$ docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
png9lwynji17        our_api             replicated          2/2                 httpd:latest        *:80->80/tcp
[cloud_user@ip-10-0-0-11 ~]$ docker service ps our_api
ID                  NAME                IMAGE               NODE                        DESIRED STATE       CURRENT STATE            ERROR                              PORTS
pkhr8jqkrh6w        our_api.1           httpd:latest        ip-10-0-0-11.ec2.internal   Running             Running 6 minutes ago                                       
73reja4m188s        our_api.2           httpd:latest        ip-10-0-0-11.ec2.internal   Running             Running 4 minutes ago                                       
o5zaaqw4me3w         \_ our_api.2       httpd:latest        ip-10-0-0-12.ec2.internal   Shutdown            Rejected 4 minutes ago   "error creating external conne…"   
ljezxh875elr         \_ our_api.2       httpd:latest        ip-10-0-0-12.ec2.internal   Shutdown            Rejected 4 minutes ago   "error creating external conne…"   
gqk5tza5sepa         \_ our_api.2       httpd:latest        ip-10-0-0-12.ec2.internal   Shutdown            Rejected 4 minutes ago   "error creating external conne…"   
s27vbkk38fdq         \_ our_api.2       httpd:latest        ip-10-0-0-12.ec2.internal   Shutdown            Rejected 4 minutes ago   "error creating external conne…"   
8m04j5v71owv        our_api.3           httpd:latest        ip-10-0-0-12.ec2.internal   Shutdown            Rejected 2 minutes ago   "error creating external conne…"   
buu210ue9jhk         \_ our_api.3       httpd:latest        ip-10-0-0-12.ec2.internal   Shutdown            Failed 2 minutes ago     "error creating external conne…"   
54nusd5z0dfo        our_api.4           httpd:latest        ip-10-0-0-12.ec2.internal   Shutdown            Rejected 2 minutes ago   "error creating external conne…"   
xt0gtl3ixsd9         \_ our_api.4       httpd:latest        ip-10-0-0-12.ec2.internal   Shutdown            Rejected 3 minutes ago   "error creating external conne…"   
tjo92dqwcb2s         \_ our_api.4       httpd:latest        ip-10-0-0-12.ec2.internal   Shutdown            Rejected 3 minutes ago   "error creating external conne…"   

[cloud_user@ip-10-0-0-11 ~]$ docker service inspect our_api
[
    {
        "ID": "png9lwynji17lwumpyp1wczej",
        "Version": {
            "Index": 216
        },
        "CreatedAt": "2018-08-03T15:48:01.186686936Z",
        "UpdatedAt": "2018-08-03T15:53:44.60994242Z",
        "Spec": {
            "Name": "our_api",
            "Labels": {},
            "TaskTemplate": {
                "ContainerSpec": {
                    "Image": "httpd:latest@sha256:8c84e065bdf72b4909bd55a348d5e91fe265e08d6b28ed9104bfdcac9206dcc8",
                    "Init": false,
                    "StopGracePeriod": 10000000000,
                    "DNSConfig": {},
                    "Isolation": "default"
                },
                "Resources": {
                    "Limits": {},
                    "Reservations": {}
                },
                "RestartPolicy": {
                    "Condition": "any",
                    "Delay": 5000000000,
                    "MaxAttempts": 0
                },
                "Placement": {
                    "Platforms": [
                        {
                            "Architecture": "amd64",
                            "OS": "linux"
                        },
                        {
                            "OS": "linux"
                        },
                        {
                            "OS": "linux"
                        },
                        {
                            "Architecture": "386",
                            "OS": "linux"
                        }
                    ]
                },
                "ForceUpdate": 0,
                "Runtime": "container"
            },
            "Mode": {
                "Replicated": {
                    "Replicas": 2
                }
            },
            "UpdateConfig": {
                "Parallelism": 1,
                "FailureAction": "pause",
                "Monitor": 5000000000,
                "MaxFailureRatio": 0,
                "Order": "stop-first"
            },
            "RollbackConfig": {
                "Parallelism": 1,
                "FailureAction": "pause",
                "Monitor": 5000000000,
                "MaxFailureRatio": 0,
                "Order": "stop-first"
            },
            "EndpointSpec": {
                "Mode": "vip",
                "Ports": [
                    {
                        "Protocol": "tcp",
                        "TargetPort": 80,
                        "PublishedPort": 80,
                        "PublishMode": "ingress"
                    }
                ]
            }
        },
        "PreviousSpec": {
            "Name": "our_api",
            "Labels": {},
            "TaskTemplate": {
                "ContainerSpec": {
                    "Image": "httpd:latest@sha256:8c84e065bdf72b4909bd55a348d5e91fe265e08d6b28ed9104bfdcac9206dcc8",
                    "Init": false,
                    "DNSConfig": {},
                    "Isolation": "default"
                },
                "Resources": {
                    "Limits": {},
                    "Reservations": {}
                },
                "Placement": {
                    "Platforms": [
                        {
                            "Architecture": "amd64",
                            "OS": "linux"
                        },
                        {
                            "OS": "linux"
                        },
                        {
                            "OS": "linux"
                        },
                        {
                            "Architecture": "386",
                            "OS": "linux"
                        }
                    ]
                },
                "ForceUpdate": 0,
                "Runtime": "container"
            },
            "Mode": {
                "Replicated": {
                    "Replicas": 4
                }
            },
            "EndpointSpec": {
                "Mode": "vip",
                "Ports": [
                    {
                        "Protocol": "tcp",
                        "TargetPort": 80,
                        "PublishedPort": 80,
                        "PublishMode": "ingress"
                    }
                ]
            }
        },
        "Endpoint": {
            "Spec": {
                "Mode": "vip",
                "Ports": [
                    {
                        "Protocol": "tcp",
                        "TargetPort": 80,
                        "PublishedPort": 80,
                        "PublishMode": "ingress"
                    }
                ]
            },
            "Ports": [
                {
                    "Protocol": "tcp",
                    "TargetPort": 80,
                    "PublishedPort": 80,
                    "PublishMode": "ingress"
                }
            ],
            "VirtualIPs": [
                {
                    "NetworkID": "r4e0uorl83jymmr7tzhmclst0",
                    "Addr": "10.255.0.4/16"
                }
            ]
        }
    }
]

[cloud_user@ip-10-0-0-11 ~]$ docker service ps our_api --no-trunc
ID                          NAME                IMAGE                                                                                  NODE                        DESIRED STATE       CURRENT STATE            ERROR               PORTS
pkhr8jqkrh6wwonf5qm3b3ghs   our_api.1           httpd:latest@sha256:8c84e065bdf72b4909bd55a348d5e91fe265e08d6b28ed9104bfdcac9206dcc8   ip-10-0-0-11.ec2.internal   Running             Running 8 minutes ago                        
73reja4m188sew1envg9em3u8   our_api.2           httpd:latest@sha256:8c84e065bdf72b4909bd55a348d5e91fe265e08d6b28ed9104bfdcac9206dcc8   ip-10-0-0-11.ec2.internal   Running             Running 6 minutes ago                        
o5zaaqw4me3w61x05f284lh76    \_ our_api.2       httpd:latest@sha256:8c84e065bdf72b4909bd55a348d5e91fe265e08d6b28ed9104bfdcac9206dcc8   ip-10-0-0-12.ec2.internal   Shutdown            Rejected 6 minutes ago   "error creating external connectivity network: Failed to Setup IP tables: Unable to enable SKIP DNAT rule:  (iptables failed: iptables --wait -t nat -I DOCKER -i docker_gwbridge -j RETURN: iptables: No chain/target/match by that name.
 (exit status 1))"          
ljezxh875elry45gtn2gxok30    \_ our_api.2       httpd:latest@sha256:8c84e065bdf72b4909bd55a348d5e91fe265e08d6b28ed9104bfdcac9206dcc8   ip-10-0-0-12.ec2.internal   Shutdown            Rejected 6 minutes ago   "error creating external connectivity network: Failed to Setup IP tables: Unable to enable SKIP DNAT rule:  (iptables failed: iptables --wait -t nat -I DOCKER -i docker_gwbridge -j RETURN: iptables: No chain/target/match by that name.
 (exit status 1))"          
gqk5tza5sepa5dw0x3z2935to    \_ our_api.2       httpd:latest@sha256:8c84e065bdf72b4909bd55a348d5e91fe265e08d6b28ed9104bfdcac9206dcc8   ip-10-0-0-12.ec2.internal   Shutdown            Rejected 6 minutes ago   "error creating external connectivity network: Failed to Setup IP tables: Unable to enable SKIP DNAT rule:  (iptables failed: iptables --wait -t nat -I DOCKER -i docker_gwbridge -j RETURN: iptables: No chain/target/match by that name.
 (exit status 1))"          
s27vbkk38fdqyv9rv17j2zuaa    \_ our_api.2       httpd:latest@sha256:8c84e065bdf72b4909bd55a348d5e91fe265e08d6b28ed9104bfdcac9206dcc8   ip-10-0-0-12.ec2.internal   Shutdown            Rejected 6 minutes ago   "error creating external connectivity network: Failed to Setup IP tables: Unable to enable SKIP DNAT rule:  (iptables failed: iptables --wait -t nat -I DOCKER -i docker_gwbridge -j RETURN: iptables: No chain/target/match by that name.
 (exit status 1))"          
8m04j5v71owvpcblg5mnyl7vw   our_api.3           httpd:latest@sha256:8c84e065bdf72b4909bd55a348d5e91fe265e08d6b28ed9104bfdcac9206dcc8   ip-10-0-0-12.ec2.internal   Shutdown            Rejected 5 minutes ago   "error creating external connectivity network: Failed to Setup IP tables: Unable to enable SKIP DNAT rule:  (iptables failed: iptables --wait -t nat -I DOCKER -i docker_gwbridge -j RETURN: iptables: No chain/target/match by that name.
 (exit status 1))"          
buu210ue9jhkq2q1hgqn0xo5w    \_ our_api.3       httpd:latest@sha256:8c84e065bdf72b4909bd55a348d5e91fe265e08d6b28ed9104bfdcac9206dcc8   ip-10-0-0-12.ec2.internal   Shutdown            Failed 5 minutes ago   "error creating external connectivity network: Failed to Setup IP tables: Unable to enable SKIP DNAT rule:  (iptables failed: iptables --wait -t nat -I DOCKER -i docker_gwbridge -j RETURN: iptables: No chain/target/match by that name.
 (exit status 1))"          
54nusd5z0dfowe9qnrw2lsorq   our_api.4           httpd:latest@sha256:8c84e065bdf72b4909bd55a348d5e91fe265e08d6b28ed9104bfdcac9206dcc8   ip-10-0-0-12.ec2.internal   Shutdown            Rejected 5 minutes ago   "error creating external connectivity network: Failed to Setup IP tables: Unable to enable SKIP DNAT rule:  (iptables failed: iptables --wait -t nat -I DOCKER -i docker_gwbridge -j RETURN: iptables: No chain/target/match by that name.
 (exit status 1))"          
xt0gtl3ixsd9wre6fldtmocb3    \_ our_api.4       httpd:latest@sha256:8c84e065bdf72b4909bd55a348d5e91fe265e08d6b28ed9104bfdcac9206dcc8   ip-10-0-0-12.ec2.internal   Shutdown            Rejected 5 minutes ago   "error creating external connectivity network: Failed to Setup IP tables: Unable to enable SKIP DNAT rule:  (iptables failed: iptables --wait -t nat -I DOCKER -i docker_gwbridge -j RETURN: iptables: No chain/target/match by that name.
 (exit status 1))"          
tjo92dqwcb2shetlgokcpy6az    \_ our_api.4       httpd:latest@sha256:8c84e065bdf72b4909bd55a348d5e91fe265e08d6b28ed9104bfdcac9206dcc8   ip-10-0-0-12.ec2.internal   Shutdown            Rejected 5 minutes ago   "error creating external connectivity network: Failed to Setup IP tables: Unable to enable SKIP DNAT rule:  (iptables failed: iptables --wait -t nat -I DOCKER -i docker_gwbridge -j RETURN: iptables: No chain/target/match by that name.
 (exit status 1))"          

[cloud_user@ip-10-0-0-11 ~]$ ^C
[cloud_user@ip-10-0-0-11 ~]$ Connection to 34.230.2.97 closed by remote host.
Connection to 34.230.2.97 closed.
craig:~ cn$

```

### Node-1 10.0.0.12

```bash

craig:~ cn$ ssh cloud_user@54.173.121.142
The authenticity of host '54.173.121.142 (54.173.121.142)' can't be established.
ECDSA key fingerprint is SHA256:UE+sN0+iPQ+7cJesmyoddnAcwghjsZn0B3BTNl81sDM.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '54.173.121.142' (ECDSA) to the list of known hosts.
cloud_user@54.173.121.142's password: 
Last login: Tue Mar 27 14:51:34 2018 from 75-142-56-142.static.mtpk.ca.charter.com
[cloud_user@ip-10-0-0-12 ~]$ bash <(curl -s https://raw.githubusercontent.com/c
raignicholson/docker-quickstart/master/03_Orchestration/centos7_dockerInstall.s
h)
[sudo] password for cloud_user: 
Loaded plugins: fastestmirror
base                                                     | 3.6 kB     00:00     
extras                                                   | 3.4 kB     00:00     
updates                                                  | 3.4 kB     00:00     
(1/4): extras/7/x86_64/primary_db                          | 173 kB   00:00     
(2/4): updates/7/x86_64/primary_db                         | 4.3 MB   00:01     
(3/4): base/7/x86_64/group_gz                              | 166 kB   00:02     
base/7/x86_64/primary_db       FAILED                                          
http://mirror.tocici.com/centos/7.5.1804/os/x86_64/repodata/03d0a660eb33174331aee3e077e11d4c017412d761b7f2eaa8555e7898e701e0-primary.sqlite.bz2: [Errno 14] curl#7 - "Failed to connect to 2605:4d00::61: Network is unreachable"
Trying other mirror.
(4/4): base/7/x86_64/primary_db                            | 5.9 MB   00:00     
Determining fastest mirrors
 * base: distro.ibiblio.org
 * extras: mirror.vcu.edu
 * updates: repo1.ash.innoscale.net
Resolving Dependencies
--> Running transaction check
---> Package device-mapper-persistent-data.x86_64 0:0.7.3-3.el7 will be installed
--> Processing Dependency: libaio.so.1(LIBAIO_0.4)(64bit) for package: device-mapper-persistent-data-0.7.3-3.el7.x86_64
--> Processing Dependency: libaio.so.1(LIBAIO_0.1)(64bit) for package: device-mapper-persistent-data-0.7.3-3.el7.x86_64
--> Processing Dependency: libaio.so.1()(64bit) for package: device-mapper-persistent-data-0.7.3-3.el7.x86_64
---> Package lvm2.x86_64 7:2.02.177-4.el7 will be installed
--> Processing Dependency: lvm2-libs = 7:2.02.177-4.el7 for package: 7:lvm2-2.02.177-4.el7.x86_64
--> Processing Dependency: liblvm2app.so.2.2(Base)(64bit) for package: 7:lvm2-2.02.177-4.el7.x86_64
--> Processing Dependency: libdevmapper.so.1.02(DM_1_02_141)(64bit) for package: 7:lvm2-2.02.177-4.el7.x86_64
--> Processing Dependency: libdevmapper-event.so.1.02(Base)(64bit) for package: 7:lvm2-2.02.177-4.el7.x86_64
--> Processing Dependency: liblvm2app.so.2.2()(64bit) for package: 7:lvm2-2.02.177-4.el7.x86_64
--> Processing Dependency: libdevmapper-event.so.1.02()(64bit) for package: 7:lvm2-2.02.177-4.el7.x86_64
---> Package yum-utils.noarch 0:1.1.31-46.el7_5 will be installed
--> Processing Dependency: python-kitchen for package: yum-utils-1.1.31-46.el7_5.noarch
--> Processing Dependency: libxml2-python for package: yum-utils-1.1.31-46.el7_5.noarch
--> Running transaction check
---> Package device-mapper-event-libs.x86_64 7:1.02.146-4.el7 will be installed
---> Package device-mapper-libs.x86_64 7:1.02.140-8.el7 will be updated
--> Processing Dependency: device-mapper-libs = 7:1.02.140-8.el7 for package: 7:device-mapper-1.02.140-8.el7.x86_64
---> Package device-mapper-libs.x86_64 7:1.02.146-4.el7 will be an update
---> Package libaio.x86_64 0:0.3.109-13.el7 will be installed
---> Package libxml2-python.x86_64 0:2.9.1-6.el7_2.3 will be installed
---> Package lvm2-libs.x86_64 7:2.02.177-4.el7 will be installed
--> Processing Dependency: device-mapper-event = 7:1.02.146-4.el7 for package: 7:lvm2-libs-2.02.177-4.el7.x86_64
---> Package python-kitchen.noarch 0:1.1.1-5.el7 will be installed
--> Running transaction check
---> Package device-mapper.x86_64 7:1.02.140-8.el7 will be updated
---> Package device-mapper.x86_64 7:1.02.146-4.el7 will be an update
---> Package device-mapper-event.x86_64 7:1.02.146-4.el7 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

===============================================================================================================================================
 Package                                         Arch                     Version                              Repository                 Size
===============================================================================================================================================
Installing:
 device-mapper-persistent-data                   x86_64                   0.7.3-3.el7                          base                      405 k
 lvm2                                            x86_64                   7:2.02.177-4.el7                     base                      1.3 M
 yum-utils                                       noarch                   1.1.31-46.el7_5                      updates                   120 k
Installing for dependencies:
 device-mapper-event                             x86_64                   7:1.02.146-4.el7                     base                      185 k
 device-mapper-event-libs                        x86_64                   7:1.02.146-4.el7                     base                      184 k
 libaio                                          x86_64                   0.3.109-13.el7                       base                       24 k
 libxml2-python                                  x86_64                   2.9.1-6.el7_2.3                      base                      247 k
 lvm2-libs                                       x86_64                   7:2.02.177-4.el7                     base                      1.0 M
 python-kitchen                                  noarch                   1.1.1-5.el7                          base                      267 k
Updating for dependencies:
 device-mapper                                   x86_64                   7:1.02.146-4.el7                     base                      289 k
 device-mapper-libs                              x86_64                   7:1.02.146-4.el7                     base                      316 k

Transaction Summary
===============================================================================================================================================
Install  3 Packages (+6 Dependent packages)
Upgrade             ( 2 Dependent packages)

Total download size: 4.3 M
Downloading packages:
Delta RPMs disabled because /usr/bin/applydeltarpm not installed.
(1/11): device-mapper-event-1.02.146-4.el7.x86_64.rpm                                                                   | 185 kB  00:00:00     
(2/11): device-mapper-1.02.146-4.el7.x86_64.rpm                                                                         | 289 kB  00:00:00     
(3/11): device-mapper-event-libs-1.02.146-4.el7.x86_64.rpm                                                              | 184 kB  00:00:00     
(4/11): device-mapper-libs-1.02.146-4.el7.x86_64.rpm                                                                    | 316 kB  00:00:00     
(5/11): device-mapper-persistent-data-0.7.3-3.el7.x86_64.rpm                                                            | 405 kB  00:00:00     
(6/11): libaio-0.3.109-13.el7.x86_64.rpm                                                                                |  24 kB  00:00:00     
(7/11): libxml2-python-2.9.1-6.el7_2.3.x86_64.rpm                                                                       | 247 kB  00:00:00     
(8/11): lvm2-libs-2.02.177-4.el7.x86_64.rpm                                                                             | 1.0 MB  00:00:00     
(9/11): python-kitchen-1.1.1-5.el7.noarch.rpm                                                                           | 267 kB  00:00:00     
(10/11): lvm2-2.02.177-4.el7.x86_64.rpm                                                                                 | 1.3 MB  00:00:00     
(11/11): yum-utils-1.1.31-46.el7_5.noarch.rpm                                                                           | 120 kB  00:00:00     
-----------------------------------------------------------------------------------------------------------------------------------------------
Total                                                                                                          3.9 MB/s | 4.3 MB  00:00:01     
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Updating   : 7:device-mapper-libs-1.02.146-4.el7.x86_64                                                                                 1/13 
  Updating   : 7:device-mapper-1.02.146-4.el7.x86_64                                                                                      2/13 
  Installing : 7:device-mapper-event-libs-1.02.146-4.el7.x86_64                                                                           3/13 
  Installing : 7:device-mapper-event-1.02.146-4.el7.x86_64                                                                                4/13 
  Installing : 7:lvm2-libs-2.02.177-4.el7.x86_64                                                                                          5/13 
  Installing : libaio-0.3.109-13.el7.x86_64                                                                                               6/13 
  Installing : device-mapper-persistent-data-0.7.3-3.el7.x86_64                                                                           7/13 
  Installing : python-kitchen-1.1.1-5.el7.noarch                                                                                          8/13 
  Installing : libxml2-python-2.9.1-6.el7_2.3.x86_64                                                                                      9/13 
  Installing : yum-utils-1.1.31-46.el7_5.noarch                                                                                          10/13 
  Installing : 7:lvm2-2.02.177-4.el7.x86_64                                                                                              11/13 
Created symlink from /etc/systemd/system/sysinit.target.wants/lvm2-lvmpolld.socket to /usr/lib/systemd/system/lvm2-lvmpolld.socket.
  Cleanup    : 7:device-mapper-libs-1.02.140-8.el7.x86_64                                                                                12/13 
  Cleanup    : 7:device-mapper-1.02.140-8.el7.x86_64                                                                                     13/13 
  Verifying  : device-mapper-persistent-data-0.7.3-3.el7.x86_64                                                                           1/13 
  Verifying  : 7:lvm2-2.02.177-4.el7.x86_64                                                                                               2/13 
  Verifying  : yum-utils-1.1.31-46.el7_5.noarch                                                                                           3/13 
  Verifying  : 7:device-mapper-1.02.146-4.el7.x86_64                                                                                      4/13 
  Verifying  : 7:device-mapper-event-1.02.146-4.el7.x86_64                                                                                5/13 
  Verifying  : libxml2-python-2.9.1-6.el7_2.3.x86_64                                                                                      6/13 
  Verifying  : python-kitchen-1.1.1-5.el7.noarch                                                                                          7/13 
  Verifying  : 7:device-mapper-event-libs-1.02.146-4.el7.x86_64                                                                           8/13 
  Verifying  : 7:lvm2-libs-2.02.177-4.el7.x86_64                                                                                          9/13 
  Verifying  : libaio-0.3.109-13.el7.x86_64                                                                                              10/13 
  Verifying  : 7:device-mapper-libs-1.02.146-4.el7.x86_64                                                                                11/13 
  Verifying  : 7:device-mapper-1.02.140-8.el7.x86_64                                                                                     12/13 
  Verifying  : 7:device-mapper-libs-1.02.140-8.el7.x86_64                                                                                13/13 

Installed:
  device-mapper-persistent-data.x86_64 0:0.7.3-3.el7          lvm2.x86_64 7:2.02.177-4.el7          yum-utils.noarch 0:1.1.31-46.el7_5         

Dependency Installed:
  device-mapper-event.x86_64 7:1.02.146-4.el7     device-mapper-event-libs.x86_64 7:1.02.146-4.el7     libaio.x86_64 0:0.3.109-13.el7         
  libxml2-python.x86_64 0:2.9.1-6.el7_2.3         lvm2-libs.x86_64 7:2.02.177-4.el7                    python-kitchen.noarch 0:1.1.1-5.el7    

Dependency Updated:
  device-mapper.x86_64 7:1.02.146-4.el7                               device-mapper-libs.x86_64 7:1.02.146-4.el7                              

Complete!
Loaded plugins: fastestmirror
adding repo from: https://download.docker.com/linux/centos/docker-ce.repo
grabbing file https://download.docker.com/linux/centos/docker-ce.repo to /etc/yum.repos.d/docker-ce.repo
repo saved to /etc/yum.repos.d/docker-ce.repo
Loaded plugins: fastestmirror
docker-ce-stable                                                                                                        | 2.9 kB  00:00:00     
docker-ce-stable/x86_64/primary_db                                                                                      |  14 kB  00:00:00     
Loading mirror speeds from cached hostfile
 * base: distro.ibiblio.org
 * extras: mirror.vcu.edu
 * updates: repo1.ash.innoscale.net
Resolving Dependencies
--> Running transaction check
---> Package docker-ce.x86_64 0:18.06.0.ce-3.el7 will be installed
--> Processing Dependency: container-selinux >= 2.9 for package: docker-ce-18.06.0.ce-3.el7.x86_64
--> Processing Dependency: libltdl.so.7()(64bit) for package: docker-ce-18.06.0.ce-3.el7.x86_64
--> Running transaction check
---> Package container-selinux.noarch 2:2.66-1.el7 will be installed
--> Processing Dependency: selinux-policy-targeted >= 3.13.1-192 for package: 2:container-selinux-2.66-1.el7.noarch
--> Processing Dependency: selinux-policy-base >= 3.13.1-192 for package: 2:container-selinux-2.66-1.el7.noarch
--> Processing Dependency: selinux-policy >= 3.13.1-192 for package: 2:container-selinux-2.66-1.el7.noarch
---> Package libtool-ltdl.x86_64 0:2.4.2-22.el7_3 will be installed
--> Running transaction check
---> Package selinux-policy.noarch 0:3.13.1-166.el7_4.9 will be updated
---> Package selinux-policy.noarch 0:3.13.1-192.el7_5.4 will be an update
--> Processing Dependency: policycoreutils >= 2.5-18 for package: selinux-policy-3.13.1-192.el7_5.4.noarch
---> Package selinux-policy-targeted.noarch 0:3.13.1-166.el7_4.9 will be updated
---> Package selinux-policy-targeted.noarch 0:3.13.1-192.el7_5.4 will be an update
--> Running transaction check
---> Package policycoreutils.x86_64 0:2.5-17.1.el7 will be updated
--> Processing Dependency: policycoreutils = 2.5-17.1.el7 for package: policycoreutils-python-2.5-17.1.el7.x86_64
---> Package policycoreutils.x86_64 0:2.5-22.el7 will be an update
--> Processing Dependency: libsepol >= 2.5-8 for package: policycoreutils-2.5-22.el7.x86_64
--> Processing Dependency: libselinux-utils >= 2.5-12 for package: policycoreutils-2.5-22.el7.x86_64
--> Running transaction check
---> Package libselinux-utils.x86_64 0:2.5-11.el7 will be updated
---> Package libselinux-utils.x86_64 0:2.5-12.el7 will be an update
--> Processing Dependency: libselinux(x86-64) = 2.5-12.el7 for package: libselinux-utils-2.5-12.el7.x86_64
---> Package libsepol.i686 0:2.5-6.el7 will be updated
---> Package libsepol.x86_64 0:2.5-6.el7 will be updated
---> Package libsepol.i686 0:2.5-8.1.el7 will be an update
---> Package libsepol.x86_64 0:2.5-8.1.el7 will be an update
---> Package policycoreutils-python.x86_64 0:2.5-17.1.el7 will be updated
---> Package policycoreutils-python.x86_64 0:2.5-22.el7 will be an update
--> Processing Dependency: setools-libs >= 3.3.8-2 for package: policycoreutils-python-2.5-22.el7.x86_64
--> Processing Dependency: libsemanage-python >= 2.5-9 for package: policycoreutils-python-2.5-22.el7.x86_64
--> Running transaction check
---> Package libselinux.i686 0:2.5-11.el7 will be updated
---> Package libselinux.x86_64 0:2.5-11.el7 will be updated
--> Processing Dependency: libselinux(x86-64) = 2.5-11.el7 for package: libselinux-python-2.5-11.el7.x86_64
---> Package libselinux.i686 0:2.5-12.el7 will be an update
---> Package libselinux.x86_64 0:2.5-12.el7 will be an update
---> Package libsemanage-python.x86_64 0:2.5-8.el7 will be updated
---> Package libsemanage-python.x86_64 0:2.5-11.el7 will be an update
--> Processing Dependency: libsemanage = 2.5-11.el7 for package: libsemanage-python-2.5-11.el7.x86_64
---> Package setools-libs.x86_64 0:3.3.8-1.1.el7 will be updated
---> Package setools-libs.x86_64 0:3.3.8-2.el7 will be an update
--> Running transaction check
---> Package libselinux-python.x86_64 0:2.5-11.el7 will be updated
---> Package libselinux-python.x86_64 0:2.5-12.el7 will be an update
---> Package libsemanage.x86_64 0:2.5-8.el7 will be updated
---> Package libsemanage.x86_64 0:2.5-11.el7 will be an update
--> Finished Dependency Resolution

Dependencies Resolved

===============================================================================================================================================
 Package                                  Arch                    Version                              Repository                         Size
===============================================================================================================================================
Installing:
 docker-ce                                x86_64                  18.06.0.ce-3.el7                     docker-ce-stable                   41 M
Installing for dependencies:
 container-selinux                        noarch                  2:2.66-1.el7                         extras                             35 k
 libtool-ltdl                             x86_64                  2.4.2-22.el7_3                       base                               49 k
Updating for dependencies:
 libselinux                               i686                    2.5-12.el7                           base                              166 k
 libselinux                               x86_64                  2.5-12.el7                           base                              162 k
 libselinux-python                        x86_64                  2.5-12.el7                           base                              235 k
 libselinux-utils                         x86_64                  2.5-12.el7                           base                              151 k
 libsemanage                              x86_64                  2.5-11.el7                           base                              150 k
 libsemanage-python                       x86_64                  2.5-11.el7                           base                              112 k
 libsepol                                 i686                    2.5-8.1.el7                          base                              293 k
 libsepol                                 x86_64                  2.5-8.1.el7                          base                              297 k
 policycoreutils                          x86_64                  2.5-22.el7                           base                              867 k
 policycoreutils-python                   x86_64                  2.5-22.el7                           base                              454 k
 selinux-policy                           noarch                  3.13.1-192.el7_5.4                   updates                           453 k
 selinux-policy-targeted                  noarch                  3.13.1-192.el7_5.4                   updates                           6.6 M
 setools-libs                             x86_64                  3.3.8-2.el7                          base                              619 k

Transaction Summary
===============================================================================================================================================
Install  1 Package  (+ 2 Dependent packages)
Upgrade             ( 13 Dependent packages)

Total download size: 51 M
Downloading packages:
Delta RPMs disabled because /usr/bin/applydeltarpm not installed.
(1/16): container-selinux-2.66-1.el7.noarch.rpm                                                                         |  35 kB  00:00:00     
(2/16): libselinux-2.5-12.el7.x86_64.rpm                                                                                | 162 kB  00:00:00     
(3/16): libselinux-2.5-12.el7.i686.rpm                                                                                  | 166 kB  00:00:00     
(4/16): libselinux-python-2.5-12.el7.x86_64.rpm                                                                         | 235 kB  00:00:00     
(5/16): libsemanage-2.5-11.el7.x86_64.rpm                                                                               | 150 kB  00:00:00     
(6/16): libsemanage-python-2.5-11.el7.x86_64.rpm                                                                        | 112 kB  00:00:00     
(7/16): libsepol-2.5-8.1.el7.i686.rpm                                                                                   | 293 kB  00:00:00     
(8/16): libsepol-2.5-8.1.el7.x86_64.rpm                                                                                 | 297 kB  00:00:00     
(9/16): libselinux-utils-2.5-12.el7.x86_64.rpm                                                                          | 151 kB  00:00:00     
(10/16): libtool-ltdl-2.4.2-22.el7_3.x86_64.rpm                                                                         |  49 kB  00:00:00     
(11/16): policycoreutils-python-2.5-22.el7.x86_64.rpm                                                                   | 454 kB  00:00:00     
(12/16): setools-libs-3.3.8-2.el7.x86_64.rpm                                                                            | 619 kB  00:00:00     
(13/16): policycoreutils-2.5-22.el7.x86_64.rpm                                                                          | 867 kB  00:00:00     
warning: /var/cache/yum/x86_64/7/docker-ce-stable/packages/docker-ce-18.06.0.ce-3.el7.x86_64.rpm: Header V4 RSA/SHA512 Signature, key ID 621e9f35: NOKEY
Public key for docker-ce-18.06.0.ce-3.el7.x86_64.rpm is not installed
(14/16): docker-ce-18.06.0.ce-3.el7.x86_64.rpm                                                                          |  41 MB  00:00:01     
(15/16): selinux-policy-3.13.1-192.el7_5.4.noarch.rpm                                                                   | 453 kB  00:00:00     
(16/16): selinux-policy-targeted-3.13.1-192.el7_5.4.noarch.rpm                                                          | 6.6 MB  00:00:01     
-----------------------------------------------------------------------------------------------------------------------------------------------
Total                                                                                                           24 MB/s |  51 MB  00:00:02     
Retrieving key from https://download.docker.com/linux/centos/gpg
Importing GPG key 0x621E9F35:
 Userid     : "Docker Release (CE rpm) <docker@docker.com>"
 Fingerprint: 060a 61c5 1b55 8a7f 742b 77aa c52f eb6b 621e 9f35
 From       : https://download.docker.com/linux/centos/gpg
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Updating   : libsepol-2.5-8.1.el7.x86_64                                                                                                1/29 
  Updating   : libselinux-2.5-12.el7.x86_64                                                                                               2/29 
  Updating   : libsemanage-2.5-11.el7.x86_64                                                                                              3/29 
  Updating   : libselinux-utils-2.5-12.el7.x86_64                                                                                         4/29 
  Updating   : policycoreutils-2.5-22.el7.x86_64                                                                                          5/29 
  Updating   : selinux-policy-3.13.1-192.el7_5.4.noarch                                                                                   6/29 
  Updating   : selinux-policy-targeted-3.13.1-192.el7_5.4.noarch                                                                          7/29 
  Updating   : libsemanage-python-2.5-11.el7.x86_64                                                                                       8/29 
  Updating   : libselinux-python-2.5-12.el7.x86_64                                                                                        9/29 
  Updating   : setools-libs-3.3.8-2.el7.x86_64                                                                                           10/29 
  Updating   : policycoreutils-python-2.5-22.el7.x86_64                                                                                  11/29 
  Installing : 2:container-selinux-2.66-1.el7.noarch                                                                                     12/29 
  Installing : libtool-ltdl-2.4.2-22.el7_3.x86_64                                                                                        13/29 
  Updating   : libsepol-2.5-8.1.el7.i686                                                                                                 14/29 
  Installing : docker-ce-18.06.0.ce-3.el7.x86_64                                                                                         15/29 
  Updating   : libselinux-2.5-12.el7.i686                                                                                                16/29 
  Cleanup    : selinux-policy-targeted-3.13.1-166.el7_4.9.noarch                                                                         17/29 
  Cleanup    : policycoreutils-python-2.5-17.1.el7.x86_64                                                                                18/29 
  Cleanup    : selinux-policy-3.13.1-166.el7_4.9.noarch                                                                                  19/29 
  Cleanup    : libselinux-2.5-11.el7                                                                                                     20/29 
  Cleanup    : policycoreutils-2.5-17.1.el7.x86_64                                                                                       21/29 
  Cleanup    : libselinux-utils-2.5-11.el7.x86_64                                                                                        22/29 
  Cleanup    : setools-libs-3.3.8-1.1.el7.x86_64                                                                                         23/29 
  Cleanup    : libselinux-python-2.5-11.el7.x86_64                                                                                       24/29 
  Cleanup    : libsemanage-python-2.5-8.el7.x86_64                                                                                       25/29 
  Cleanup    : libsepol-2.5-6.el7                                                                                                        26/29 
  Cleanup    : libsemanage-2.5-8.el7.x86_64                                                                                              27/29 
  Cleanup    : libselinux-2.5-11.el7                                                                                                     28/29 
  Cleanup    : libsepol-2.5-6.el7                                                                                                        29/29 
  Verifying  : libselinux-python-2.5-12.el7.x86_64                                                                                        1/29 
  Verifying  : selinux-policy-3.13.1-192.el7_5.4.noarch                                                                                   2/29 
  Verifying  : setools-libs-3.3.8-2.el7.x86_64                                                                                            3/29 
  Verifying  : libsemanage-python-2.5-11.el7.x86_64                                                                                       4/29 
  Verifying  : policycoreutils-2.5-22.el7.x86_64                                                                                          5/29 
  Verifying  : libsepol-2.5-8.1.el7.i686                                                                                                  6/29 
  Verifying  : libsemanage-2.5-11.el7.x86_64                                                                                              7/29 
  Verifying  : selinux-policy-targeted-3.13.1-192.el7_5.4.noarch                                                                          8/29 
  Verifying  : policycoreutils-python-2.5-22.el7.x86_64                                                                                   9/29 
  Verifying  : libtool-ltdl-2.4.2-22.el7_3.x86_64                                                                                        10/29 
  Verifying  : 2:container-selinux-2.66-1.el7.noarch                                                                                     11/29 
  Verifying  : libselinux-2.5-12.el7.i686                                                                                                12/29 
  Verifying  : docker-ce-18.06.0.ce-3.el7.x86_64                                                                                         13/29 
  Verifying  : libsepol-2.5-8.1.el7.x86_64                                                                                               14/29 
  Verifying  : libselinux-2.5-12.el7.x86_64                                                                                              15/29 
  Verifying  : libselinux-utils-2.5-12.el7.x86_64                                                                                        16/29 
  Verifying  : libselinux-utils-2.5-11.el7.x86_64                                                                                        17/29 
  Verifying  : libsepol-2.5-6.el7.i686                                                                                                   18/29 
  Verifying  : libselinux-2.5-11.el7.x86_64                                                                                              19/29 
  Verifying  : libsepol-2.5-6.el7.x86_64                                                                                                 20/29 
  Verifying  : policycoreutils-python-2.5-17.1.el7.x86_64                                                                                21/29 
  Verifying  : selinux-policy-targeted-3.13.1-166.el7_4.9.noarch                                                                         22/29 
  Verifying  : policycoreutils-2.5-17.1.el7.x86_64                                                                                       23/29 
  Verifying  : selinux-policy-3.13.1-166.el7_4.9.noarch                                                                                  24/29 
  Verifying  : libsemanage-python-2.5-8.el7.x86_64                                                                                       25/29 
  Verifying  : libselinux-2.5-11.el7.i686                                                                                                26/29 
  Verifying  : libsemanage-2.5-8.el7.x86_64                                                                                              27/29 
  Verifying  : libselinux-python-2.5-11.el7.x86_64                                                                                       28/29 
  Verifying  : setools-libs-3.3.8-1.1.el7.x86_64                                                                                         29/29 

Installed:
  docker-ce.x86_64 0:18.06.0.ce-3.el7                                                                                                          

Dependency Installed:
  container-selinux.noarch 2:2.66-1.el7                                  libtool-ltdl.x86_64 0:2.4.2-22.el7_3                                 
▽
Dependency Updated:
  libselinux.i686 0:2.5-12.el7                libselinux.x86_64 0:2.5-12.el7              libselinux-python.x86_64 0:2.5-12.el7               
  libselinux-utils.x86_64 0:2.5-12.el7        libsemanage.x86_64 0:2.5-11.el7             libsemanage-python.x86_64 0:2.5-11.el7              
  libsepol.i686 0:2.5-8.1.el7                 libsepol.x86_64 0:2.5-8.1.el7               policycoreutils.x86_64 0:2.5-22.el7                 
  policycoreutils-python.x86_64 0:2.5-22.el7  selinux-policy.noarch 0:3.13.1-192.el7_5.4  selinux-policy-targeted.noarch 0:3.13.1-192.el7_5.4 
  setools-libs.x86_64 0:3.3.8-2.el7          

Complete!
groupadd: group 'docker' already exists
Created symlink from /etc/systemd/system/multi-user.target.wants/docker.service to /usr/lib/systemd/system/docker.service.
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
 * base: distro.ibiblio.org
 * extras: mirror.vcu.edu
 * updates: repo1.ash.innoscale.net
No unfinished transactions left.
[cloud_user@ip-10-0-0-12 ~]$ docker images
Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Get http://%2Fvar%2Frun%2Fdocker.sock/v1.38/images/json: dial unix /var/run/docker.sock: connect: permission denied
[cloud_user@ip-10-0-0-12 ~]$ exit
logout
Connection to 54.173.121.142 closed.
craig:~ cn$ ssh user@52.73.160.222
^C        
craig:~ cn$ ssh cloud_user@54.173.121.142
cloud_user@54.173.121.142's password: 
Last login: Fri Aug  3 11:40:40 2018 from 108-74-118-125.lightspeed.tukrga.sbcglobal.net
[cloud_user@ip-10-0-0-12 ~]$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
[cloud_user@ip-10-0-0-12 ~]$ sudo vim /etc/hosts
[sudo] password for cloud_user: 

127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

10.0.0.11 manager
10.0.0.12 node1
~                                                                                                                                              
~                                                                                                                                              
~                                                                                                                                              
~                                                                                                                                              
~                                                                                                                                              
~                                                                                                                                              
~                                                                                                                                              
~                                                                                                                                              
~                                                                                                                                              
~                                                                                                                                              
~                                                                                                                                              
~                                                                                                                                              
~                                                                                                                                              
~                                                                                                                                              
~                                                                                                                                              
~                                                                                                                                              
~                                                                                                                                              
~                                                                                                                                              
~                                                                                                                                              
~                                                                                                                                              
~                                                                                                                                              
~                                                                                            "/etc/hosts" 5L, 193C written                                                                                                
[cloud_user@ip-10-0-0-12 ~]$ docker swarm join --token SWMTKN-1-3cni1469xirj0sykjtp8jlvmsw1i3lbo9t1lhb9dza3xeo03a8-8h72iqqx5m6oayh1wpfbdi5uh 1
0.0.0.11:2377
Error response from daemon: rpc error: code = Unavailable desc = all SubConns are in TransientFailure, latest connection error: connection error: desc = "transport: Error while dialing dial tcp 10.0.0.11:2377: connect: no route to host"
[cloud_user@ip-10-0-0-12 ~]$ sudo systemctl disable firewalld && sudo systemctl stop firewalld
Removed symlink /etc/systemd/system/dbus-org.fedoraproject.FirewallD1.service.
Removed symlink /etc/systemd/system/basic.target.wants/firewalld.service.
[cloud_user@ip-10-0-0-12 ~]$ docker swarm join --token SWMTKN-1-3cni1469xirj0sykjtp8jlvmsw1i3lbo9t1lhb9dza3xeo03a8-8h72iqqx5m6oayh1wpfbdi5uh 1
0.0.0.11:2377
This node joined a swarm as a worker.
[cloud_user@ip-10-0-0-12 ~]$ Connection to 54.173.121.142 closed by remote host.
Connection to 54.173.121.142 closed.
craig:~ cn$ 

```
