<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<configuration>
<#--Simple macro definition-->
<#macro property key value>
<property>
  <name>${key}</name>
  <value>${value}</value>
</property>
</#macro>
<#--------------------------->
<#--Take properties from the context-->
<#list service['graphconf.xml'] as key, value>
  <@property key value/>
</#list>
</configuration>
