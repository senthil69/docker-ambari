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


After login , you can start openssh-server and ntp server using the scrip
```
sh /tmp/start-daemon.sh
```

Start ambari server and ambari agent 
```
ambari-server start 
ambari-agent start 
```



## Cluster deployment via blueprint

The blueprint to create a single node cluster can be found at (https://cwiki.apache.org/confluence/display/AMBARI/Blueprints). However, We noticed that Ambari's ability to select default locations for log does not work with docker. Docker mounts /etc/resolv.conf and Ambari thinks that this mount point can be used for log location. To circumvent the problem,I created the cluster using WebUI and finetuned the parameters and took snapshot. Ambari twiki mentioned above has instructions to take snapshot of the blueprint
 
```
