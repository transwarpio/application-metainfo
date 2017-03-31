#!/usr/bin/env bash

export NAMENODE_CLUSTER_ID=${service.sid}
<#if service.nameservices??>
  <#list service.nameservices as nameservice>
    <#assign namenodes=service[nameservice]["HDFS_NAMENODE"]>
    <#if namenodes?size == 1>
      <#if namenodes[0].id == .data_model["role.id"]>
export NAMENODE_NAMESERVICE=${nameservice}
export HDFS_HA=false
      </#if>
    <#elseif namenodes?size == 2>
      <#if namenodes[0].id lt namenodes[1].id>
        <#assign nn1=namenodes[0]>
        <#assign nn2=namenodes[1]>
      <#else>
        <#assign nn1=namenodes[1]>
        <#assign nn2=namenodes[0]>
      </#if>

      <#if nn1.id == .data_model["role.id"]>
export NAMENODE_NAMESERVICE=${nameservice}
export HDFS_HA=true
export NAMENODE_ORDINAL=0
      <#elseif nn2.id == .data_model["role.id"]>
export NAMENODE_NAMESERVICE=${nameservice}
export HDFS_HA=true
export NAMENODE_ORDINAL=1
        <#if service["namenode.http-port"]??>
          <#assign nn1HttpPort=service["namenode.http-port"]>
        </#if>
export NAMENODE_PRIMARY_JMX_URL=http://${nn1.hostname}:${nn1HttpPort}/jmx
      </#if>
    <#else>
      <#stop "more than 2 NameNodes in the same NameService not supported">
    </#if>
  </#list>
</#if>

<#if service["HDFS_NAMENODE"]??>
  <#list service["HDFS_NAMENODE"] as namenode>
    <#if namenode.id == .data_model["role.id"]>
export HDFS_HA=false
    </#if>
  </#list>
</#if>

# Export journalnode config
<#if service['journalnode.http-port']??>
export JOURNALNODE_HTTP_PORT=${service['journalnode.http-port']}
export JOURNALNODE_RPC_PORT=${service['journalnode.rpc-port']}
export HDFS_JOURNAL_NODE_COUNT=${service.roles.HDFS_JOURNALNODE?size}
</#if>

# Export dfs.datanode.data.dir
<#if service[.data_model["localhostname"]]['dfs.datanode.data.dir']??>
export DATA_DIRS=${service[.data_model["localhostname"]]['dfs.datanode.data.dir']}
<#else>
export DATA_DIRS=/hadoop/data
</#if>
export DATA_DIRS_PARENT=/hadoop/mounts/${service.sid}/datadir
<#if service['dfs.namenode.name.dir']??>
export NAMENODE_DATA_DIRS=${service['dfs.namenode.name.dir']?trim}
</#if>
