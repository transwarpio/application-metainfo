<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<#--Simple macro definition-->
<#macro property key value>
<property>
    <name>${key}</name>
    <value>${value}</value>
</property>
</#macro>
<#--------------------------->
<#assign
    sid=service.sid
    auth=service.auth
    historyServer=service.roles.YARN_HISTORYSERVER[0]['hostname']
>
<configuration>
    <@property "mapreduce.jobhistory.address" historyServer + ":10020"/>
    <@property "mapreduce.jobhistory.webapp.address" historyServer + ":19888"/>
    <@property "yarn.app.mapreduce.am.staging-dir" "/" + sid + "/user"/>
<#--Take properties from the context-->
<#list service['mapred_site'] as key, value>
    <@property key value/>
</#list>
</configuration>
