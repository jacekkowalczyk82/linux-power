docker run -i -t -p 1234:1234 -p 9191:9191 --net=host -v /data:/data -v ~/docker-dev-env-workspace:/home/developer/debian-workspace docker-dev-env-debian 
