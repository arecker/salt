#!/bin/bash
# configure_postgresql.sh
#
# Dirty little script that finds the active version of postgres, then
# updates the settings for docker
CONFIG_PATH=`su -c 'psql -t -c "show config_file"' postgres`
HBA_PATH=`su -c 'psql -t -c "show hba_file"' postgres`
sed -i "s|listen_addresses='localhost'|listen_addresses='localhost 172.17.0.1/16'|g" $CONFIG_PATH
grep -q -F 'host all all 172.17.0.1/16 trust' $HBA_PATH || echo 'host all all 172.17.0.1/16 trust' >> $HBA_PATH
