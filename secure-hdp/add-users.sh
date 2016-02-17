#!/bin/bash

. setEnv.sh

ldapdelete -x -D cn=Manager,$BASE_DN -w admin123  "uid=john,ou=People,$BASE_DN"
ldapdelete -x -D cn=Manager,$BASE_DN -w admin123  "uid=david,ou=People,$BASE_DN"
ldapdelete -x -D cn=Manager,$BASE_DN -w admin123  "cn=cokebiz,ou=PosixGroups,$BASE_DN"
ldapdelete -x -D cn=Manager,$BASE_DN -w admin123  "cn=cokebiz,ou=Groups,$BASE_DN"
ldapdelete -x -D cn=Manager,$BASE_DN -w admin123  "ou=PosixGroups,$BASE_DN"
ldapdelete -x -D cn=Manager,$BASE_DN -w admin123  "ou=Groups,$BASE_DN"



export JPWD=`slappasswd -s sds`
export DPWD=`slappasswd -s coke`

cat <<EOF >addusers.ldif 

dn: ou=Groups,$BASE_DN
objectClass: organizationalUnit
ou: Group

dn: ou=PosixGroups,$BASE_DN
objectClass: organizationalUnit
ou: Group

dn: cn=cokebiz,ou=PosixGroups,$BASE_DN
objectClass: posixGroup
cn: cokebiz
gidNumber: 5000
dn: cn=cokedev,ou=PosixGroups,$BASE_DN
objectClass: posixGroup
cn: cokedev
gidNumber: 5001
dn: cn=sdsbiz,ou=PosixGroups,$BASE_DN
objectClass: posixGroup
cn: sdsbiz
gidNumber: 5002
dn: cn=sdsdev,ou=PosixGroups,$BASE_DN
objectClass: posixGroup
cn: sdsdev
gidNumber: 5003


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
userPassword: $DPWD
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

dn: uid=jane,ou=People,$BASE_DN
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: shadowAccount
objectClass: organizationalPerson
objectClass: person
uid: jane
sn: Jane
givenName: Ann
cn: Jane Ann
displayName: Jane Ann
uidNumber: 10002
gidNumber: 5001
userPassword: $DPWD
gecos: Jane Ann
loginShell: /bin/bash
homeDirectory: /home/jane

dn: uid=lucy,ou=People,$BASE_DN
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: shadowAccount
objectClass: organizationalPerson
objectClass: person
uid: lucy
sn: Lucy
givenName: Morning
cn: Lucy Morning
displayName: Lucy Morning
uidNumber: 10003
gidNumber: 5001
userPassword: $DPWD
gecos: Lucy Morning
loginShell: /bin/bash
homeDirectory: /home/lucy


dn: uid=jkim,ou=People,$BASE_DN
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: shadowAccount
objectClass: organizationalPerson
objectClass: person
uid: jkim
sn: Kim
givenName: Jong Ho
cn: Jong Ho Kim
displayName: Jong Ho Kim
uidNumber: 10004
gidNumber: 5002
userPassword: $JPWD
gecos: Jong Ho Kim
loginShell: /bin/bash
homeDirectory: /home/jkim


dn: uid=jjung,ou=People,$BASE_DN
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: shadowAccount
objectClass: organizationalPerson
objectClass: person
uid: jjung
sn: Jung
givenName: Jaewoon
cn: Jaewoon Jung
displayName: Jaewoon Jung
uidNumber: 10005
gidNumber: 5002
userPassword: $JPWD
gecos: Jaewoon Jung
loginShell: /bin/bash
homeDirectory: /home/jjung


dn: uid=jpark,ou=People,$BASE_DN
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: shadowAccount
objectClass: organizationalPerson
objectClass: person
uid: jpark
sn: Park
givenName: Joseph
cn: Joseph Park
displayName: Joseph Park
uidNumber: 10006
gidNumber: 5003
userPassword: $JPWD
gecos: Jospeph Park
loginShell: /bin/bash
homeDirectory: /home/jpark


dn: uid=jjoo,ou=People,$BASE_DN
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: shadowAccount
objectClass: organizationalPerson
objectClass: person
uid: jjoo
sn: Joo
givenName: Jaemin
cn: Jaemin Joo
displayName: Jaemin Joo
uidNumber: 10007
gidNumber: 5003
userPassword: $JPWD
gecos: Jaemin Joo
loginShell: /bin/bash
homeDirectory: /home/jjoo

dn: cn=cokebiz,ou=Groups,$BASE_DN
objectClass: top
objectClass: groupofnames
cn: cokebiz
member: uid=john,ou=People,$BASE_DN
member: uid=david,ou=People,$BASE_DN
dn: cn=cokedev,ou=Groups,$BASE_DN
objectClass: top
objectClass: groupofnames
cn: cokedev
member: uid=jane,ou=People,$BASE_DN
member: uid=lucy,ou=People,$BASE_DN

dn: cn=sdsbiz,ou=Groups,$BASE_DN
objectClass: top
objectClass: groupofnames
cn: sdsbiz
member: uid=jkim,ou=People,$BASE_DN
member: uid=jjung,ou=People,$BASE_DN
dn: cn=sdsdev,ou=Groups,$BASE_DN
objectClass: top
objectClass: groupofnames
cn: sdsdev
member: uid=jpark,ou=People,$BASE_DN
member: uid=jjoo,ou=People,$BASE_DN

EOF

ldapadd -x -D cn=Manager,$BASE_DN -w admin123 -f addusers.ldif
