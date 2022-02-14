#!/bin/bash
sudo apt-get update
curl -fsSL https://get.docker.com | sudo sh
sudo usermod -aG docker ubuntu
sudo apt-get install docker-compose
mkdir /home/ubuntu/tomcat-docker
touch /home/ubuntu/tomcat-docker/Dockerfile
#Dockerfile tomcat:
echo "FROM tomcat:9.0.41-jdk11
VOLUME /tmp/volume
COPY todo-mvc.war /tmp/volume/
ADD todo-mvc.war /usr/local/tomcat/webapps
RUN mv /usr/local/tomcat/webapps/todo-mvc.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh","run"]" >> /home/ubuntu/tomcat-docker/Dockerfile
