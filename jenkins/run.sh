#! /bin/bash

sudo docker run -d -p 8888:8080 -v /jenkins:/var/jenkins_home --name my_jenkins -u root jenkins/jenkins:lts
