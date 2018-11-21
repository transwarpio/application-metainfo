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
</#if>

<#--Take properties from the context-->
<#list service['core-site.xml'] as key, value>
    <@property key value/>
</#list>
</configuration>
