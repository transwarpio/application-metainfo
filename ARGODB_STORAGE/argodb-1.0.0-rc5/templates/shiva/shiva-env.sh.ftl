<#if service.roles.SHIVA_MASTER?? && service.roles.SHIVA_MASTER?size gt 0>
  <#assign masters=[]/>
  <#list service.roles.SHIVA_MASTER as role>
    <#assign masters += [role.ip + ":" + service["shiva.master.rpc_service.master_service_port"]]>
  </#list>
  <#assign master_group = masters?join(",")>
export MASTER_GROUP=${master_group}
export MASTER_SERVICE_PORT=${service["shiva.master.rpc_service.master_service_port"]}
export TABLETSERVER_SERVICE_PORT=${service["shiva.tabletserver.rpc_service.manage_service_port"]}
</#if>
