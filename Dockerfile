# FROM debian:jessie
# RUN apt-get update && apt-get install -y wget
# RUN echo 'deb http://debian.saltstack.com/debian jessie-saltstack main' >> /etc/apt/sources.list
# RUN wget -q -O- "http://debian.saltstack.com/debian-salt-team-joehealy.gpg.key" | apt-key add -
# RUN apt-get update && apt-get install -y salt-minion

FROM ubuntu:trusty
RUN apt-get update && apt-get install -y software-properties-common
RUN add-apt-repository ppa:saltstack/salt
RUN apt-get update && apt-get install -y salt-minion

RUN mkdir -p /srv/salt
COPY . /srv/salt
RUN mkdir -p /srv/pillar
RUN echo 'base:\n\
  "*":\n\
    - docker-pillar\n'\
>> /srv/pillar/top.sls
COPY ./docker-pillar.sls /srv/pillar/

EXPOSE 22
