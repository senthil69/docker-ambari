#!/bin/bash

. setEnv.sh

# Set the default parameters for LDAP DB configuration 
# Openldap uses HDB as default DB
cp /usr/share/openldap-servers/DB_CONFIG.example /var/lib/ldap/DB_CONFIG
chown ldap. /var/lib/ldap/DB_CONFIG

# Start the LDAP Daemon (This instruction is applicable if you 
# are running LDAP in container
source /etc/sysconfig/slapd
/usr/sbin/slapd -u ldap -h "${SLAPD_URLS}" $SLAPD_OPTIONS

# On baremetal or VM Run
# systemctl enable slapd
# systemctl start slapd

# Set the Root password for the LDAP DB 
# Use this password to perform DB related operations 
# such as logging , indexing etc. 
export ROOT_PWD=`slappasswd -s admin123`
cat <<EOF >chrootpw.ldif
dn: olcDatabase={0}config,cn=config
changetype: modify
add: olcRootPW
olcRootPW: $ROOT_PWD

EOF
ldapadd -Y EXTERNAL -H ldapi:/// -f chrootpw.ldif



# set the Base DN for this DB. It is set to dc=sds,dc=com by default 
# RootDN denotes super user for this DB cn=Manager,dc=sds,dc=com
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


# Dump the Kerberos Schema in LDIF format and import into the DB
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

# Convert kerberos.schema into LDIF format and import into schema
slapcat -f /tmp/schema_convert.config -F /tmp/ldif_output -n0 -s "cn={12}kerberos,cn=schema,cn=config" > /tmp/cn=kerberos.ldif
sed -i  -e  's/{12}kerberos/kerberos/g' /tmp/cn\=kerberos.ldif 
sed -i   '160,167d' /tmp/cn\=kerberos.ldif 
cp /tmp/cn\=kerberos.ldif /etc/openldap/schema/kerberos.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/cosine.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/nis.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/inetorgperson.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/kerberos.ldif

# Use this command to verify that the schmea is loaded succesfully
ldapsearch -Q -LLL -Y EXTERNAL -H ldapi:/// -b  cn=schema,cn=config dn


# Enable memberof Plugin needed by Ranger. 
# Ensure that you have plugin binary at /usr/lib64/openldap/memberof.la
# Change the olcModulePath if required 
cat > memberof.ldif <<EOT 
dn: cn=module,cn=config
cn: module
objectClass: olcModuleList
objectClass: top
olcModulePath: /usr/lib64/openldap
olcModuleLoad: memberof.la

dn: olcOverlay={0}memberof,olcDatabase={2}hdb,cn=config
objectClass: olcConfig
objectClass: olcMemberOf
objectClass: olcOverlayConfig
objectClass: top
olcOverlay: memberof

EOT
ldapadd -Y EXTERNAL -H ldapi:/// -f  memberof.ldif

# Similarly Enable Referencial integrity plugin
cat > refint.ldif <<EOT
dn: cn=module,cn=config
cn: module
objectclass: olcModuleList
objectclass: top
olcmoduleload: refint.la
olcmodulepath: /usr/lib64/openldap

dn: olcOverlay={1}refint,olcDatabase={2}hdb,cn=config
objectClass: olcConfig
objectClass: olcOverlayConfig
objectClass: olcRefintConfig
objectClass: top
olcOverlay: {1}refint
olcRefintAttribute: memberof member manager owner

EOT
ldapadd -Y EXTERNAL -H ldapi:/// -f  refint.ldif


# Enable logging. Use journalctl command to view the logs 
cat <<EOF >logging.ldif

dn: cn=config
changetype: modify
replace: olcLogLevel
olcLogLevel: stats

EOF

ldapmodify -Q -Y EXTERNAL -H ldapi:/// -f logging.ldif

# Use this command to check the list of ACLs defined on the DB.
# It should not list any ACLs  
ldapsearch -Q -LLL -Y EXTERNAL -H ldapi:/// -b cn=config '(olcDatabase={1}hdb)' olcAccess


# Define basic ACL
# The syntax is cryptic. Read http://www.openldap.org/doc/admin24/access-control.html 
# for more details
# Super user has privilage to change the password , individual user 
# as privilege to change their own password 
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

# Define top level objects such as People and Groups
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

dn: ou=PosixGroups,$BASE_DN
objectClass: organizationalUnit
ou: Group

EOF

ldapadd -x -D  $ROOT_DN  -w admin123 -f basedomain.ldif


#ldapsearch -Q -LLL -Y EXTERNAL -H ldapi:/// -b  cn=schema,cn=config dn

# The script contains list of users to be added and their group association
# Feel free to change the users to suit your testing environment 
/add-users.sh


# Hadoop uses keytabs for system level services. The keytabs are not LDAP users
# Hence it is stored under different container as shown below. 

cat <<EOF > krb5.ldif

dn: cn=krb5,$BASE_DN
objectClass: krbContainer
cn: krb5

EOF

ldapadd -x -D $ROOT_DN -w admin123 -f krb5.ldif


# Bash entry point for LDAP container - Not required if you are setting up
# the ldap on VM or baremetal server
/bin/bash
#while [ true ];  do  sleep 5 ; done

