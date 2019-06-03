
#####################################################
#Docker Info
#####################################################

#version
Docker Version

#info about images and containers
Docker Info


#####################################################
#Deleting
#####################################################
#delete all containers
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)

docker ps -a

#delete all images
docker rmi $(docker images -q) --force



#####################################################
#Listing
#####################################################

#ps command: list containers
docker ps -a

#last container to run
docker ps -l 

#docker top lets us see the top running process in a container
docker top imageid

#docker inspect -- detailed info
docker inspect imageid

#see logs of containor
docker logs imageid #-f to follow, keep streaming

#see pid within the containor
ps -ef


#####################################################
#Run detached (in background)
#####################################################


#-d: run detached
#-d  =>start container in detached mode (in background)
#-p  =>ports 8081:80 => map port 8081 of docker host to web server running on 80 in container

docker run -d --name web -p 8081:8080 nigelpoulton/pluralsight-docker-ci

docker start web
docker stop web


#####################################################
#Run interactive mode
#####################################################

#-it: run container in interactive mode
#-it  => i=interactive terminal, t = tty
#This will start a container called temp using ubantu lates image and run bash--  you will be #at root of the machine
#To exit : Ctrl p + Q

docker run -it --name temp ubuntu:latest /bin/bash

#exit container without killing it
ctrl-p-q


#####################################################
#Connecting
#####################################################

#Connect to an existing container that is stopped
#get the id
docker ps -a
docker start 41ba6ea2f889
docker attach  41ba6ea2f889
docker restart id

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Images
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


#####################################################
#List Images
#####################################################

#list images
docker images


#####################################################
#Delete Images
#####################################################

#you have to remove linked containers first

#get ids of containers
docker ps -a

#delete containers
docker rm id --force

#delete image
docker rmi ubuntu:14.04 --force


#####################################################
#Pulling Images
#####################################################

#images once pulled are stored under /var/lib/docker/overlay2  <storage driver--overlay2 for ubuntu>

# ls -l /var/lib/docker/aufs
docker pull alpine
docker pull ubuntu
docker pull ubuntu:14.04


#####################################################
#Copying  Images
#####################################################

#create a short lived container that creates a file and exits(non interactive mode)
docker run ubuntu /bin/bash -c "echo 'My cool content' > /tmp/cool-file"

#grab the id of the container just run. In this case it is 61065e43645a
docker ps -a

#docker commit: takes our changes and makes a new image. We will call the image fridge
docker commit cfd3445eca11  fridge

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


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Docker File
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



#####################################################
#Create Dockerfile
#####################################################
#Call it Dockerfile (no extension)

#FROM instruction has to be the first instruction

#RUN commands used to run instructions against our images. Every run instruction creates a layer in our image.

#save this file as Dockerfile


#Simple Asp.Net Core MVC app
#https://docs.microsoft.com/en-us/dotnet/core/docker/building-net-docker-images

#This sample uses Publish to build production version of app. The -c release argument builds the application in release mode (the default is debug mode)
<#

FROM microsoft/aspnetcore-build:2.0 AS build-env

#sets the working directory
WORKDIR /app

# copy csproj and restore as distinct layers
COPY *.csproj ./do
RUN dotnet restore

# copy everything else and build
COPY . ./
RUN dotnet publish -c Release -o out

# build runtime image
FROM microsoft/aspnetcore:2.0
WORKDIR /app
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "aspnetapp.dll"]

#>

#After the application starts, visit http://localhost:5000 in your web browser.
cd aspnetapp
docker build -t aspnetapp .
docker run -it --rm -p 5000:80 --name aspnetcore_sample aspnetapp

docker ps

#########################################################################
# Docker Compose
########################################################################
#when building a VS project, it creates a docker compo
#HOST:CONTAINER



#Compose
#docker-compose  -f "D:\docker\hb\hellodockertools\docker-compose.yml" -f "D:\docker\hb\hellodockertools\docker-compose.override.yml" -f "D:\docker\hb\hellodockertools\obj\Docker\docker-compose.vs.debug.g.yml" -p dockercompose15010737430134370792 --no-ansi up -d --no-build --force-recreate --remove-orphans

docker-compose up -d

#rebuild
docker-compose up --build

#rebuilding specific containers


docker-compose build --no-cache sql.data 

 

#This will give the port it is running on
 docker ps
docker inspect --format="{{json .NetworkSettings.Ports}}" b0f7452d47f9  

#To run at a specific port specify HOST:CONTAINER. hellodockertools is the name of the service in docker-compose.yml
docker-compose run -p 5001:80 hellodockertools

#hit it
http://localhost:32774/


#########################################################################
# sql server
########################################################################
#To connect to sql server running inside docker, use the host ip (laptop ip & port at which sql srver is running )
# enable tcp in sql configurtion

#192.168.1.82\sqlexpress,1433