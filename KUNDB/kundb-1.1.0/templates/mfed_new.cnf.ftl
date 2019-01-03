<#if service['mfed_new.cnf']?? >
<#list service['mfed_new.cnf'] as key, value>
${key} = ${value}
</#list>
</#if>
