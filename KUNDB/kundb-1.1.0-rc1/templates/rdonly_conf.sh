#!/bin/bash
export UIDBASE=${service['shard.uid_base']}
export PORT=${service['rdonly.debug.port']}
export MYSQL_ROOT=${service['mysql.root']}
export GROUPID=$[$[$PORT-15100]/10]
export SET_DATA_DIR="/vdir${service['rdonly.data_dir']}"

<#if service.Shard?? && service.Shard?size gt 0>
  <#assign shardNum = (service.Shard?size) shardIndex = 0 localShardId = 0>
  <#assign groupIds = service.groupIds>
export SHARD_NUM=${shardNum}
    <#list service.Shard as sn>
        <#if service[sn]["KUNTABLET_RDONLY"]??>
        <#assign rdonlynode = service[sn]["KUNTABLET_RDONLY"] roleIndex = 0>
          <#list rdonlynode as rnode>
            <#if rnode.hostname == .data_model["localhostname"] >
              <#if groupIds[shardIndex] == .data_model["role.groupId"]>
export KEYSPACE=${service['kundb.keyspace']}
export DEFAULT_DBNAME=vt_$KEYSPACE
export SHARD_NAME=${roleGroupName}
export SHARD_ID=${groupIds[shardIndex]}
export SHARD_INDEX=${shardIndex}		
export GROUP_INDEX=$GROUPID
export LOCAL_SHARD_ID=${localShardId}
export PORT_BASE=${service['rdonly.port_base']}
export GRPC_PORT_BASE=${service['rdonly.grpc.port_base']}
export MYSQL_PORT_BASE=${service['rdonly.mysql.port_base']}
              <#assign realIndex =roleIndex + 5 > 
export UIDINDEX=${realIndex}
              </#if>
            <#assign localShardId += 1>
            </#if>
            <#assign roleIndex += 1 > 
          </#list>
      <#assign shardIndex += 1>
      </#if>
    </#list>
</#if>

