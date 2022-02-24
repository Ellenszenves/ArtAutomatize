#!/bin/bash
#docker build -t tomcat-in-a-box .
#docker run -dp 8080:8080 --mount type=bind,source=/home/ubuntu/backend/setenv.sh,target=/usr/local/tomcat/bin/setenv.sh fileshare
sudo chmod 777 backendstart.sh
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
jenkinscheck=$(systemctl status jenkins)
if [ "$jenkinscheck" == "Unit jenkins.service could not be found." ]
then
sudo apt update
sudo apt install -y openjdk-11-jdk
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update
sudo apt install -y jenkins
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
else
echo "Jenkins already installed!"
fi
sudo mv ~/Dockerfile /var/lib/jenkins/Dockerfile
sudo mv ~/docker-compose.yml /var/lib/jenkins/docker-compose.yml
sudo mv ~/.dockerignore /var/lib/jenkins/.dockerignore