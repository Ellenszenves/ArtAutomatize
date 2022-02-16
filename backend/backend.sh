#!/bin/bash
sudo chmod 777 backendstart.sh
mkdir ~/backend
mv ~/Dockerfile ~/backend/Dockerfile
mv ~/docker-compose.yml ~/backend/docker-compose.yml
mv ~/.dockerignore ~/backend/.dockerignore
#Ha már fent van a docker, akkor ezt a lépést kihagyja. docker-compose down
dockercheck=$(docker --version | grep -o "Docker")
if [ "$dockercheck" == "Docker" ]
then
echo "Docker already installed!"
else
sudo apt-get update
curl -fsSL https://get.docker.com | sudo sh
sudo usermod -aG docker ubuntu
sudo apt-get install -y docker-compose
fi