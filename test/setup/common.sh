#!/usr/bin/env bash

# Needed to run vagrant as a proxy to itself
sudo usermod -p "`openssl passwd -1 'travis'`" travis

# https://github.com/saltstack/salt/issues/34065
# Just install it manually
sudo apt-get install python-pip
sudo pip install docker-py
