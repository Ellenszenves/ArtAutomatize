#!/bin/bash
sudo apt-get update
curl -fsSL https://get.docker.com | sudo sh
sudo usermod -aG docker ubuntu
sudo apt-get install docker-compose
#Megy a git clone ubuntun, ide megy majd a repo
git clone