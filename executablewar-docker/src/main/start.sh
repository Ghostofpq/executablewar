#!/bin/bash

sudo docker run -v /etc/localtime:/etc/localtime:ro -Ptd --name ${module.name} ${module.name}:${project.version} /opt/applications/${module.name}/bin/startup.sh
