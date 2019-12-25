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
<#assign roles=["drivers", "resources"]>
<#list roles as role>
    <@property "local." + role + ".dir" "/etc/sqleditor/" + role/>
</#list>
    <#--  for search driver file -->
    <@property "local.driver.path.suffix" "*.jar"/>
    <@property "default.user" "0"/>
    <@property "connection.timeout" "3600"/>
    <@property "execute.sql.timeout" "1800"/>
    <@property "execute.sql.timeout.ms" "1800000"/>
    <@property "resultset.reader.timeout.ms" "300000"/>
    <@property "resultset.reader.period.ms" "300000"/>
    <@property "local.driver.classname.file" "name"/>
    <@property "reader.thread.max.num" "1000"/>
</configuration>