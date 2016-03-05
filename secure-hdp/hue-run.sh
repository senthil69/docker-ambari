#!/bin/bash
source /root/setEnv.sh

cd /root/hue-3.8.1
make install
chown -R hue /usr/local/hue

cat <<EOF | tee /etc/krb5.conf
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
cp /root/hue.ini /usr/local/hue/desktop/conf/hue.ini 
mkdir -p /etc/security/keytabs
kadmin -w admin123 -p admin/admin -q addprinc -randkey hue
kadmin -w admin123 -p admin/admin -q 'addprinc -randkey hue'
kadmin -w admin123 -p admin/admin -q 'modprinc -maxrenewlife 7days hue'
kadmin -w admin123 -p admin/admin -q 'modprinc -maxrenewlife 7days krbtgt/SDS.COM'
kadmin -w admin123 -p admin/admin -q 'ktadd -k /etc/security/keytabs/hue.keytab hue'
chown hue /etc/security/keytabs/hue.keytab hue
/bin/bash
