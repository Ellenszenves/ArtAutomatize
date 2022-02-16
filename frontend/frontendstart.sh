#!/bin/bash
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
cp Dockerfile ~/ArtMag-Monet/frontend/
cp docker-compose.yml ~/ArtMag-Monet/frontend/
cp .dockerignore ~/ArtMag-Monet/frontend/
sudo docker-compose -f ~/ArtMag-Monet/frontend/docker-compose.yml up -d
fi
