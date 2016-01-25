echo "Starting ..."
sudo docker build -f ldap.Dockerfile -t openldap:1 . 
sleep 3
sudo docker build -f krb5.Dockerfile -t  krb5:1 . 
sleep 3
sudo docker build -f postgres.Dockerfile -t  postgres:1 . 

