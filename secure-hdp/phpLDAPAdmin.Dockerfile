# Creates an Ambari Server base on vanilla centos
# To build the image use:
#

FROM centos:7
MAINTAINER Senthil

RUN sed -i 's/tsflags/#tsflags/'  /etc/yum.conf
RUN yum install -y epel-release
RUN yum install  -y  phpldapadmin
ADD config.php  /etc/phpldapadmin/config.php
ADD phpldapadmin.conf /etc/httpd/conf.d/phpldapadmin.conf 
