#!/bin/bash

. setEnv.sh

ldapdelete -x -D cn=Manager,$BASE_DN -w admin123  "uid=john,ou=People,$BASE_DN"
ldapdelete -x -D cn=Manager,$BASE_DN -w admin123  "uid=david,ou=People,$BASE_DN"
ldapdelete -x -D cn=Manager,$BASE_DN -w admin123  "cn=miners,ou=PosixGroups,$BASE_DN"
ldapdelete -x -D cn=Manager,$BASE_DN -w admin123  "cn=miners,ou=Groups,$BASE_DN"
ldapdelete -x -D cn=Manager,$BASE_DN -w admin123  "ou=PosixGroups,$BASE_DN"
ldapdelete -x -D cn=Manager,$BASE_DN -w admin123  "ou=Groups,$BASE_DN"



export JPWD=`slappasswd -s john`
export DPWD=`slappasswd -s david`

cat <<EOF >addusers.ldif 

dn: ou=Groups,$BASE_DN
objectClass: organizationalUnit
ou: Group

dn: ou=PosixGroups,$BASE_DN
objectClass: organizationalUnit
ou: Group

dn: cn=miners,ou=PosixGroups,$BASE_DN
objectClass: posixGroup
cn: miners
gidNumber: 5000


dn: uid=john,ou=People,$BASE_DN
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: shadowAccount
objectClass: organizationalPerson
objectClass: person
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
objectClass: organizationalPerson
objectClass: person
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

dn: cn=miners,ou=Groups,$BASE_DN
objectClass: top
objectClass: groupofnames
cn: miners
member: uid=john,ou=People,$BASE_DN
member: uid=david,ou=People,$BASE_DN

EOF

ldapadd -x -D cn=Manager,$BASE_DN -w admin123 -f addusers.ldif
