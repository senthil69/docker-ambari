#!/bin/bash
. /setEnv.sh

for i in $(seq 1 5); do
        nc -z -v -w 1 $HOST_FQDN 5432
        if [[ $? == 0 ]]; then
                break
        fi
        sleep 5
done

cat <<EOF | tee /etc/krb5.conf
[logging]
 default = FILE:/var/log/krb5libs.log
 kdc = FILE:/var/log/krb5kdc.log
 admin_server = FILE:/var/log/kadmind.log

[libdefaults]
 dns_lookup_realm = false
 ticket_lifetime = 24h
 renew_lifetime = 7d
 forwardable = true
 rdns = false
 default_realm = $KRB5_DOMAIN
#default_ccache_name = KEYRING:persistent:%{uid}

[realms]
 $KRB5_DOMAIN = {
  kdc = $HOST_KRB5
  admin_server = $HOST_KRB5
  default_domain = $HOST_DOMAIN
 }

[domain_realm]
 .$HOST_DOMAIN = $KRB5_DOMAIN
 $HOST_DOMAIN = $KRB5_DOMAIN


EOF


ambari-server setup -s  --database=postgres --databasehost=$HOST_FQDN --databaseport=5432  --databasename=ambari --postgresschema=ambari --databaseusername=ambari --databasepassword=bigdata --java-home=/usr/lib/jvm/java
export PGPASSWORD=bigdata
psql -h $HOST_FQDN  -U ambari  ambari < /var/lib/ambari-server/resources/Ambari-DDL-Postgres-CREATE.sql
echo "DB Update complete"
ambari-server start
echo "Ambari server started ...."
while [ true ];  do  sleep 5 ; done
