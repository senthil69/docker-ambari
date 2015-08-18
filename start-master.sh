#!/bin/bash
echo "Starting Ambari Server..."
rm -fr /var/log/hadoop  /var/run/hadoop
ambari-server start
/bin/bash
