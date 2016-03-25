# Creates an Ambari Server base on vanilla centos
# To build the image use:
#

FROM postgres
MAINTAINER Senthil
RUN mkdir -p /docker-entrypoint-initdb.d
ADD bootStrapPostGRESQLDB.sql /docker-entrypoint-initdb.d/bootStrapPostGRESQLDB.sql
ADD pg_hba.conf  /
RUN cat /pg_hba.conf >> /var/lib/postgresql/data/pg_hba.conf
ENV POSTGRES_PASSWORD  postgres


