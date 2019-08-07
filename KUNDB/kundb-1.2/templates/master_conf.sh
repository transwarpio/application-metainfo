#!/bin/bash
export UIDINDEX=0
export UIDBASE=${service['shard.uid_base']}
export PORT=${service['master.debug.port']}
export MYSQL_ROOT=${service['mysql.root']}
export ALWAYS_SET_USER=${service['kundb.always_set_effective_user']}
export GROUPID=$[$[$PORT-15100]/10]
export SET_DATA_DIR="/vdir${service['master.data_dir']}"
export mysql_user="root"
export mysql_password="!Transwarp"

<#if service.Shard?? && service.Shard?size gt 0>
  <#assign shardNum = (service.Shard?size) shardIndex = 0 localShardId = 0>
  <#assign groupIds = service.groupIds>
export SHARD_NUM=${shardNum}
    <#list service.Shard as sn>
      <#if service[sn]["KUNTABLET_MASTER"]??>
      <#assign masternode = service[sn]["KUNTABLET_MASTER"]>
        <#list masternode as mnode>
          <#if mnode.hostname == .data_model["localhostname"]> 
            <#if groupIds[shardIndex] == .data_model["role.groupId"]>
            <#assign connectionURLPrefix="jdbc:mysql://" + mnode.hostname +":"> 
export KEYSPACE=${service['kundb.keyspace']}
export DEFAULT_DBNAME=vt_$KEYSPACE
export SHARD_NAME=${roleGroupName}
export SHARD_ID=${groupIds[shardIndex]}
export SHARD_INDEX=${shardIndex}
export GROUP_INDEX=$GROUPID
export LOCAL_SHARD_ID=${localShardId}
export PORT_BASE=${service['master.port_base']}
export GRPC_PORT_BASE=${service['master.grpc.port_base']}
export MYSQL_PORT_BASE=${service['master.mysql.port_base']}
export mysql_jdbc_url_prefix=${connectionURLPrefix}
            </#if>
          <#assign localShardId += 1>
          </#if>
        </#list>
      </#if>
    <#assign shardIndex += 1>
    </#list>
</#if>


