#! /bin/bash

sudo docker run -d -p 8081:8081 -p 12000:12000 --name nexus -v data:/nexus-data sonatype/nexus3