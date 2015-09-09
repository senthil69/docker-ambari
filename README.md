# Ambari on Docker


## Environment setup 

Follow the description at the docker [getting started](https://www.docker.io/gettingstarted/#h_installation). 
Required Platforms:

   * Docker 1.8.1 
   * CentOS 7.1 64 bit. 


## Build the docker images

Ambari has two components namely server and agent. We build two images namely ambari-agent and ambari-server. The instructions to build the images are provided in build.sh. Modify the image tag name or build options to suit your needs 


./build.sh



## Starting the Ambari Server

You need to start Ambari server.Ambari server logs can be monitored from host by mounting /var/log directory of container  

```
sudo docker run --net=host -d postgres 
sudo docker run --net=host -v /$CUSTOM/log:/var/log ambari-server:1

```

The explanation of the parameters:

- **--net=host** : In this mode we will use host IP instead of  private IP
- **$CUSTOM/log** - Ambari server logs can be collected on host machine for monitoring purpose

## Starting the Ambari Server

You need to run Ambari Agent. Ambari Agent need to know the IP address of the Ambari Master. Since We are using host IP address, you need to pass the host IP 
...
sudo docker run --net=host -e AMBARI\_MASTER=$AMBARI\_MASTER_HOST  -v $CUSTOM/log:/var/log/ambari-agent ambari-agent:1 
```

## Starting the Hadoop Client

If you want to try out custom spark version provided by Hortonworks, you may want to run

...
sudo docker run --net=host -e AMBARI\_MASTER=$AMBARI\_MASTER_HOST  -v $CUSTOM/log:/var/log/ambari-agent ambari-client:1
...

If you choose to use this option, the following blueprint will not work. After starting the container, you need to access ambari server via browser as http://<ambariserver>:8888/

During host selection choose this container as client only and ensure the container has YARN and HDFS client installed. 

## Cluster deployment via blueprint

The blueprint to create a single node cluster can be found at (https://cwiki.apache.org/confluence/display/AMBARI/Blueprints). 


Load the sample blueprint (part of workspace) and register under the name b1 using the following command. 
...
curl -H "X-Requested-By: Ambari" -u admin:admin -X POST -d @bp3.json http://<ambari\_master_host>:8888/api/v1/blueprints/b1
...

Create the cluster with the following command 

...
curl -H "X-Requested-By: Ambari" -u admin:admin -X POST -d @cl1.json http://<ambari\_master_host>:8888/api/v1/clusters/c1
...

Ambari returns the URL to monitor the progress of the cluster creation. as follows 

...
curl -H "X-Requested-By: Ambari" -u admin:admin -X  GET  http://<ambari\_master_host>:8888/api/v1/clusters/c1/requests/1/tasks/10000
...

