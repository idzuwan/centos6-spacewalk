Dockerfile - Spacewalk on Centos 6
======================

Current version <p>
v1.0.8: Spacewalk v2.6<br>
v1.0.9-dev: Spacewalk v2.9

### Build ###
```
# git clone https://github.com/idzuwan/spacewalk.git spacewalk
# docker build --rm -t spacewalk spacewalk
```
Note: above command will make a copy to the current directory you run the command

Also available on docker.io
```
https://hub.docker.com/r/skelator/centos6-spacewalk/
```

```
docker pull idzuwan/spacewalk
```

### Run ###
```
# docker run --privileged=true -d --name="spacewalk" spacewalk
```

```
# docker inspect -f '{{ .NetworkSettings.IPAddress }}' spacewalk
172.17.0.126
```

### How I run the container ###

1. Create custom data volumes, change this to your own path for me I have /opt/data on LVM disk dedicated for dockers data
```
export DATA="/opt/data"
mkdir -p $DATA/spacewalk/opt
mkdir -p $DATA/spacewalk/var/satellite
```

2. Copy answer.txt and spacewalk.sh from the cloned git repo to our new data volumes path
```
cp -Rp PATH-TO-GIT/docker-spacewalk/conf/answer.txt $DATA/spacewalk/opt/
cp -Rp PATH-TO-GIT/docker-spacewalk/conf/spacewalk.sh $DATA/spacewalk/opt/
```

3. Run, with all port binded to host instead of internal IP
```
docker run -d --privileged=true -p 80:80 -p 443:443 -p 5222:5222 \
 --restart=always \
 -v /opt/data/spacewalk/opt:/opt \
 -v /opt/data/spacewalk/var/satellite:/var/satellite \
 -h "spacewalk.local" \
 --name="spacewalk" spacewalk
```
