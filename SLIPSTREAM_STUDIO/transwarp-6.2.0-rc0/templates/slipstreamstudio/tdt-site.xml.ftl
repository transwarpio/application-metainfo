<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<#--Simple macro definition-->
<#macro property key value>
<property>
  <name>${key}</name>
  <value>${value}</value>
</property>
</#macro>
<configuration>
  <#if dependencies.INCEPTOR_GATEWAY??>
      <#assign gateway_host=dependencies.INCEPTOR_GATEWAY.roles.INCEPTOR_GATEWAY[0]['hostname']>
      <#assign gateway_port=dependencies.INCEPTOR_GATEWAY['inceptor.gateway.port']>
      <@property "tdt.inceptor.address" "${gateway_host}:${gateway_port}"/>
  <#elseif dependencies.SLIPSTREAM??>
      <#assign inceptor_server=dependencies.SLIPSTREAM.roles.INCEPTOR_SERVER[0]>
      <#assign inceptor_url = inceptor_server['hostname'] + ":" + dependencies.SLIPSTREAM['hive.server2.thrift.port']>
      <@property "tdt.inceptor.address" "${inceptor_url}"/>
  </#if>

<#if dependencies.TXSQL??>
    <#assign mysqlHostPorts = []/>
    <#list dependencies.TXSQL.roles['TXSQL_SERVER'] as role>
        <#assign mysqlHostPorts = mysqlHostPorts + [role.hostname + ':' + dependencies.TXSQL['mysql.rw.port']]>
    </#list>
<#else>
    <#assign mysqlHostPorts = [service.roles.INCEPTOR_MYSQL[0]['hostname'] + ":" + service['mysql.port']]/>
</#if>
    <#assign dbconnectionstring="jdbc:mysql://" + mysqlHostPorts?join(",") + "/metastore_" + dependencies.SLIPSTREAM.sid + "?characterEncoding=UTF-8">
    <@property "tdt.inceptor.metastore.mysql.url" dbconnectionstring/>
    <@property "tdt.inceptor.metastore.mysql.username" service['javax.jdo.option.ConnectionUserName']/>
    <@property "tdt.inceptor.metastore.mysql.password" service['javax.jdo.option.ConnectionPassword']/>



<#if service.auth="kerberos">
  <#if dependencies.SLIPSTREAM??>
    <@property "tdt.inceptor.principal" "hive/${dependencies.SLIPSTREAM.roles.INCEPTOR_SERVER[0]['hostname']}@${service.realm}"/>
    <#if dependencies.SLIPSTREAM['hive.server2.authentication'] == "LDAP">
      <@property "tdt.inceptor.auth.mode" "LDAP"/>
    <#else>
      <@property "tdt.inceptor.auth.mode" "KERBEROS"/>
    </#if>
  </#if>
<#else>
  <@property "tdt.inceptor.auth.mode" "NONE"/>
</#if>  
<@property "tdt.server.log.location" "/var/log/${service.sid}"/>
  <#assign license_servers=[]>
  <#list dependencies.LICENSE_SERVICE.roles.LICENSE_NODE as server>
     <#assign license_servers += [(server.hostname + ":" + dependencies.LICENSE_SERVICE[server.hostname]["zookeeper.client.port"])]>
  </#list>
  <#assign licenses=license_servers?join(",")>
  <@property "tdt.license.quorum" licenses/>

<#if service.auth = "kerberos">
  <@property "tdt.server.principal" "slipstream/${localhostname?lower_case}@${service.realm}"/>
  <@property "tdt.server.keytab" "${service.keytab}"/>
    <#assign casServerSslPort=dependencies.GUARDIAN['cas.server.ssl.port']>
    <#if dependencies.GUARDIAN['guardian.server.cas.server.host']?matches("^\\s*$")>
      <#assign casServerName="https://${dependencies.GUARDIAN.roles.CAS_SERVER[0]['ip']}:${casServerSslPort}">
    <#else>
      <#assign casServerName="https://${dependencies.GUARDIAN['guardian.server.cas.server.host']}:${casServerSslPort}">
    </#if>
    <#assign casServerUrl="${casServerName}${dependencies.GUARDIAN['cas.server.context.path']}">
  <@property "tdt.cas.enable" "true"/>
  <@property "tdt.cas.server.url" "${casServerUrl}"/>
  <@property "tdt.cas.centrallogout.flag" "true"/>
<#else>
  <@property "tdt.cas.enable" "false"/>
</#if>

<#--handle dependent.zookeeper-->
<#if dependencies.ZOOKEEPER??>
    <#assign zookeeper=dependencies.ZOOKEEPER quorum=[]>
    <#list zookeeper.roles.ZOOKEEPER as role>
        <#assign quorum += [role.hostname]>
    </#list>
    <@property "tdt.zookeeper.quorum" quorum?join(",")/>
</#if>

<#--Take properties from the context-->
<#list service['tdt-site.xml'] as key, value>
   <@property key value/>
</#list>


</configuration>
