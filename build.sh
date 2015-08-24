sudo docker build -f ambari-db.Dockerfile -t ambari-db:1 .
sudo docker build -f ambari-base.Dockerfile -t ambari-base:1 .
sudo docker build -f ambari-server.Dockerfile -t ambari-server:1 .
sudo docker build -f ambari-agent.Dockerfile -t ambari-agent:1 .
#sudo docker build -f ambari-hbase.Dockerfile -t ambari-hbase:1 .

