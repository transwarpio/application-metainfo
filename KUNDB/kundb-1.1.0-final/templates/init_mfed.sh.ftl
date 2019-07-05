#!/bin/bash

if [ -f "$ROLE_CONF_DIR/kundb-env.sh" ]; then
   source $ROLE_CONF_DIR/mfed_conf.sh
else
   echo "/etc/kundb1/conf/ is not exist cant start kundb"
fi
export vtgate_port=$PRIV_KUNGATE_SERVER_PORT
export uidbase=${service['computenode.uid_base']}

<#if service.roles.COMPUTE_NODE?? && service.roles.COMPUTE_NODE?size gt 0>
  <#assign mfedNum = (service.roles.COMPUTE_NODE?size) mfedIndex = 0 hostrums = []>
export MFED_SHARD_NUM=${mfedNum}
    <#list service.roles.COMPUTE_NODE as mfed>
     <#assign hostrums += [mfed.hostname]> 
HostName=${mfed.hostname}
     <#assign mfedIndex += 1>
    </#list>
    <#assign hostrum=hostrums?join(" ")>
</#if>
export mfedHost=(${hostrum}) 

