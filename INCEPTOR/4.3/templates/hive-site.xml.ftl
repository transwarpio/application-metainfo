<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<#--Simple macro definition-->
<#macro property key value>
<property>
    <name>${key}</name>
    <value>${value}</value>
</property>
</#macro>
<#--------------------------->
<#assign auth=service.auth>
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

<#-- TODO handle the kerberos-->
<#if auth == "kerberos">
    <@property "hadoop.security.authentication" auth/>
    <#if service["hadoop.http.authentication.type"]=="kerberos">
    <@property "hadoop.http.filter.initializers" "org.apache.hadoop.security.AuthenticationFilterInitializer"/>
    <@property "hadoop.http.authentication.simple.anonymous.allowed" "false"/>
    <#assign realm=service['kerberos.realm'] principal="HTTP/" + localhostname?lower_case + "@" + realm>
    <@property "hadoop.http.authentication.kerberos.principal" principal/>
    <@property "hadoop.http.authentication.kerberos.keytab" "/etc/"+ fsid + "/hdfs.keytab"/>
    <@property "hadoop.http.authentication.signature.secret.file" "/etc/hadoop-http-auth-signature-secret"/>
    </#if>
</#if>

<#if dependencies.TXSQL??>
    <#assign mysqlHostPorts = []/>
    <#list dependencies.TXSQL.roles['TXSQL_SERVER'] as role>
        mysqlHostPorts = mysqlHostPorts + [role.hostname + ':' + dependencies.TXSQL['mysql.rw.port']]
    </#list>
<#else>
    <#assign mysqlHostPorts = [service.roles.INCEPTOR_MYSQL[0]['hostname'] + ":" + service['mysql.port']]/>
</#if>

    <#assign dbconnectionstring="jdbc:mysql://" + mysqlHostPorts?join(",") + "/metastore_" + service.sid + "?createDatabaseIfNotExist=true&amp;user=hiveuser&amp;password=password&amp;characterEncoding=UTF-8">
    <@property "hive.stats.dbconnectionstring" dbconnectionstring/>
    <#assign scratchdir="hdfs://" + dependencies.HDFS.nameservices[0] + "/" + service.sid + "/tmp/hive">
    <@property "hive.exec.scratchdir" scratchdir/>
    <#assign uris="thrift://" + service.roles.INCEPTOR_METASTORE[0]['hostname'] + ":" + service['hive.metastore.port']>
    <@property "hive.metastore.uris" uris/>
    <#assign tracker=service.roles.INCEPTOR_METASTORE[0]['hostname'] + ":8031">
    <@property "mapred.job.tracker" tracker/>
    <#assign connectionURL="jdbc:mysql://" + service.roles.INCEPTOR_MYSQL[0]['hostname'] + ":" + service['mysql.port'] + "/metastore_" + service.sid + "?createDatabaseIfNotExist=false&amp;characterEncoding=UTF-8">
    <@property "javax.jdo.option.ConnectionURL" connectionURL/>
    <#if dependencies.LICENSE_SERVICE??>
    <#assign  license=dependencies.LICENSE_SERVICE license_servers=[]>
    <#list license.roles["LICENSE_NODE"] as role>
        <#assign license_servers += [(role.hostname + ":" + license[role.hostname]["zookeeper.client.port"])]>
    </#list>
    <@property "license.zookeeper.quorum" license_servers?join(",")/>
    </#if>
    <#assign inceptor=service.roles.INCEPTOR_SERVER[0]['hostname'] + ":" + service['hive.server2.thrift.port']>
    <@property "transwarp.docker.inceptor" inceptor/>

<#--Take properties from the context-->
<#list service['hive-site.xml'] as key, value>
    <@property key value/>
</#list>
</configuration>
