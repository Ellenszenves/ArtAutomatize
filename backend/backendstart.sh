#!/bin/bash
if [ -d /home/ubuntu/ArtMag-Monet-backend ]
then
echo "Pulling the repository!"
gitpull=$(git -C /home/ubuntu/ArtMag-Monet-backend pull)
    if [ "$gitpull" == "Already up to date." ]
    then
    echo "Build is up-to-date!"
    else
    sudo docker-compose -f /home/ubuntu/ArtMag-Monet-backend/backend/docker-compose.yml down
    sudo docker-compose -f /home/ubuntu/ArtMag-Monet-backend/backend/docker-compose.yml up -d
    fi
else
echo "Cloning the repository."
git clone https://github.com/gegenypeter/ArtMag-Monet-backend.git
cp Dockerfile ~/ArtMag-Monet-backend/backend/
cp docker-compose.yml ~/ArtMag-Monet-backend/backend/
cp .dockerignore ~/ArtMag-Monet-backend/backend/
sudo docker-compose -f ~/ArtMag-Monet-backend/backend/docker-compose.yml up -d
fi
