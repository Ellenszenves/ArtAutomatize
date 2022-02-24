#!/bin/bash
#sudo lsof -nP -iTCP -sTCP:LISTEN | grep 8080 | cut -d " " -f 7 -- PID of the running process
if [ -d /var/lib/jenkins/common-fileshare-starter ]
then
dockeron=$(lsof -nP -iTCP -sTCP:LISTEN | grep -o 8080)
if [ -z "$dockeron" ]
then
export DRIVER_CLASS_NAME="org.postgresql.Driver"
export LOGIN="monet"
export PASSWORD="monet"
export URL="jdbc:postgresql://3.125.151.179:5432/monet"
pid=$(lsof -nP -iTCP -sTCP:LISTEN | grep 8080 | cut -d " " -f 7)
kill $pid
cd /var/lib/jenkins/common-fileshare-starter
git pull
mvn package
cd /var/lib/jenkins/common-fileshare-starter/target
BUILD_ID=dontKillMe nohup java -jar fileshare-0.0.1-SNAPSHOT.jar >> output.logs &
fi
else
git clone https://github.com/dokaattila/common-fileshare-starter.git
export DRIVER_CLASS_NAME="org.postgresql.Driver"
export LOGIN="monet"
export PASSWORD="monet"
export URL="jdbc:postgresql://3.125.151.179:5432/monet"
cd /var/lib/jenkins/common-fileshare-starter
mvn package
cd /var/lib/jenkins/common-fileshare-starter/target
nohup java -jar fileshare-0.0.1-SNAPSHOT.jar &
fi