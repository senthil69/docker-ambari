# Creates an Ambari Server base on vanilla centos
# To build the image use:
#

FROM centos:6.6
MAINTAINER Senthil

# Add Ambari and HDP repositry
ADD ambari.repo /etc/yum.repos.d/
RUN yum update -y
RUN yum install -y  ambari-agent
RUN yum install -y tar git curl which openssh-server java-1.7.0-openjdk java-1.7.0-openjdk-devel
ENV JAVA_HOME /usr


RUN sed -i "/pam_limits/ s/^/#/" /etc/pam.d/*
