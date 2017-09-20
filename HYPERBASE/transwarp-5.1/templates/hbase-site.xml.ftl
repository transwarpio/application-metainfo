<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<#--Simple macro definition-->
<#macro property key value>
<property>
    <name>${key}</name>
    <value>${value}</value>
</property>
</#macro>
<#--------------------------->
<#assign
    sid=service.sid
>
<configuration>

<#--handle dependent.zookeeper-->
<#if dependencies.ZOOKEEPER??>
    <#assign zookeeper=dependencies.ZOOKEEPER quorum=[]>
    <#list zookeeper.roles.ZOOKEEPER as role>
        <#assign quorum += [role.hostname]>
    </#list>
    <@property "hbase.zookeeper.quorum" quorum?join(",")/>
    <@property "zookeeper.znode.parent" "/" + sid/>
</#if>

<#-- TODO handle the kerberos-->
<#assign coprocessorRegion=""/>
<#assign coprocessorMaster=""/>
<#if service.auth == "kerberos">
    <@property "hbase.security.authentication" "kerberos"/>
    <@property "hbase.rpc.engine" "org.apache.hadoop.hbase.ipc.SecureRpcEngine"/>
    <@property "hbase.regionserver.kerberos.principal" "hbase/_HOST@" + service.realm/>
    <@property "hbase.regionserver.keytab.file" service.keytab/>
    <@property "hbase.master.kerberos.principal" "hbase/_HOST@" + service.realm/>
    <@property "hbase.master.keytab.file" service.keytab/>
    <@property "hbase.thrift.kerberos.principal"  "hbase/_HOST@" + service.realm/>
    <@property "hbase.thrift.keytab.file" service.keytab/>
    <@property "hbase.thrift.security.qop" "auth-conf"/>
    <@property "hbase.rest.kerberos.principal" "hbase/_HOST@" + service.realm/>
    <@property "hbase.rest.keytab.file" service.keytab/>
    <@property "hbase.rest.authentication.kerberos.principal" "hbase/_HOST@" + service.realm/>
    <@property "hbase.rest.authentication.kerberos.keytab" service.keytab/>
    <@property "hbase.security.authorization" "true"/>
    <#assign coprocessorRegion=",org.apache.hadoop.hbase.security.token.TokenProvider,org.apache.hadoop.hbase.security.access.AccessController,org.apache.hadoop.hbase.security.access.SecureBulkLoadEndpoint"/>
    <#assign coprocessorMaster=",org.apache.hadoop.hbase.security.access.AccessController"/>
</#if>

<#if service.plugins?seq_contains("guardian")>
    <@property "hbase.service.id" service.sid/>
    <#assign coprocessorRegion=",org.apache.hadoop.hbase.security.token.TokenProvider,io.transwarp.guardian.plugins.hyperbase.GuardianAccessController,org.apache.hadoop.hbase.security.access.SecureBulkLoadEndpoint"/>
    <#assign coprocessorMaster=",io.transwarp.guardian.plugins.hyperbase.GuardianAccessController"/>
</#if>

    <#assign esRegionCoprocessor=dependencies.SEARCH???string(",org.apache.hadoop.hyperbase.fulltextindex.coprocessor.EsRegionCoprocessor", "")>
    <@property "hbase.coprocessor.region.classes" service['hbase.coprocessor.region.classes'] + esRegionCoprocessor + coprocessorRegion/>
    <@property "hbase.coprocessor.master.classes" service['hbase.coprocessor.master.classes'] + coprocessorMaster/>

    <#assign path="hdfs://" + dependencies.HDFS.nameservices[0] + "/" + service.sid + "_hregionindex">
    <@property "hregion.index.path" path/>
    <#assign rootdir="hdfs://" + dependencies.HDFS.nameservices[0] + "/" + service.sid>
    <@property "hbase.rootdir" rootdir/>
    <#assign dir="hdfs://" + dependencies.HDFS.nameservices[0] + "/" + service.sid + "/hbase_timediff">
    <@property "hbase.sservice.hdfs.dir" dir/>
    <#if dependencies.LICENSE_SERVICE??>
    <#assign  license=dependencies.LICENSE_SERVICE license_servers=[]>
    <#list license.roles["LICENSE_NODE"] as role>
        <#assign license_servers += [(role.hostname + ":" + license[role.hostname]["zookeeper.client.port"])]>
    </#list>
    <@property "license.zookeeper.quorum" license_servers?join(",")/>
    </#if>
    <@property "hbase.master.port" service['master.port']/>
    <@property "hbase.master.info.port" service['master.info.port']/>
    <@property "hbase.regionserver.port" service['regionserver.port']/>
    <@property "hbase.regionserver.info.port" service['regionserver.info.port']/>
    <@property "hbase.master.report.ip" "false"/>
    <@property "hbase.regionserver.report.ip" "false"/>
<#if dependencies.SEARCH??>
    <#assign es_nodes=[]>
    <#list dependencies.SEARCH.roles.SEARCH_SERVER as server>
        <#assign es_nodes+=[server.hostname]>
    </#list>
    <@property "discovery.zen.minimum_master_nodes" "${dependencies.SEARCH['discovery.zen.minimum_master_nodes']}"/>
    <@property "discovery.zen.ping.unicast.hosts" "${es_nodes?join(',')}"/>
    <@property "discovery.zen.ping.multicast.enabled" "${dependencies.SEARCH['discovery.zen.ping.multicast.enabled']}"/>
    <@property "cluster.name" "${dependencies.SEARCH['cluster.name']}"/>
</#if>
<#--Take properties from the context-->
<#list service['hbase-site.xml'] as key, value>
    <@property key value/>
</#list>
</configuration>
