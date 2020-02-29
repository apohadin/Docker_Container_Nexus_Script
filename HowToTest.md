

# How to test


# Testing Creation and Moving to another Server
sudo install-docker.sh
sudo bash mrclean.sh --create MYNEXUS 8081:8081
sudo docker exec -it CONTAINER_NAME /bin/bash -c "cat  /nexus-data/admin.password"

- create a new admin password 
- create a raw hosted repository

# Now we backup the Container
sudo ./mrclean.sh --backup backupname

# On workstation pull down backupname.tar
scp -i ~/.ssh/mydeployuser ej@104.197.82.250:backupname.tar .

# On workstation push to new server 
scp -i ~/.ssh/mydeployuser backup280220.tar ej@35.193.199.57:~
scp -i ~/.ssh/mydeployuser install-docker.sh ej@35.193.199.57:~
scp -i ~/.ssh/mydeployuser mrclean.sh ej@35.193.199.57:~


# Steps on the new server 
sudo install-docker.sh
sudo bash mrclean.sh --create MYNEXUS 8081:8081 --> note wait for a while for it to setup ..
go to http://104.197.82.250:8081/ to check if nexus is already setup
sudo bash mrclean.sh --backup --> note: will be generating 2 files {image}.tar and {config}`date +%d%m%y`.tar
sudo bash mrclean.sh --restore backupname.tar 


















sudo bash mrclean.sh restore backup.tar
sudo bash mrclean.sh --restore backup.tar
x=$(sudo docker images | grep none | cut -d '>' -f3 | cut -d \t -f1)
y=$(echo $x | cut -d" " -f1)
sudo docker run --name sample -d -p 8081:8081 -v nexus-data:/nexus-data -t $y





x=$(sudo docker images | grep none | cut -d '>' -f3 | cut -d \t -f1)
y=$(echo $x | cut -d" " -f1)
sudo docker exec -it $y /bin/bash -c "cat  /nexus-data/admin.password"



sudo docker run --name sample -d -p 8081:8081 -v nexus-data:/nexus-data -t $y


Note: Edit to allow instance in network to have access http external(public network).






