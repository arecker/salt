FROM ubuntu:trusty
RUN apt-get update && apt-get install -y software-properties-common
RUN add-apt-repository ppa:saltstack/salt
RUN apt-get update && apt-get install -y salt-minion

RUN mkdir -p /srv/salt
RUN mkdir -p /srv/pillar
COPY . /srv/salt
COPY ./docker/* /srv/pillar

EXPOSE 22 80
