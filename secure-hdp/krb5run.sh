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
  database_module = openldap_ldapconf
 }
 
[domain_realm]
 .$HOST_DOMAIN = $KRB5_DOMAIN
 $HOST_DOMAIN = $KRB5_DOMAIN
 
[dbdefaults]
 ldap_kerberos_container_dn = cn=krb5,$BASE_DN

[dbmodules]
 openldap_ldapconf = {
  db_library = kldap
  ldap_kdc_dn = "$ROOT_DN"

  # this object needs to have read rights on
  # the realm container, principal container and realm sub-trees
  ldap_kadmind_dn = "$ROOT_DN"

  # this object needs to have read and write rights on
  # the realm container, principal container and realm sub-trees
  ldap_service_password_file = /var/kerberos/krb5kdc/service.keyfile
  ldap_servers = ldap://$HOST_FQDN
  ldap_conns_per_server = 5
  }

EOF

rngd -r /dev/random -o /dev/urandom

kdb5_ldap_util -D  $ROOT_DN -w admin123 create -subtrees ou=People,$BASE_DN -r $KRB5_DOMAIN -P admin123 -s -H ldap://$HOST_FQDN

kdb5_ldap_util -D $ROOT_DN -w admin123 stashsrvpw -f /var/kerberos/krb5kdc/service.keyfile -P admin123 $ROOT_DN

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


. /etc/sysconfig/krb5kdc
/usr/sbin/krb5kdc -P /var/run/krb5kdc.pid $KRB5KDC_ARGS

. /etc/sysconfig/kadmin
/usr/sbin/_kadmind -P /var/run/kadmind.pid $KADMIND_ARGS

kadmin.local -q 'addprinc -pw admin123 admin/admin'
kadmin.local -q "addprinc -x dn=uid=david,ou=People,dc=us-west-2,dc=compute,dc=internal -pw david david"
/bin/bash
