<#--handle dependent.zookeeper-->
<#if dependencies.ZOOKEEPER??>
<#assign zookeeper=dependencies.ZOOKEEPER quorums=[]>
<#list zookeeper.roles.ZOOKEEPER as role>
<#assign quorums += [role.hostname]>
</#list>
<#assign quorum = quorums?join(",")>
</#if>

<#--handle bootstrap-->
<#if service.roles.KAFKA_SERVER??>
  <#assign bootstrap=service.roles.KAFKA_SERVER bootstraps=[]>
  <#list service.roles.KAFKA_SERVER as role>
    <#assign bootstraps += [service[role.hostname]["advertised.listeners"]?split("://")[1]]>
   </#list>
  <#assign bootstrap_servers=bootstraps?join(",")>
</#if>

bootstrap.servers=${bootstrap_servers}
zookeeper.connect=${quorum}
<#if service['kafka.rest.port']??>
  port=${service['kafka.rest.port']}
</#if>

############################# Custom and Other ###############################
<#list service['kafka-rest.properties'] as key, value>
${key}=${value}
</#list>
