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
<#assign license_servers=[]>
<#list dependencies.LICENSE_SERVICE.roles.LICENSE_NODE as server>
    <#assign license_servers += [(server.hostname + ":" + dependencies.LICENSE_SERVICE[server.hostname]["zookeeper.client.port"])]>
</#list>
<#assign licenses=license_servers?join(",")>
    <@property "tdt.license.string" "${licenses}"/>

<#--Take properties from the context-->
<#list service['tdt-site.xml'] as key, value>
    <@property key value/>
</#list>
</configuration>
