# Creates an Ambari Server base on vanilla centos
# To build the image use:
#

FROM postgres
MAINTAINER Senthil
RUN mkdir -p /docker-entrypoint-initdb.d
ADD bootStrapPostGRESQLDB.sql /docker-entrypoint-initdb.d/bootStrapPostGRESQLDB.sql
ENV POSTGRES_PASSWORD  postgres


