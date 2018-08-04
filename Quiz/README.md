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


