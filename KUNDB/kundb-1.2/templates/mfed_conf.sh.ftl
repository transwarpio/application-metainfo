#!/bin/bash
export KEYSPACE=_mfed
export DEFAULT_DBNAME=vt_$KEYSPACE
export UIDBASE=${service['computenode.uid_base']}
export UIDINDEX=0
export PORT=${service['computenode.debug.port']}
export MYSQL_ROOT=/usr/local/mariadb
export MYSQL_FLAVOR=MariaDB
export ALWAYS_SET_USER=${service['kundb.always_set_effective_user']}
export PRIV_KUNGATE_SERVER_PORT=${service['computenode.kungate.server.port']}
export PRIV_KUNGATE_WEB_PORT=${service['computenode.kungate.debug.port']}
export PRIV_KUNGATE_GRPC_PORT=${service['computenode.kungate.grpc.port']}
export PRIV_KUNGATE_AUDIT_FILTER="${service['computenode.audit_filter']}"
export PRIV_KUNGATE_OPTIONAL_ARGS="-mysql_auth_server_static_file $KUNDB_CONF_DIR/mysql_auth_server_static_creds.json" 

<#if service.roles.COMPUTE_NODE?? && service.roles.COMPUTE_NODE?size gt 0>
  <#assign mfedNum = (service.roles.COMPUTE_NODE?size) mfedIndex = 0>
export SHARD_NUM=${mfedNum}
    <#list service.roles.COMPUTE_NODE as mfed>
      <#if mfed.hostname == .data_model["localhostname"]>
export SHARD_INDEX=${mfedIndex}
export GROUP_INDEX=${mfedIndex}
export MFED_DATA_DIR="/vdir${service['computenode.data_dir']}"
      </#if>
      <#assign mfedIndex += 1>
    </#list>
</#if>


