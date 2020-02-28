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
    docker  run --name $2 -d -p 8081:8081 sonatype/nexus3 | echo "Creating docker image nexus3"
    exit 0
else
    $(docker ps -a|grep $2 |awk '{print $13}') 2>/dev/null | echo "Container has already been created.."
fi

if [ "$1" == "--backup" ];then
    docker commit -p $(sudo docker ps -aq) $2 || echo "Snapshot has been created...."
    docker save $2 > $2.tar
    docker export $(sudo docker ps -aq) > $(sudo docker ps -aq)-import-`date +%d%m%y`.tar
    exit 0
else
    echo "Usage: ./mrclean.sh --backup backupname"
fi

if [ "$1" == "--restore" ];then
  cat $2 |docker load  2>/dev/null|| echo "Image loading ...."
  exit 0
fi

if [ "$1" == "--frombackup" ];then
    docker  run --name $2 -d -p 8081:8081 $(docker images|egrep -v 'REPOSITORY|sonatype/nexus3'|awk '{print $1}') | echo "Creating docker image from backup"
    exit 0
else
    $(docker ps -a|grep $2 |awk '{print $13}') 2>/dev/null | echo "Container has already been created.."
fi


exit 0