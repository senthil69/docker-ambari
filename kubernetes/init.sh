
kubectl create -f namespace.yml
kubectl config set-context brightics-hadoop --namespace=brightics-hadoop
kubectl config use-context brightics-hadoop

kubectl label node centos7-01 role=ambari-server
kubectl label node centos7-02 role=ambari-agent1
kubectl label node centos7-03 role=ambari-agent2
kubectl label node centos7-04 role=ambari-agent3

kubectl create -f ambari-server/postgres-rc.yml
kubectl create -f ambari-server/ambariserver-rc.yml
