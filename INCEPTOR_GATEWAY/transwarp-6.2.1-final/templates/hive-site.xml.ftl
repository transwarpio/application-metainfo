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

<#-- handle the kerberos-->
<#assign  authentication="NONE">
<#if service.auth == "kerberos">
  <#assign  authentication="KERBEROS">
  <@property "hive.metastore.sasl.enabled" "true"/>
  <@property "hive.metastore.kerberos.keytab.file" service.keytab/>
  <@property "hive.metastore.kerberos.principal" "hive/_HOST@" + service.realm/>
  <@property "yarn.resourcemanager.principal" "yarn/_HOST@" + service.realm/>
  <@property "hive.server2.authentication.kerberos.principal"  "hive/_HOST@" + service.realm/>
  <@property "hive.server2.authentication.kerberos.keytab" service.keytab/>
</#if>

<#assign  manager="NONE">
<#if authentication != "NONE">
  <@property "hive.server2.authentication" authentication/>
  <@property "hive.security.authenticator.manager" "org.apache.hadoop.hive.ql.security.SessionStateUserAuthenticator"/>
  <@property "hive.security.authorization.enabled" "true"/>
  <#assign  manager="org.apache.hadoop.hive.ql.security.authorization.plugin.sqlstd.SQLStdHiveAuthorizerFactory">
<#else>
  <@property "hive.server2.authentication" "CUSTOM"/>
  <@property "hive.server2.custom.authentication.class" "io.transwarp.gateway.octopus." + service['inceptor.server.version'] + ".CustomAuthen"/>
</#if>
<#if service.plugins?seq_contains("guardian")>
  <@property "plsql.link.hooks" "org.apache.hadoop.hive.ql.pl.parse.hooks.PLAnonExecHook"/>
  <@property "hive.exec.pre.hooks" "io.transwarp.guardian.plugins.inceptor.GuardianPLFunctionHook"/>
  <#assign  manager="io.transwarp.guardian.plugins.inceptor.GuardianHiveAuthorizerFactory">
</#if>
<#if manager != "NONE">
  <@property "hive.security.authorization.manager" manager/>
</#if>

<#if dependencies.GUARDIAN?? && dependencies.GUARDIAN.roles.CAS_SERVER??>
  <#assign  guardian=dependencies.GUARDIAN guardian_servers=[]>
  <#list guardian.roles["GUARDIAN_SERVER"] as role>
    <#assign guardian_servers += [("https://" + role.hostname + ":" + guardian["guardian.server.port"])]>
  </#list>
  <@property "hive.server2.authentication.guardian.url" "${guardian_servers?join(' ')}"/>
  <@property "hive.server2.authentication.cas.prefix" 'https://' + guardian.roles.CAS_SERVER[0]['hostname'] + ':' + guardian['cas.server.ssl.port'] + guardian['cas.server.context.path']/>
</#if>

</configuration>