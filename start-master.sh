#!/bin/bash
echo "Starting Ambari Server..."
ambari-server setup -j /usr --database=postgres  --databasehost=localhost --databaseport=5432 --databasename=ambari  --postgresschema=ambarischema --databaseusername=ambari --databasepassword=bigdata  --silent
rm -fr /var/log/hadoop  /var/run/hadoop
ambari-server start
cat /var/log/ambari-server/ambari-server.out
cat /var/log/ambari-server/ambari-server.log
while [ true ];  do  sleep 5 ; done
