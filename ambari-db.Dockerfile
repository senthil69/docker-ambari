# Creates an Ambari Server base on vanilla centos
# To build the image use:
#

FROM postgres:latest
MAINTAINER Senthil

# Add Ambari and HDP repositry
ADD bootStrapDB.sql /root/bootStrapDB.sql 
ADD bootStrap.sh /root/bootStrap.sh
ADD Ambari-DDL-Postgres-CREATE.sql  /root/Ambari-DDL-Postgres-CREATE.sql
RUN chmod +x /root/bootStrap.sh
ENTRYPOINT  /root/bootStrap.sh
