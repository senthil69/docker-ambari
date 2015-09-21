sudo docker build -f ambari-base.Dockerfile -t ambari-base:1 .
sleep 3
sudo docker build -f ambari-server.Dockerfile -t ambari-server:1 .
sleep 3
sudo docker build -f ambari-agent.Dockerfile -t ambari-agent:1 .
sleep 3
sudo docker build -f ambari-client.Dockerfile -t ambari-client:1 .
sleep 3
sudo docker build -f ambari-repo.Dockerfile -t ambari-repo:1 .
sleep 3
sudo docker build -f docker-repo.Dockerfile -t docker-repo:1 .
