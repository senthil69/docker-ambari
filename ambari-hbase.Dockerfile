# Creates an Ambari Server base on vanilla centos
# To build the image use:
#

FROM ambari-base:1
MAINTAINER Senthil

RUN yum install -y -d 0 -e 0 hbase_2_2_*  phoenix_2_2_* 



RUN chmod +x /tmp/start-daemon.sh
ENV JAVA_HOME /usr

CMD /tmp/start-daemon.sh
