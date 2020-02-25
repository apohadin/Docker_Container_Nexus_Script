#!/bin/bash

# options:
# remove stopped containers and untagged images
#   $ mrclean
# remove all stopped|running containers and untagged images
#   $ mrclean --reset
# remove containers|images|tags matching {repository|image|repository\image|tag|image:tag}
# pattern and untagged images
#   $ mrclean --purge {image}
# everything
#   $ mrclean --nuclear


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
    exit 0
fi

if [ "$1" == "--nuclear" ]; then
    docker rm -vf $(docker ps -a -q) 2>/dev/null || echo "No more containers to remove."
    docker rmi $(docker images -q) 2>/dev/null || echo "No more images to remove."
    exit 0
else
    # Always remove untagged images
    docker rmi $(docker images | grep "<none>" | awk '{print $3}') 2>/dev/null || echo "No untagged images to delete."
fi


if [ "$1" == "--create" ];then
    docker volume create --name nexus-data 2>/dev/null
    docker  run --name $2 -d -p $3 -v nexus-data:/nexus-data sonatype/nexus3 2>/dev/null|| echo "Creating docker image nexus3"
    exit 0
else
    $(docker ps -a|grep $2 |awk '{print $13}') 2>/dev/null || echo "Container has already been created.."
fi

if [ "$1" == "--backup" ];then
    docker commit -p $(docker ps -aq) $2 || echo "Snapshot has been created...."
    docker save $2 > $2.tar
    exit 0
else
    echo "Usage: ./mrclean.sh --backup container-id backupname"
fi

if [ "$1" == "--restore" ];then
  cat $2.tar |docker load  2>/dev/null|| echo "Image loading ...."
  exit 0
else
  echo "Usage: ./mrclean.sh --restore backupname.tar"
fi


exit 0
