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
    <#assign inceptor_server = dependencies.INCEPTOR.roles.INCEPTOR_SERVER[0]['hostname']>
    <#assign inceptor_url = inceptor_server + ":" + dependencies.INCEPTOR['hive.server2.thrift.port']>
    <#if service.auth != "kerberos">
    <@property "tdt.jdbc.url" "jdbc:hive2://${inceptor_url}/tdt"/>
    <#else>
    <@property "tdt.jdbc.url" "jdbc:hive2://${inceptor_url}/tdt;authentication=kerberos;kuser=tdt/${localhostname}@${service.realm};keytab=${service.keytab};krb5conf=/etc/krb5.conf;principal=hive/${inceptor_server}@${service.realm}"/>
    </#if>

<#assign license_servers=[]>
<#list dependencies.LICENSE_SERVICE.roles.LICENSE_NODE as server>
    <#assign license_servers += [(server.hostname + ":" + dependencies.LICENSE_SERVICE[server.hostname]["zookeeper.client.port"])]>
</#list>
<#assign licenses=license_servers?join(",")>
    <@property "tdt.license.string" licenses/>

<#--Take properties from the context-->
<#list service['tdt-site.xml'] as key, value>
    <@property key value/>
</#list>
    <#-- security configurations-->
<#if service.auth="kerberos">
    <#if service['tdt.server.authentication'] != "LDAP">
    <@property "tdt.server.authentication" "KERBEROS"/>
    <@property "tdt.server.authentication.kerberos.keytab" service.keytab/>
    <@property "tdt.server.authentication.kerberos.principal" "tdt/${localhostname}@${service.realm}"/>
    <#else>
    <@property "tdt.server.authentication" "LDAP"/>
    <@property "tdt.server.authentication.ldap.url" "ldap://" + dependencies.GUARDIAN.roles.GUARDIAN_APACHEDS?sort_by("id")[0].hostname + ":" + dependencies.GUARDIAN['guardian.apacheds.ldap.port']/>
    <@property "tdt.server.authentication.ldap.baseDN" "ou=People,${service.domain}"/>
    </#if>
<#else>
    <@property "tdt.server.authentication" "NONE"/>
</#if>
</configuration>
