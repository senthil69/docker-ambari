# Ambari on Docker


## Install Docker

Follow the description at the docker [getting started](https://www.docker.io/gettingstarted/#h_installation)

**Note:** If you are using `boot2docker` make sure you forward all ports from docker:
http://docs.docker.io/en/latest/installation/mac/#forwarding-vm-port-range-to-host

## Setup SSH Keys
Ambari requires SSH keys to setup Hadoop in each container. After the seutp, you may also want to login 
into the container to check what is going on. Hence generate ssh keys using 

...
ssh-keygen 
Generating public/private rsa key pair.
Enter file in which to save the key (/home/devisenthil/.ssh/id_rsa): ./id_rsa
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in ./id_rsa.
Your public key has been saved in ./id_rsa.pub.
The key fingerprint is:
...

Leave password empty. The private and public keys are generated in current directory. 
After generating the private/public key, you can build using

...
 sudo docker build -t ambari:test .
...

## Starting the container

This will start (and download if you never used it before) an image based on
centos-6 with preinstalled Ambari 2.0.0 ready to install HDP 2.2.

```
sudo docker run --privileged -h amb.aws.com -t -i -p 8080:8080  -p 2222:22 -v /mnt/d2:/d2 ambari:test /bin/bash

```

The explanation of the parameters:

- **-t -i** : interactive mode to start ambari-server
- **-p**: expose ssh and Ambari WebUI ports defined in the Dockerfile
- **-h amb0.mycorp.kom**: sets the hostname

## Cluster deployment via blueprint

Once the container is running, you can deploy a cluster. Instead of going to
the webui, we can use ambari-shell, which can interact with ambari via cli,
or perform automated provisioning. We will use the automated way, and of
course there is a docker image, with prepared ambari-shell in it:

```
docker run -e BLUEPRINT=single-node-hdfs-yarn --link amb0:ambariserver -t --rm --entrypoint /bin/sh sequenceiq/ambari-shell -c /tmp/install-cluster.sh
```

Ambari-shell uses Ambari's new [Blueprints](https://cwiki.apache.org/confluence/display/AMBARI/Blueprints)
capability. It just simple posts a cluster definition JSON to the ambari REST api,
and 1 more json for cluster creation, where you specify which hosts go
to which hostgroup.

Ambari shell will show the progress in the upper right corner.
So grab a cup coffee, and after about 10 minutes, you have a ready HDP 2.2 cluster.

## Multi-node Hadoop cluster

For the multi node Hadoop cluster instructions please read our [blog](http://blog.sequenceiq.com/blog/2014/06/19/multinode-hadoop-cluster-on-docker/) entry or run this one-liner:

```
curl -Lo .amb j.mp/docker-ambari && . .amb && amb-deploy-cluster
```


## Alternate method 

...
sudo docker rm amb0
sudo docker run -d -p 8080:8080 -p 2222:22  -h ec2-52-12-235-16.us-west-2.compute.amazonaws.com  --name amb0  -v /mnt/d3:/d3 -v /mnt/d4:/d4  ambari:1.1 --tag ambari-server=true
sudo docker ps
sudo  docker run -e BLUEPRINT=single-node-hdfs-yarn --link amb0:ambariserver -t --rm --entrypoint /bin/sh sequenceiq/ambari-shell -c /tmp/install-cluster.sh
...                                                                                                         
~                                                                                                           
