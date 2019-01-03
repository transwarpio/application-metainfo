<#if service['mysql_new.cnf']?? >
<#list service['mysql_new.cnf'] as key, value>
${key} = ${value}
</#list>
</#if>
