#!/bin/bash

. setEnv.sh


sudo docker build -f hue.Dockerfile -t hue:1 .
sleep 3
TMPDIR=/tmp/hue-run
rm -fr  $TMPDIR
mkdir -p $TMPDIR
cp /etc/hadoop/conf/hdfs-site.xml $TMPDIR
cp /etc/hadoop/conf/core-site.xml $TMPDIR
cp /etc/hive/conf/hive-site.xml $TMPDIR
cp hue-run.Dockerfile $TMPDIR
cp hue-run.Dockerfile $TMPDIR
cp hue-run.sh  $TMPDIR
sed  "s/HOST_FQDN/$HOST_FQDN/g" hue.ini > $TMPDIR/hue.ini
sudo docker build -f $TMPDIR/hue-run.Dockerfile -t hue-run:2 $TMPDIR 
sudo docker run -ti --name=hue --privileged=true --net=host  hue-run:2 
