#!/bin/bash
echo "Starting Ambari Server..."
psql -U postgres -h localhost < /root/bootStrapDB.sql
psql -U ambari -h localhost < /var/lib/ambari-server/resources/Ambari-DDL-Postgres-CREATE.sql

ambari-server setup -j /usr --database=postgres  --databasehost=localhost --databaseport=5432 --databasename=ambari  --postgresschema=ambarischema --databaseusername=ambari --databasepassword=bigdata  --silent
rm -fr /var/log/hadoop  /var/run/hadoop
ambari-server start
while [ true ];  do  sleep 5 ; done
