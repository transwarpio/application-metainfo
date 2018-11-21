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

<#assign master_group=[]>
<#list service.roles.SHIVA_MASTER as master>
    <#assign master_group += [master.ip + ":" + service['shiva.master.rpc_service.master_service_port']]>
</#list>
<@property "ngmr.holodesk.shiva.mastergroup" master_group?join(",")/>

<#--TODO hardcoded port 19998-->
<#assign scheme='ladder://' host=service.roles.LADDER_MASTER[0]['hostname'] port='19998'>
<@property "fs.defaultFS" scheme + host + ':' + port/>

<#--handle dependent.zookeeper-->
<#if dependencies.ZOOKEEPER??>
    <#assign zookeeper=dependencies.ZOOKEEPER quorum=[]>
    <#list zookeeper.roles.ZOOKEEPER as role>
        <#assign quorum += [role.hostname]>
    </#list>
    <@property "hive.zookeeper.quorum" quorum?join(",")/>
    <@property "hbase.zookeeper.quorum" quorum?join(",")/>
    <@property "holodesk.zookeeper.quorum" quorum?join(",")/>
    <@property "zookeeper.znode.parent" "/${service.sid}" />
</#if>

<#-- handle the kerberos-->
<#assign  authentication="NONE">
<#if service.auth == "kerberos">
    <#assign  authentication="KERBEROS">
    <@property "hive.metastore.sasl.enabled" "true"/>
    <@property "hive.metastore.kerberos.keytab.file" service.keytab/>
    <@property "hive.metastore.kerberos.principal" "hive/_HOST@" + service.realm/>
    <@property "yarn.resourcemanager.principal" "yarn/_HOST@" + service.realm/>
    <#--<@property "transwarp.docker.inceptor" service.roles.INCEPTOR_SERVER[0]['hostname'] + ':' + service['hive.server2.thrift.port']/>-->
    <@property "hive.server2.authentication.kerberos.principal"  "hive/_HOST@" + service.realm/>
    <@property "hive.server2.authentication.kerberos.keytab" service.keytab/>
</#if>
<#if service['hive.server2.authentication'] == "LDAP">
    <#assign  authentication="LDAP">
    <#assign  guardian=dependencies.GUARDIAN guardian_servers=[]>
    <#list guardian.roles["GUARDIAN_APACHEDS"] as role>
        <#assign guardian_servers += [("ldap://" + role.hostname + ":" + guardian["guardian.apacheds.ldap.port"])]>
    </#list>
    <@property "hive.server2.authentication.ldap.baseDN", "ou=People,${service.domain}"/>
    <@property "hive.server2.authentication.ldap.extra.baseDNs", "ou=System,ou=People,${service.domain}"/>
    <@property "hive.server2.authentication.ldap.url" "${guardian_servers?join(' ')}"/>
</#if>

<#if dependencies.GUARDIAN?? && dependencies.GUARDIAN.roles.CAS_SERVER??>
    <#assign  guardian=dependencies.GUARDIAN guardian_servers=[]>
    <#list guardian.roles["GUARDIAN_SERVER"] as role>
        <#assign guardian_servers += [("https://" + role.hostname + ":" + guardian["guardian.server.port"])]>
    </#list>
    <@property "hive.server2.authentication.guardian.url" "${guardian_servers?join(' ')}"/>
    <@property "hive.server2.authentication.cas.prefix" 'https://' + guardian.roles.CAS_SERVER[0]['hostname'] + ':' + guardian['cas.server.ssl.port'] + guardian['cas.server.context.path']/>
</#if>

<#assign  manager="NONE">
<#if authentication != "NONE">
    <@property "hive.server2.authentication" authentication/>
    <@property "hive.security.authenticator.manager" "org.apache.hadoop.hive.ql.security.SessionStateUserAuthenticator"/>
    <@property "hive.security.authorization.enabled" "true"/>
    <#assign  manager="org.apache.hadoop.hive.ql.security.authorization.plugin.sqlstd.SQLStdHiveAuthorizerFactory">
</#if>
<#if service.plugins?seq_contains("guardian")>
    <@property "hive.metastore.event.listeners" "io.transwarp.guardian.plugins.inceptor.GuardianMetaStoreListener,io.transwarp.guardian.binding.metastore.GuardianMetaStoreNotificationLogListener"/>
    <@property "plsql.link.hooks" "org.apache.hadoop.hive.ql.pl.parse.hooks.PLAnonExecHook"/>
    <@property "hive.exec.pre.hooks" "io.transwarp.guardian.plugins.inceptor.GuardianPLFunctionHook"/>
    <#assign  manager="io.transwarp.guardian.plugins.inceptor.GuardianHiveAuthorizerFactory">
</#if>
<#if manager != "NONE">
    <@property "hive.security.authorization.manager" manager/>
</#if>

<#-- handle inceptor scheduler -->
<#if service['inceptor.scheduler.enabled'] = "true">
    <@property "inceptor.scheduler.enabled" "true"/>
    <#if service.plugins?seq_contains("guardian")>
        <@property "spark.guardian.enabled" "true"/>
    <#else>
        <@property "inceptor.scheduler.config" "/etc/${service.sid}/conf/inceptor-scheduler.xml"/>
    </#if>
<#else>
    <@property "inceptor.scheduler.enabled" "false"/>
    <#if service.plugins?seq_contains("guardian")>
        <@property "spark.guardian.enabled" "true"/>
    </#if>
</#if>

<#if service.plugins?seq_contains("governor")>
    <@property "hive.exec.post.hooks" "org.apache.atlas.hive.hook.HivePostHook"/>
    <@property "hive.exec.failure.hooks" "org.apache.atlas.hive.hook.HiveFailHook"/>
    <@property "atlas.cluster.name" "${service.sid}"/>
</#if>

<#if dependencies.TXSQL??>
    <#assign mysqlHostPorts = []/>
    <#list dependencies.TXSQL.roles['TXSQL_SERVER'] as role>
        <#assign mysqlHostPorts = mysqlHostPorts + [role.hostname + ':' + dependencies.TXSQL['mysql.rw.port']]>
    </#list>
<#else>
    <#assign mysqlHostPorts = [service.roles.INCEPTOR_MYSQL[0]['hostname'] + ":" + service['mysql.port']]/>
</#if>

    <#assign dbconnectionstring="jdbc:mysql://" + mysqlHostPorts?join(",") + "/metastore_" + service.sid + "?createDatabaseIfNotExist=true&amp;user=" + service['javax.jdo.option.ConnectionUserName'] + "&amp;password=" + service['javax.jdo.option.ConnectionPassword'] + "&amp;characterEncoding=UTF-8" + "&amp;failOverReadOnly=false">
    <@property "hive.stats.dbconnectionstring" dbconnectionstring/>
    <@property "inceptor.ui.port" "${service['inceptor.ui.port']}"/>
<#assign uris = []/>
<#if dependencies.INCEPTOR??>
    <#list dependencies.INCEPTOR.roles["INCEPTOR_METASTORE"] as role>
        <#assign uris += [("thrift://" + role.hostname + ":" + dependencies.INCEPTOR["hive.metastore.port"])]>
    </#list>
    <@property "hive.metastore.service.id" "${dependencies.INCEPTOR.sid}"/>
<#else>
    <#list service.roles["INCEPTOR_METASTORE"] as role>
        <#assign uris += [("thrift://" + role.hostname + ":" + service["hive.metastore.port"])]>
    </#list>
</#if>
    <@property "hive.metastore.uris" uris?join(",")/>
    <#assign connectionURL="jdbc:mysql://" + mysqlHostPorts?join(",") + "/metastore_" + service.sid + "?failOverReadOnly=false&amp;createDatabaseIfNotExist=false&amp;characterEncoding=UTF-8">
    <@property "javax.jdo.option.ConnectionURL" connectionURL/>
    <#if dependencies.LICENSE_SERVICE??>
    <#assign  license=dependencies.LICENSE_SERVICE license_servers=[]>
    <#list license.roles["LICENSE_NODE"] as role>
        <#assign license_servers += [(role.hostname + ":" + license[role.hostname]["zookeeper.client.port"])]>
    </#list>
    <@property "license.zookeeper.quorum" license_servers?join(",")/>
    </#if>

<#-- handle dependency -->
    <@property "hive.service.type" "INCEPTOR"/>
    <@property "hive.service.id" "${service.sid}"/>
<#--Take properties from the context-->
<#list service['hive-site.xml'] as key, value>
    <@property key value/>
</#list>
</configuration>
