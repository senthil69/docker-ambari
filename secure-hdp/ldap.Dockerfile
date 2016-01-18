# Creates an Ambari Server base on vanilla centos
# To build the image use:
#

FROM centos:7
MAINTAINER Senthil

RUN sed -i 's/tsflags/#tsflags/'  /etc/yum.conf
RUN yum install -y tar  openldap-servers openldap-clients krb5-server-ldap
ENV SLAPD_URL ldapi:/// ldap:///
ADD ldap-run.sh /ldap-run.sh 
ADD setEnv.sh  /setEnv.sh
CMD ["/ldap-run.sh"]

