# Creates an Ambari Server base on vanilla centos
# To build the image use:
#

FROM ambari-base:1
MAINTAINER Senthil

ADD spark* /root/
RUN yum install -y postgresql-jdbc
ENV JAVA_HOME /usr
RUN echo "client.api.port=8888"  >> /etc/ambari-server/conf/ambari.properties
ADD start-master.sh /tmp/start-master.sh
RUN chmod +x /tmp/start-master.sh
ADD bootStrapDB.sql /root/bootStrapDB.sql

RUN yum install -y wget
WORKDIR /root
RUN wget --quiet https://s3.amazonaws.com/public-repo-1.hortonworks.com/HDP-LABS/Projects/spark/1.4.1/spark-assembly_2.10-1.4.1.2.3.1.0-8-dist.tar.gz
RUN useradd spark
ENV SPARK_HOME=/opt/apache/spark-1.4.1
ENV YARN_CONF_DIR=/etc/hadoop/conf
RUN mkdir -p $SPARK_HOME
WORKDIR $SPARK_HOME
RUN tar -zxf /root/spark-assembly_2.10-1.4.1.2.3.1.0-8-dist.tar.gz
ADD spark-defaults.conf $SPARK_HOME/conf/spark-defaults.conf
RUN echo "-Dhdp.version=2.2.6.0-2800" > $SPARK_HOME/conf/java-opts
RUN touch RELEASE

#EXPOSE 8670 8080 8440 8441 
CMD /tmp/start-master.sh


#  --database=DBMS       Database to use embedded|oracle|mysql|postgres
#  --databasehost=DATABASE_HOST
#                        Hostname of database server
#  --databaseport=DATABASE_PORT
#                        Database port
#  --databasename=DATABASE_NAME
#                        Database/Service name or ServiceID
#  --postgresschema=POSTGRES_SCHEMA
#                        Postgres database schema name
#  --databaseusername=DATABASE_USERNAME
#                        Database user login
#  --databasepassword=DATABASE_PASSWORD
#                        Database user password

