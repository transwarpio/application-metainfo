<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<#--Simple macro definition-->
<#macro property key value>
<property>
  <name>${key}</name>
  <value>${value}</value>
</property>
</#macro>
<configuration>
  <#assign inceptor_server = dependencies.INCEPTOR.roles.INCEPTOR_SERVER[0]['hostname']>
  <#assign inceptor_url = inceptor_server + ":" + dependencies.INCEPTOR['hive.server2.thrift.port']>
  <@property "tdt.inceptor.address" "${inceptor_url}"/>

<#if dependencies.INCEPTOR.auth="kerberos">
  <@property "tdt.inceptor.principal" "hive/${inceptor_server}@${service.realm}"/>
	 <#if dependencies.INCEPTOR['hive.server2.authentication'] == "LDAP">
    <@property "tdt.inceptor.auth.mode" "LDAP"/>
	 <#else>
    <@property "tdt.inceptor.auth.mode" "KERBEROS"/>
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
  <@property "tdt.server.principal" "tdt/${localhostname?lower_case}@${service.realm}"/>
  <@property "tdt.server.keytab" "${service.keytab}"/>
  <#assign casServerUrl="https://${dependencies.GUARDIAN.roles.CAS_SERVER[0]['hostname']}:${dependencies.GUARDIAN['cas.server.ssl.port']}${dependencies.GUARDIAN['cas.server.context.path']}">
  <@property "tdt.cas.enable" "true"/>
  <@property "tdt.cas.server.url" "${casServerUrl}"/>
<#else>
  <@property "tdt.cas.enable" "false"/>
</#if>

<#--Take properties from the context-->
<#list service['tdt-site.xml'] as key, value>
	 <@property key value/>
</#list>
</configuration>
