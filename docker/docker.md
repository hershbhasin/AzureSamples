

#Notes

# Unix

http://www.westwind.com/reference/os-x/commandline/navigation.html



```bash
root : cd /

home : cd ~

previous: cd -

#to make hersh owner instead of root tof the docker folder
sudo chown -R -v hersh /var/lib/docker

#install nano
apt-get install -y nano

```



# Registries



Registries**

Docker Hub, Quay.io, AWS EC2 Container Registry

Private Registries
Docker Trusted Registry (DTR)

Docker Content Trust  & Yubico hardware crypto solution (turn on)

cloud
Docker Hub (ship)
Tutum (run: deploying & managing apps in cloud)

**On Premise**
DTR
Docker Universal Control Plane

Docker hub: http://hub.docker.com

# Containers

**Kernal namespaces**: partition up system namespaces:  pid (process name space), net namespace, mnt namespace, user namespaces. Containers use this to partition.

**Control groups** (cgroups). Containors map to cgroups (one to one) and limits to system resources can be applied.

Capabilities: fine grained control on what privileges or process gets

# Installing Ubuntu

Remember if using Oracle Virtual Box, disable Hyper V else you don't see 64 bit images

1. Download Ubuntu iso from Ubuntu we site
2. Install Oracle Virtual Box
3. Add New Virtual Machine and accept defaults
4. Network: Highlight new vm & click on settings on toolbar & select Network. 
   * Click on tab Adapter 2
   * Check Enable Network Adaptor & in Attached To droplist, select  "Host-only adapter"
5. Go to Storage tab in settings:
   * Select the disk icon labelled "Empty" (Under Controller: IDE). Then navigate to the Ubuntu iso sudyou downloaded  
6. Click Start on Toolbar
7. Select options to install: OpenSSH Server and Ubuntu Gnome Desktop


### To set up GUI

```bash
#Select Ubuntu GNOME desktop (space to select)
sudo tasksel

```

Set up Guest Additions

From Devices/ Insert Guest Additions  CD Image. If this does not work, then

Devices/Optical Images/Choose Desk Image/Browse to Program Files/Oracle/VirtualBox/select VBoxGuestAdditions.iso

```bash

#for shared folders, give rights to user
sudo adduser <yourUsername> vboxsf
```



### Set up other software

```bash
#w3m : for browing from terminal
 sudo apt-get install w3m w3m-img
 
#dot net core:https://docs.microsoft.com/en-us/dotnet/core/linux-prerequisites?tabs=netcore2x

#set trusted
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg

#for Ubuntu 16.04

sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-xenial-prod xenial main" > /etc/apt/sources.list.d/dotnetdev.list'

sudo apt-get update

#install core
sudo apt-get install dotnet-sdk-2.0.0
```

### Turn off screen lock

```bash
gsettings set org.gnome.desktop.session idle-delay 0 (0 to disable)

To disable the screen lock:

gsettings set org.gnome.desktop.screensaver lock-enabled false
```



# #Set up ssh into Ubuntu

Virtual Box terminal is lame. You might want to use putty. To enable port forwarding to the vm, follow this link

 http://blog.johannesmp.com/2017/01/25/port-forwarding-ssh-from-virtualbox/

1. Select Settings/ Network/Adapter1

2. Port Forwarding

3.  Set Name, Protocol Host IP, Host Port, Guest IP, Guest Port to

    ssh,TCP, 127.0.0.1, 2222, 10.0.2.15, 22

**Putty & WinSCP**

IP Address: 127.0.0.1

Port 2222



# Installing Docker

Follow link:

 https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/#install-docker-ce-1

# Configuring Docker

To run Docker a user needs root access. If you add a user to the Docker Group, you effectively give him root access. So instead of giving root access to users, add them to the docker group. Doing so, we can log in as a normal user and not have to preface all commands with sudo. 



Explanation:

Docker binds to /var/run/docker.sock (link to run). If you run

```bash
 ls -l /run
```

You can  docker.sock listed (pink) . It is owned by root but the group owner is "docker". Since the docker group has full control of local  Unix socket, any members added to this will be given root access.

### To add a user to docker group

```bash
#check if docker group exists
cat /etc/group

#add user Hersh to group docker
sudo gpasswd -a hersh docker

#check if added

```

# Unix Commands

```bash
ping 8.8.8.8

#whats running
ps -elf

cat /etc/hosts

#kernal
uname -a
#centos or Ubantu?
cat /etc/redhat-release

#install vim
yum install -y vim

#create a file
vim /tmp/testfile

#alias
alias dps = "docker ps"

```

# Delete all images & containers

```bash
#delete all containers
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
docker ps -a

#delete all images
docker rmi $(docker images -q) --force
```



# Containers

Call to run kicks off the PID1 process of the container. PID1 manages and takes care of all other processes.  In a Linux machine this is the Init task.  

phusion/baseimage is a full blown Linux system.

If you look at the pids from outside the container, using: *docker top imageid*, you will not see pid 1 but pids with high numbers. However it you see it from inside the container using *ps -ef*, you will see pid1

```bash
#version
Docker Version

#info about images and containers
Docker Info

#ps command: list containers
docker ps -a
docker ps -l #last container to run

#-d: run detached
#-d  =>start container in detached mode (in background)
#-p  =>ports 80:80 => map port 80 of docker host to web server running on 8080 in container

docker run -d --name web -p 80:8080 nigelpoulton/pluralsight-docker-ci
docker run hello-world
#ping google dns 30 times
docker run -d ubuntu /bin/bash -c "ping 8.8.8.8 -c 30" 

#-it: run container in interactive mode
#-it  => i=interactive terminal, t = tty
#This will start a container called temp using ubantu lates image and run bash--  you will be #at root of the machine
#To exit : Ctrl p + Q

docker run -it --name temp ubuntu:latest /bin/bash

#exit container without killing it
ctrl-p-q

#start stop
docker start web
docker stop web

#delete a container
docmer rm id --force

#delete all containers
#q => quiet
#a=> all

docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
docker ps -a

#Connect to an existing container that is stopped
#get the id
docker ps -a
docker start 41ba6ea2f889
docker attach  41ba6ea2f889
docker restart id

#docker top lets us see the top running process in a container
docker top imageid

#docker inspect -- detailed info
docker inspect imageid

#see logs of containor
docker logs imageid #-f to follow, keep streaming

#see pid within the containor
ps -ef




```



## Entering a running container

Option 2, exec is simpler and that is the one that should be used

1. #### nsenter

when you attach bash , you by default attach to pid1. If you want to attach to a specific pid  (where say an application is running) you can use nsenter. nsenter allows us to enter namespaces. We need to get it the containers pid



```bash
#get a lsit of images
docker ps -a

#attach to one
docker start temp
docker attach temp

#get out on container and onto root
ctrl p+q

#get the id of the running container
docker ps -a

#to get containers pid
docker inspect temp |grep Pid

#mount the namespace to it
#-m: mount namespace
#-u: uts namespace
#-n: network namespace
#-p: process namespace
#i : ipc namespace
#if we exit, the pid1 is still running, container is still alive
nsenter -m -u -n -p -i -t 4556 /bin/bash
```

2. Docker exec

   ```bash
   docker exec -it temp /bin/bash

   ```

   ​

# Images

Union Mounts: The ability to mount multiple file systems on top of each other: image layering. They combine all of the layers into a single view, giving  the look and feel of a single everyday file system. All the layers, except the topmost, are read-only.  

The top layer, an additional layer that is added when we launch a container, is the only writable layer. This is where all changes to a container is made: installing/updating  applications, writing new files, config changes ...this is where all the container state is stored.

The bottom most layer image has our rootfs. However there is another layer below that, sometimes: when we start a container, there is actually a small boofs: its very short lived. It disappears after startup.

overlay2is the default union mount implementation used on Ubuntu hosts running Docker.

```bash
#list images
docker images

#remove image
#you have to remove linked containers first
#get ids of containers
docker ps -a
#delete containers
docker rm id --force
#delete image
docker rmi ubuntu:14.04 --force

#pulling images
#images once pulled are stored under /var/lib/docker/overlay2  <storage driver--overlay2 for ubuntu>
# ls -l /var/lib/docker/aufs
docker pull alpine
docker pull ubuntu
docker pull ubuntu:14.04


```

### Copying images

```bash
#create a short lived container that creates a file and exits(non interactive mode)
docker run ubuntu /bin/bash -c "echo 'My cool content' > /tmp/cool-file"

#grab the id of the container just run. In this case it is 61065e43645a
docker ps -a

#docker commit: takes our changes and makes a new image. We will call the image fridge
docker commit 7abef10f2cf0 fridge

#to confirm that our new image "fridge" has been created
docker images

#see history
docker history fridge

#view that fridge image has our new file: run in interactive mode
docker run -it fridge /bin/bash
cat /tmp/cool-file

#Save our fridge image to tar
docker save -o /tmp/fridge.tar fridge

#to see how big our new image is
ls -lh /tmp/fridge.tar

#to view the tar file
tar -tf /tmp/fridge.tar

#Now copy the tar image to your other docker machine and run the following
docker load -i /tmp/fridge.tar
```



# Dockerfile

### intro

Call it Dockerfile (no extension)

FROM instruction has to be the first instruction

RUN commands used to run instructions against our images. Every run instruction creates a layer in our image.

```bash
#save this file as Dockerfile
#Ubuntu based hello World container
FROM ubuntu:15.04
MAINTAINER hersh_b@abc.com
RUN apt-get update
RUN apt-get install -y apache2
RUN apt-get install -y vim
RUN apt-get install -y golang
CMD ["echo", "Hello World"]


```



Build Dockerfile

(period at end implies current folder)

```bash
docker build -t="helloworld:0.1" .

docker info
```

Check

```bash
docker history helloworld:0.1
docker run helloworld:0.1
docker history id
```

# Dockerfile for a webserver

```bash
#simple web service
FROM ubuntu:15.04
MAINTAINER hersh_b@abc.com
RUN apt-get update
RUN apt-get install -y apache2
RUN apt-get install -y apache2-utils
RUN apt-get install -y vim
RUN apt-get clean
EXPOSE 80
CMD ["apache2ctl","-D", "FOREGROUND"]
```

Better version (fewer layers)

```bash
#simple web service
FROM ubuntu:15.04
RUN apt-get update && apt-get install -y \
apache2 \
apache2-utils \
vim \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
EXPOSE 80
CMD ["apache2ctl","-D", "FOREGROUND"]
```



Build

```bash
#build
docker build -t="webserver" .

#check
docker images

#run
docker run -d -p 80:80 webserver

#check if running
docker ps -a
```

###Browser on terminal

Refer: https://askubuntu.com/questions/29540/browsing-the-internet-from-the-command-line

Install w3m

```bash
 sudo apt-get install w3m w3m-img
```

Commands of w3m

```bash
1. to open a webpage simply type in a terminal window: w3m <url_of_the_webpage>
2. to open a new page: type Shift-U
3. to go back one page: Shift-B
open a new tab: Shift-T
4. Quit :q (right click)
```

Check if localhost is working at port 80

```
w3m localhost
```

Stop container and check again

```bash
docker stop id

#will not work
w3m localhost
```

### CMD

only 1 cmd per Dockerfile allowed,  if you bash on run, then that takes precedence over CMD in Dockerfile. CMD can be used as default parameters that can be overridden by run options

​	1. Shell form : Commands gets prepended with "/bin/sh -c"

```bash
CMD echo "hello world"
```

2. Exec Form: json format

   ```bash
   CMD ["echo", "Hello World"]
   ```

### ENTRYPOINT

ENTRYPOINT is Preferred way of specifying the default app to run inside a container (though CMD can also be used). Entrypoint cannot be overridden by specifying commands on the run line (CMD can).

Any command at run time is used as an argument to ENTRYPOINT.

Example:

```bash

FROM ubuntu:15.04
RUN apt-get update && apt-get install -y  iputils-ping
ENTRYPOINT ["echo"]
```

```bash
#build
docker build -t="hw2" .

#run
docker run hw2 hello there 

#output : note command is used as an argument for ENTRYPOINT
# resulting cmd =  sh echo "hello there"
> hello there
```

### Env

Environment Variables: available inside the container as environment variables

```bash
ENV var=value
```

Example

```bash
FROM ubuntu:15.04
RUN apt-get update && apt-get install -y  iputils-ping
ENV var1=Hersh var2=Bhasin

```

```bash
#build
docker build -t="testenv"

#run
docker run -it testenv /bin/bash

#check env: you should see var1 & var2
env


```

# Volumes

You might want to save data of a container on its host volume so that it can be shared. use the -v flag to specify a volume (directory) on host

This stores data in test-vol folder on host

```bash
docker run -it -v /test-vol --name="voltainer" ubuntu:15.04 /bin/bash
```

Run another container that uses the same container

```bash
docker run -it -volumes-from=voltainer --name="voltainer2" ubuntu:15.04 /bin/bash
```

### Host Mount

Mounting a volume from a host to a container. This mounts a host volume called data to a container volume called data. Caution: not scalable as it couples host & container.

```bash
docker run -v /data:/data
```

### Specifying host volume in Dockerfile

this store data in host volume called data

```bash
#simple web service
FROM ubuntu:15.04
VOLUME /data
RUN apt-get update && apt-get install -y \
```





# Pushing to Docker Hub

```bash
#get the image id 
docker images

#tag it 
docker tag ac5021e97eda  hershb/helloworld:1.0

#login
docker login

#push it
docker push hershb/helloworld:1.0
```



# Private Registry

```bash
docker run -d -p 5000:5000 registry
```

# Networking

docker0. When docker host starts, it creates docker0 interface: its actually a bridge or virtual switch created entirely in software inside the linux kernal. By default, each new container gets one interface  automatically attached to the docker0 virtual bridge

```bash
#to look at networking stack on host: note docker0 @ 172.17.0.1/16
ip a
#to see connected devices, install bridge-utils
apt-get install bridge-utils
#then. the interfaces show connectede devices (containers)
brctl show docker0

```

```bash
FROM ubuntu:15.04
RUN apt-get update && apt-get install -y  iputils-ping traceroute
ENTRYPOINT ["/bin/bash"]
```

```bash
#build
docker build -t="net-img" .
#run
docker run -it --name=net1  net-img 

#come out of container
ctrl p+q

#view connected devices: you will see it connected in interfaces. If you run another, you will see two etc.

brctl show docker0

#get into container
docker attach net1

#install iproute2 inside container
apt-get install iproute2

#look at networking stack : note eth0
ip aclear


#gateway : = 172.17.0.1 
traceroute 8.8.8.8
```

### docker pipe

its like a virtual Ethernet cable connecting the docker0/interface with eth0 in container

docker0 --->interface attached---> connected to eth0 in container

### Exposing ports

```bash
#simple web service
FROM ubuntu:15.04
RUN apt-get update && apt-get install -y iputils-ping traceroute apache2
EXPOSE 80

ENTRYPOINT ["apache2ctl"]
CMD ["-D", "FOREGROUND"]
```

```bash
docker build -t="apache-img" .
#run
docker run -d -p 5001:80 --name=web1 apache-img

#to see port
docker port web1
```





# Swarm Mode

Swarm: A collection of docker engines joined into a cluster is a swarm. Contains one or more managed nodes  and one or more worker nodes

Manager Nodes: manage state and tasks; High availability, 3 or 5 recommended, only 1 is leader.

Worker Nodes: execute tasks

Swarm mode: each engine in a swarm run in swarm mode (swarm mode is optional)

Standalone mode: when an engine does not run in swarm mode

Services: only available in swarm mode: Declarative and scalable way of running tasks(containers)


docker service create --name web -fe --replicas 5


Task (container): atomic unit of work assigned to a worker node. Developers tell managers of services. Manager assigns the service out to worker nodes as tasks (containers).

### Run Init on first machine

docker swarm init --advertise-addr 172.31.12.161:2377 --listen-addr 172.31.12.161:2377


**Master:** 

The output of init command will give you a docker swarm join manager command that you need to run on each worker nodes. 

**Worker:**

The output of init command will give you a docker swarm join command that you need to run on each worker nodes.

**To get command to run on other managers or nodes**

docker swarm join-token manager

docker swarm join-token worker

This will give you the actual command that you need to run on other machines 

To confirm:

```bash
 docker info
 docker node ls (can only be run from a manager)
```

**To promote to manager**

```bash
docker node promote [id of worker]
```

# Services

```p
docker service create --name psight1 -p 8080:8080 --replicas 5 nigelpoulton/pluralsight-docker-ci

docker service ps psight1
docker service inspect psight1
docker service ls

Remove:
docker service rm psight1

To get info:
docker node ps ip-172-31-12-162 (enter ip of machine with dashes)
docker node self

Scale:
docker service scale psight1 = 7
or
docker service update --replicas 10 psight1
```

**Routing mesh:** Docker's native container aware load balancer. It can augment existing non-container aware load balancers. When you have a load balancer, the routing mesh resides behind your load balancer, providing second layer of load balancing.

# Rolling Updates

```p
docker network create -d overlay ps-net
docker network ls

docker service create --name psight2 --network ps-net -p 80:80 --replicas 12  nigelpoulton/tu-demo:v1

docker service ls
docker service ps psight2
docker service inspect --pretty psight2

Update to a new version of image (update 2 tasks ata time with a 10s delay):
docker service update --image nigelpoulton/tu-demo:v2 --update-parallelism 2 --update-delay 10s psight2

```



# Stacks and DABs

