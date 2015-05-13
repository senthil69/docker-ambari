# Creates an Ambari Server base on vanilla centos
# To build the image use:
#

FROM centos:6.6
MAINTAINER Senthil

# Ambari  Repo
ADD ambari.repo /etc/yum.repos.d/
ADD hdp.repo /etc/yum.repos.d/
ADD download-deps.sh /tmp/download-deps.sh
RUN yum install -y tar git curl which ntp openssh-server openssh-client  java-1.7.0-openjdk java-1.7.0-openjdk-devel
RUN chmod +x /tmp/download-deps.sh
RUN /tmp/download-deps.sh
RUN yum install -y ambari-agent
ADD id_rsa.pub  /root/.ssh/id_rsa.pub 
ADD id_rsa  /root/.ssh/id_rsa
ADD id_rsa.pub  /root/.ssh/authorized_keys
RUN sed -i "/pam_limits/ s/^/#/" /etc/pam.d/*

ADD start-daemon.sh /tmp/start-daemon.sh
ENV JAVA_HOME /usr
EXPOSE 22 8080 5005
#Accumula Ports
EXPOSE 9999 9997 50091 50095 4560 12234 42424 10002 10001 
#HDFS
EXPOSE 50070 50470 8020 9000 50075 50475 50010 50020 50090 
#MAP reduce
EXPOSE 10020 19888 13562 
#YARN Ports
EXPOSE 8088 8050 8025 8030 8141 45454 10200 8188 8190 19888
#Hive
EXPOSE 10000 9999 9933 
#Hbase 
EXPOSE 60000 60010 60020 60030 8080 8085 9090 9095 
#ZooK 
EXPOSE 2888 3888 2181 
#MySQL 
EXPOSE 3306  8440 8441

## instead of starting the docker file FROM sequenceiq/ssh:
#RUN yum install -y curl
#RUN curl -L https://api.github.com/repos/sequenceiq/docker-ssh/tarball/master|tar -xz -C /usr/local/serf --strip-components=2 --touch \*/serf
## Setup our own private keys to login into container.Note You need to genrerate own private/public key pair at this directory 
#RUN yum install -y openssh-server openssh-clients
#ADD id_rsa.pub  /root/.ssh/id_rsa.pub 
#ADD id_rsa  /root/.ssh/id_rsa.
#ADD id_rsa.pub  /root/.ssh/authorized_keys
#
#
## fix annoying PAM error 'couldnt open session'
#RUN sed -i "/pam_limits/ s/^/#/" /etc/pam.d/*
#
## warm up the image
#ADD hdp.repo /etc/yum.repos.d/
#ADD download-warmup-deps.sh /tmp/
#RUN chmod +x  /tmp/download-warmup-deps.sh
#RUN /tmp/download-warmup-deps.sh
#RUN yum install -y ambari-log4j hadoop hadoop-libhdfs hadoop-lzo hadoop-lzo-native hadoop-mapreduce hadoop-mapreduce-historyserver hadoop-yarn hadoop-yarn-nodemanager hadoop-yarn-proxyserver hadoop-yarn-resourcemanager lzo net-snmp net-snmp-utils snappy snappy-devel unzip zookeeper hbase
#
## add ambari shell to the image so new users don't need the 1GB java image
#RUN curl -o /tmp/ambari-shell.jar https://s3-eu-west-1.amazonaws.com/maven.sequenceiq.com/releases/com/sequenceiq/ambari-shell/0.1.23/ambari-shell-0.1.23.jar
#ADD install-cluster.sh /tmp/
#ADD wait-for-host-number.sh /tmp/
#ADD ambari-shell.sh /tmp/
#ENV JAVA_HOME /usr/jdk64/jdk1.7.0_67
#ENV PATH $PATH:$JAVA_HOME/bin
#WORKDIR /tmp
#
## fixing pgsql issue
#RUN rm -rf /tmp/.s.PGSQL.5432.*
#
#ADD public-hostname.sh /etc/ambari-agent/conf/public-hostname.sh
#ADD internal-hostname.sh /etc/ambari-agent/conf/internal-hostname.sh
#RUN sed -i "/\[agent\]/ a public_hostname_script=\/etc\/ambari-agent\/conf\/public-hostname.sh" /etc/ambari-agent/conf/ambari-agent.ini
#RUN sed -i "/\[agent\]/ a hostname_script=\/etc\/ambari-agent\/conf\/internal-hostname.sh" /etc/ambari-agent/conf/ambari-agent.ini
#
#RUN mkdir /var/log/hadoop-metrics && chmod 777 /var/log/hadoop-metrics
#ADD hadoop-metrics2.properties.j2 /var/lib/ambari-server/resources/stacks/HDP/2.0.6/hooks/before-START/templates/hadoop-metrics2.properties.j2
#
## Error: database disk image is malformed
##ADD 00_dbclean.sh /usr/local/init/00_dbclean.sh
#
#VOLUME /var/log
#
## increase agent timeout
#RUN sed -i "s/agent.task.timeout=900/agent.task.timeout=2000/" /etc/ambari-server/conf/ambari.properties
#
#EXPOSE 8080 22
#ENTRYPOINT ["/usr/local/serf/bin/start-serf-agent.sh"]
#CMD ["--log-level", "debug"]
