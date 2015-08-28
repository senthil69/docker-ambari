# Ambari on Docker


## Install Docker

Follow the description at the docker [getting started](https://www.docker.io/gettingstarted/#h_installation)


## Build the docker images

Ambari has two components namely server and agent. We build two images namely ambari-agent and ambari-server. The instructions to build the images are provided in build.sh. Modify the image tag name or build options to suit your needs 

...
./build.sh
...

## Starting the container

First you need to start Ambari server. Upon launching container the progress can be monitored at $CUSTOM/log/ambari-server/ambari-server.log 

```
sudo docker run --net=host -d postgres 
sudo docker run --privileged --net=host -v /$CUSTOM/log:/var/log ambari-server:1

```

The explanation of the parameters:

- **--net=host** : In this mode we will use host IP instead of  private IP
- **-privileged=true**: Faciliate sudo operations in container.
- ** $CUSTOM/log - Ambari server logs can be collected on host machine for monitoring purpose

```
Second you need to run Ambari Agent. Ambari Agent need to know the IP address of the Ambari Master. Since We are using host IP address, you need to pass the host IP 
...
sudo docker run --net=host --privileged=true -v $CUSTOM/log:/var/log -v $CUSTOM/hadoop:/hadoop ambari-agent:1 
```



## Cluster deployment via blueprint

The blueprint to create a single node cluster can be found at (https://cwiki.apache.org/confluence/display/AMBARI/Blueprints). However, We noticed that Ambari's ability to select default locations for log does not work with docker. Docker mounts /etc/resolv.conf and Ambari thinks that this mount point can be used for log location. To circumvent the problem,I created the cluster using WebUI and finetuned the parameters and took snapshot. Ambari twiki mentioned above has instructions to take snapshot of the blueprint
 
```
