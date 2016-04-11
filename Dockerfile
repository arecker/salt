# FROM debian:jessie
# RUN apt-get update && apt-get install -y wget
# RUN echo 'deb http://debian.saltstack.com/debian jessie-saltstack main' >> /etc/apt/sources.list
# RUN wget -q -O- "http://debian.saltstack.com/debian-salt-team-joehealy.gpg.key" | apt-key add -
# RUN apt-get update && apt-get install -y salt-minion

FROM debian:wheezy
RUN apt-get update && apt-get install -y wget
RUN echo 'deb http://debian.saltstack.com/debian wheezy-saltstack main' >> /etc/apt/sources.list
RUN wget -q -O- "http://debian.saltstack.com/debian-salt-team-joehealy.gpg.key" | apt-key add -
RUN apt-get update && apt-get install -y salt-minion

# FROM ubuntu:trusty
# RUN apt-get update && apt-get install -y software-properties-common
# RUN add-apt-repository ppa:saltstack/salt
# RUN apt-get update && apt-get install -y salt-minion

# FROM centos:7
# RUN yum install -y wget
# RUN wget -O /tmp/epel-release.rpm http://mirrors.rit.edu/fedora/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
# RUN rpm -Uvh /tmp/epel-release.rpm
# RUN yum -y install salt-minion

RUN mkdir -p /srv/salt
COPY . /srv/salt
RUN mkdir -p /srv/pillar
RUN echo 'base:\n\
  "*":\n\
    - docker-pillar\n'\
>> /srv/pillar/top.sls
COPY ./docker-pillar.sls /srv/pillar/

EXPOSE 22
