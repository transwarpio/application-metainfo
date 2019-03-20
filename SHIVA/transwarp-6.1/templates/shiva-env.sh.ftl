<#if service.roles.SHIVA_MASTER?? && service.roles.SHIVA_MASTER?size gt 0>
  <#assign masters=[]/>
  <#list service.roles.SHIVA_MASTER as role>
    <#assign masters += [role.ip + ":" + service["master.rpc_service.master_service_port"]]>
  </#list>
  <#assign master_group = masters?join(",")>
export MASTER_GROUP=${master_group}
</#if>
