#!/bin/bash
cd applications 
rm -rf *
tar -zxvf ../tmp/${module.name}-app-${project.version}.tar.gz
mv ${module.name}* ${module.name}
