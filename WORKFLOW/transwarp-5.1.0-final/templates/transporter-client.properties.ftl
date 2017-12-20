# the general control of enabling/disabling transporter-client
<#if dependencies.TRANSPORTER?? && dependencies.TRANSPORTER.roles.TDT_SERVER?size gt 0>
transporter.enabled=true

<#--handle dependent.transporter-->
<#assign transporter=dependencies.TRANSPORTER address=[]>
<#list transporter.roles.TDT_SERVER as role>
    <#assign address += [role.hostname + ":" + transporter["tdt.server.port"]]>
</#list>
<#assign address = address?join(",")>

# the host of transporter
transporter.address=${address}

<#else>
transporter.enabled=false
</#if>