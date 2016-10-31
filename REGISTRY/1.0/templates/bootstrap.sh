#!/bin/bash

set -e
umask 0022

CURRENTPATH=`dirname $0`

REGISTRY_IP="127.0.0.1"
REGISTRY_DATA="/var/lib/registry_data"
#mkdir -p /etc/docker/certs.d/${REGISTRY_ADDRESS}/
#/bin/cp ca.crt /etc/docker/certs.d/${REGISTRY_ADDRESS}/

# 2. load registry and generate certs
echo "docker load -i $CURRENTPATH/registry.tar.gz"
docker load -i $CURRENTPATH/registry.tar.gz
#cd registry-certs/gencerts/
#./make-server-cert.sh ${REGISTRY_IP} \
#  IP:${REGISTRY_IP},DNS:registry,DNS:registry.transwarp.io,DNS:$(hostname)
#if [ $? -ne 0 ]; then
#  echo "generate cert error"
#  exit 1
#fi
#cd -
#/bin/cp registry-certs/gencerts/{server.cert,server.key} registry-certs/

# 3. uncompress registry-data.tar.gz
if [ -f $CURRENTPATH/registry.data.tar.gz ]; then
  mkdir -p ${REGISTRY_DATA}
  echo "tar -xvf $CURRENTPATH/registry.data.tar.gz -C ${REGISTRY_DATA}"
  tar -xvf $CURRENTPATH/registry.data.tar.gz -C ${REGISTRY_DATA}
else
  echo "*** Images Data not found ***"
  exit 1
fi

# 4. start registry
echo "docker-compose -f $CURRENTPATH/docker-registry.yml up -d"
docker-compose -f $CURRENTPATH/docker-registry.yml up -d