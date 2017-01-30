#!/bin/bash

if [ -e files/eclipse-java-neon-2-linux-gtk-x86_64.tar.gz ]; then
   echo "eclipse package already exists"
else
   wget -O files/eclipse-java-neon-2-linux-gtk-x86_64.tar.gz  http://mirror.onet.pl/pub/mirrors/eclipse//technology/epp/downloads/release/neon/2/eclipse-java-neon-2-linux-gtk-x86_64.tar.gz
fi
docker build -t docker-dev-env-debian .

