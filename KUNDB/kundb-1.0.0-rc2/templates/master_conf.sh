#!/bin/bash
export KEYSPACE=${service['kundb.keyspace']}
export DEFAULT_DBNAME=vt_$KEYSPACE
export UIDINDEX=0
export UIDBASE=${service['shard.uid_base']}
export PORT=${service['master.debug.port']}

<#if service.Shard?? && service.Shard?size gt 0>
  <#assign shardNum = (service.Shard?size) shardIndex = 0>
  <#assign groupIds = service.groupIds>
export SHARD_NUM=${shardNum}
    <#list service.Shard as sn>
      <#assign masternode = service[sn]["KUNTABLET_MASTER"]>
        <#list masternode as mnode>
          <#if mnode.hostname == .data_model["localhostname"] && groupIds[shardIndex] == .data_model["role.groupId"]>
export SHARD_ID=${groupIds[shardIndex]}
export SHARD_INDEX=${shardIndex}
export PORT_BASE=${service['master.port_base']}
export GRPC_PORT_BASE=${service['master.grpc.port_base']}
export MYSQL_PORT_BASE=${service['master.mysql.port_base']}
          </#if>
        </#list>
    <#assign shardIndex += 1>
    </#list>
</#if>


