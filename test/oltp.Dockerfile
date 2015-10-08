# Creates an Ambari Server base on vanilla centos
# To build the image use:
#

FROM centos:7
MAINTAINER Senthil

RUN yum update -y
RUN yum install -y tar git curl which wget java-1.7.0-openjdk java-1.7.0-openjdk-devel
RUN yum install -y ant 
WORKDIR /root
RUN git clone https://github.com/oltpbenchmark/oltpbench.git
ENV JAVA_HOME /usr/lib/jvm/java-1.7.0-openjdk
