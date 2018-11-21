<#if service.roles.INCEPTOR_EXECUTOR??>
    <#list service.roles.INCEPTOR_EXECUTOR as executor>
    ${executor['hostname']}
    </#list>
</#if>