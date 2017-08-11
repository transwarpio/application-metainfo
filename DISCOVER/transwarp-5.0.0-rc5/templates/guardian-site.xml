<#if dependencies.GUARDIAN??>
<#assign  guardian=dependencies.GUARDIAN guardian_servers=[]>
<#list guardian.roles["GUARDIAN_SERVER"] as role>
    <#assign guardian_servers += [(role.hostname + ":" + guardian["guardian.server.port"])]>
</#list>
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <property>
        <name>guardian.server.address</name>
        <value>${guardian_servers?join(";")}</value>
    </property>
    <property>
        <name>guardian.connection.username</name>
        <value>guardian/guardian</value>
    </property>
    <property>
        <name>guardian.connection.user.issystem</name>
        <value>true</value>
    </property>
    <property>
        <name>guardian.connection.password.store</name>
        <value>/etc/${service.sid}/conf/guardian-client.jks</value>
    </property>
    <property>
        <name>guardian.connection.client.impl</name>
        <value>REST</value>
    </property>
    <property>
        <name>guardian.client.cache.enabled</name>
        <value>${guardian['guardian.client.cache.enabled']}</value>
    </property>
    <property>
        <name>guardian.server.tls.enabled</name>
        <value>${guardian['guardian.server.tls.enabled']}</value>
    </property>
</configuration>
</#if>