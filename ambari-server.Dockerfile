# Creates an Ambari Server base on vanilla centos
# To build the image use:
#

FROM ambari-base:1
MAINTAINER Senthil


RUN yum install -y postgresql-jdbc
ENV JAVA_HOME /usr
RUN echo "client.api.port=8888"  >> /etc/ambari-server/conf/ambari.properties
ADD start-master.sh /tmp/start-master.sh
RUN chmod +x /tmp/start-master.sh

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

