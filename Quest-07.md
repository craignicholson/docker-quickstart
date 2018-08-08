# Creating Data Containers

After consulting with the Radar Board (The official SpaceBones technology team), we have decided the best option for sharing data between several containers will be Docker data containers. As our resident Docker expert, we are counting on you to create a data container running the training/postgres image (for our purposes, name that data container 'boneyard'), then mount the data container on three app containers (also running training/postgres) with the following names:

- cheese
- tuna
- bacon

Good luck, brave one! We are rooting for you!

Check if docker is running.

> docker ps

Pull the postgres image.

> docker pull training/postgres

See what images we have on the server.

> docker images

```bash
REPOSITORY                         TAG                 IMAGE ID            CREATED             SIZE
docker.io/centos                   6                   b5e5ffb5cdea        40 hours ago        194 MB
docker.io/06kellyjac/nyancat       latest              329bb91b174b        2 weeks ago         782 kB
docker.io/hello-world              latest              2cb0d9787c4d        4 weeks ago         1.85 kB
docker.io/ogtrilliams/spacebones   thewebsite          5f9cfb85ce71        3 months ago        367 MB
docker.io/spacebones/doge          latest              a01e4e5e728e        3 months ago        111 MB
```

Create the data container.

> docker create -v /data --name boneyard training/postgres /bin/true

Review the data container we created... and how is this different than docker volume create???

> docker volume ls

```bash
DRIVER              VOLUME NAME
local               ec05527eee33cc2a36f2108a9b9b0f6f19908a972e35275ac351808d879fab4d
```

> docker volume inspect

```json
ec05527eee33cc2a36f2108a9b9b0f6f19908a972e35275ac351808d879fab4d
[
    {
        "Driver": "local",
        "Labels": null,
        "Mountpoint": "/var/lib/docker/volumes/ec05527eee33cc2a36f2108a9b9b0f6f19908a972e35275ac351808d879fab4d/_data",
        "Name": "ec05527eee33cc2a36f2108a9b9b0f6f19908a972e35275ac351808d879fab4d",
        "Options": {},
        "Scope": "local"
    }
]
```

Create our containers running attached to the volume.

```bash

docker run -d --volumes-from boneyard --name cheese training/postgres
docker run -d --volumes-from boneyard --name tuna training/postgres
docker run -d --volumes-from boneyard --name bacon training/postgres

docker ps

CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
70f48b709714        training/postgres   "su postgres -c '/..."   3 seconds ago       Up 3 seconds        5432/tcp            tuna
ed995849df49        training/postgres   "su postgres -c '/..."   13 seconds ago      Up 12 seconds       5432/tcp            bacon
dc6489f4808e        training/postgres   "su postgres -c '/..."   24 seconds ago      Up 23 seconds       5432/tcp            cheese
```

Review what we created

> docker ps -a

```bash
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
70f48b709714        training/postgres   "su postgres -c '/..."   31 seconds ago      Up 30 seconds       5432/tcp            tuna
ed995849df49        training/postgres   "su postgres -c '/..."   41 seconds ago      Up 40 seconds       5432/tcp            bacon
dc6489f4808e        training/postgres   "su postgres -c '/..."   52 seconds ago      Up 50 seconds       5432/tcp            cheese
75721ce4e82d        training/postgres   "/bin/true"              2 minutes ago       Created                                 boneyard
```