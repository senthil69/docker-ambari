FROM hue:1
Maintainer Senthil 

RUN mkdir -p /etc/hadoop/conf
RUN mkdir -p /etc/hive/conf
ADD  hdfs-site.xml /etc/hadoop/conf/
ADD  core-site.xml /etc/hadoop/conf/
ADD  hive-site.xml /etc/hive/conf/
ADD  hue.ini  /root/hue.ini
WORKDIR /root
ADD hue-run.sh  /root/hue-run.sh
CMD "/bin/bash" "/root/hue-run.sh"
