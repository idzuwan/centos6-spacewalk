#
# Dockerfile - Spacewalk 2.6
#
# - Build
# git clone https://github.com/idzuwan/centos-spacewalk26.git centos-spacewalk26
# docker build --rm -t centos-spacewalk26 centos-spacewalk26
#
# - Run
# docker run --privileged=true -d --name="spacewalk" centos-spacewalk26

# 1. Base images
FROM     centos:centos6
MAINTAINER Nor Idzuwan Mohammad <zuan@mylinux.net.my>
LABEL version=1.0.5

# 2. Set the environment variable
WORKDIR /opt

# 3. Add the epel, spacewalk, jpackage repository
ADD conf/jpackage.repo /etc/yum.repos.d/jpackage.repo
RUN yum install -y epel-release \
    && yum install -y http://yum.spacewalkproject.org/latest/RHEL/6/x86_64/spacewalk-repo-2.6-0.el6.noarch.rpm

# 4. Installation a spacewalk
ADD conf/answer.txt	/opt/answer.txt
ADD conf/spacewalk.sh	/opt/spacewalk.sh
RUN chmod a+x /opt/spacewalk.sh && yum install -y spacewalk-setup-postgresql spacewalk-postgresql

# 5. Supervisor
RUN yum install -y python-setuptools \
 && easy_install pip && pip install supervisor \
 && pip install --upgrade meld3==0.6.10 \
 && mkdir /etc/supervisord.d
ADD conf/supervisord.conf /etc/supervisord.d/supervisord.conf

# 6. Start supervisord
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.d/supervisord.conf"]

# System Log: /var/log
# PostgreSQL Data: /var/lib/pgsql/data
# RPM repository: /var/satellite
# Bootstrap directory: /var/www/html/pub
VOLUME /var/log /var/lib/pgsql/data /var/satellite /var/www/html/pub

# Port
EXPOSE 80 443 5222
