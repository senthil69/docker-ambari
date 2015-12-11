FROM centos:6.6
MAINTAINER Chanhun

RUN yum update -y
RUN yum install -y createrepo httpd gnupg yum-utils expect wget tar
RUN mkdir -p /var/www/html/repo



WORKDIR /var/www/html
ADD  HDP-2.3.2.0-centos6-rpm.tar.gz /var/www/html
WORKDIR /var/www/html/repo
ADD  HDP-UTILS-1.1.0.20-centos6.tar.gz  /var/www/html/repo
ADD update-repo.sh /tmp/
RUN /tmp/update-repo.sh

ADD create-repolist.sh /tmp/
RUN /tmp/create-repolist.sh

ADD start-repository.sh /tmp/
CMD /tmp/start-repository.sh
