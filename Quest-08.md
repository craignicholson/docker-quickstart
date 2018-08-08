# Container Networking with Links

Create a network link between the two Docker containers, spacebones:thewebsite & treatlist using legacy Docker links. Use the image found at spacebones/postgres to create the database.

What does this event accomplish????

docker ps

-- this was already running
docker run -d -p 80:80 --name spacebones spacebones/spacebones:thewebsite

docker ps

Create the line

docker run -d -P --name treatlist --link spacebones spacebones/postgres

docker ps

docker inspect -f "{{.HostConfig.Links }}" treatlist

cloud_user@ip-10-0-1-165 ~]$ docker run -d -p 80:80 --name spacebones spacebones/spacebones:thewebsite
90d3255feec8710318eb91c511b78a67ceb4e026ab35561d3ef37a5f4b3c535b
[cloud_user@ip-10-0-1-165 ~]$ docker run -d -P --name treatlist --link spacebones spacebones/postgres
6b2b41e2c7c74873a20bd7500311f94097162140acf31d6c3698b5da4488793f
[cloud_user@ip-10-0-1-165 ~]$ 
[cloud_user@ip-10-0-1-165 ~]$ docker inspect -f "{{.HostConfig.Links }}" treatlist
[/spacebones:/treatlist/spacebones]
[cloud_user@ip-10-0-1-165 ~]$ ^C
[cloud_user@ip-10-0-1-165 ~]$ 
