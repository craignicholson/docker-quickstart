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

2) Which of the following configuration files can be used to override the default Docker logging driver?

Correct

Correct answer
/etc/docker/daemon.json

Explanation
The /etc/docker/daemon.json file is used to override various Docker defaults, including the logging driver.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1376/lesson/4/module/150

3) When Docker is first installed, what is the name of the default Docker network interface that is created?

Correct

Correct answer
docker0

Explanation
The Docker installation will create a network interface called 'docker0' that will function as both the 'gateway' to the private network on the host, which is used for Docker container communication, as well as defining the network range available for container IP assignments.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1376/lesson/1/module/150

4) Which directory will contain the Docker image storage layers (by default) on a host?

Correct

Correct answer
/var/lib/docker

Explanation
Storage related to Docker image and container layers are stored in /var/lib/docker unless changed in the configuration or daemon at launch time.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1376/lesson/3/module/150

5) Which of the following commands will enable and start the Docker CE service?

Correct

Correct answer
systemctl enable docker && systemctl start docker

Explanation
The Docker CE service can be enabled and started via typical systemd service management methods.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1376/lesson/1/module/150

6) What information is contained in the '/run/docker.pid' file when the Docker service is running?

Correct

Correct answer
The PID (Process ID) of the Docker service.

Explanation
The 'docker.pid' file only contains the number corresponding to the process of the Docker service.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1376/lesson/1/module/150

7) Which file, owned by Docker in the /run directory, determines which accounts can use the service?

Correct

Correct answer
/run/docker.sock

Explanation
The 'docker.sock' command is owned by the 'docker' group. Adding a user to this group will allow them to run Docker commands with unprivileged accounts.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1376/lesson/1/module/150

8) The 'docker' service can be queried for its state (whether it is stopped or running) with which of the following commands?

Correct

Correct answer
systemctl status docker

Explanation
The Docker service can be managed via standard systemd service management utilities.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1376/lesson/1/module/150

9) Which of the following are requirements for Docker to run but are NOT installed as dependencies? (Choose all that apply)

Correct

Correct answer
yum-utils, lvm2, device-mapper-persistent-data

Explanation
The first three are not installed with Docker and exist on most full system installations, but they may need to be added to a server or minimal initial configurations.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1376/lesson/1/module/150

10) Which command will enable the 'user' account to access the Docker application, and the system resources necessary to execute Docker commands, without needing elevated privileges?

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

2) Which of the following configuration files will allow you to change the configured Docker storage driver?

Correct

Correct answer
/etc/docker/daemon.json

Explanation
The /etc/docker/daemon.json file can be used to changed various default Docker configuration items, the storage driver included.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1375/lesson/12/module/150

3) Which of the following commands will list the status of a Docker Swarm cluster when run from the primary manager node?

Correct

Correct answer
docker node ls

Explanation
Docker typically uses the 'docker' command followed by the object that the subsequent action should be performed on.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1376/lesson/6/module/150

4) When creating a Dockerfile intended to be used for local image creation in the current directory, which of the following commands will build the file into an image and create it with the name 'myimage:v1'?

Correct

Correct answer
docker build -t myimage:v1 .

Explanation
When the Dockerfile is in the current context (directory), you build it with an image name and tag with the -t option followed by the image:tag and the directory context of the file, in this case '.'.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1375/lesson/7/module/150

5) From the list below, which option would you add to the 'docker login' command in order to provide the username to the repository in order to log in?

Correct

Correct answer
--username=[USERNAME]

Explanation
The '--username=[USERNAME]' will allow you to specify the intended account to login with at the remote image repository.

Further Reading
https://linuxacademy.com/cp/courses/lesson/course/1375/lesson/14/module/150