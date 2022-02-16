#!/bin/bash
sudo chmod 777 frontendstart.sh
#Ha már fent van a docker, akkor ezt a lépést kihagyja. docker-compose down
dockercheck=$(docker --version | grep -o "Docker")
if [ "$dockercheck" == "Docker" ]
then
echo "Docker already installed!"
else
sudo apt-get update
curl -fsSL https://get.docker.com | sudo sh
sudo usermod -aG docker ubuntu
sudo apt-get install docker-compose
fi