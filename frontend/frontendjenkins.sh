#!/bin/bash
if [ -d /var/lib/jenkins/ArtMag-Monet ]
then
echo "Pulling the repository!"
gitpull=$(git -C /var/lib/jenkins/ArtMag-Monet pull)
    if [ "$gitpull" == "Already up to date." ]
    then
    echo "Build is up-to-date!"
    dockeron=$(sudo docker ps | grep -o "3000")
        if [ -z "$dockeron" ]
        then
        cd /var/lib/jenkins/ArtMag-Monet/frontend
        docker image prune -f
        docker-compose up --build -d
        else
        echo "Docker is up and running!"
        fi
    else
    cd /var/lib/jenkins/ArtMag-Monet/frontend
    docker image prune -f
    docker-compose up --build -d
    fi
else
echo "Cloning the repository."
cd /var/lib/jenkins
git clone https://github.com/gegenypeter/ArtMag-Monet.git
cp /var/lib/jenkins/Dockerfile /var/lib/jenkins/ArtMag-Monet/frontend/Dockerfile
cp /var/lib/jenkins/docker-compose.yml /var/lib/jenkins/ArtMag-Monet/frontend/docker-compose.yml
cd /var/lib/jenkins/ArtMag-Monet/frontend
docker-compose up -d
fi