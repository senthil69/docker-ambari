# Creates an Ambari Server base on vanilla centos
# To build the image use:
#

FROM ambari-base:1
MAINTAINER Senthil


RUN yum install -y ambari-server postgresql-jdbc  nc mysql-connector-java  mysql
ENV JAVA_HOME /usr
RUN echo "client.api.port=8888"  >> /etc/ambari-server/conf/ambari.properties
ADD start-master-withPostGRESQL.sh /root/start-master-withPostGRESQL.sh
ADD start-master-withMySQL.sh /root/start-master-withMySQL.sh
RUN chmod +x /root/start-master-withMySQL.sh
ADD bootStrapPostGRESQLDB.sql /root/bootStrapPostGRESQLDB.sql
ADD bootStrapMySQLDB.sql /root/bootStrapMySQLDB.sql
#CMD /root/start-master-withMySQL.sh
CMD /root/start-master-withPostGRESQL.sh


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

