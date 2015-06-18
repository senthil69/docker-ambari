# Creates an Ambari Server base on vanilla centos
# To build the image use:
#

FROM centos:6.6
MAINTAINER Senthil

# Add Ambari and HDP repositry
ADD ambari.repo /etc/yum.repos.d/
ADD HDP.repo /etc/yum.repos.d/
ADD HDP-UTILS.repo /etc/yum.repos.d/
RUN yum install -y ambari-server  ambari-agent
RUN yum install -y tar git curl which openssh-server openssh-client  java-1.7.0-openjdk java-1.7.0-openjdk-devel

RUN sed -i "/pam_limits/ s/^/#/" /etc/pam.d/*
ADD start-daemon.sh /tmp/start-daemon.sh
RUN chmod +x /tmp/start-daemon.sh
ENV JAVA_HOME /usr

EXPOSE 8670 8080 8440 8441 

EXPOSE 9999 9997 50091 50095 4560 12234 42424 10002 10001 
#HDFS
EXPOSE 50070 50470 8020 9000 50075 50475 50010 50020 50090 
#MAP reduce
EXPOSE 10020 19888 13562 
#YARN Ports
EXPOSE 8088 8050 8025 8030 8141 45454 10200 8188 8190 19888
#Hive
EXPOSE 10000 9999 9933 
#Hbase 
EXPOSE 60000 60010 60020 60030 8080 8085 9090 9095 
#ZooK 
EXPOSE 2888 3888 2181 
#MySQL 
EXPOSE 8440 8441  8670

CMD /tmp/start-daemon.sh

