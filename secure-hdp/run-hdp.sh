#!/bin/bash

. setEnv.sh

echo -n "Enabling LDAP"
sudo authconfig  --enableldap --ldapserver=$HOST_FQDN  --ldapbasedn="$BASE_DN" --update
echo  "Done"
echo -n "Restarting Ambari-agent ..."
sudo ambari-agent restart 
echo "Done"
echo -n "uploading blueprint..."
#while IFS='' read -r line || [[ -n "$line" ]]; do      eval echo  $line; done < "./c1b1-min.json" > /tmp/c1b1-min.json
curl -H "X-Requested-By: ambari" -X POST -d  @./c1b1-hive.json  -u admin:admin http://$HOST_FQDN:8080/api/v1/blueprints/b1
echo -n "done"
cat <<EOF > /tmp/x 

{
  "blueprint" : "b1",
  "default_password" : "my-super-secret-password",
  "host_groups" :[
    {
      "name" : "host_group_1", 
      "hosts" : [         
        {
          "fqdn" : "$HOST_FQDN"
        }
      ]
    }
  ]
}
EOF


curl -H "X-Requested-By: ambari" -X POST -d @/tmp/x  -u admin:admin http://$HOST_FQDN:8080/api/v1/clusters/c1
