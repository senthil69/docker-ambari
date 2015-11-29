#!/bin/bash
echo "Starting Ambari Server..."
if [[ -n "$MYSQL_DB" ]]
then
	MYSQL_HOST=$MYSQL_DB
else
	MYSQL_HOST=`hostname -f`
fi

echo "Set MySQLDB server to" $MYSQL_HOST 

for i in $(seq 1 5); do
        nc -v -z -w 3 $MYSQL_HOST  3306
        if [[ $? == 0 ]]; then
                break
        fi
        sleep 5
done

mysql -u root -h $MYSQL_HOST --password=root < /root/bootStrapMySQLDB.sql
mysql -u ambari --password=bigdata -h $MYSQL_HOST ambari  < /var/lib/ambari-server/resources/Ambari-DDL-MySQL-CREATE.sql

ambari-server setup -j /usr --database=mysql --databasehost=$MYSQL_HOST --databaseport=3306 --databasename=ambari  --databaseusername=ambari --databasepassword=bigdata  --silent
rm -fr /var/log/hadoop  /var/run/hadoop
ambari-server setup --jdbc-db=mysql --jdbc-driver=/usr/share/java/mysql-connector-java.jar
ambari-server start
while [ true ];  do  sleep 5 ; done
