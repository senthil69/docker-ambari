# Creates an Ambari Server base on vanilla centos
# To build the image use:
#

FROM postgres
MAINTAINER Senthil
RUN mkdir -p /docker-entrypoint-initdb.d
ADD bootStrapPostGRESQLDB.sql /docker-entrypoint-initdb.d/bootStrapPostGRESQLDB.sql
ADD add-pghost.sh  /docker-entrypoint-initdb.d/add-pghost.sh
ADD pg_hba.conf  /
ENV POSTGRES_PASSWORD  postgres
