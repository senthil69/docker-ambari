
. setEnv.sh
cat <<EOF > services-hdp.ldif


# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# see http://tools.ietf.org/html/rfc4519#page-21
# see http://oav.net/mirrors/LDAP-ObjectClasses.html
# look for applicationProcess
version: 1

# entry for a sample services container
# please replace with site specific values

dn: cn=rangerhdfslookup,ou=services,$BASE_DN
objectclass:top
objectclass: applicationProcess
objectclass:simpleSecurityObject
cn: rangerhdfslookup
userPassword:rangerhdfslookup


dn: cn=rangerhdfslookup,ou=groups,$BASE_DN
objectclass:top
objectclass: groupofnames
cn: rangerhdfslookup
member: cn=rangerhdfslookup,ou=services,$BASE_DN


EOF

ldapadd -x -D cn=Manager,$BASE_DN -w admin123 -f services-hdp.ldif

