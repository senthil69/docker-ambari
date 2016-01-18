#sudo docker build -f oltp.Dockerfile -t oltp-bench:1 .
sudo docker build -f ldap.Dockerfile -t  openldap:1 . 
sudo docker build -f krb5.Dockerfile -t  krb5:1 . 
sudo docker build -f postgres.Dockerfile -t  postgres:1 . 

