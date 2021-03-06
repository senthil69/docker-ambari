#Secure Hadoop Cluster using Docker (Quick Start Guide)

## Introduction

Securing Hadoop cluster using Kerberos is often cumbersome and error prone. This procedure 
automates building basic security infrastructure to setup secure hadoop cluster. In this setup, we will setup 
Kerberos Server for authentication, LDAP server for storing user credentials and postgre SQL DB. The PostgreSQL db 
is a common database used by Ambari server, WebHCat server , Ranger and Oozie. 

## Pre-requisites

1. OS: Centos 7.1 (64-bit) or RHEL 7.1 
2. Root Partition space : 16GB or above
3. Main Memory : 16GB or above 
4. Each host must have fully qualified domain name. Run the command domainname to verify. 
If the command returns empty or invalid value , you must fix it before continuing your setup. 

## Approach 

In this process, we will follow these steps 

1. Build docker images 
2. Run the docker images 
3. Prepare hosts for Hadoop setup
4. Setup Hadoop and make it secure

## Build docker images

 The configuration parameters required for cluster is built into the docker 
images. Hence you need to modify the file setupEnv.sh with your settings before building docker images. 
The following table describes the configuration parameters for the cluster setup. 

| Name | Default value | Comments |
| --- | --- | --- |
| BASE_DN | dc=sds,dc=com | base distinguished name in openLDAP. All entries in LDAP such as user,group will be a child node of BASE DN |
| ROOT_DN | cn=Manager,dc=sds,dc=com | Superuser of openLDAP. We will use this principal to make changes to LDAP DB configuration. |
| KRB5_DOMAIN | SDS.COM | Domain for Kerberos. All principals will be referred with this domain suffix ex john@SDS.COM |
| HOST_DOMAIN | us-west-2.compute.internal | Default domain of the host. The default is set for AWS EC2. You need to change to appropriate value |


### Checklist 

* Modify the setEnv.sh and run `source setEnv.sh`. Then run  `echo $HOST_FQDN`.
The result must show the hostname with domain name 


| Docker File Name | Purpose |
| --- | --- |
| ldap.Dockerfile | Installs openldap packages on CentOS 7 |
| krb5.Dockerfile | Installs Kerberos server on CentOS 7 |
| postgres.Dockerfile | Installs PostgreSQL DB and sets the root password as postgres | 
| ambari-server.Dockerfile | Installs Ambari server, kerberos clients  | 

### Setup 

* Setup Docker on Centos7 using https://docs.docker.com/engine/installation/linux/centos/
* Run `chmod +x *.sh` . Ensure all the scripts have permission to execute. 
* Run `sudo systemctl status docker` - Ensure docker process is running.
 
The instructions to build the docker images are in script `build.sh`. 
You may run the script and create docker images

* Run `docker images` and ensure docker images for openldap, krb5, ambari-server is built successfully. 

## Run Docker Images 

The instructions to run all docker images are given in script `run-containers.sh`. 
The containers are launched using utility  screen - It helps us to interact with containers using single terminal. 
Here is the basic tutorial about GNU Screen http://www.kuro5hin.org/story/2004/3/9/16838/14935 and
https://www.gnu.org/software/screen/manual/screen.html . 
If the user is not comfortable with screen, they can always launch four independent terminals and run the container

Run  

`sudo docker run --net=host --privileged=true  --name=ldap -ti openldap:1`

`sudo docker run --net=host --privileged=true   --name=db   -ti postgres:1`

`sudo docker run --net=host --privileged=true   --name=krb5 -ti  krb5:1`

`sudo docker run --net=host --privileged=true   --name=ambaris -ti  ambaris:1`

The Kerberos container with name krb5 requires admin password for setup. You need to enter the password as `admin123`. 
For this setup, the password is hardcoded to admin123. In future , we can make it configurable. 

### Checklist 

* Run  `sudo docker ps` in the host - Ensure all four containers are running. 
* Goto `ldap` container and run `ldapsearch -Q -LLL -Y EXTERNAL -H ldapi:/// -b ou=People,dc=sds,dc=com dn`  
ensure that all users are listed 
* Goto `krb5` container terminal and run 

`kadmin -p admin/admin` 

Enter `admin123` as password and you should be login into kerberos. 

## Prepare the hosts for Hadoop setup 

The host must be prepared to run Hadoop cluster by running the script 

`build-host.sh`

The script installs Ambari agent , JDK and kerberos client which is necessary to talk to Kerberos Server. 
Ensure that `/etc/ambari-agent/conf/ambari-agent.ini` configuration file refers to correct ambari-server hostname. If you are installing ambari-server container and ambari-agent 
on same host, there is no config changes necessary. 


## Setup Hadoop and make it secure

Run 

`run-hdp.sh` 

This scripts setup single node hadoop cluster with Hive. 

### Checklist 

Access the Ambari console using `http://$HOST_FQDN:8080`  where HOST_FQDN is the hostname of Ambari server container. 

Default user id and password is admin/admin`

Upon successful login, you should be able to view all the components installed. 

Document to enable Kerberos in HDP is given [here](
https://docs.hortonworks.com/HDPDocuments/Ambari-2.2.0.0/bk_Ambari_Security_Guide/content/ch_amb_sec_guide.html)

Documentation to install Ranger using Ambari is given [here](
https://docs.hortonworks.com/HDPDocuments/HDP2/HDP-2.3.2/bk_Ranger_Install_Guide/content/ch_overview_ranger_ambari_install.html)



