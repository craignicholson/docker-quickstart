# Adding External Content to Containers

Works best on unix.  Mac will complain about:

docker: Error response from daemon: Mounts denied: 
The path /home/user/docker/mydata
is not shared from OS X and is not known to Docker.
You can configure shared paths from Docker -> Preferences... -> File Sharing.
See https://docs.docker.com/docker-for-mac/osxfs/#namespaces for more info.
.
ERRO[0000] error waiting for container: context canceled 


1. Create a directory in your 'user' home directory called 'docker'. Within that directory, create another directory called 'mydata'. Within that directory, create a file called 'mydata.txt' containing any text message you want.

mkdir docker
cd docker
mkdir mydata
echo "Never gonna give you up\!" >> mydata/mydata.txt
ls mydata/

1. Create a docker container name 'local_vol' from the 'centos:6' image. The container should be created in interactive mode, attached to the current terminal and running the bash shell. Finally create the container with a volume (or directory) called 'containerdata' so that the system will automatically create the directory/mount when the container starts.

docker create --it --name local_vol -v /containerdata centos:6 /bin/bash
OR

docker run -it --name local_vol -v /containerdata centos:6 /bin/bash

OR

docker run -it --name local_vol --rm  -v /containerdata centos:6 /bin/bash

1. List the filesystems within the container, specifically looking for the volume/directory that was added to the container during creation.

ls -al

1. Exit the container. This time, create another container called 'remote_vol' with the same container configuration except when creating the volume in the container, link the volume name 'mydata' to the underlying host directory structure created in Step #1.

docker run -it --name remote_vol --rm  -v /home/user/docker/mydata:/mydata centos:6 /bin/bash

docker run -it --name="remote_vol" -v /home/user/docker/mydata:/mydata centos:6 /bin/bash

1. Once the container is started, list the disk mounts and verify the remote (host) volume is mounted. Change to that directory and verify that the text file created in Step #1 appears with the content created.

df -h

cat /mydata/mydata.txt 