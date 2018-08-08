# Quizs

## Installation and Configuration (Section Quiz)

1) Which of the following commands will display a summary of the system configuration as seen by the Docker service?

Correct

Correct answer
docker info

Explanation
The 'docker info' command displays system wide configuration information as seen by the Docker service.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1376/lesson/4/module/150

1) Which of the following configuration files can be used to override the default Docker logging driver?

Correct

Correct answer
/etc/docker/daemon.json

Explanation
The /etc/docker/daemon.json file is used to override various Docker defaults, including the logging driver.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1376/lesson/4/module/150

1) When Docker is first installed, what is the name of the default Docker network interface that is created?

Correct

Correct answer
docker0

Explanation
The Docker installation will create a network interface called 'docker0' that will function as both the 'gateway' to the private network on the host, which is used for Docker container communication, as well as defining the network range available for container IP assignments.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1376/lesson/1/module/150

1) Which directory will contain the Docker image storage layers (by default) on a host?

Correct

Correct answer
/var/lib/docker

Explanation
Storage related to Docker image and container layers are stored in /var/lib/docker unless changed in the configuration or daemon at launch time.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1376/lesson/3/module/150

1) Which of the following commands will enable and start the Docker CE service?

Correct

Correct answer
systemctl enable docker && systemctl start docker

Explanation
The Docker CE service can be enabled and started via typical systemd service management methods.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1376/lesson/1/module/150

1) What information is contained in the '/run/docker.pid' file when the Docker service is running?

Correct

Correct answer
The PID (Process ID) of the Docker service.

Explanation
The 'docker.pid' file only contains the number corresponding to the process of the Docker service.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1376/lesson/1/module/150

1) Which file, owned by Docker in the /run directory, determines which accounts can use the service?

Correct

Correct answer
/run/docker.sock

Explanation
The 'docker.sock' command is owned by the 'docker' group. Adding a user to this group will allow them to run Docker commands with unprivileged accounts.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1376/lesson/1/module/150

1) The 'docker' service can be queried for its state (whether it is stopped or running) with which of the following commands?

Correct

Correct answer
systemctl status docker

Explanation
The Docker service can be managed via standard systemd service management utilities.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1376/lesson/1/module/150

1) Which of the following are requirements for Docker to run but are NOT installed as dependencies? (Choose all that apply)

Correct

Correct answer
yum-utils, lvm2, device-mapper-persistent-data

Explanation
The first three are not installed with Docker and exist on most full system installations, but they may need to be added to a server or minimal initial configurations.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1376/lesson/1/module/150

1) Which command will enable the 'user' account to access the Docker application, and the system resources necessary to execute Docker commands, without needing elevated privileges?

Correct

Correct answer
usermod -aG docker user

Explanation
By adding the 'user' account to the 'docker' group and then logging out/back in, the 'user' will now belong to the group that owns the Docker socket file in the /run directory, therefore allowing non-privileged running of Docker commands.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1376/lesson/1/module/150

## QUIZ : IMAGE CREATION, MANAGEMENT, AND REGISTRY (SECTION QUIZ)

1) Which of the following commands will allow you to interact inside a container and will NOT cause the container to stop when you exit the running shell?

Correct

Correct answer
docker exec -it [containername] /bin/bash

Explanation
Attaching directly to a running container and then exiting the shell will cause the container to stop. Executing another shell in a running container and then exiting that shell will not stop the underlying container process started on instantiation.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1375/lesson/6/module/150

1) Which of the following configuration files will allow you to change the configured Docker storage driver?

Correct

Correct answer
/etc/docker/daemon.json

Explanation
The /etc/docker/daemon.json file can be used to changed various default Docker configuration items, the storage driver included.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1375/lesson/12/module/150

1) Which of the following commands will list the status of a Docker Swarm cluster when run from the primary manager node?

Correct

Correct answer
docker node ls

Explanation
Docker typically uses the 'docker' command followed by the object that the subsequent action should be performed on.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1376/lesson/6/module/150

1) When creating a Dockerfile intended to be used for local image creation in the current directory, which of the following commands will build the file into an image and create it with the name 'myimage:v1'?

Correct

Correct answer
docker build -t myimage:v1 .

Explanation
When the Dockerfile is in the current context (directory), you build it with an image name and tag with the -t option followed by the image:tag and the directory context of the file, in this case '.'.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1375/lesson/7/module/150

1) From the list below, which option would you add to the 'docker login' command in order to provide the username to the repository in order to log in?

Correct

Correct answer
--username=[USERNAME]

Explanation
The '--username=[USERNAME]' will allow you to specify the intended account to login with at the remote image repository.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1375/lesson/14/module/150


## ORCHESTRATION (SECTION QUIZ)

1) When run on the manager node, this command will remove the indicated node from the swarm it is a member of.

Correct

Correct answer
docker node rm [NODE ID]

Explanation
Docker will apply the 'rm' to the indicated object identified by the NODE ID in the current swarm.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1376/lesson/6/module/150

2) Create a service called 'my_api' with one of the following commands as if it is being run on the manager node based on a locally installed image called 'httpd'.

Correct

Correct answer
docker service create --name my_api httpd

Explanation
When run on the manager, Docker will create the indicated 'my_api' service.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1374/lesson/3/module/150

3) Given a token called 'ighhsjkd6637' and an IP of 10.0.1.100, which of the following commands would allow a node to join the indicated cluster of the IP above?

Correct

Correct answer
docker swarm join --token ighhsjkd6637 10.0.1.100:2377

Explanation
Docker allows a node with the appropriate token to join the swarm indicated by the IP and port.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1376/lesson/6/module/150

4) Once a node in a cluster has been marked 'down', which of the following commands will allow you to remove that node from the cluster?

Correct

Correct answer
docker node rm [NODE ID]

Explanation
Docker tries to use typical/recognizable actions following the object that they are intended to operate on (in this case, 'rm' being a well known command for removing something).

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1376/lesson/6/module/150

5) One of the following commands, when executed on one of the master nodes, will display the logs for the indicated service running on the swarm.

Correct

Correct answer
docker service logs [SERVICE NAME]

Explanation
Displays the logs for the indicated service running on an existing cluster.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1374/lesson/10/module/150

6) Which of the following commands will allow you to scale your service, called 'my_api', from whatever its current replica count is to TEN replicas in the cluster?

Correct

Correct answer
docker service scale my_api=10

Explanation
Docker allows you to indicate the number of nodes that the indicated service should scale to simply by assigning the appropriate number to the service name.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1374/lesson/4/module/150

7) Which of the following commands will allow you to retrieve the command needed for a node to join a cluster?

Correct

Correct answer
docker swarm join-token worker

Explanation
Docker provides the necessary command for any node to join upon creation. The indicated command will allow you to redisplay that information for additional nodes to use.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1376/lesson/5/module/150

8) Undo the 'drain' task applied to a node so that it can be used again for services.

Incorrect

Correct answer
docker node update --availability active [NODE ID]

Explanation
Once a node has been drained, it is marked DOWN and must be updated to ACTIVE status so that it's availability for services as advertised.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1374/lesson/3/module/150

9) One of the commands below will drain the indicated node so that future services will not run on it unless the command is undone (when run from the manager node).

Correct

Correct answer
docker node update --availability drain [NODE ID]

Explanation
Docker updates the object (node) to DOWN when the availability is indicated to be 'drain' on the indicated NODE ID.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1374/lesson/3/module/150

10) The following option, when added to the 'docker inspect [NODE ID]' command will format the associated output in a more easily readable format.

Correct

Correct answer
--pretty

Explanation
The output will be formatted as to be more easily readable on standard output.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1376/lesson/3/module/150

11) Which of the following commands will allow you to scale the number of replicas in your swarm to FIVE once the cluster is already running?

Correct

Correct answer
docker service scale [SERVICE NAME]=5

Explanation
The 'scale' option allows you to indicate the service to scale along with the number of replicas to scale to.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1374/lesson/4/module/150

12) Create a service called 'my_api' that contains three replicas from a service image called MYAPI:

Correct

Correct answer
docker service create --name my_api --replicas 3 MYAPI

Explanation
The 'service' object allows you to create a service with the specified number of replicas from the indicated service image.

Further Reading
https://linuxacademy.com/cp/admin/questionadmin/id/6288/quizid/489/moduleid/150

13) Choose the command that will remove a service called 'my_api' from the running swarm.

Correct

Correct answer
docker service rm my_api

Explanation
Docker will allow you to remove the named service using the traditional 'rm' command.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1374/lesson/4/module/150

14) Which of the following commands would stop a service called 'myweb' on your cluster?

Incorrect

Correct answer
docker service rm myweb

Explanation
Docker requires you to specify the 'service' object when removing a service rather than a single container from a host.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1374/lesson/4/module/150

15) One of the following commands allows you to 'gracefully' leave a swarm that your node is a member of (when executed from the intended node).

Correct

Correct answer
docker swarm leave

Explanation
When executed from the node you are removing, you can gracefully leave the cluster without having to use the NODE ID.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1376/lesson/5/module/150

16) Which command will list all the nodes in the swarm when issued on one of the manager nodes in a cluster?

Correct

Correct answer
docker node ls

Explanation
The simple 'ls' command applied to the 'node' object from the manager provides a list of all nodes that the manager is aware of.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1376/lesson/6/module/150

17) Which of the following commands will allow you to retrieve the necessary information for a 'manager' node to join an existing cluster?

Correct

Correct answer
docker swarm join-token manager

Explanation
Docker will display the necessary information for a manager or node to join a cluster during initialization. This command will allow you to retrieve that information for subsequent joins.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1376/lesson/5/module/150

18) Undo the 'drain' task applied to a node so that it can be used again for services.

Incorrect

Correct answer
docker node update --availability active [NODE ID]

Explanation
Once a node has been drained, it is marked DOWN and must be updated to ACTIVE status so that it's availability for services as advertised.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1374/lesson/3/module/150





6) Which of the following commands will allow you to retrieve the necessary information for a 'manager' node to join an existing cluster?

Incorrect

Correct answer
docker swarm join-token manager

Explanation
Docker will display the necessary information for a manager or node to join a cluster during initialization. This command will allow you to retrieve that information for subsequent joins.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1376/lesson/5/module/150



14) One of the commands below will drain the indicated node so that future services will not run on it unless the command is undone (when run from the manager node).

Incorrect

Correct answer
docker node update --availability drain [NODE ID]

Explanation
Docker updates the object (node) to DOWN when the availability is indicated to be 'drain' on the indicated NODE ID.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1374/lesson/3/module/150

## Storage

1) When using the --mount option, which of the following parameters would you use to indicate that the container should have access to the host filesystem?

Correct

Correct answer
type=bind

Explanation
The 'bind' type will allow the container access to the underlying host operating system from the indicated target directory in the container filesystem.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1379/lesson/3/module/150

2) Which of the following commands would clean up ALL images from a Docker host?

Correct

Correct answer
docker system prune -a

Explanation
The 'prune' command, when paired with the '-a' option, will remove all container and image storage from the host.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1379/lesson/4/module/150

3) Which of the following configuration files would allow you to change the default Docker storage driver on a host?

Correct

Correct answer
/etc/docker/daemon.json

Explanation
The /etc/docker/daemon.json allows you to change the Docker daemon configuration of many items, including the storage driver.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1379/lesson/1/module/150


## Security

1) MTLS stands for what in the Docker security space?
Correct

Correct answer
Mutual Transport Layer Security

Explanation
Mutual Transport Layer Security, or MTLS, is used to secure communications between the manager and nodes in a Docker Swarm cluster.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1378/lesson/8/module/150

2) Which Docker variable determines whether a host will ONLY download Docker trusted images?
Correct

Correct answer
DOCKER_CONTENT_TRUST=1

Explanation
The variable DOCKER_CONTENT_TRUST set to '1' will inform the Docker daemon to only pull trusted content within the shell it is set in.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1378/lesson/1/module/150

3) A UCP Client Bundle provides which of the following items to a client that intends to use or manage the cluster? (Choose all that apply)
Correct

Correct answer
account security key, UCP certificate files to trust., Environment variables to set the connection destination.

Explanation
The bundle provides the keys, certificates, and environment variables for a client to use when interacting with UCP and Docker from a client system.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1378/lesson/5/module/150

Retake Quiz

## Final Quiz

Review mount type vs volumes.


docker node
Usage:	docker node COMMAND
Manage Swarm nodes
Commands:
  demote      Demote one or more nodes from manager in the swarm
  inspect     Display detailed information on one or more nodes
  ls          List nodes in the swarm
  promote     Promote one or more nodes to manager in the swarm
  ps          List tasks running on one or more nodes, defaults to current node
  rm          Remove one or more nodes from the swarm
  update      Update a node


1) Which of the following commands will provide a list of all Docker networks and their drivers currently configured on the Docker host?
Correct

Correct answer
docker network ls

Explanation
The 'ls' command for the 'docker network' object will list all networks and drivers installed.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1377/lesson/1/module/150

REVIEW AND TEST THIS
2) You need to launch a detached web container based on the 'httpd' image on your system. That container should bind to a host directory called /my/webfiles to the /usr/local/apache2/htdocs directory on the container, to serve content from. Which of the following container instantiation commands would accomplish that goal?
Correct

Correct answer
docker run -d --mount type=bind,src=/my/webfiles,target=/usr/local/apache2/htdocs httpd

Explanation
Using the type=bind option along with the --mount directive is the proper way to expose the underlying host directory to the container.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1379/lesson/3/module/150

3) Your production cluster has come under heavy load as a result of a recent marketing campaign. Your engineering team has already provisioned additional node capacity and they have already joined them to the cluster. You need to scale your environment to a total of 12 replicas using one of the following commands:
Correct

Correct answer
docker service scale [SERVICE NAME]=12

Explanation
The 'scale' option allows you to indicate the service to scale along with the number of replicas to scale to.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1374/lesson/4/module/150

4) You have to temporarily use a public DNS (8.8.8.8) when launching transient detached containers while your corporate DNS servers are undergoing maintenance. Which docker command would use that public DNS server for name resolution?
Correct

Correct answer
docker container run -d --dns=8.8.8.8 [image]

Explanation
The 'docker run' command uses the --dns option to override the default DNS servers for a container.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1377/lesson/2/module/150

5) You have stopped a container called 'myweb' with the ID of 'i89dk38dk' on your host. You no longer need the container or its underlying storage and want to remove it completely from the host. Which of the following commands would remove that stopped container from the host? (CHOOSE ALL THAT APPLY)
Correct

Correct answer
docker rm myweb, docker rm i89dk38dk

Explanation
The 'rm' option removes containers and it can be used with either the container name or its ID.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1375/lesson/4/module/150

6) The most common public repository for published Docker images is called what?
Correct

Correct answer
docker hub

Explanation
The Docker Hub is the standard public repository for published Docker images.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1375/lesson/1/module/150

7) Given a running container called 'myweb', you need to connect directly to it so that after you exit your connection, the container remains running. Which command will allow you to accomplish this?
Correct

Correct answer
docker exec -it myweb /bin/bash

Explanation
The 'exec' option will execute that command and leave the container running when the command is exited (bash in this case). The 'attach' command will attach to the running container process, and exiting that will exit the container entirely.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1375/lesson/10/module/150

8) You have received a 'docker inspect' report that appears to be formatted as one long line. What option can you instruct your staff to use next time in order to clean up the format into something more readable?
Incorrect

Correct answer
--format="{{.Structure.To.Review}}" [objectid/name]

Explanation
The output will be formatted as to be more easily readable on standard output.

9) Which cloud providers allow you to install the Docker Engine on instances directly? (Choose all that apply)
Correct

Correct answer
AWS, Azure, Google

Explanation
The three major cloud providers support local image Docker installs as well as container services.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1373/lesson/4/module/150

10) If you want to review an image's storage layers, which command might you execute?
Correct

Correct answer
docker history [image id]

Explanation
The 'history' option will display the image layers, the number of them, and how they were built on the image.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1375/lesson/10/module/150

11) When working with Docker container clusters, which cluster management and deployment system might you use?
Correct

Correct answer
docker swarm

Explanation
Docker swarm allows you to deploy clusters of Docker containers across multiple nodes and manage their behavior.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1373/lesson/4/module/150

12) When querying the configuration of a running container called 'myweb', which command would display the container's IP Address?
Correct

Correct answer
docker inspect myweb | grep IPAddress

Explanation
There are multiple references to the key search term IP, but only one specifically called 'IPAddress' when running the 'inspect' command on any container.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1374/lesson/9/module/150

13) Which command will display a list of container's that are NOT currently running but still exist on the system?
Correct

Correct answer
docker ps -a

Explanation
Much like its Linux counterpart, the 'ps -a' option for Docker will provide a list of containers that are on the system but not running.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1375/lesson/6/module/150

14) In order to provide redundancy as you prepare your cluster for release to production, you need to join a second node to the cluster as a manager. One of the following commands will display both the command and the associated token that will allow a new node to join the cluster as a manager, which one is it?
Correct

Correct answer
docker swarm join-token manager

Explanation
Docker will display the necessary information for a manager or node to join a cluster during initialization. This command will allow you to retrieve that information for subsequent joins.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1376/lesson/5/module/150

15) You have a node in your cluster that has already been marked as down related to maintenance that needs to be performed. You want to now remove that node from the cluster completely using the appropriate command from the choices below.
Correct

Correct answer
docker node rm [NODE ID]

Explanation
Docker tries to use typical/recognizable actions following the object that they are intended to operate on, in this case, 'rm' being a well-known command for removing something.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1376/lesson/6/module/150

16) Which utility can be used to define and deploy multiple containers (non-cluster) within one configuration file?
Correct

Correct answer
docker-compose

Explanation
Docker-compose allows you to define one or more containers in a single configuration file that can then be deployed all at once.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1374/lesson/6/module/150

17) Which Docker command is used to remove a base image, even if that image has containers that are based on it?
Correct

Correct answer
docker rmi [image name] --force

Explanation
The 'rmi' option for 'remove image' must be forced if you want to remove an image with containers based on it as they will otherwise be left orphaned.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1375/lesson/4/module/150

18) Which of the following 'namespaces' does Docker use to maintain its isolation and security model? (Choose all that apply)
Correct

Correct answer
PID, Network

Explanation
The PID and Network namespaces mean that each container is isolated in terms of them, which maintains the isolation and separation of the container processes from underlying host services.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1376/lesson/12/module/150

19) Your recently created a service, called 'my_api', has been having reported communication issues that, when they occur, should be logged. Which command would you use to display that information?
Correct

Correct answer
docker service logs my_api

Explanation
Displays the logs for the indicated service running on an existing cluster.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1377/lesson/6/module/150

20) When performing a 'docker inspect [container name]', what format does the output display in by default?
Correct

Correct answer
JSON

Explanation
JSON is the default output from an inspect command.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1374/lesson/9/module/150

21) When building a base image in a Dockerfile, which directive will cause any container instantiated from it to run the indicated command (unless overridden)?
Correct

Correct answer
ENTRYPOINT

Explanation
The 'ENTRYPOINT' directive in a Dockerfile will be the command that any container instantiated on the image will execute on startup by default, unless overridden when the container is started.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1375/lesson/9/module/150

22) Which of the following operating systems is Docker available on? (Choose all that apply)
Correct

Correct answer
Microsoft Windows, Apple OSX/sierraOS, Linux (all flavors)

Explanation
All major x86 based operating systems, and even some 'arm', support Docker.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1373/lesson/4/module/150

23) You need a container running Apache to be launched from an image called 'http:latest'. This container should be named 'myweb' and mount the underlying hosts's '/var/www/html' directory in the container's '/usr/local/apache2/htdocs' directory. Which command will accomplish this?
Correct

Correct answer
docker run -d --name myweb -v /var/www/html:/usr/local/apache2/htdocs httpd:latest

Explanation
The '-v [path on host]:[path in container]' format is used to mount a host's path and contents, making it available inside the indicated path in the container.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1377/lesson/3/module/150

24) Which of the following does a virtual machine directly rely on that a container does not?
Correct

Correct answer
hypervisor

Explanation
A virtual machine relies on some type of 'hypervisor' that is responsible for translating calls from applications to the underlying hardware: storage, CPU, and memory requests.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1373/lesson/4/module/150

25) Which of the following commands will recreate the Dockerfile from an existing image?
Correct

Correct answer
None of the above.

Explanation
There is no way to rebuilt a Dockerfile from an existing image, although the 'history' option can be used to help see the commands that were run in building it.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1375/lesson/10/module/150

26) The file that can be used to assemble a base image locally from commands, applications, and other key items to be built, is called what?
Correct

Correct answer
Dockerfile

Explanation
The 'Dockerfile' is used to assemble a base image using a variety of directives to indicate files, packages, and other configuration specifics for doing a 'docker build'.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1375/lesson/7/module/150

27) The ability for any node in a cluster to answer for an exposed service port even if there is no replica for that service running on it, is handled by what?
Correct

Correct answer
The 'routing mesh'

Explanation
The 'routing mesh' allows all nodes that participate in a Swarm for a given service to be aware of and capable of responding to any published service port request even if a node does not have a replica for said service running on it.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1377/lesson/7/module/150

28) Which of the following Docker client commands will display all of the base images available for local containers to be instantiated from?
Correct

Correct answer
docker images

Explanation
The 'docker images' command will list the locally installed images that can be used to instantiate containers from.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1375/lesson/1/module/150

29) By default, a Docker container will use which HOST network interface for communication and to determine the range of IPs assigned to it?
Correct

Correct answer
docker0

Explanation
The 'docker0' adapter is installed by default during Docker setup and will be assigned an address range that will determine the local host IPs available to the containers running on it.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1376/lesson/1/module/150

30) You need to add a new node to your cluster, but the token that is needed was not noted by your staff during the initial creation. Which of the following commands will allow you to retrieve the token and associated command needed to join the existing cluster?
Correct

Correct answer
docker swarm join-token worker

Explanation
Docker provides the necessary command for any node to join upon creation, the indicated command will allow you to redisplay that information for additional nodes to use.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1376/lesson/6/module/150

31) When changes are made to a Docker image and are ready to be made available for containers to be instantiated on, which of the following commands would make that new image available, called 'httpd:v2'?
Incorrect

Correct answer
docker commit -m "Notes made here" myweb httpd:v2

Explanation
The 'docker commit' command is used to take a container's build and commit it to the indicated image name.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1375/lesson/6/module/150

32) You need to instantiate a container called 'myweb' running an Apache application from the image 'httpd:latest' on your system, and map the container port 80 to a port on the host in a specified range (based on availability). Which command would accomplish this task?
Incorrect

Correct answer
docker run -d --name myweb -p 80-85:80 httpd:latest

Explanation
The '-p 80-85:80' option will allow the container port 80 to be redirected to the underlying host's port somewhere in the range of 80-85, based on port availability.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1377/lesson/3/module/150

33) Which of the following resource limitation options, when added to a container instantiation, is representative of a 'Control Group (cgroup)?(Choose all that apply)
Correct

Correct answer
--cpus=[value], --memory=[amount b/k/m/g]

Explanation
Whereas 'namespaces' provide security and isolation, control groups provide resource management and reporting. The two options above allow CPU and Memory limit setting in container.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1376/lesson/12/module/150

34) The development team has asked that a new overlay network is added to the cluster with a particular network range and gateway. This network will be named 'dev_overlay'. Which of the following commands would meet those requirements?
Correct

Correct answer
docker network create --driver=overlay --subnet=192.168.1.0/24 --gateway 192.168.1.250 dev_overlay

Explanation
The 'docker network create' command can take a network, subnet and gateway as arguments for either bridge or overlay drivers.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1377/lesson/4/module/150

35) Which of the following options on the 'docker container inspect' command will show JUST the IP address of a running container called 'testweb'?
Correct

Correct answer
--format="{{.NetworkSettings.Networks.bridge.IPAddress}" testweb

Explanation
The --format option with the provided template will pull the indicated value from the JSON structured output of the 'docker inspect' command.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1375/lesson/5/module/150

36) Within a Dockerfile, which of the following directives will create a new image layer when executed? (Choose all that apply)
Correct

Correct answer
FROM, LABEL, RUN

Explanation
EVERY directive in a Dockerfile, when executed, will create a new image layer when building an image.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1375/lesson/8/module/150

37) When instantiating a container from the base image called 'myimage', if you intend to connect to that container upon instantiation on your local terminal, which launch command would you use?
Correct

Correct answer
docker run -it myimage /bin/bash

Explanation
The 'docker -it' option tells docker that the container should be launched in 'interactive' mode in the current 'terminal'.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1375/lesson/6/module/150

38) If you want an instantiated container named 'myweb' to have a path inside of it called '/my/data/volume', which command would accomplish this?
Correct

Correct answer
None of the above.

Explanation
None of the indicated options are appropriate for adding a volume to an instantiated container

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1379/lesson/3/module/150

39) You are creating a new service call 'my_api' in an existing cluster that contains three replicas based on a service image called MYAPI. Which of the following commands would you use?
Correct

Correct answer
docker service create --name my_api --replicas 3 MYAPI

Explanation
The 'service' object allows you to create a service with the specified number of replicas from the indicated service image.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1374/lesson/4/module/150

40) In Docker UCP Security, the term 'RBAC' stands for what?
Correct

Correct answer
Role Based Access Control

Explanation
RBAC is an acronym that determines what a user, team, or organization has access to on the cluster based on the role granted to them.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1378/lesson/4/module/150

41) Which option, when provided to a container at startup, will allow it to perform operations that a container may otherwise be restricted from performing?
Incorrect

Correct answer
--privileged

Explanation
The '--privileged' option will allow Docker to perform actions normally restricted, like binding a device path to an internal container path.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1375/lesson/10/module/150

42) Recent problems with the service called 'my_api' in your cluster has caused your development team to request its removal from the cluster while they address the problems. Which command will you need to execute to remove it?
Correct

Correct answer
docker service rm my_api

Explanation
Docker will allow you to remove the named service using the traditional 'rm' command.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1374/lesson/3/module/150

43) One of the nodes in your existing cluster is logging errors related to the storage subsystem it exists on in your infrastructure and needs to be taken offline. Which command will allow you to gracefully remove the swarm it is a member of when executed ON the node itself?
Correct

Correct answer
docker swarm leave

Explanation
When executed from the node you are removing, you can gracefully leave the cluster without having to use the NODE ID.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1376/lesson/6/module/150

44) When instantiating a docker container called 'myweb' that is running an Apache web server on port 80 by default within it, you can allow direct access to the container service via the host's IP by redirecting the container port 80 to the host port 80. Which command will accomplish this?
Correct

Correct answer
docker run -d --name myweb -p 80:80 httpd:latest

Explanation
Redirecting ports is through the '-p [host port]:[container port]' syntax.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1374/lesson/3/module/150

Retake Quiz

INCORRECT ONES

8) You have received a 'docker inspect' report that appears to be formatted as one long line. What option can you instruct your staff to use next time in order to clean up the format into something more readable?
Incorrect

Correct answer
--format="{{.Structure.To.Review}}" [objectid/name]

Explanation
The output will be formatted as to be more easily readable on standard output.



31) When changes are made to a Docker image and are ready to be made available for containers to be instantiated on, which of the following commands would make that new image available, called 'httpd:v2'?
Incorrect

Correct answer
docker commit -m "Notes made here" myweb httpd:v2

Explanation
The 'docker commit' command is used to take a container's build and commit it to the indicated image name.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1375/lesson/6/module/150

32) You need to instantiate a container called 'myweb' running an Apache application from the image 'httpd:latest' on your system, and map the container port 80 to a port on the host in a specified range (based on availability). Which command would accomplish this task?
Incorrect

Correct answer
docker run -d --name myweb -p 80-85:80 httpd:latest

Explanation
The '-p 80-85:80' option will allow the container port 80 to be redirected to the underlying host's port somewhere in the range of 80-85, based on port availability.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1377/lesson/3/module/150

41) Which option, when provided to a container at startup, will allow it to perform operations that a container may otherwise be restricted from performing?
Incorrect

Correct answer
--privileged

Explanation
The '--privileged' option will allow Docker to perform actions normally restricted, like binding a device path to an internal container path.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1375/lesson/10/module/150



-----

MOUNTS
https://docs.docker.com/storage/#choose-the-right-type-of-mount

We basically have 3 types of volumes or mounts for persistent data:

Bind mounts
Named volumes
Volumes in dockerfiles

Volumes are stored in a part of the host filesystem which is managed by Docker (/var/lib/docker/volumes/ on Linux). Non-Docker processes should not modify this part of the filesystem. Volumes are the best way to persist data in Docker.

Bind mounts may be stored anywhere on the host system. They may even be important system files or directories. Non-Docker processes on the Docker host or a Docker container can modify them at any time.

tmpfs mounts are stored in the host system’s memory only, and are never written to the host system’s filesystem.



● Demonstrate​ ​steps​ ​to​ ​lock​ ​a​ ​swarm​ ​cluster
https://docs.docker.com/engine/swarm/swarm_manager_locking/#initialize-a-swarm-with-autolocking-enabled


Convert​ ​an​ ​application​ ​deployment​ ​into​ ​a​ ​stack​ ​file​ ​using​ ​a​ ​YAML​ ​compose​ ​file​ ​with "docker​ ​stack​ ​deploy"

Illustrate​ ​running​ ​a​ ​replicated​ ​vs​ ​global​ ​service

● Apply​ ​node​ ​labels​ ​to​ ​demonstrate​ ​placement​ ​of​ ​tasks

● Demonstrate​ ​the​ ​usage​ ​of​ ​templates​ ​with​ ​"docker​ ​service​ ​create"

Tagging and image
docker tag 0e5574283393 fedora/httpd:version1.0

● Modify​ ​an​ ​image​ ​to​ ​a​ ​single​ ​layer

● Sign​ ​an​ ​image​ ​in​ ​a​ ​registry

● Describe​ ​how​ ​image​ ​deletion​ ​works

● Demonstrate​ ​the​ ​ability​ ​to​ ​upgrade​ ​the​ ​Docker​ ​engine

Troubleshoot​ ​container​ ​and​ ​engine​ ​logs​ ​to​ ​understand​ ​a​ ​connectivity​ ​issue​ ​between
containers

● Configure​ ​Docker​ ​to​ ​use​ ​external​ ​DNS

Use​ ​Docker​ ​to​ ​load​ ​balance​ ​HTTP/HTTPs​ ​traffic​ ​to​ ​an​ ​application​ ​(Configure​ ​L7​ ​load
balancing​ ​with​ ​Docker​ ​EE)

● Describe​ ​the​ ​difference​ ​between​ ​"host"​ ​and​ ​"ingress"​ ​port​ ​publishing​ ​mode

 Describe​ ​default​ ​engine​ ​security
● Describe​ ​swarm​ ​default​ ​security
● Describe​ ​MTLS

● State​ ​which​ ​graph​ ​driver​ ​should​ ​be​ ​used​ ​on​ ​which​ ​OS
https://docs.docker.com/storage/storagedriver/select-storage-driver/#suitability-for-your-workload

Compare​ ​object​ ​storage​ ​to​ ​block​ ​storage,​ ​and​ ​explain​ ​which​ ​one​ ​is​ ​preferable​ ​when
available

Block-level storage drivers such as devicemapper, btrfs, and zfs perform better for write-heavy workloads (though not as well as Docker volumes).

 Describe​ ​how​ ​volumes​ ​are​ ​used​ ​with​ ​Docker​ ​for​ ​persistent​ ​storage
● Identify​ ​the​ ​steps​ ​you​ ​would​ ​take​ ​to​ ​clean​ ​up​ ​unused​ ​images​ ​on​ ​a​ ​filesystem,​ ​also​ ​on
DTR
● Demonstrate​ ​how​ ​storage​ ​can​ ​be​ ​used​ ​across​ ​cluster​ ​nodes