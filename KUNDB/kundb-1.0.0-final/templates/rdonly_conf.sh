#!/bin/bash
export UIDBASE=${service['shard.uid_base']}
export PORT=${service['rdonly.debug.port']}


<#if service.Shard?? && service.Shard?size gt 0>
  <#assign shardNum = (service.Shard?size) shardIndex = 0>
  <#assign groupIds = service.groupIds>
export SHARD_NUM=${shardNum}
    <#list service.Shard as sn>
      <#if service[sn]["KUNTABLET_REPLICA"]??>
      <#assign replicanode = service[sn]["KUNTABLET_REPLICA"]>
      <#assign replicaNum = (replicanode?size) roleIndex = replicaNum>
        <#if service[sn]["KUNTABLET_RDONLY"]??>
        <#assign rdonlynode = service[sn]["KUNTABLET_RDONLY"] roleIndex += 1>
          <#list rdonlynode as rnode>
            <#if rnode.hostname == .data_model["localhostname"] && groupIds[shardIndex] == .data_model["role.groupId"]>
export KEYSPACE=${service['kundb.keyspace']}
export DEFAULT_DBNAME=vt_$KEYSPACE
export SHARD_NAME=${roleGroupName}
export SHARD_ID=${groupIds[shardIndex]}
export SHARD_INDEX=${shardIndex}		
export GROUP_INDEX=${shardIndex}
export PORT_BASE=${service['rdonly.port_base']}
export GRPC_PORT_BASE=${service['rdonly.grpc.port_base']}
export MYSQL_PORT_BASE=${service['rdonly.mysql.port_base']}
export UIDINDEX=${roleIndex}
            </#if>
            <#assign roleIndex += 1 > 
          </#list>
        </#if>
      <#assign shardIndex += 1>
      </#if>
    </#list>
</#if>

