# Managing Containers

1. Create a container from the base image for the latest version of Ubuntu available (if you do not have an Ubuntu base image installed locally, pull the latest one down for your local repository). The container should be started in interactive mode attached to the current terminal and running the bash shell. Once running, shut the container down by exiting.

```bash
docker pull ubuntu:latest
docker run -it --name myCon  ubuntu:latest /bin/bash
docker run -it ubuntu:latest /bin/bash
# exit
```


1. Run the appropriate Docker command to get the name of the previously run container. Issue the appropriate command to restart the container that you obtained the name of. Do NOT create a new container, restart the one we just used.

```bash
docker ps -a
docker restart myCon

```

1. Stop the container. Remove that container from the system completely using the appropriate command.

docker stop myCon

1. Create (not run) a container called "my_container", create it with parameters that will allow it to run interactively and attached to the local console running the bash shell. Verify that the container is not running.

docker create -it --name=my_container ubuntu:latest /bin/bash

1. Start the container and again, verify the container is running. Run the appropriate command to attach your session to the running container so you are logged into the shell.

docker start my_continer
docker restart my_container

docker exec -it my_container /bin/bash

docker attach my_container