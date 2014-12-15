#!/bin/bash
./prepare.sh
sudo docker build -t ${module.name}:${project.version} .
