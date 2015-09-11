# Creates an Ambari Server base on vanilla centos
# To build the image use:
#

FROM ambari-base:1
MAINTAINER Senthil



RUN sed -i "/pam_limits/ s/^/#/" /etc/pam.d/*

ADD start-agent.sh /tmp/start-agent.sh
RUN chmod +x /tmp/start-agent.sh
ENV JAVA_HOME /usr
RUN yum install -y wget 
WORKDIR /root
RUN wget https://s3.amazonaws.com/public-repo-1.hortonworks.com/HDP-LABS/Projects/spark/1.4.1/spark-assembly_2.10-1.4.1.2.3.1.0-8-dist.tar.gz
RUN useradd spark
ENV SPARK_HOME=/opt/apache/spark-1.4.1
ENV YARN_CONF_DIR=/etc/hadoop/conf
RUN mkdir -p $SPARK_HOME
WORKDIR $SPARK_HOME
RUN tar -zxf /root/spark-assembly_2.10-1.4.1.2.3.1.0-8-dist.tar.gz
ADD spark-defaults.conf $SPARK_HOME/conf/spark-defaults.conf
RUN echo "-Dhdp.version=2.2.6.0-2800" > $SPARK_HOME/conf/java-opts
RUN touch RELEASE

CMD /tmp/start-agent.sh
