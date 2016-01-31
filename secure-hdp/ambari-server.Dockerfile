# Creates an Ambari Server base on vanilla centos
# To build the image use:
#

FROM centos:7
MAINTAINER Senthil

ADD  setEnv.sh  / 
ADD ambari.repo /etc/yum.repos.d/
RUN  yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel ambari-server ambari-agent postgresql-jdbc krb5-workstation nss-pam-ldapd openldap-clients mysql  nc
ENV JAVA_HOME  /usr/lib/jvm/java
RUN echo "client.api.port=8888"  >> /etc/ambari-server/conf/ambari.properties
ADD run-ambari.sh /
CMD /run-ambari.sh
