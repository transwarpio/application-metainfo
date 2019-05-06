<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<#--Simple macro definition-->
<#macro property key value>
<property>
    <name>${key}</name>
    <value>${value}</value>
</property>
</#macro>

<configuration>
<#--handle the kerberos-->
<#if service.auth == "kerberos">
    <@property "hadoop.security.authentication" service.auth/>
    <@property "hadoop.security.authorization" "true"/>
    <@property "hadoop.http.filter.initializers" "org.apache.hadoop.security.AuthenticationFilterInitializer"/>
    <@property "hadoop.http.authentication.simple.anonymous.allowed" "true"/>
    <#assign principal="HTTP/" + localhostname?lower_case + "@" + service.realm/>
    <@property "hadoop.http.authentication.kerberos.principal" principal/>
    <#if dependencies.HDFS??>
        <@property "hadoop.http.authentication.kerberos.keytab" "/etc/"+ dependencies.HDFS.sid + "/conf/hdfs.keytab"/>
    <#else>
        <@property "hadoop.http.authentication.kerberos.keytab" "/etc/"+ service.sid + "/conf/argodb_computing.keytab"/>
    </#if>

    <@property "hadoop.http.authentication.signature.secret.file" "/etc/hadoop-http-auth-signature-secret"/>
</#if>
<#--hadoop.proxyuser.[hive, hue, httpfs, oozie].[hosts,groups]-->
<#assign services=["hbase","hive", "hue", "httpfs", "oozie", "guardian"]>
<#list services as s>
    <@property "hadoop.proxyuser." + s + ".hosts" "*"/>
    <@property "hadoop.proxyuser." + s + ".groups" "*"/>
</#list>

<#--Take properties from the context-->
<#list service['core-site.xml'] as key, value>
    <@property key value/>
</#list>
</configuration>
