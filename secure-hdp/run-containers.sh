#!/bin/bash

CMD="sudo docker run --net=host --privileged=true "

$CMD --name=ldap -d openldap:1
sleep 1
$CMD --name=db   -d postgres:1
sleep 1
$CMD --name=krb5 -d  krb5:1
sleep 1
$CMD --name=ambaris -ti  ambaris:1


