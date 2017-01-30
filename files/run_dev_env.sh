#!/bin/bash 
#run_dev_env.sh 


#    if [ -d /home/developer/workspace/personal-repo ]; then 
#       cd  /home/developer/workspace/personal-repo &&  git status 
#       # && git stash save "personal-repo at `date`" && git pull --rebase 
#    else 
#       cd /home/developer/workspace && git clone --verbose GIT_SSH_REPO_URL
#
#    fi 	

#    cd /home/developer/workspace/personal-repo/app 
    
    git config --global user.name "Jacek Kowalczyk"
    git config --global user.email jacekkowalczyk82@gmail.com

    export DISPLAY=<your_windows_host_name>:0.0
    cd /home/developer
    terminator & 

    emacs  &
    scite & 
    chmod 755  /home/developer/eclipse/eclipse
    cd /home/developer/eclipse
    chown -R developer:developer /home/developer
    nohup /home/developer/eclipse/eclipse & 
    tail /home/developer/run_dev_env.sh
    cd ~
    bash  	
	


