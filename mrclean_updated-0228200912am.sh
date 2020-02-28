#!/bin/bash

if [ "$1" == "--reset" ]; then
    # Remove all containers regardless of state
    docker rm -vf $(docker ps -a -q) 2>/dev/null || echo "No more containers to remove."
    exit 0
elif [ "$1" == "--purge" ]; then
    # Attempt to remove running containers that are using the images we're trying to purge first.
    (docker rm -vf $(docker ps -a | grep "$2/\|/$2 \| $2 \|:$2\|$2-\|$2:\|$2_" | awk '{print $1}') 2>/dev/null || echo "No containers using the \"$2\" image, continuing purge.") &&\
    # Remove all images matching arg given after "--purge"
    docker rmi $(docker images | grep "$2/\|/$2 \| $2 \|$2 \|$2-\|$2_" | awk '{print $3}') 2>/dev/null || echo "No images matching \"$2\" to purge."
    exit 0
else
    # This alternate only removes "stopped" containers
    docker rm -vf $(docker ps -a | grep "Exited" | awk '{print $1}') 2>/dev/null || echo "No stopped containers to remove."
fi

if [ "$1" == "--create" ];then
    docker volume create --name nexus-data 2>/dev/null
    docker  run --name $2 -d -p 8081:8081 -v nexus-data:/nexus-data sonatype/nexus3 | echo "Creating docker image nexus3"
    exit 0
else
    $(docker ps -a|grep $2 |awk '{print $13}') 2>/dev/null | echo "Container has already been created.."
    echo "Usage: ./mrclean.sh --create name port:port"
fi

if [ "$1" == "--backup" ];then
    docker commit -p $(docker ps -aq) $2 || echo "Snapshot has been created...."
    docker save $2 > $2.tar
    exit 0
else
    echo "Usage: ./mrclean.sh --backup container-id backupname"
fi

if [ "$1" == "--frombackup" ];then
    docker volume create --name nexus-data 2>/dev/null
    docker  run --name $2 -d -p 8081:8081 -v nexus-data:/nexus-data $(docker images|grep -v 'sonatype/nexus3'|grep -v 'REPOSITORY'|awk '{print $1}') 2>/dev/null|| echo "Creating docker image nexus3"
    exit 0
else
    $(docker ps -a|grep $2 |awk '{print $13}') 2>/dev/null | echo "Container has already been created.."
    exit 1
fi

exit 0