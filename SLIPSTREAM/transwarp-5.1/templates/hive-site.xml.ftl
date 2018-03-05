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

<#--handle dependent.zookeeper-->
<#if dependencies.ZOOKEEPER??>
    <#assign zookeeper=dependencies.ZOOKEEPER quorum=[]>
    <#list zookeeper.roles.ZOOKEEPER as role>
        <#assign quorum += [role.hostname]>
    </#list>
    <@property "hive.zookeeper.quorum" quorum?join(",")/>
    <@property "hbase.zookeeper.quorum" quorum?join(",")/>
    <@property "holodesk.zookeeper.quorum" quorum?join(",")/>
    <@property "zookeeper.znode.parent" "/" + (dependencies.HYPERBASE??)?then(dependencies.HYPERBASE.sid, service.sid)/>
</#if>

<#-- handle the kerberos-->
<#assign  authentication="NONE">
<#if service.auth == "kerberos">
    <#assign  authentication="KERBEROS">
    <@property "hive.metastore.sasl.enabled" "true"/>
    <@property "hive.metastore.kerberos.keytab.file" service.keytab/>
    <@property "hive.metastore.kerberos.principal" "hive/_HOST@" + service.realm/>
    <@property "yarn.resourcemanager.principal" "yarn/_HOST@" + service.realm/>
    <@property "transwarp.docker.inceptor" service.roles.INCEPTOR_SERVER[0]['hostname'] + ':' + service['hive.server2.thrift.port']/>
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
    <@property "hive.server2.authentication.ldap.url" "${guardian_servers?join(' ')}"/>
  <#if service.plugins?seq_contains("guardian")>
    <#assign  authentication="CUSTOM">
    <@property "hive.server2.custom.authentication.class" "io.transwarp.guardian.plugins.inceptor.GuardianLdapAuthProviderImpl"/>
  </#if>
</#if>
<#assign  manager="NONE">
<#if authentication != "NONE">
    <@property "hive.server2.authentication" authentication/>
    <@property "hive.security.authenticator.manager" "org.apache.hadoop.hive.ql.security.SessionStateUserAuthenticator"/>
    <@property "hive.security.authorization.enabled" "true"/>
    <#assign  manager="org.apache.hadoop.hive.ql.security.authorization.plugin.sqlstd.SQLStdHiveAuthorizerFactory">
</#if>
<#if service.plugins?seq_contains("guardian")>
    <@property "hive.service.id" service.sid/>
    <@property "hive.metastore.event.listeners" "io.transwarp.guardian.plugins.inceptor.GuardianMetaStoreListener"/>
    <#assign  manager="io.transwarp.guardian.plugins.inceptor.GuardianHiveAuthorizerFactory">
</#if>
<#if manager != "NONE">
    <@property "hive.security.authorization.manager" manager/>
</#if>

<#-- handle inceptor scheduler -->
<#if service.plugins?seq_contains("guardian")>
    <@property "spark.guardian.enabled" "true"/>
</#if>
<#if service['inceptor.scheduler.enabled'] = "true">
    <@property "inceptor.scheduler.enabled" "true"/>
    <@property "inceptor.scheduler.config" "/etc/${service.sid}/conf/inceptor-scheduler.xml"/>
<#else>
    <@property "inceptor.scheduler.enabled" "false"/>
</#if>

<#if dependencies.TXSQL??>
    <#assign mysqlHostPorts = []/>
    <#list dependencies.TXSQL.roles['TXSQL_SERVER'] as role>
        <#assign mysqlHostPorts = mysqlHostPorts + [role.hostname + ':' + dependencies.TXSQL['mysql.rw.port']]>
    </#list>
<#else>
    <#assign mysqlHostPorts = [service.roles.INCEPTOR_MYSQL[0]['hostname'] + ":" + service['mysql.port']]/>
</#if>

    <#assign dbconnectionstring="jdbc:mysql://" + mysqlHostPorts?join(",") + "/metastore_" + service.sid + "?createDatabaseIfNotExist=true&amp;user=" + service['javax.jdo.option.ConnectionUserName'] + "&amp;password=" + service['javax.jdo.option.ConnectionPassword'] + "&amp;characterEncoding=UTF-8">
    <@property "hive.stats.dbconnectionstring" dbconnectionstring/>
    <#assign scratchdir="hdfs://" + dependencies.HDFS.nameservices[0] + "/" + service.sid + "/tmp/hive">
    <@property "hive.exec.scratchdir" scratchdir/>
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
<#if dependencies.YARN??>
    <#assign rmHostPorts = []/>
    <#list dependencies.YARN.roles["YARN_RESOURCEMANAGER"] as role>
        <#assign rmHostPorts += [(role.hostname + ":" + dependencies.YARN["resourcemanager.resource-tracker.port"])]>
    </#list>
    <@property "mapred.job.tracker" rmHostPorts?join(",")/>
</#if>
    <#assign connectionURL="jdbc:mysql://" + mysqlHostPorts?join(",") + "/metastore_" + service.sid + "?createDatabaseIfNotExist=false&amp;characterEncoding=UTF-8">
    <@property "javax.jdo.option.ConnectionURL" connectionURL/>
    <#if dependencies.LICENSE_SERVICE??>
    <#assign license=dependencies.LICENSE_SERVICE license_servers=[]>
    <#list license.roles["LICENSE_NODE"] as role>
        <#assign license_servers += [(role.hostname + ":" + license[role.hostname]["zookeeper.client.port"])]>
    </#list>
    <@property "license.zookeeper.quorum" license_servers?join(",")/>
    </#if>

<#-- handle dependency -->
    <#if dependencies.HYPERBASE?? && service.auth = "kerberos">
    <@property "hbase.regionserver.kerberos.principal" "hbase/_HOST@${service.realm}"/>
    <@property "hbase.master.kerberos.principal" "hbase/_HOST@${service.realm}"/>
    <@property "hbase.security.authentication" "kerberos"/>
    </#if>
    <#if dependencies.SEARCH??>
    <#assign es_nodes=[]>
    <#list dependencies.SEARCH.roles.SEARCH_SERVER as server>
        <#assign es_nodes+=[(server.hostname + ":" + dependencies.SEARCH["http.port"])]>
    </#list>
    <@property "discovery.zen.minimum_master_nodes" "${dependencies.SEARCH['discovery.zen.minimum_master_nodes']}"/>
    <@property "discovery.zen.ping.unicast.hosts" "${es_nodes?join(',')}"/>
    <@property "cluster.name" "${dependencies.SEARCH['cluster.name']}"/>
    </#if>
    <@property "hive.service.type" "SLIPSTREAM"/>
<#--Take properties from the context-->
<#list service['hive-site.xml'] as key, value>
    <@property key value/>
</#list>
</configuration>
