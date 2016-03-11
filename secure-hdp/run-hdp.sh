#!/bin/bash

. setEnv.sh
# Enable LDAP as user credential store in addition to /etc/passwd
# Still we have not enabled LDAP authentication on the hadoop node 
echo -n "Enabling LDAP"
sudo authconfig  --enableldap --ldapserver=$HOST_FQDN  --ldapbasedn="$BASE_DN" --update
echo  "Done"

# Ensure that Ambari-agent is running before configuring 
echo -n "Restarting Ambari-agent ..."
sudo ambari-agent restart 
echo "Done"


# The following blueprint installs single node Hadoop cluster with Hive
# if YOu desire to install manually, you can login into Ambari server console
# with default admin/admin credentials and configure the cluster. 
# The default cluster does not have kerberos or ranger installed. 
echo -n "uploading blueprint..."
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
