#!/bin/bash
# configure_postgresql.sh
#
# Dirty little script that finds the active version of postgres, then
# updates the settings for docker
CONFIG_PATH=`find /etc/postgresql -name "postgresql.conf" | head -1`
HBA_PATH=`find /etc/postgresql -name "pg_hba.conf" | head -1`
grep -q -F "listen_addresses='localhost 172.17.0.1/16'" $CONFIG_PATH || echo "listen_addresses='localhost 172.17.0.1/16'" >> $CONFIG_PATH
grep -q -F 'host all all 172.17.0.1/16 trust' $HBA_PATH || echo 'host all all 172.17.0.1/16 trust' >> $HBA_PATH
