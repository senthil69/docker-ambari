#!/bin/bash
if [[ -n "$AMBARI_MASTER" ]]
then 
	echo "Modifying AMBARI_MASTER in ambari-agent.conf"
	sed -i "s/^hostname=localhost/hostname=$AMBARI_MASTER/" /etc/ambari-agent/conf/ambari-agent.ini
fi
rm -fr /var/log/hadoop  /var/run/hadoop
ambari-agent start
/bin/bash
