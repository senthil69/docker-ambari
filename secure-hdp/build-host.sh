
#!/bin/bash

sudo cp ambari.repo /etc/yum.repos.d/
sudo yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel ambari-server ambari-agent postgresql-jdbc krb5-workstation nss-pam-ldapd openldap-clients  
