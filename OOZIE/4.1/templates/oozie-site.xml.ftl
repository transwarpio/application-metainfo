<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<#--Simple macro definition-->
<#macro property key value>
<property>
    <name>${key}</name>
    <value>${value}</value>
</property>
</#macro>
<#--------------------------->
<configuration>

    <#assign url="http://" + service.roles.OOZIE_SERVER[0]['hostname'] + ":" + service['oozie.http.port']>
    <@property "oozie.base.url" url/>
    <@property "oozie.service.ProxyUserService.proxyuser.hue.groups" "*"/>
    <@property "oozie.service.ProxyUserService.proxyuser.hue.hosts" "*"/>
    <#assign yarn_sid=dependencies.YARN.sid>
    <@property "oozie.service.HadoopAccessorService.hadoop.configurations" "*=hadoop-conf"/>
    <@property "oozie.service.HadoopAccessorService.action.configurations" "*=action-conf"/>
<#--Take properties from the context-->
<#list service['oozie-site.xml'] as key, value>
    <@property key value/>
</#list>
</configuration>
