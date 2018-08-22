#!/bin/bash
export KEYSPACE=_mfed
export DEFAULT_DBNAME=${service['computenode.default_dbname']}
export UIDBASE=${service['computenode.uid_base']}
export UIDINDEX=0
export PORT=${service['computenode.debug.port']}

<#if service.roles.COMPUTE_NODE?? && service.roles.COMPUTE_NODE?size gt 0>
  <#assign mfedNum = (service.roles.COMPUTE_NODE?size) mfedIndex = 0>
export SHARD_NUM=${mfedNum}
    <#list service.roles.COMPUTE_NODE as mfed>
      <#if mfed.hostname == .data_model["localhostname"]>
export SHARD_INDEX=${mfedIndex}
      </#if>
      <#assign mfedIndex += 1>
    </#list>
</#if>


