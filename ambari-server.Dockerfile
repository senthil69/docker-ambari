# Creates an Ambari Server base on vanilla centos
# To build the image use:
#

FROM ambari-base:1
MAINTAINER Senthil


ENV JAVA_HOME /usr
RUN ambari-server setup -j /usr --silent
ADD start-master.sh /tmp/start-master.sh
RUN chmod +x /tmp/start-master.sh

EXPOSE 8670 8080 8440 8441 
CMD /tmp/start-master.sh
