# Creates an Ambari Server base on vanilla centos
# To build the image use:
#

FROM ambari-base:1
MAINTAINER Senthil


RUN yum install -y -d 0 -e 0 hdp-select  snappy snappy-devel ambari-log4j  hadoop_2_2_* hbase_2_2_*  phoenix_2_2_*
#
ENV JAVA_HOME /usr
RUN ambari-server setup -j /usr --silent
EXPOSE 8670 8080 8440 8441 
