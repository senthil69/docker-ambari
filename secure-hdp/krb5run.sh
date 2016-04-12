#!/bin/bash

# All the environment variables listed in the file are defined in 
# setEenv.sh
. setEnv.sh

# Default parameters for krb5.conf . 
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

# Start the random number generator for better performance
echo -n "Starting random gen ..."
rngd -r /dev/random -o /dev/urandom
echo  "Done "


# This command sets up master password for LDAP DB 
# This command configures People subtree as kerberos principals
echo -n "Setting KRB5 master password ..."
kdb5_ldap_util -D  $ROOT_DN -w admin123 create -subtrees ou=People,$BASE_DN -r $KRB5_DOMAIN -P admin123 -s -H ldap://$HOST_FQDN
echo  "Done "


# Allow Kerberos Server to login into LDAP without interactive password 
echo -n "Setting KRB5 stach password ..."
kdb5_ldap_util -D $ROOT_DN -w admin123 stashsrvpw -f /var/kerberos/krb5kdc/service.keyfile -P admin123 $ROOT_DN
echo  "Done "

# Default ACL - admin/admin can perform any operation on KerberosDB
cat <<EOF > /var/kerberos/krb5kdc/kadm5.acl
*/admin@$KRB5_DOMAIN     *
EOF

# Config parameters for KDC 
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
 default_principal_flags = +renewable
 }

EOF


echo -n "Starting KRB5  ..."
. /etc/sysconfig/krb5kdc
/usr/sbin/krb5kdc -P /var/run/krb5kdc.pid $KRB5KDC_ARGS

. /etc/sysconfig/kadmin
/usr/sbin/_kadmind -P /var/run/kadmind.pid $KADMIND_ARGS
echo  "Done "


#Provision LDAP users as kerberos principals. Ex john -> john@SDS.COM
# where SDS.COM is the Kerberos domain name set earlier 
echo -n "Provisioning user id  ..."
kadmin.local -q 'addprinc -pw admin123 admin/admin'
kadmin.local -q "addprinc -x dn=uid=john,ou=People,$BASE_DN -pw coke john"
kadmin.local -q "addprinc -x dn=uid=david,ou=People,$BASE_DN -pw coke david"
kadmin.local -q "addprinc -x dn=uid=jane,ou=People,$BASE_DN -pw coke jane"
kadmin.local -q "addprinc -x dn=uid=lucy,ou=People,$BASE_DN -pw coke lucy"
kadmin.local -q "addprinc -x dn=uid=jkim,ou=People,$BASE_DN -pw sds jkim"
kadmin.local -q "addprinc -x dn=uid=jjung,ou=People,$BASE_DN -pw sds jjung"
kadmin.local -q "addprinc -x dn=uid=jpark,ou=People,$BASE_DN -pw sds jpark"
kadmin.local -q "addprinc -x dn=uid=jjoo,ou=People,$BASE_DN -pw sds jjoo"
kadmin.local -q "addprinc -x dn=uid=keyadmin2,ou=People,$BASE_DN -pw keyadmin2 keyadmin2"
echo  "Done "

/bin/bash
