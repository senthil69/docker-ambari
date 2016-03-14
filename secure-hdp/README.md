#Secure Hadoop Cluster using Docker

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

| Name  |  Default value | Comments |
| BASE_DN | dc=sds,dc=com | base distinguished name in openLDAP. All entries in LDAP such as user,group will be a child node of BASE DN |
| ROOT_DN | cn=Manager,dc=sds,dc=com | Superuser of openLDAP. We will use this principal to make changes to LDAP DB configuration |
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

 On terminal 1 
 


