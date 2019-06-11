<#if service['mysql.cfg']?? >
<#list service['mysql.cfg'] as key, value>
${key} = ${value}
</#list>
</#if>
