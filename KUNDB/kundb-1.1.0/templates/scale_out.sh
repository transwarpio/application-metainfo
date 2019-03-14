#!/bin/bash

set -x
if [ -f "$KUNDB_CONF_DIR/kundb-env.sh" ]; then
   source $KUNDB_CONF_DIR/kundb-env.sh
   source $KUNDB_CONF_DIR/mfed_conf.sh
else
   echo "/etc/kundb1/conf/ is not exist cant start kundb"
   exit 1
fi

keyspace=$1
./kunctl.sh ListAllTablets transwarp | grep $keyspace| grep master | wl -l
if [ $? -gt 1 ]; then
   ./kunctl.sh ApplyVShema  -vschema_file= $KUNDB_CONF_DIR/sharded_vschema.json $keyspace
else
   ./kunctl.sh ApplyVShema  -vschema_file= $KUNDB_CONF_DIR/unsharded_vschema.json $keyspace
fi

vtgate_port=$PRIV_KUNGATE_SERVER_PORT
for((i=0; i< $SHARD_NUM; i++)); 
do
   if [ -f "$KUNDB_CONF_DIR/shard_conf.sh" ]; then
      cd $KUNDB_CONF_DIR && source $KUNDB_CONF_DIR/shard_conf.sh $SHARD_NUM $i $UIDBASE $GROUP_INDEX 
   else
      echo "shard_conf.sh is not exist cant start kundb"
      exit 2
   fi
   printf -v alias '%s-%010d' $CELLNAME $SHARD_UIDBASE
   echo "InitMfed $alias ... "
   cd $KUNHOME && ./kunctl.sh InitMfed -mfed_alias $alias -vtgate_host `hostname -f` -vtgate_port $vtgate_port 
done
set +x
	
