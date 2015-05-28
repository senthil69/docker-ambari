# Creates an Ambari Server base on vanilla centos
# To build the image use:
#

FROM centos:6.6
MAINTAINER Senthil

ADD ambari.repo /etc/yum.repos.d/
ADD HDP.repo /etc/yum.repos.d/
ADD HDP-UTILS.repo /etc/yum.repos.d/
RUN yum install -y ambari-server  ambari-agent
RUN yum install -y tar git curl which openssh-server openssh-client  java-1.7.0-openjdk java-1.7.0-openjdk-devel
ADD id_rsa.pub  /root/.ssh/id_rsa.pub 
ADD id_rsa  /root/.ssh/id_rsa
ADD id_rsa.pub  /root/.ssh/authorized_keys
RUN sed -i "/pam_limits/ s/^/#/" /etc/pam.d/*

ADD start-daemon.sh /tmp/start-daemon.sh
ENV JAVA_HOME /usr
RUN ambari-server setup -j /usr --silent
EXPOSE 8670 8080 8440 8441 
