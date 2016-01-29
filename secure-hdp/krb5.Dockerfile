# Creates an Ambari Server base on vanilla centos
# To build the image use:
#

FROM centos:7
MAINTAINER Senthil

RUN sed -i 's/tsflags/#tsflags/'  /etc/yum.conf
RUN yum install -y tar  krb5-server krb5-workstation krb5-server-ldap rng-tools
ADD krb5run.sh /krb5run.sh 
ADD krb5standAlone.sh /krb5standAlone.sh 
ADD setEnv.sh /setEnv.sh 
#CMD ["/krb5run.sh"]
CMD ["/krb5standAlone.sh"]

