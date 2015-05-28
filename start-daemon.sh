#!/bin/sh
if [[ -z "$AMBARI_SERVER" ]] then 
sed -i "s/^hostname=localhost/hostname=$AMBARI_SERVER/" /etc/ambari-agent/conf/ambari-agent.ini
fi
ambari-server start
ambari-agent start
/bin/bash
