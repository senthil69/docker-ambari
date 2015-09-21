FROM centos:6.6
MAINTAINER Chanhun

RUN yum update -y
RUN yum install -y createrepo httpd gnupg yum-utils expect
RUN rm -rf /etc/yum.repos.d/

ADD ambari.repo /etc/yum.repos.d/
ADD hdp.repo /etc/yum.repos.d/

RUN mkdir -p /var/www/html/repo
RUN cd /var/www/html/repo && reposync

WORKDIR /var/www/html/repo
ADD update-repo.sh /tmp/
RUN /tmp/update-repo.sh

ADD create-repolist.sh /tmp/
RUN /tmp/create-repolist.sh

ADD start-repository.sh /tmp/
CMD /tmp/start-repository.sh
