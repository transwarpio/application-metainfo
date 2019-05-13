<#if service['mfed.cfg']?? >
<#list service['mfed.cfg'] as key, value>
${key} = ${value}
</#list>
</#if>
