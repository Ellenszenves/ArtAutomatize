#!/bin/bash
if [ -d /var/lib/jenkins/ArtMag-Monet-backend ]
then
echo "Pulling the repository!"
gitpull=$(git -C /var/lib/jenkins/ArtMag-Monet-backend pull)
    if [ "$gitpull" == "Already up to date." ]
    then
    echo "Build is up-to-date!"
    dockeron=$(sudo docker ps | grep -o "4000")
        if [ -z "$dockeron" ]
        then
        cd /var/lib/jenkins/ArtMag-Monet-backend/backend
        docker image prune -f
        docker-compose up --build -d
        else
        echo "Docker is up and running!"
        fi
    else
    cd /var/lib/jenkins/ArtMag-Monet-backend/backend
    docker image prune -f
    docker-compose up --build -d
    fi
else
echo "Cloning the repository."
cd /var/lib/jenkins
git clone https://github.com/gegenypeter/ArtMag-Monet-backend.git
cp /var/lib/jenkins/backend/Dockerfile /var/lib/jenkins/ArtMag-Monet-backend/backend/Dockerfile
cp /var/lib/jenkins/backend/docker-compose.yml /var/lib/jenkins/ArtMag-Monet-backend/backend/docker-compose.yml
cd /var/lib/jenkins/ArtMag-Monet-backend/backend
docker-compose up -d
fi