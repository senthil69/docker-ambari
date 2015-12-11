sudo docker build -f ambari-base.Dockerfile -t ambari-base:1 .
sleep 3
sudo docker build -f ambari-server.Dockerfile -t ambari-server:1 .
sleep 3
sudo docker build -f ambari-agent.Dockerfile -t ambari-agent:1 .
sleep 3
if [ ! -f ../downloads/HDP-2.3.2.0-centos6-rpm.tar.gz ]; then 
	echo "Downloading HDP binaries..."
	cd ../downloads
	wget -o /tmp/wgetlog http://public-repo-1.hortonworks.com/HDP/centos6/2.x/updates/2.3.2.0/HDP-2.3.2.0-centos6-rpm.tar.gz
	wget -o /tmp/weblog http://public-repo-1.hortonworks.com/HDP-UTILS-1.1.0.20/repos/centos6/HDP-UTILS-1.1.0.20-centos6.tar.gz
fi
#sudo docker build -f ambari-client.Dockerfile -t ambari-client:1 .
#sleep 3
cp ambari-repo.Dockerfile create-repolist.sh update-repo.sh start-repository.sh ../downloads
cd ../downloads
sudo docker build -f ambari-repo.Dockerfile -t ambari-repo:1 .
cd ..
#sleep 3
#sudo docker build -f docker-repo.Dockerfile -t docker-repo:1 .
