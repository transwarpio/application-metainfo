<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<#macro property key value>
<property>
    <name>${key}</name>
    <value>${value}</value>
</property>
</#macro>
<configuration>
<@property "canal.server.log.location" "/var/log/${service.sid}/canal-server"/>
<@property "canal.server.ip" "${localhostname}"/>

<#--handle dependent.zookeeper-->
<#if dependencies.ZOOKEEPER??>
    <#assign zookeeper=dependencies.ZOOKEEPER quorums=[]>
    <#list zookeeper.roles.ZOOKEEPER as role>
        <#assign quorums += [role.hostname + ":" + zookeeper["zookeeper.client.port"]]>
    </#list>
    <@property "canal.zookeeper.quorum" quorums?join(",")/>
</#if>

<#--Take properties from the context-->
<#list service['canal-server-site.xml'] as key, value>
    <@property key value/>
</#list>
</configuration>
