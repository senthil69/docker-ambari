#!/bin/bash

. setEnv.sh 
sudo cp ambari.repo /etc/yum.repos.d/
sudo yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel ambari-server ambari-agent postgresql-jdbc krb5-workstation nss-pam-ldapd openldap-clients  

cat <<EOF | sudo tee /etc/krb5.conf
[logging]
 default = FILE:/var/log/krb5libs.log
 kdc = FILE:/var/log/krb5kdc.log
 admin_server = FILE:/var/log/kadmind.log

[libdefaults]
 dns_lookup_realm = false
 ticket_lifetime = 24h
 renew_lifetime = 7d
 forwardable = true
 rdns = false
 default_realm = $KRB5_DOMAIN
#default_ccache_name = KEYRING:persistent:%{uid}

[realms]
 $KRB5_DOMAIN = {
  kdc = $HOST_KRB5
  admin_server = $HOST_KRB5
  default_domain = $HOST_DOMAIN
 }

[domain_realm]
 .$HOST_DOMAIN = $KRB5_DOMAIN
 $HOST_DOMAIN = $KRB5_DOMAIN


EOF

