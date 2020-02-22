# Docker_Container_Nexus_Script
Docker Container Nexus Script up and down

Note: Edit to allow instance in network to have access http external(public network).


execute below command to get  Admin password:

docker exec -it CONTAINDER_NAME /bin/bash -c "cat  /nexus-data/admin.password"
# remove stopped containers and untagged images

$./mrclean.sh --reset

#remove containers|images|tags matching {repository|image|repository\image|tag|image:tag}

$ ./mrclean.sh --purge {image}

# remove everything

$ ./mrclean.sh --nuclear

# backup image
$./mrclean.sh --backup

# Save to tar to migrate to other servers/instances
$./mrclean.sh --savetofile

# Restore image 
$./mrclean.sh --restore
