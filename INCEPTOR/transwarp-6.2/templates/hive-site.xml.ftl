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

<#--handle dependent.shiva-->
<#if dependencies.SHIVA??>
    <#assign shiva=dependencies.SHIVA master_group=[]>
    <#list shiva.roles.SHIVA_MASTER as master>
        <#assign master_group += [master.ip + ":" + shiva['master.rpc_service.master_service_port']]>
    </#list>
    <@property "ngmr.holodesk.shiva.mastergroup" master_group?join(",")/>
</#if>

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
    <@property "hive.server2.authentication.ldap.extra.baseDNs", "ou=System,ou=People,${service.domain}"/>
    <@property "hive.server2.authentication.ldap.url" "${guardian_servers?join(' ')}"/>
</#if>

<#if dependencies.GUARDIAN?? && (service.auth == "kerberos" || service['hive.server2.authentication'] == "LDAP")>
    <#assign guardian=dependencies.GUARDIAN>

    <#if service.plugins?seq_contains("guardian")>
        <!-- enable spark ui when guardian plugin is enabled -->
        <@property "spark.ui.guardian.enabled" "${service['spark.ui.guardian.enabled']}"/>

        <#if dependencies.INCEPTOR??>
            <@property "spark.ui.authorization.guardian.component" "${dependencies.INCEPTOR.sid}"/>
        <#else>
            <@property "spark.ui.authorization.guardian.component" "${service.sid}"/>
        </#if>

        <#assign guardian_servers=[]>
        <#list guardian.roles["GUARDIAN_SERVER"] as role>
            <#assign guardian_servers += [(role.hostname + ":" + guardian["guardian.server.port"])]>
        </#list>
        <@property "spark.ui.authentication.accessToken.enabled" "${service['spark.ui.authentication.accessToken.enabled']}"/>
        <@property "spark.ui.authentication.accessToken.server.address" "${guardian_servers?join(' ')}"/>
        <@property "spark.ui.authentication.accessToken.server.tls.enabled" "${guardian['guardian.server.tls.enabled']}"/>

        <#if guardian.roles["CAS_SERVER"]??>
            <#assign casServerSslPort=guardian['cas.server.ssl.port']>
            <#if guardian['guardian.server.cas.server.host']?matches("^\\s*$")>
                <#assign casServerName="https://${guardian.roles.CAS_SERVER[0]['ip']}:${casServerSslPort}">
            <#else>
                <#assign casServerName="https://${guardian['guardian.server.cas.server.host']}:${casServerSslPort}">
            </#if>
            <#assign casServerPrefix="${casServerName}${guardian['cas.server.context.path']}">
            <@property "spark.ui.authentication.cas.enabled" "${service['spark.ui.authentication.cas.enabled']}"/>
            <@property "spark.ui.authentication.cas.server.url.prefix" "${casServerPrefix}"/>
            <@property "spark.ui.authentication.cas.server.login.url" "${casServerPrefix}/login"/>
        </#if>

        <#if guardian.roles['GUARDIAN_FEDERATION']??>
            <@property "spark.ui.authentication.oauth2.enabled" "${service['spark.ui.authentication.oauth2.enabled']}"/>
        </#if>
    </#if>

    <#if guardian.roles['GUARDIAN_FEDERATION']??>
        <@property "hive.server2.authentication.oauth2.enabled" "${service['hive.server2.authentication.oauth2.enabled']}"/>
    </#if>

    <#assign guardian_servers=[]>
    <#list guardian.roles["GUARDIAN_SERVER"] as role>
        <#assign guardian_servers += [("https://" + role.hostname + ":" + guardian["guardian.server.port"])]>
    </#list>
    <@property "hive.server2.authentication.guardian.url" "${guardian_servers?join(' ')}"/>

    <#if guardian.roles['CAS_SERVER']??>
        <@property "hive.server2.authentication.cas.prefix" 'https://' + guardian.roles.CAS_SERVER[0]['hostname'] + ':' + guardian['cas.server.ssl.port'] + guardian['cas.server.context.path']/>
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
    <#assign mysqlHostPorts = mysqlHostPorts?sort
             i = mysqlHostPorts?seq_index_of(localhostname + ':' + dependencies.TXSQL['mysql.rw.port'])>
    <#if i lt 0>
        <#assign i = .now?long % dependencies.TXSQL.roles['TXSQL_SERVER']?size>
    </#if>
    <#if i gt 0>
        <#assign mysqlHostPorts = mysqlHostPorts[i..] + mysqlHostPorts[0..i-1]>
    </#if>
<#else>
    <#assign mysqlHostPorts = [service.roles.INCEPTOR_MYSQL[0]['hostname'] + ":" + service['mysql.port']]/>
</#if>

    <#assign dbconnectionstring="jdbc:mysql://" + mysqlHostPorts?join(",") + "/metastore_" + service.sid + "?createDatabaseIfNotExist=true&amp;user=" + service['javax.jdo.option.ConnectionUserName'] + "&amp;password=" + service['javax.jdo.option.ConnectionPassword'] + "&amp;characterEncoding=UTF-8" + "&amp;failOverReadOnly=false">
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
<#assign i = -1>
<#list uris as uri>
    <#if uri?contains(localhostname)>
        <#assign i=uri?index>
        <#break>
    </#if>
</#list>
<#if i lt 0>
    <#assign i = .now?long % uris?size>
</#if>
<#if i gt 0>
    <#assign uris = uris[i..] + uris[0..i-1]>
</#if>
    <@property "hive.metastore.uris" uris?join(",")/>
<#if dependencies.YARN??>
    <#assign rmHostPorts = []/>
    <#list dependencies.YARN.roles["YARN_RESOURCEMANAGER"] as role>
        <#assign rmHostPorts += [(role.hostname + ":" + dependencies.YARN["resourcemanager.resource-tracker.port"])]>
    </#list>
    <@property "mapred.job.tracker" rmHostPorts?join(",")/>
</#if>
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
    <#if dependencies.HYPERBASE?? && service.auth = "kerberos">
    <@property "hbase.regionserver.kerberos.principal" "hbase/_HOST@${service.realm}"/>
    <@property "hbase.master.kerberos.principal" "hbase/_HOST@${service.realm}"/>
    <@property "hbase.security.authentication" "kerberos"/>
    </#if>
    <#if dependencies.SEARCH??>
    <#assign es_nodes=[]>
    <#list dependencies.SEARCH.roles.SEARCH_SERVER as server>
        <#assign es_nodes+=[(server.hostname + ":" + dependencies.SEARCH[server.id?c]['transport.tcp.port'])]>
    </#list>
    <@property "discovery.zen.minimum_master_nodes" "${dependencies.SEARCH['discovery.zen.minimum_master_nodes']}"/>
    <@property "discovery.zen.ping.unicast.hosts" "${es_nodes?join(',')}"/>
    <@property "cluster.name" "${dependencies.SEARCH['cluster.name']}"/>
    </#if>
    <@property "hive.service.type" "INCEPTOR"/>
    <@property "hive.service.id" "${service.sid}"/>
<#--Take properties from the context-->
<#list service['hive-site.xml'] as key, value>
    <@property key value/>
</#list>
</configuration>
