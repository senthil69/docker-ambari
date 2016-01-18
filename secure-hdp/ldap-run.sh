#!/bin/bash

. setEnv.sh

cp /usr/share/openldap-servers/DB_CONFIG.example /var/lib/ldap/DB_CONFIG
chown ldap. /var/lib/ldap/DB_CONFIG
source /etc/sysconfig/slapd
/usr/sbin/slapd -u ldap -h "${SLAPD_URLS}" $SLAPD_OPTIONS


export ROOT_PWD=`slappasswd -s admin123`
cat <<EOF >chrootpw.ldif
dn: olcDatabase={0}config,cn=config
changetype: modify
add: olcRootPW
olcRootPW: $ROOT_PWD

EOF
ldapadd -Y EXTERNAL -H ldapi:/// -f chrootpw.ldif

cat <<EOF >chdomain.ldif

dn: olcDatabase={2}hdb,cn=config
changetype: modify
replace: olcSuffix
olcSuffix: $BASE_DN

dn: olcDatabase={2}hdb,cn=config
changetype: modify
replace: olcRootDN
olcRootDN: $ROOT_DN

dn: olcDatabase={2}hdb,cn=config
changetype: modify
add: olcRootPW
olcRootPW: $ROOT_PWD

EOF

ldapmodify -Y EXTERNAL -H ldapi:/// -f chdomain.ldif



ldapsearch -Q -LLL -Y EXTERNAL -H ldapi:/// -b cn=schema,cn=config dn

cp /usr/share/doc/krb5-server-ldap-1.13.2/kerberos.schema /etc/openldap/schema/

cat <<EOF > /tmp/schema_convert.config
include /etc/openldap/schema/core.schema
include /etc/openldap/schema/collective.schema
include /etc/openldap/schema/corba.schema
include /etc/openldap/schema/cosine.schema
include /etc/openldap/schema/duaconf.schema
include /etc/openldap/schema/dyngroup.schema
include /etc/openldap/schema/inetorgperson.schema
include /etc/openldap/schema/java.schema
include /etc/openldap/schema/misc.schema
include /etc/openldap/schema/nis.schema
include /etc/openldap/schema/openldap.schema
include /etc/openldap/schema/ppolicy.schema
include /etc/openldap/schema/kerberos.schema
EOF

mkdir /tmp/ldif_output

slapcat -f /tmp/schema_convert.config -F /tmp/ldif_output -n0 -s "cn={12}kerberos,cn=schema,cn=config" > /tmp/cn=kerberos.ldif

sed -i  -e  's/{12}kerberos/kerberos/g' /tmp/cn\=kerberos.ldif 
sed -i   '160,167d' /tmp/cn\=kerberos.ldif 
cp /tmp/cn\=kerberos.ldif /etc/openldap/schema/kerberos.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/cosine.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/nis.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/inetorgperson.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/kerberos.ldif

ldapsearch -Q -LLL -Y EXTERNAL -H ldapi:/// -b  cn=schema,cn=config dn

cat <<EOF >logging.ldif

dn: cn=config
changetype: modify
replace: olcLogLevel
olcLogLevel: stats

EOF

ldapmodify -Q -Y EXTERNAL -H ldapi:/// -f logging.ldif

# NO ACLS Defined
ldapsearch -Q -LLL -Y EXTERNAL -H ldapi:/// -b cn=config '(olcDatabase={1}hdb)' olcAccess

cat <<EOF >chmod.ldif

dn: olcDatabase={2}hdb,cn=config
changetype: modify
add: olcAccess
olcAccess: {0}to attrs=userPassword,shadowLastChange,krbPrincipalKey by dn="$ROOT_DN" write by anonymous auth by self write by * none
olcAccess: {1}to dn.base="" by * read
olcAccess: {2}to * by dn="$ROOT_DN" write by * read

dn: olcDatabase={1}monitor,cn=config
changetype: modify
replace: olcAccess
olcAccess: {0}to * by dn.base="gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth" read by dn.base="$ROOT_DN" read by * none

EOF

ldapmodify -Y EXTERNAL -H ldapi:/// -f chmod.ldif

export JPWD=`slappasswd -s john`
export DPWD=`slappasswd -s david`

cat <<EOF  >basedomain.ldif
dn: $BASE_DN
objectClass: top
objectClass: dcObject
objectclass: organization
o: Server World

dn: $ROOT_DN
objectClass: organizationalRole
cn: Manager
description: Directory Manager

dn: ou=People,$BASE_DN
objectClass: organizationalUnit
ou: People

dn: ou=Groups,$BASE_DN
objectClass: organizationalUnit
ou: Group

dn: cn=miners,ou=Groups,$BASE_DN
objectClass: posixGroup
cn: miners
gidNumber: 5000

dn: uid=john,ou=People,$BASE_DN
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: shadowAccount
uid: john
sn: Doe
givenName: John
cn: John Doe
displayName: John Doe
uidNumber: 10000
gidNumber: 5000
userPassword: $JPWD
gecos: John Doe
loginShell: /bin/bash
homeDirectory: /home/john

dn: uid=david,ou=People,$BASE_DN
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: shadowAccount
uid: david
sn: David
givenName: David
cn: David Kim
displayName: David Kim
uidNumber: 10001
gidNumber: 5000
userPassword: $DPWD
gecos: David Kim
loginShell: /bin/bash
homeDirectory: /home/david

EOF

ldapadd -x -D  $ROOT_DN  -w admin123 -f basedomain.ldif


ldapsearch -Q -LLL -Y EXTERNAL -H ldapi:/// -b  cn=schema,cn=config dn




cat <<EOF > krb5.ldif

dn: cn=krb5,$BASE_DN
objectClass: krbContainer
cn: krb5

EOF

ldapadd -x -D $ROOT_DN -w admin123 -f krb5.ldif


/bin/bash
