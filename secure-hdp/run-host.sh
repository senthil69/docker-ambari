
. setEnv.sh

sudo ambari-server setup -s  --database=postgres --databasehost=$HOST_FQDN --databaseport=5432  --databasename=ambari --postgresschema=ambari --databaseusername=ambari --databasepassword=bigdata --java-home=/usr/lib/jvm/java

psql -h $HOST_FQDN -U ambari ambari < /var/lib/ambari-server/resources/Ambari-DDL-Postgres-CREATE.sql

sudo ambari-server start

sudo ambari-agent restart 

