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

<#--Kerberos-->
<#if service.auth = "kerberos">
    <@property "local.realm" "${service.realm}"/>
    <@property "oozie.service.HadoopAccessorService.kerberos.enabled" "true"/>
    <@property "oozie.service.HadoopAccessorService.keytab.file" "${service.keytab}"/>
    <@property "oozie.service.HadoopAccessorService.kerberos.principal" "oozie/${localhostname?lower_case}@${service.realm}"/>

    <@property "oozie.authentication.type" "${service.auth}"/>
    <@property "oozie.server.authentication.type" "${service.auth}"/>
    <@property "oozie.authentication.kerberos.principal" "HTTP/${localhostname?lower_case}@${service.realm}"/>
    <@property "oozie.authentication.kerberos.keytab" "${service.keytab}"/>

    <@property "oozie.credentials.credentialclasses" "hcat=org.apache.oozie.action.hadoop.HCatCredentials,hbase=org.apache.oozie.action.hadoop.HbaseCredentials,hive2=org.apache.oozie.action.hadoop.Hive2Credentials"/>
</#if>

<#--Take properties from the context-->
<#list service['oozie-site.xml'] as key, value>
    <@property key value/>
</#list>
</configuration>
