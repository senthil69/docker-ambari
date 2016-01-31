#!/bin/bash

. setEnv.sh

echo -n "uploading blueprint..."
curl -H "X-Requested-By: ambari" -X POST -d  @hdfs-bp.json  -u admin:admin http://$HOST_FQDN:8888/api/v1/blueprints/b1
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


curl -H "X-Requested-By: ambari" -X POST -d @/tmp/x  -u admin:admin http://$HOST_FQDN:8888/api/v1/clusters/c1
