#!/bin/bash
echo "Starting Ambari Server..."
if [[ -n "$POSTGRES" ]]
then
	POSTGRES_HOST=$POSTGRES
else
	POSTGRES_HOST=localhost
fi

echo "Set PostgresDB server to" $POSTGRES 

for i in $(seq 1 5); do
        nc -v -z -w 3 $POSTGRES_HOST 5432
        if [[ $? == 0 ]]; then
                break
        fi
        sleep 5
done

psql -U postgres -h $POSTGRES_HOST < /root/bootStrapDB.sql
psql -U ambari -h $POSTGRES_HOST < /var/lib/ambari-server/resources/Ambari-DDL-Postgres-CREATE.sql

ambari-server setup -j /usr --database=postgres  --databasehost=$POSTGRES_HOST --databaseport=5432 --databasename=ambari  --postgresschema=ambarischema --databaseusername=ambari --databasepassword=bigdata  --silent
rm -fr /var/log/hadoop  /var/run/hadoop
ambari-server start
while [ true ];  do  sleep 5 ; done
