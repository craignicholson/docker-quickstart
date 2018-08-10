# Container Run Examples

1. Using the Docker base image for Ubuntu, create a container with the following characteristics:

- Interactive
- Attached to Terminal
- Using Google Public DNS
- Named 'mycontainer1'

> docker run --it --name mycontainer1 --dns=["8.8.8.8", "8.8.4.4"] ubuntu:latest /bin/bash

1. Exit the container from Step #1. Using the Docker base image for Ubuntu, create a container with the following characteristics:

- Interactive
- Attached to Terminal 
- Using Google Public DNS
- Using Domain Search "mydomain.local"
- Named 'mycontainer2'

> docker run -it -name mycontainer2 --dns=8.8.8.8 --dns-search="mydomain.local" ubuntu:latest /bin/bash

1. Exit the container from Step #2. Using the Docker base image for Ubuntu, create a container with the following characteristics:

- Interactive
- Attached to Terminal 
- Using Google Public DNS
- Using Domain Search "mydomain.local"
- Create a mount called '/local_vol'
- Create a mount called '/remote_vol' that mounts the file system in /home/user
- Named 'mycontainer3'

> docker run --it --dns=8.8.8.8 --dns-search="mydomain.local" -v /local_vol -v /home/user:/remote_vol --name mycontainer3 ubuntu:lastest /bin/bash

docker run -it --dns=8.8.8.8 --dns-search="mydomain.local" --name="mycontainer3" -v /local_vol -v /home/tcox:/remote_vol ubuntu:latest /bin/bash

> df -h

1. Exit the container from Step #3. List all the containers. List all characteristics inspected from 'mycontainer2' and then remove and verify removal of all containers.

> docker inspect mycontainer2

> docker rm mycontainer1
> docker rm mycontainer2
> docker rm mycontainer3

OR

> docker rm `docker ps -a -q`