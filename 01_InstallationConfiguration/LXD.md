# Install LXC/LXD Ubuntu

Install and configure LXD on a Linux Server.

```bash
sudo apt install lxd lxd-client
# follow the menus's accept all the defaults
# the one default to skip is this one... no need for NAT with http6
 sudo lxd init
 Name of the storage backend to use (dir or zfs) [default=dir]: dir
 Would you like LXD to be available over the network (yes/no) [default=no]? yes
 Address to bind LXD to (not including port) [default=all]: all
 Port to bind LXD to [default=8443]: 8443
 Trust password for new clients: {secret}
 Again: {secret}
 Do you want to configure the LXD bridge (yes/no) [default=yes]? yes
 Warning: Stopping lxd.service, but it can still be activated by:
 lxd.socket
 LXD has been successfully configured.
 ```

Download and launch v3.5 of the Alpine Linux image.  Name this container, "test".

 ```bash
 sudo  lxc launch images:alpine/3.5 test

# List the available images.
sudo lxc image list

#  List the running containers.
sudo lxc list

 ```

 Launch a shell in the test container and issue a few simple commands to verify functionality, such as ls or df.

sudo lxc exec test -- ash
df -h
ls -la

Stop and delete the test container

lxc list
lxc stop test
lxc list
lxc delete test
lxc list

Solution 2: Delete a running container

lxc delete --force test
lxc list


## Exercise: Launching Your First Container

1. Launch a container named 'web' based on the Alpine v3.5 image.

lxc image copy images:alpine/3.5 local: --alias my-alpine
lxc launch my-alpine web
lxc list

1. Install and configure nginx in your new container without logging in to the container's console.

lxc exec web -- apk update
lxc exec web -- apk add nginx
lxc file edit web/etc/nginx/conf.d/default.conf

```bash
server {
        listen 80 default_server;
        listen [::]:80 default_server;

        # Everything is a 404
        root /var/www/;
}
```

1. Create a test page called "index.html" and place it in the web root with the following content:  "Web page served out of an LXC container!"

nano index.html
Web page served out of an LXC container!
lxc file push index.html web/var/www/index.html

1. Log into the container's console and set nginx to automatically start when the container starts (The command is rc-update add nginx default.)

lxc exec web -- ash
rc-update add nginx default
* service nginx added to runlevel default

1. Start nginx in your container.

lxc exec web -- ash

1. Exit your container and verify that everything is functioning as expected using the curl command with your container's IP address. Note that this is a private IP address and will only be accessible from the console of the LXD host.

exit
lxc list

curl 10.179.69.6
Web page served out of an LXC container!

1. Create a snapshot of your container called 1.0.

lxc snapshot web 1.0
lxc info web

1. Change the contents of the index.html in the web root to read, "Typos are horrible!" and verify the changes took place with curl.

lxc file edit web/var/www/index.html
Typos are horrible!
curl 10.179.69.6

1. Create a snapshot of your container called 1.1.

lxc snapshot web 1.1
lxc list

1. Restore your container to the 1.0 state and verify that the changes took place.

lxc restore web 1.0
curl 10.179.69.6

1. Delete the 1.1 snapshot.

 lxc delete web/1.1
 lxc list
 