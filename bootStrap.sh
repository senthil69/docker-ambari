#!/bin/bash
echo "Configuring Ambari DB"
psql -U postgres -h localhost < /root/bootStrapDB.sql
psql -U ambari -h localhost < /root/Ambari-DDL-Postgres-CREATE.sql
echo "Sure...."
