
#!/usr/bin/bash
<#assign cell=service['kundb.cellname']>
<#assign keyspace=service['kundb.keyspace']>

export CELLNAME="${cell}"
export KEYSPACE=${keyspace}
export PORT_BASE=15000
export GRPC_PORT_BASE=16000
export MYSQL_PORT_BASE=17000
export MYSQL_USER="root"
export MYSQL_PASSWORD="123456"

export CTLD_GRPC_PORT=15999
export CTLD_WEB_PORT=${service['kunctld.debug.port']}

export KUNGATE_WEB_PORT=${service['kungate.debug.port']}
export KUNGATE_GRPC_PORT=15991
export MYSQL_SERVER_PORT_BASE=${service['kungate.server.port']}

export MFED_SHARD=0	
export MFED_UIDBASE=800
export MFED_UIDINDEX=0

<#if dependencies.ZOOKEEPER??>
    <#assign zookeeper = dependencies.ZOOKEEPER quorums = [] hostrums = [] >
    <#list zookeeper.roles.ZOOKEEPER as role>
        <#assign quorums += [role.hostname + ":" + zookeeper["zookeeper.client.port"]]>
        <#assign hostrums += [role.hostname]> 
    </#list>
    <#assign quorum=quorums?join(",")>
    <#assign hostrum=hostrums?join(" ")>
</#if>
export KUNDB_ZOOKEEPER_SERVER="${quorum}"
export KUNDB_ZOOKEEPER_SERVER_ARR=(${hostrum})
<#if dependencies.ZOOKEEPER??>
    <#if dependencies.ZOOKEEPER['zookeeper.client.port']??>
export KUNDB_ZOOKEEPER_PORT=${dependencies.ZOOKEEPER['zookeeper.client.port']}
    </#if>
</#if>

<#if service.Shard?? && service.Shard?size gt 0>
  <#assign shardNum = (service.Shard?size) shardIndex = 0>
export STORE_SHARD_NUM=${shardNum}
    <#list service.Shard as sn>
    <#assign masterIndex = []  replicaIndex = [] rdonlyIndex = []>
      <#assign masternode = service[sn]["KUNTABLET_MASTER"]>
        <#list masternode as mnode>
          <#if mnode.hostname == .data_model["localhostname"]>
          <#assign masterIndex += [shardIndex]>
export MASTER_SHARD_INDEX=${shardIndex}
          </#if>
        </#list>
      <#assign replicanode = service[sn]["KUNTABLET_REPLICA"]>
        <#list replicanode as pnode>
          <#if pnode.hostname == .data_model["localhostname"]>
          <#assign replicaIndex += [shardIndex]>
export REPLICA_SHARD_INDEX=${shardIndex}	
          </#if>
        </#list>
      <#assign rdonlynode = service[sn]["KUNTABLET_RDONLY"]>
        <#list rdonlynode as rnode>
          <#if rnode.hostname == .data_model["localhostname"]>
          <#assign rdonlyIndex += [shardIndex]>
export RDONLY_SHARD_INDEX=${shardIndex}		
          </#if>
        </#list>
      <#assign shardIndex += 1>
    </#list>
    <#assign masterIndex = masterIndex?join(" ")>
    <#assign replicaIndex = replicaIndex?join(" ")>
    <#assign rdonlyIndex = rdonlyIndex?join(" ")>
</#if>

<#if service.roles.COMPUTE_NODE?? && service.roles.COMPUTE_NODE?size gt 0>
  <#assign mfedNum = (service.roles.COMPUTE_NODE?size) mfedIndex = 0>
export MFED_SHARD_NUM=${mfedNum}
    <#list service.roles.COMPUTE_NODE as mfed>
      <#if mfed.hostname == .data_model["localhostname"]>
export MFED_SHARD_INDEX=${mfedIndex}
      </#if>
      <#assign mfedIndex += 1>
    </#list>
</#if>

<#if service.roles.KUNCTLD??>
  <#list service.roles.KUNCTLD as ctld>
    <#assign ctldHost = ctld.hostname> 
  </#list>
</#if>
#export CTLD_HOST=`hostname -I`
export CTLD_HOST=${ctldHost}



hostname=`hostname -f`
export VTTOP=$VTROOT/src/github.com/youtube/vitess
export VT_MYSQL_ROOT=/usr/local/mariadb
export MYSQL_FLAVOR=MariaDB
export KUNHOME=/vt/manager
export KUNUSER="kundb"
export VTAGTE_OPTIONAL_ARGS="-mysql_auth_server_static_file $KUNDB_CONF_DIR/mysql_auth_server_static_creds.json" 

if [ -f "$KUNDB_CONF_DIR/kundb-env.sh" ]; then
   cp $KUNDB_CONF_DIR/*.cnf $VTROOT/config/mycnf
elif [ -f "$ROLE_CONF_DIR/kundb-env.sh" ]; then
   cp $ROLE_CONF_DIR/*.cnf $VTROOT/config/mycnf
else
   echo "can not cp cnf to $VTROOT/config/mycnf !!"
fi

#export VTDATAROOT=/vt/vtdataroot
export PATH=$PATH:$VT_MYSQL_ROOT/bin:$VTROOT/bin
export VTROOT=/vt
<#if service['data.localdir']??>
   <#assign datadir=service['data.localdir']>
export VIR_DATA_DIR=${datadir}
</#if>

export VTDATAROOT=$VIR_DATA_DIR

# Try to find mysqld_safe on PATH.
if [ -z "$VT_MYSQL_ROOT" ]; then
  mysql_path=`which mysqld_safe`
  if [ -z "$mysql_path" ]; then
    echo "Can't guess location of mysqld_safe. Please set VT_MYSQL_ROOT so it can be found at \$VT_MYSQL_ROOT/bin/mysqld_safe."
    exit 1
  fi
  export VT_MYSQL_ROOT=$(dirname `dirname $mysql_path`)
fi

#mkdir -p $VTDATAROOT/tmp

TOPOLOGY_FLAGS="-topo_implementation zk2 -topo_global_server_address $KUNDB_ZOOKEEPER_SERVER -topo_global_root /kundb/global"

