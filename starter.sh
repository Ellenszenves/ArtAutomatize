#!/bin/bash
#CSINÁLNI KULCSOT A CSAPATNAK AWS-EN!!!!!
start_instances() {
desc=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=monet*" "Name=instance-state-name,Values=running" \
       --output text --query 'Reservations[*].Instances[*].[PublicIpAddress,InstanceId,Tags[?Key==`Name`].Value]')
if [ -z "$desc" ]
then
aws ec2 run-instances --image-id ami-042ad9eec03638628 \
--count 1 --instance-type t2.micro --key-name erdelyi-tamas \
--security-group-ids sg-08fb876c08317c18c \
--tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=monet-frontend}]'

aws ec2 run-instances --image-id ami-042ad9eec03638628 \
--count 1 --instance-type t2.micro --key-name erdelyi-tamas \
--security-group-ids sg-08fb876c08317c18c \
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
        ssh -i "/home/ubuntu/host/erdelyi-tamas.pem" ubuntu@$ip1 < frontend.sh
        ssh -i "/home/ubuntu/host/erdelyi-tamas.pem" ubuntu@$ip2 < backend.sh
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