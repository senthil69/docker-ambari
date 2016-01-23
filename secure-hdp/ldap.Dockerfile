# Creates an Ambari Server base on vanilla centos
# To build the image use:
#

FROM centos:7
MAINTAINER Senthil

RUN sed -i 's/tsflags/#tsflags/'  /etc/yum.conf
RUN yum install -y tar  openldap-servers openldap-clients krb5-server-ldap
ENV SLAPD_URL ldapi:/// ldap:///
ADD run-ldap.sh /run-ldap.sh 
ADD add-users.sh /add-users.sh
ADD setEnv.sh  /setEnv.sh
CMD ["/run-ldap.sh"]

