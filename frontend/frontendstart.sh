#!/bin/bash
#cd paranccsal be kell lépni a mappába ahol a docker-compose fájl van, különben nem megy crontab-al
if [ -d /home/ubuntu/ArtMag-Monet ]
then
echo "Pulling the repository!"
gitpull=$(git -C /home/ubuntu/ArtMag-Monet pull)
    if [ "$gitpull" == "Already up to date." ]
    then
    echo "Build is up-to-date!"
    dockeron=$(sudo docker ps | grep -o "3000")
        if [ -z "$dockeron" ]
        then
        cd /home/ubuntu/ArtMag-Monet/frontend
        sudo docker-compose -f /home/ubuntu/ArtMag-Monet/frontend/docker-compose.yml up --build -d
        else
        echo "Docker is up and running!"
        fi
    else
    cd /home/ubuntu/ArtMag-Monet/frontend
    sudo docker image prune -f
    sudo docker-compose -f /home/ubuntu/ArtMag-Monet/frontend/docker-compose.yml up --build -d
    fi
else
echo "Cloning the repository."
git clone https://github.com/gegenypeter/ArtMag-Monet.git
cp Dockerfile ~/ArtMag-Monet/frontend/
cp docker-compose.yml ~/ArtMag-Monet/frontend/
cp .dockerignore ~/ArtMag-Monet/frontend/
cd /home/ubuntu/ArtMag-Monet/frontend
sudo docker-compose -f ~/ArtMag-Monet/frontend/docker-compose.yml up -d
fi
