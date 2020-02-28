# Docker_Container_Nexus_Script
Docker Container Nexus Script up and down

Note: Edit to allow instance in network to have access http external(public network).


# execute below command to get  Admin password:

docker exec -it $(docker ps -qa) /bin/bash -c "cat  /nexus-data/admin.password"

# Remove stopped containers and untagged images

$./mrclean.sh --reset

# Remove containers|images|tags matching {repository|image|repository\image|tag|image:tag}

$ ./mrclean.sh --purge 

# Backup image
$./mrclean.sh --backup name

# Restore image 
$./mrclean.sh --restore backup.tar
