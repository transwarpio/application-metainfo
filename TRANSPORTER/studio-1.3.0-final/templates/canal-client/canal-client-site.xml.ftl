<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<#--Simple macro definition-->
<#macro property key value>
<property>
    <name>${key}</name>
    <value>${value}</value>
</property>
</#macro>
<configuration>
<@property "canal.client.log.location" "/var/log/${service.sid}/canal-client"/>

<#--handle dependent.zookeeper-->
<#if dependencies.ZOOKEEPER??>
    <#assign zookeeper=dependencies.ZOOKEEPER quorums=[]>
    <#list zookeeper.roles.ZOOKEEPER as role>
        <#assign quorums += [role.hostname + ":" + zookeeper["zookeeper.client.port"]]>
    </#list>
    <@property "canal.zookeeper.quorum" quorums?join(",")/>
</#if>

<#--Take properties from the context-->
<#list service['canal-client-site.xml'] as key, value>
    <@property key value/>
</#list>
</configuration>
