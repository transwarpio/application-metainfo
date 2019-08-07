#!/bin/bash
export UIDBASE=${service['shard.uid_base']}
export PORT=${service['replica.debug.port']}
export MYSQL_ROOT=${service['mysql.root']}
export ALWAYS_SET_USER=${service['kundb.always_set_effective_user']}
export GROUPID=$[$[$PORT-15100]/10]
export SET_DATA_DIR="/vdir${service['replica.data_dir']}"
export mysql_user="root"
export mysql_password="!Transwarp"

<#if service.Shard?? && service.Shard?size gt 0>
  <#assign shardNum = (service.Shard?size) shardIndex = 0 localShardId = 0>
  <#assign groupIds = service.groupIds>
export SHARD_NUM=${shardNum}
    <#list service.Shard as sn>
      <#if service[sn]["KUNTABLET_REPLICA"]??>
      <#assign replicanode = service[sn]["KUNTABLET_REPLICA"]>
      <#assign roleNum = (replicanode?size) roleIndex = 1>
export ROLE_NUM=${roleNum}	
        <#list replicanode as pnode>
          <#if pnode.hostname == .data_model["localhostname"]>
            <#if groupIds[shardIndex] == .data_model["role.groupId"]>
            <#assign connectionURLPrefix="jdbc:mysql://" + pnode.hostname +":"> 
export KEYSPACE=${service['kundb.keyspace']}
export DEFAULT_DBNAME=vt_$KEYSPACE
export SHARD_NAME=${roleGroupName}
export SHARD_ID=${groupIds[shardIndex]}
export SHARD_INDEX=${shardIndex}	
export GROUP_INDEX=$GROUPID
export LOCAL_SHARD_ID=${localShardId}
export PORT_BASE=${service['replica.port_base']}
export GRPC_PORT_BASE=${service['replica.grpc.port_base']}
export MYSQL_PORT_BASE=${service['replica.mysql.port_base']}
export UIDINDEX=${roleIndex}
export mysql_jdbc_url_prefix=${connectionURLPrefix}
            </#if>
          <#assign localShardId += 1>
          </#if>
          <#assign roleIndex += 1 > 
        </#list>
      </#if>
      <#assign shardIndex += 1>
    </#list>
</#if>
