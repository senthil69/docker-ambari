FROM ubuntu
Maintainer Senthil 

ADD sources.list  /etc/apt/sources.list
RUN apt-get -y update 
RUN apt-get install -y build-essential 
RUN apt-get install -y openjdk-7-jdk
RUN apt-get install -y gcc g++ libkrb5-dev libmysqlclient-dev libssl-dev libsasl2-dev libsasl2-modules-gssapi-mit 
RUN apt-get install -y  python-dev python-simplejson python-setuptools ldap-utils krb5-user 
RUN apt-get install -y libldap2-dev libsqlite3-dev libtidy-0.99-0 libxml2-dev libxslt-dev  maven ant
RUN apt-get install -y  wget rsync
WORKDIR /root
RUN wget https://dl.dropboxusercontent.com/u/730827/hue/releases/3.8.1/hue-3.8.1.tgz
ADD setEnv.sh  /root/setEnv.sh
RUN tar -zxf hue-3.8.1.tgz
ADD hue-run.sh  /root/hue-run.sh
RUN useradd hue
CMD "/bin/bash" "/root/hue-run.sh"
