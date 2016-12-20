#!/usr/bin/env bash

# Copy the "certs" over to the expected directory
mkdir -p /etc/letsencrypt/live
cp -R $TRAVIS_BUILD_DIR/test/certs/* /etc/letsencrypt/live/
