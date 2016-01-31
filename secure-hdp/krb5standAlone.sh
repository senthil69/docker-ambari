#!/bin/bash

. setEnv.sh

cat <<EOF > /etc/krb5.conf

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
  kdc = $HOST_FQDN
  admin_server = $HOST_FQDN
  default_domain = $HOST_DOMAIN
 }
 
[domain_realm]
 .$HOST_DOMAIN = $KRB5_DOMAIN
 $HOST_DOMAIN = $KRB5_DOMAIN
 

EOF

echo -n "Starting random gen ..."
rngd -r /dev/random -o /dev/urandom
echo  "Done "


echo -n "Setting KRB5 master password ..."
kdb5_util  -r $KRB5_DOMAIN -P admin123 create -s 
echo  "Done "



cat <<EOF > /var/kerberos/krb5kdc/kadm5.acl
*/admin@$KRB5_DOMAIN     *
EOF

cat <<EOF > /var/kerberos/krb5kdc/kdc.conf
[kdcdefaults]
 kdc_ports = 88
 kdc_tcp_ports = 88

[realms]
 $KRB5_DOMAIN = {
  #master_key_type = aes256-cts
  acl_file = /var/kerberos/krb5kdc/kadm5.acl
  dict_file = /usr/share/dict/words
  admin_keytab = /var/kerberos/krb5kdc/kadm5.keytab
  supported_enctypes = aes256-cts:normal aes128-cts:normal des3-hmac-sha1:normal arcfour-hmac:normal camellia256-cts:normal camellia128-cts:normal des-hmac-sha1:normal des-cbc-md5:normal des-cbc-crc:normal
 }

EOF


echo -n "Starting KRB5  ..."
. /etc/sysconfig/krb5kdc
/usr/sbin/krb5kdc -P /var/run/krb5kdc.pid $KRB5KDC_ARGS

. /etc/sysconfig/kadmin
/usr/sbin/_kadmind -P /var/run/kadmind.pid $KADMIND_ARGS
echo  "Done "

echo -n "Provisioning user id  ..."
kadmin.local -q 'addprinc -pw admin123 admin/admin'
kadmin.local -q "addprinc -pw david david"
echo  "Done "

while [ true ];  do  sleep 5 ; done

