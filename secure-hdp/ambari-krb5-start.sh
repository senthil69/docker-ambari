. setEnv.sh

set -x 

cat <<EOF > /tmp/krb5.enable.json

{
  "session_attributes" : {
    "kerberos_admin" : {
      "principal" : "admin/admin",
      "password" : "admin123"
    }
  },
  "Clusters": {
    "security_type" : "KERBEROS"
  }
}

EOF


cat << EOF

# Stop all services
#curl -H "X-Requested-By:ambari" -u admin:admin -i -X PUT -d '{"RequestInfo": {"context":"Stop Cluster via REST" },"ServiceInfo": {"state" : "INSTALLED"}}' http://$HOST_FQDN:8080/api/v1/clusters/c1/services
# Enable Kerberos
#curl -H "X-Requested-By:ambari" -u admin:admin -i -X PUT -d @/tmp/krb5.enable.json http://$HOST_FQDN:8080/api/v1/clusters/c1
# Restart cluster
#curl -H "X-Requested-By:ambari" -u admin:admin -i -X PUT -d '{"RequestInfo":{"context":"Start Cluster via REST"},"ServiceInfo": {"state" : "STARTED"}}' http://$HOST_FQDN:8080/api/v1/clusters/c1/services

EOF
# you can customize the default config if required - We are not doing it now
#curl -H "X-Requested-By:ambari" -u admin:admin -i -X GET http://$HOST_FQDN:8080/api/v1/stacks/HDP/versions/2.3/artifacts/kerberos_descriptor > /tmp/kerb.txt
#curl -H "X-Requested-By:ambari" -u admin:admin -i -X GET http://$HOST_FQDN:8080/api/v1/clusters/c1/artifacts/kerberos_descriptor > /tmp/kerb2.txt
#curl -H "X-Requested-By:ambari" -u admin:admin -i -X PUT -d @/tmp/kerb.txt http://$HOST_FQDN:8080/api/v1/clusters/c1/artifacts/kerberos_descriptor

#curl -H "X-Requested-By:ambari" -u admin:admin -i -X POST -d @/tmp/kerb.txt http://$HOST_FQDN:8080/api/v1/clusters/c1/artifacts/kerberos_descriptor


