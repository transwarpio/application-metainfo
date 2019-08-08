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
<#if service.auth == "kerberos">
  <@property "hadoop.security.authentication" service.auth/>
  <@property "hadoop.security.authorization" "true"/>
  <@property "hadoop.http.filter.initializers" "org.apache.hadoop.security.AuthenticationFilterInitializer"/>
  <@property "hadoop.http.authentication.simple.anonymous.allowed" "true"/>
  <#assign principal="HTTP/" + localhostname?lower_case + "@" + service.realm/>
  <@property "hadoop.http.authentication.kerberos.principal" principal/>
  <@property "hadoop.http.authentication.kerberos.keytab" "/etc/"+ service.sid + "/conf/inceptor_gateway.keytab"/>
  <@property "hadoop.http.authentication.signature.secret.file" "/etc/hadoop-http-auth-signature-secret"/>
  <#if dependencies.GUARDIAN??>
  <#--handle CAS-->
    <#if dependencies.GUARDIAN.roles.CAS_SERVER??>
      <#assign casServerSslPort=dependencies.GUARDIAN['cas.server.ssl.port']>
      <#if dependencies.GUARDIAN['guardian.server.cas.server.host']?matches("^\\s*$")>
        <#assign casServerName="https://${dependencies.GUARDIAN.roles.CAS_SERVER[0]['ip']}:${casServerSslPort}">
      <#else>
        <#assign casServerName="https://${dependencies.GUARDIAN['guardian.server.cas.server.host']}:${casServerSslPort}">
      </#if>
      <#assign webCasEnabled=(service['hadoop.security.authentication.web.cas.enabled'])!"false">
      <@property "hadoop.security.authentication.web.cas.enabled" "${webCasEnabled}"/>
      <@property "hadoop.security.authentication.cas.server.loginUrl" "${casServerName}/cas/login"/>
      <@property "hadoop.security.authentication.cas.server.prefix" "${casServerName}/cas"/>
    </#if>
  <#--handle Guardian Federation-->
    <#if dependencies.GUARDIAN.roles["GUARDIAN_FEDERATION"]??>
      <#assign oauth2Enabled=(service['hadoop.security.authentication.oauth2.enabled'])!"false">
      <@property "hadoop.security.authentication.oauth2.enabled" "${oauth2Enabled}"/>
      <#assign webOauth2Enabled=(service['hadoop.security.authentication.web.oauth2.enabled'])!"false">
      <@property "hadoop.security.authentication.web.oauth2.enabled" "${webOauth2Enabled}"/>
    </#if>
  </#if>
  <#if service.plugins?seq_contains("guardian")>
    <#assign  guardian=dependencies.GUARDIAN guardian_servers=[]>
    <#list guardian.roles["GUARDIAN_APACHEDS"] as role>
      <#assign guardian_servers += [("ldap://" + role.hostname + ":" + guardian["guardian.apacheds.ldap.port"])]>
    </#list>
    <@property "hadoop.security.group.mapping" "org.apache.hadoop.security.LdapGroupsMapping"/>
    <@property "hadoop.security.group.mapping.ldap.bind.user" "uid=admin,ou=system"/>
    <@property "hadoop.security.group.mapping.ldap.bind.password.file" "/etc/${service.sid}/conf/ldap-conn-pass.txt"/>
    <@property "hadoop.security.group.mapping.ldap.url" "${guardian_servers?join(' ')}"/>
    <@property "hadoop.security.group.mapping.ldap.base" "${dependencies.GUARDIAN['guardian.ds.domain']}"/>
    <@property "hadoop.security.group.mapping.ldap.search.filter.user" "(&amp;(objectClass=inetOrgPerson)(uid={0}))"/>
    <@property "hadoop.security.group.mapping.ldap.search.filter.group" "(objectClass=configGroup)"/>
    <@property "hadoop.security.group.mapping.ldap.search.attr.member" "member"/>
    <@property "hadoop.security.group.mapping.ldap.search.attr.group.name" "cn"/>
  </#if>
</#if>
<#--hadoop.proxyuser.[hive, hue, httpfs, oozie].[hosts,groups]-->
<#assign services=["hdfs","hbase","hive", "hue", "httpfs", "oozie", "guardian"]>
<#list services as s>
  <@property "hadoop.proxyuser." + s + ".hosts" "*"/>
  <@property "hadoop.proxyuser." + s + ".groups" "*"/>
</#list>
<#assign user=.data_model['current.user']>
<@property "hadoop.proxyuser." + user + ".hosts" "*"/>
<@property "hadoop.proxyuser." + user + ".groups" "*"/>
<@property "net.topology.node.switch.mapping.impl" "org.apache.hadoop.net.ScriptBasedMapping"/>
<@property "net.topology.script.file.name" "/usr/lib/transwarp/scripts/rack_map.sh"/>
</configuration>