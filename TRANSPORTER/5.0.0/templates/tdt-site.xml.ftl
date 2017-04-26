<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<#--Simple macro definition-->
<#macro property key value>
<property>
    <name>${key}</name>
    <value>${value}</value>
</property>
</#macro>
<configuration>
    <@property "tdt.server.logging.task.log.location" "/var/log/${service.sid}"/>
    <@property "tdt.task.rule.file.location" "/etc/${service.sid}/conf/rule.json"/>
    <#assign inceptor_url = dependencies.INCEPTOR.roles.INCEPTOR_SERVER[0]['hostname'] + ":" + dependencies.INCEPTOR['hive.server2.thrift.port']>
    <@property "tdt.jdbc.url" "jdbc：hive2://${inceptor_url}/tdt"/>
<#--Take properties from the context-->
<#list service['tdt-site.xml'] as key, value>
    <@property key value/>
</#list>
</configuration>
