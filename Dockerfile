#
# Dockerfile - Spacewalk 
#
# - Build
# git clone https://github.com/idzuwan/centos6-spacewalk.git centos6-spacewalk
# docker build --rm -t centos6-spacewalk centos6-spacewalk
#
# - Run
# docker run --privileged=true -d --name="spacewalk" centos6-spacewalk

# 1. Base images
FROM     centos:centos6
MAINTAINER Nor Idzuwan Mohammad <zuan@mylinux.net.my>
LABEL version=1.0.9-dev

# 2. Set the environment variable
WORKDIR /opt

# 3. Add the epel, spacewalk, jpackage repository
RUN echo "sslverify=false" >>/etc/yum.conf
RUN yum install -y yum-plugin-tmprepo \
 && yum install -y spacewalk-repo --tmprepo=https://copr-be.cloud.fedoraproject.org/results/%40spacewalkproject/spacewalk-2.9/epel-6-x86_64/repodata/repomd.xml --nogpg \
 && yum install -y epel-release

# 4. Installation a spacewalk
ADD conf/answer.txt	/opt/answer.txt
ADD conf/spacewalk.sh	/opt/spacewalk.sh
RUN chmod a+x /opt/spacewalk.sh && yum install -y spacewalk-setup-postgresql spacewalk-postgresql

# 5. Supervisor
RUN yum install -y python-pip \
 && pip --trusted-host files.pythonhosted.org --trusted-host pypi.org --trusted-host pypi.python.org install supervisor==3.4.0 \
 && pip --trusted-host files.pythonhosted.org --trusted-host pypi.org --trusted-host pypi.python.org install --upgrade meld3==0.6.10 \
 && mkdir /etc/supervisord.d \
 && yum clean all && rm -fr /var/cache/yum
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
