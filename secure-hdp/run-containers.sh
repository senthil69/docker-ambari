#!/bin/bash

CMD="sudo docker run --net=host --privileged=true "

screen -t ldap $CMD --name=ldap -ti openldap:1
sleep 1
screen -t postgres $CMD --name=db   -ti postgres:1
sleep 1
screen -t krb5 $CMD --name=krb5 -ti  krb5:1
sleep 1
screen -t ambari $CMD --name=ambaris -ti  ambaris:1
sleep 1
screen -t hue $CMD --name=hue -ti  hue:1
