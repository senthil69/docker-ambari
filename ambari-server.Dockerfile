# Creates an Ambari Server base on vanilla centos
# To build the image use:
#

FROM ambari-base:1
MAINTAINER Senthil


#RUN yum install -y -d 0 -e 0 hdp-select  snappy snappy-devel ambari-log4j  
#
ENV JAVA_HOME /usr
RUN ambari-server setup -j /usr --silent
RUN mkdir -p /var/lib/ambari-server/resources/stacks/HDP/2.2.Brightics
ADD 2.2.Brightics/  /var/lib/ambari-server/resources/stacks/HDP/2.2.Brightics
EXPOSE 8670 8080 8440 8441 
