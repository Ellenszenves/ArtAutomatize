#!/bin/bash
#Közös kulcs: monet-project.pem
#crontab -e --> crontab hozzáadása, megtekintése 
#grep CRON /var/log/syslog --> cron logjai
#docker-compose --force-recreate, --build
start_instances() {
desc=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=monet*" "Name=instance-state-name,Values=running" \
       --output text --query 'Reservations[*].Instances[*].[PublicIpAddress,InstanceId,Tags[?Key==`Name`].Value]')
if [ -z "$desc" ]
then
aws ec2 run-instances --image-id ami-042ad9eec03638628 \
--count 1 --instance-type t2.micro --key-name monet-project \
--security-group-ids sg-07dbad0270e4a4956 \
--tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=monet-frontend}]'

aws ec2 run-instances --image-id ami-042ad9eec03638628 \
--count 1 --instance-type t2.micro --key-name monet-project \
--security-group-ids sg-0f23178cb3d8d2520 \
--tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=monet-backend}]'
starter
else
#Ha futnak már futnak a gépek, itt ki lehet őket lőni.
echo "Instances are already running."
read -p "Terminate the instances?" term
    if [ "$term" == "yes" ]
    then
        while IFS=" " read -r ips
        do
        ezaz+="$ips "
        done <<< "$desc"
        id1=$(echo $ezaz | cut -d " " -f 2)
        id2=$(echo $ezaz | cut -d " " -f 5)
        aws ec2 terminate-instances --instance-ids $id1 $id2
        starter
    else
    starter
    fi
fi
}

describe_my_instances() {
#InstanceID and public IP
desc=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=monet*" "Name=instance-state-name,Values=running" \
       --output text --query 'Reservations[*].Instances[*].[PublicIpAddress,InstanceId,Tags[?Key==`Name`].Value]')
if [ -z "$desc" ]
then
echo "Instance not available!"
starter
else
while IFS=" " read -r ips
do
ezaz+="$ips "
done <<< "$desc"
ip1=$(echo $ezaz | cut -d " " -f 1)
ip2=$(echo $ezaz | cut -d " " -f 4)
id1=$(echo $ezaz | cut -d " " -f 2)
id2=$(echo $ezaz | cut -d " " -f 5)
echo "First instance IP:" $ip1 "ID:" $id1
echo "Second instance IP:" $ip2 "ID:" $id2
starter
fi
}

#Felmásolja a szükséges fájlokat, és feltelepíti a dockert, docker-compose-t.
install_docker() {
desc=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=monet*" "Name=instance-state-name,Values=running" \
       --output text --query 'Reservations[*].Instances[*].[PublicIpAddress,InstanceId,Tags[?Key==`Name`].Value]')
        if [ -z "$desc" ]
        then
        echo "Instance not available!"
        read -p "You want to make the instances?" make
            if [ "$make" == "yes" ]
            then
            start_instances
            else
            starter
            fi
        else
        scp -i "/home/ubuntu/host/monet-project.pem" ./frontend/Dockerfile ubuntu@$ip1:/home/ubuntu
        scp -i "/home/ubuntu/host/monet-project.pem" ./frontend/docker-compose.yml ubuntu@$ip1:/home/ubuntu
        scp -i "/home/ubuntu/host/monet-project.pem" ./frontend/.dockerignore ubuntu@$ip1:/home/ubuntu
        scp -i "/home/ubuntu/host/monet-project.pem" ./frontend/frontendstart.sh ubuntu@$ip1:/home/ubuntu
        ssh -i "/home/ubuntu/host/monet-project.pem" ubuntu@$ip1 < ./frontend/frontend.sh
        scp -i "/home/ubuntu/host/monet-project.pem" ./backend/Dockerfile ubuntu@$ip1:/home/ubuntu
        scp -i "/home/ubuntu/host/monet-project.pem" ./backend/docker-compose.yml ubuntu@$ip1:/home/ubuntu
        scp -i "/home/ubuntu/host/monet-project.pem" ./backend/.dockerignore ubuntu@$ip1:/home/ubuntu
        scp -i "/home/ubuntu/host/monet-project.pem" ./backend/frontendstart.sh ubuntu@$ip1:/home/ubuntu
        ssh -i "/home/ubuntu/host/monet-project.pem" ubuntu@$ip2 < ./backend/backend.sh
        starter
        fi
fi
}

starter() {
    echo "Art project"
    read -r "Choose function:" func
    if [ "$func" == "ec2" ]
    then
    start_instances
    elif [ "$func" == "describe" ]
    then
    describe_my_instances
    else
    echo "Wrong command!"
    starter
    fi
}

starter