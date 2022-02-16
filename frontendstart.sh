#!/bin/bash
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
if [ -d /home/ubuntu/ArtMag-Monet ]
then
echo "Pulling the repository!"
gitpull=$(git -C /home/ubuntu/ArtMag-Monet pull)
if [ "$gitpull" == "Already up to date." ]
then
echo "Build is up-to-date!"
else
sudo docker-compose -f /home/ubuntu/ArtMag-Monet/frontend/docker-compose.yml down
sudo docker-compose -f /home/ubuntu/ArtMag-Monet/frontend/docker-compose.yml up -d
fi
else
echo "Cloning the repository."
git clone https://github.com/gegenypeter/ArtMag-Monet.git
touch /home/ubuntu/ArtMag-Monet/frontend/Dockerfile
touch /home/ubuntu/ArtMag-Monet/frontend/docker-compose.yml
touch /home/ubuntu/ArtMag-Monet/frontend/.dockerignore
fi
