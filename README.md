# linux-power
* The purpose of this instruction and set of scripts is to setup linux power development environment with docker on windows

## Elements of the setup

### Windows 7 with installed software
* Virtualbox
* Xming
* Git for Windows
* Docker toolbox for Windows ,
* docker-machine VM boot2docker, or Atomic project or Debian
* ssh client, putty, babun. I recommend [babun](http://babun.github.io/).

### Virualbox running Light Linux distro
* boot2docker or Debian

### Docker image elements
* the current choice is Debian as base docker image
* Terminator
* Git
* Byobu
* Meld
* Web browser chrome  chromium
* Java
* Python
* IDE eclipse
* Atom editor
* Scite

## How to setup Debian Virtualbox vm

* Install debian-8.7.1, no GUI
* Configure fort forwarding on the vm from host port 8122 to guest 22
* `ssh -p 8122 kowalczy@localhost` to connect to vm
* `su ` to become root
* `apt install sudo`
* `usermod -aG sudo kowalczy`
* `visudo` to edit sudoers file
* `exit` from root
* `sudo apt update` as normal user with sudo eccess, you may need to logout and login again
* update sources.list and add:
  `deb http://ftp.debian.org/debian jessie-backports main`

* run commands:

```
$ sudo apt-get install curl
$ sudo apt-get install apt-transport-https \
                       ca-certificates \
                       software-properties-common

$ curl -fsSL https://yum.dockerproject.org/gpg | sudo apt-key add -

$ sudo lsb_release -a
No LSB modules are available.
Distributor ID: Debian
Description:    Debian GNU/Linux 8.7 (jessie)
Release:        8.7
Codename:       jessie

$ sudo add-apt-repository \
       "deb https://apt.dockerproject.org/repo/ \
       debian-$(lsb_release -cs) \
       main"

$ sudo apt-get update
$ sudo apt-get -y install docker-engine
$ sudo docker run hello-world
$ sudo usermod -aG docker kowalczy
```

* logout and log in again  and run commands
  `docker run hello-world`
* configure autostart
  `sudo systemctl enable docker`

* add required tools

```
sudo apt-get install -y git byobu mc htop vim emacs-nox
```

* generate ssh keys
  `ssh-keygen`
* add generated public key to git repositories
* install virtualbox guest additions

```
$ sudo apt-get update
$ sudo apt-get upgrade
$ sudo apt-get install build-essential module-assistant
$ sudo m-a prepare
$ sudo mount /media/cdrom

```

* configure shared folders for this vm

|x  |mount point|windows path|
|---|-----------|------------|
|   |'/d/docker/debian-workspace' |'d:\docker\debian-workspace'|

* mount

```
$ sudo mkdir -p /d/docker/debian-workspace
$ sudo chown -R kowalczy:kowalczy /d/
$ sudo chmod -R 777 /d/
$ sudo mount -t vboxsf /d/docker/debian-workspace /d/docker/debian-workspace/
$ ln -s /d/docker/debian-workspace/ ~/workspace
$ df -h

```

* sudo nano /etc/fstab -  TODO::THIS DOES NOT WORK

```
# windows share
#/d/docker/debian-workspace on /d/docker/debian-workspace type vboxsf (rw,nodev,relatime)
/d/docker/debian-workspace    /d/docker/debian-workspace  vboxsf rw 0  0

```
Virtualbox handles it itself and mount it to /media/sf_/d/docker/debian-workspace



* `sudo apt-get install screenfetch`
* get screenfetch :-)

```
$ screenfetch -D 'Debian'
         _,met$$$$$gg.           kowalczy@tw1w7v-400100
      ,g$$$$$$$$$$$$$$$P.        OS: Debian 8.7 jessie
    ,g$$P""       """Y$$.".      Kernel: x86_64 Linux 3.16.0-4-amd64
   ,$$P'              `$$$.      Uptime: 17m
  ',$$P       ,ggs.     `$$b:    Packages: 744
  `d$$'     ,$P"'   .    $$$     Shell: bash 4.3.30
   $$P      d$'     ,    $$P     CPU: Intel Core i7-4810MQ CPU @ 2.794GHz
   $$:      $$.   -    ,d$$'     RAM: 98MB / 3961MB
   $$\;      Y$b._   _,d$P'
   Y$$.    `.`"Y$$$$P"'
   `$$b      "-.__
    `Y$$
     `Y$$.
       `$$b.
         `Y$$b.
            `"Y$b._
                `""""


```


* build
  use `./build.sh` as it will download eclipse package to be installed inside docker
  `docker build -t docker-dev-env .`
* run
  `docker run -i -t -p 1234:1234 -p 9191:9191 --net=host -v /d/docker/debian-workspace:/home/developer/debian-workspace docker-dev-env-debian`
