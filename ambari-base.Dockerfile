# Creates an Ambari Server base on vanilla centos
# To build the image use:
#

FROM centos:6.6
MAINTAINER Senthil

# Add Ambari and HDP repositry
ADD ambari.repo /etc/yum.repos.d/
RUN yum update -y
RUN yum install -y ambari-server  ambari-agent
RUN (yum install -y tar git curl which openssh-server  || yum install -y tar git curl which openssh-server)
RUN (yum install -y openssh-client  java-1.7.0-openjdk java-1.7.0-openjdk-devel || yum install -y openssh-client  java-1.7.0-openjdk java-1.7.0-openjdk-devel )

# Upgrade obsolete SSL packages
RUN sed -i "/pam_limits/ s/^/#/" /etc/pam.d/*
