# Creates an Ambari Server base on vanilla centos
# To build the image use:
#

FROM ambari-base:1
MAINTAINER Senthil


ADD start-agent.sh /tmp/start-agent.sh
RUN chmod +x /tmp/start-agent.sh
CMD /tmp/start-agent.sh

EXPOSE 1024:65000