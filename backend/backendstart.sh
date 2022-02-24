#!/bin/bash
if [ -d /home/fallouterdo/common-fileshare-starter ]
then
echo "Pulling the repository!"
gitpull=$(git -C /home/fallouterdo/common-fileshare-starter pull)
    if [ "$gitpull" == "Already up to date." ]
    then
    echo "Build is up-to-date!"
    dockeron=$(docker ps | grep -o "8080")
        if [ -z "$dockeron" ]
        then
        cd /home/fallouterdo/common-fileshare-starter
        docker image prune -f
        docker-compose up --build -d
        else
        echo "Docker is up and running!"
        fi
    else
    cd /home/fallouterdo/common-fileshare-starter
    docker image prune -f
    docker-compose up --build -d
    fi
else
echo "Cloning the repository."
cd /home/fallouterdo/
git clone https://github.com/dokaattila/common-fileshare-starter.git
cp /home/fallouterdo/backend/Dockerfile /home/fallouterdo/common-fileshare-starter/Dockerfile
cp /home/fallouterdo/backend/docker-compose.yml /home/fallouterdo/common-fileshare-starter/docker-compose.yml
cd /home/fallouterdo/common-fileshare-starter
docker-compose up -d
fi