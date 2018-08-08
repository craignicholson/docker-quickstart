# Persitant Data Volumes

Mission Accomplished!

Thanks to Droolidian graciousness & generosity, treats for the hungry SpaceBonians have been obtained - there's almost too much to handle! Greatful (& full, in general) SpaceBonians have once again raised their voices that President Squawk deliver a very special message to the wonderful person who lent a helping hand to reward deserving Good Boys & Girls. As a result, we have one more request of you, our star Docker expert.

Great job, cadet! SpaceBonians have created a special message for you! To view it, create a Docker volume containing the contents of /content-dockerquest-spacebones/volumes/ named missionstatus, then mount the volume on a new httpd container named fishin-mission running on port :80 to view it!

docker ps
Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?

> sudo usermod -aG docker $USER

if not already present, clone the content-dockerquest-spacebones repo on your machine

> git clone https://github.com/linuxacademy/content-dockerquest-spacebones.git

Create a new volume named missionstatus

> docker volume create missionstatus

> docker volume ls
```bash
DRIVER              VOLUME NAME
local               missionstatus
```

Use Docker commandline to print all information on the missionstatus volume. 

> docker volume inspect missionstatus

```json
[
    {
        "CreatedAt": "2018-08-08T09:10:27-04:00",
        "Driver": "local",
        "Labels": {},
        "Mountpoint": "/var/lib/docker/volumes/missionstatus/_data",
        "Name": "missionstatus",
        "Options": {},
        "Scope": "local"
    }
]
```

Drop to root, then copy the contents of content-dockerquest-spacebones/volumes/ to missionstatus data directory

> sudo -i
> cp -r /home/cloud_user/content-dockerquest-spacebones/volumes/ /var/lib/docker/volumes/missionstatus/_data

Hmm we some how created a volumes directory under the _data directory.  Must have been the -r.  Investigate.

> sudo ls /var/lib/docker/volumes/missionstatus/_data/volumes

```bash
images index.html  sitecode.md
```

Exit root, then start a new container named fishin-mission using the httpd base image available on DockerHub, running on port 80.

> docker run -d -p 80:80 --name fishin-mission --mount source=missionstatus,target=/usr/local/apache2/htdocs httpd

Note the web page was rooted at volumes in the