<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<#--Simple macro definition-->
<#macro property key value>
<property>
    <name>${key}</name>
    <value>${value}</value>
</property>
</#macro>
<configuration>
    <@property "httpfs.hadoop.config.dir" "/etc/${service.sid}/conf"/>
    <@property "httpfs.proxyuser.hue.groups" "*"/>
    <@property "httpfs.proxyuser.hue.hosts" "*"/>
    <@property "httpfs.proxyuser.root.groups" "*"/>
    <@property "httpfs.proxyuser.root.hosts" "*"/>
    <@property "httpfs.proxyuser.hdfs.groups" "*"/>
    <@property "httpfs.proxyuser.hdfs.hosts" "*"/>
    <@property "httpfs.proxyuser.hbase.groups" "*"/>
    <@property "httpfs.proxyuser.hbase.hosts" "*"/>
</configuration>
