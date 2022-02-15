#!/bin/bash
#Ha már fent van a docker, akkor ezt a lépést kihagyja.
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
#Ha már létezik a repónak mappa, lehúzza a módosításokat,
#ha még nincs akkor klónozza a gépre.
if [ -d /home/ubuntu/api-server-example ]
then
echo "Pulling the repository."
gitpull=$(git -C /home/ubuntu/api-server-example/ pull)
    if [ "$gitpull" == "Already up to date." ]
    then
    echo "Build is up-to-date."
    else
    #image build
    docker build . -t ubuntu/node-web-app
    #run container
    docker run -p 8080:8080 -d ubuntu/node-web-app
    fi
else
echo "Cloning the repository."
git clone https://github.com/atomrichard/api-server-example.git
touch /home/ubuntu/api-server-example/Dockerfile
touch /home/ubuntu/api-server-example/.dockerignore
#Dockerignore:
echo "node_modules
npm-debug.log" >> /home/ubuntu/api-server-example/.dockerignore
#Dockerfile node:
echo "FROM node:16
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 8080
CMD [ "node", "server.js" ]" >> /home/ubuntu/api-server-example/Dockerfile
#image build
docker build . -t ubuntu/node-web-app
#run container
docker run -p 8080:8080 -d ubuntu/node-web-app
fi