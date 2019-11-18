Dockerfile - Spacewalk 2.6 on Centos 6
======================

### NOTE: This repo will no longer be maintained/updated ###

### Build ###
```
# git clone https://github.com/idzuwan/centos-spacewalk26.git centos-spacewalk26
# docker build --rm -t centos-spacewalk26 centos-spacewalk26
```
Note: above command will make a copy to the current directory you run the command

Also available on docker.io
```
https://hub.docker.com/r/skelator/centos-spacewalk26/
```

```
docker pull skelator/centos-spacewalk26
```

### Run ###
```
# docker run --privileged=true -d --name="spacewalk" centos-spacewalk26
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
 --name="spacewalk" spacewalk26
```
