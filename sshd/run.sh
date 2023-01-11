#! /bin/bash

sudo docker build -t sshd:22.04 .
sudo docker build --build-arg SSH_USER=ubuntu --build-arg SSH_PASSWORD=ubuntu -t sshd:22.04 .
sudo docker run -d -p 22:22 --name ssh-server sshd:22.04