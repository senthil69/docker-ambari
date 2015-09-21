FROM registry:2


ADD private-repo.conf  /etc/docker/registry/config.yml
RUN chmod +x /etc/docker/registry/config.yml

