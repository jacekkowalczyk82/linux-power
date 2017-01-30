# setup docker for running syrena
# Using your preffered linux distribution install Docker 
# curl -sSL https://get.docker.com/ | sh
# sudo usermod -aG docker kowalczy 
# or 
# https://docs.docker.com/engine/installation/linux/ubuntulinux/
# https://docs.docker.com/engine/installation/linux/centos/#install-with-the-script
# at host machine 
# useradd -d /home/developer -m -s /bin/bash developer -u 1100 
# sudo passwd developer
# sudo usermod -aG sudo developer
# sudo chown -R developer:developer /home/developer
# docker build -t docker-dev-env-debian .
# mkdir -p ~/docker-dev-env-workspace
# chmod 777 -R ~/docker-dev-env-workspace
# sudo chown -R developer:developer ~/docker-dev-env-workspace
# docker run -i -t --rm -p 1234:1234 -p 9191:9191 --net=host docker-dev-env
# docker run -i -t -p 1234:1234 -p 9191:9191 --net=host -v /data:/data -v ~/docker-dev-env-workspace:/home/developer/workspace docker-dev-env-debian
#
#for windows docker toolbox 
#http://stackoverflow.com/questions/33126271/how-to-use-volume-option-with-docker-toolbox-on-windows
#This is actually an issue of the project and there are 2 working workarounds:
#1. Creating a data volume:
#docker create -v //c/Users/myuser:/myuser --name data hello-world
#winpty docker run -it --rm --volumes-from data ubuntu
#2. SSHing directly in the docker host:
#docker-machine ssh default
#And from there doing a classic:
#docker run -it --rm --volume /c/Users/myuser:/myuser ubuntu
#
#
# docker run -i -t -p 1234:1234 -p 9191:9191 --net=host -v /data:/data -v ~/docker-dev-env-workspace:/home/developer/debian-workspace docker-dev-env-debian
# docker run -i -t -p 1234:1234 -p 9191:9191 --net=host -v /d/docker/debian-workspace:/home/developer/debian-workspace docker-dev-env-debian
#

FROM debian:jessie

RUN apt-get -y update && apt-get install -y \
   python2.7 \
   python-setuptools \
   python-pip \
   sshpass \
   git \
   git-gui \
   meld \
   byobu \
   vim \
   mc \
   nano \
   wget \
   curl \
   software-properties-common \
   terminator \
   sudo \
   gawk \
   sed

RUN mkdir -p /programs && \
    chmod 777 -R /programs 


#RUN wget -O /programs/atom-amd64.tar.gz https://github.com/atom/atom/releases/download/v1.12.9/atom-amd64.tar.gz && \
#    cd /programs && tar -xvzf atom-amd64.tar.gz && \
#    ln -s /programs/atom-1.12.9-amd64/atom /usr/bin/atom
#RUN wget https://github.com/atom/atom/releases/download/v1.13.1/atom-amd64.deb
#RUN dpkg --install atom-amd64.deb


#emacs 23
RUN apt-get install -y emacs

#emacs25
#RUN apt-add-repository -y ppa:adrozdoff/emacs && \
#    apt-get update && \
#    apt-get install -y emacs25   
    
RUN apt-get install -y scite 

#java
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | tee /etc/apt/sources.list.d/webupd8team-java.list && \
   echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list  && \
   apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886  && \
   apt-get -y update  && \
   apt-get install -y oracle-java8-installer \
   oracle-java8-set-default


#user
RUN useradd -d /home/developer -m -s /bin/bash -u 1100 developer
RUN usermod -aG sudo developer
RUN chown -R developer:developer /home/developer

RUN mkdir -p /etc/sudoers.d/ && \
    echo "developer ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer

#set password for user: 
#$6$0CmRkzl5i38In1JL$fXGQ0rF41m.oBkXTVVRCRx0LaB0dZrRD8HXNfkFj.REivQlYqXdAuRGZFJvpQEyJr04T9b4aT2oMI/W0bDjFO1
RUN sed --in-place=.sed_backup 's|developer:!:|developer:$6$0CmRkzl5i38In1JL$fXGQ0rF41m.oBkXTVVRCRx0LaB0dZrRD8HXNfkFj.REivQlYqXdAuRGZFJvpQEyJr04T9b4aT2oMI/W0bDjFO1:|' /etc/shadow

	
#expose some ports for developed service 

EXPOSE 1234 9191

RUN mkdir -p /home/developer/debian-workspace/eclipse-workspace && \
    chown -R developer:developer /home/developer/debian-workspace


VOLUME ["/data","/home/developer/debian-workspace"]

RUN mkdir -p /home/developer/debian-workspace/eclipse-workspace && \
    chown -R developer:developer /home/developer/debian-workspace

RUN ln -s /home/developer/debian-workspace/eclipse-workspace /home/developer/workspace
RUN chown -R developer:developer /home/developer/workspace


ADD files/run_dev_env.sh /home/developer/run_dev_env.sh
RUN apt-get install -y dos2unix
RUN dos2unix /home/developer/run_dev_env.sh 
RUN chmod 755 /home/developer/run_dev_env.sh

ADD files/dev_env_info.txt /home/developer/dev_env_info.txt


RUN mkdir -p /home/developer/.ssh/
ADD files/docker_id_rsa  /home/developer/.ssh/
ADD files/docker_id_rsa.pub  /home/developer/.ssh/
RUN mv  /home/developer/.ssh/docker_id_rsa   /home/developer/.ssh/id_rsa
RUN mv  /home/developer/.ssh/docker_id_rsa.pub   /home/developer/.ssh/id_rsa.pub
RUN chown developer:developer /home/developer/.ssh/id_rs*
RUN chmod 600  /home/developer/.ssh/id_rsa

RUN chmod 666 /etc/hosts
RUN chown -R developer:developer /home/developer/

#RUN sudo add-apt-repository ppa:enlightenment-git/ppa && \
# sudo apt-get -y update && \
#  sudo apt-get install -y terminology

USER developer
ENV HOME /home/developer

WORKDIR /home/developer

ADD files/eclipse-java-neon-2-linux-gtk-x86_64.tar.gz  /home/developer/

CMD bash /home/developer/run_dev_env.sh 
#CMD tail -f /home/developer/run_dev_env.sh 

