#!/usr/bin/bash
<#assign cell=service['kundb.cellname']>

export CELLNAME="${cell}"
export KEYSPACE=${service['kundb.keyspace']}
export PORT_BASE=15000
export GRPC_PORT_BASE=16000
export MYSQL_PORT_BASE=17000
export MYSQL_USER="root"
export MYSQL_PASSWORD="123456"
export ENABLE_SECURITY=${service['kundb.enable_security']}

export CTLD_GRPC_PORT=${service['kunctld.grpc.port']}
export CTLD_WEB_PORT=${service['kunctld.debug.port']}

export KUNGATE_WEB_PORT=${service['kungate.debug.port']}
export KUNGATE_GRPC_PORT=${service['kungate.grpc.port']}
export MYSQL_SERVER_PORT_BASE=${service['kungate.server.port']}
export KUNGATE_AUDIT_FILTER="${service['kungate.audit_filter']}"
export KUNDB_DIR=${service.sid}
export KUNDB_LOG_DIR=${service['kundb.log_dir']}

<#if service.roles.KUNCTLD??>
  <#list service.roles.KUNCTLD as ctld>
    <#if ctld.hostname == .data_model["localhostname"]>
export CTLD_DATA_DIR="/vdir${service['kunctld.data_dir']}"
      <#break>
    </#if>
  </#list>
</#if>

<#if service.roles.KUNGATE??>
  <#list service.roles.KUNGATE as gate>
    <#if gate.hostname == .data_model["localhostname"]>
export KUNGATE_DATA_DIR="/vdir${service['kungate.data_dir']}"
      <#break>
    </#if>
  </#list>
</#if>

<#if dependencies.ZOOKEEPER??>
    <#assign zookeeper = dependencies.ZOOKEEPER quorums = [] hostrums = [] >
    <#list zookeeper.roles.ZOOKEEPER as role>
        <#assign quorums += [role.hostname + ":" + zookeeper["zookeeper.client.port"]]>
        <#assign hostrums += [role.hostname]> 
    </#list>
    <#assign quorum=quorums?join(",")>
    <#assign hostrum=hostrums?join(" ")>
export KUNDB_ZOOKEEPER_SERVER="${quorum}"
export KUNDB_ZOOKEEPER_SERVER_ARR=(${hostrum})
</#if>

<#if dependencies.ZOOKEEPER??>
    <#if dependencies.ZOOKEEPER['zookeeper.client.port']??>
export KUNDB_ZOOKEEPER_PORT=${dependencies.ZOOKEEPER['zookeeper.client.port']}
    </#if>
</#if>

<#if service.roles.KUNCTLD??>
  <#list service.roles.KUNCTLD as ctld>
    <#assign ctldHost = ctld.hostname> 
    <#break>
  </#list>
export CTLD_HOST=${ctldHost}
</#if>

<#if service.roles.ORCHESTRATOR??>
  <#list service.roles.ORCHESTRATOR as orche>
    <#assign orcheHost = orche.hostname> 
    <#break>
  </#list>
export ORCHESTRATOR_HOST=${orcheHost}
</#if>

export VTROOT=/vt
export VTTOP=$VTROOT/src/github.com/youtube/vitess
export VT_MYSQL_ROOT=${service['mysql.root']}
export PATH=$PATH:$VT_MYSQL_ROOT/bin:$VTROOT/bin
export MYSQL_FLAVOR=${service['mysql.flavor']}
export KUNHOME=/vt/manager
export KUNUSER="kundb"
export KUNGATE_OPTIONAL_ARGS="-mysql_auth_server_static_file $KUNDB_CONF_DIR/mysql_auth_server_static_creds.json" 

if [ -f "$KUNDB_CONF_DIR/kundb-env.sh" ]; then
   cp $KUNDB_CONF_DIR/*[^new].cnf $VTROOT/config/mycnf
elif [ -f "$ROLE_CONF_DIR/kundb-env.sh" ]; then
   cp $ROLE_CONF_DIR/*[^new].cnf $VTROOT/config/mycnf
else
   echo "can not cp cnf to $VTROOT/config/mycnf !!"
fi

<#if service['data.localdir']??>
   <#assign datadir=service['data.localdir']>
export VIR_DATA_DIR=(${datadir})
</#if>

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

TOPOLOGY_FLAGS="-topo_implementation zk2 -topo_global_server_address $KUNDB_ZOOKEEPER_SERVER -topo_global_root /$KUNDB_DIR/global"

