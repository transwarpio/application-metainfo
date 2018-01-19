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
        <#assign es_nodes+=[(server.hostname + ":" + dependencies.SEARCH["http.port"])]>
    </#list>
    <@property "discovery.zen.minimum_master_nodes" "${dependencies.SEARCH['discovery.zen.minimum_master_nodes']}"/>
    <@property "discovery.zen.ping.unicast.hosts" "${es_nodes?join(',')}"/>
    <@property "cluster.name" "${dependencies.SEARCH['cluster.name']}"/>
</#if>

<@property "hbase.regionserver.replication.handler.count" service['hbase.regionserver.replication.handler.count']/>
<@property "hbase.partition.ignore.unavailable.clusters" service['hbase.partition.ignore.unavailable.clusters']/>
<@property "hbase.hstore.blockingStoreFiles" service['hbase.hstore.blockingStoreFiles']/>
<@property "hbase.sservice.search.poolsize" service['hbase.sservice.search.poolsize']/>
<@property "hbase.sservice.handler.count" service['hbase.sservice.handler.count']/>
<@property "hbase.sservice.local.cacheinterval" service['hbase.sservice.local.cacheinterval']/>
<@property "hbase.regionserver.fileSplitTimeout" service['hbase.regionserver.fileSplitTimeout']/>
<@property "hbase.hregion.max.filesize" service['hbase.hregion.max.filesize']/>
<@property "hbase.client.scanner.caching" service['hbase.client.scanner.caching']/>
<@property "hbase.sservice.scheduler.poolsize" service['hbase.sservice.scheduler.poolsize']/>
<@property "hbase.abort.disconected.batchmutate" service['hbase.abort.disconected.batchmutate']/>
<@property "hbase.master.distributed.log.replay" service['hbase.master.distributed.log.replay']/>
<@property "hbase.assignment.timeout.management" service['hbase.assignment.timeout.management']/>
<@property "hbase.zookeeper.leaderport" service['hbase.zookeeper.leaderport']/>
<@property "hbase.balancer.period" service['hbase.balancer.period']/>
<@property "hbase.regionserver.handler.count" service['hbase.regionserver.handler.count']/>
<@property "hbase.client.operation.timeout" service['hbase.client.operation.timeout']/>
<@property "hbase.zookeeper.property.maxClientCnxns" service['hbase.zookeeper.property.maxClientCnxns']/>
<@property "hbase.sservice.scheduler.frequency" service['hbase.sservice.scheduler.frequency']/>
<@property "hbase.sservice.port" service['hbase.sservice.port']/>
<@property "hbase.regionserver.lease.period" service['hbase.regionserver.lease.period']/>
<@property "zookeeper.session.timeout" service['zookeeper.session.timeout']/>
<@property "dfs.support.append" service['dfs.support.append']/>
<@property "hbase.rpc.timeout" service['hbase.rpc.timeout']/>
<@property "hbase.sservice.table.localrate" service['hbase.sservice.table.localrate']/>
<@property "hbase.sservice.local.mergeinterval" service['hbase.sservice.local.mergeinterval']/>
<@property "hbase.zookeeper.peerport" service['hbase.zookeeper.peerport']/>
<@property "hbase.hregion.memstore.mslab.enabled" service['hbase.hregion.memstore.mslab.enabled']/>
<@property "hbase.regionserver.global.memstore.upperLimit" service['hbase.regionserver.global.memstore.upperLimit']/>
<@property "hbase.hregion.memstore.chunkpool.maxsize" service['hbase.hregion.memstore.chunkpool.maxsize']/>
<@property "hbase.sservice.tolerable.timediff" service['hbase.sservice.tolerable.timediff']/>
<@property "hbase.lightweight.snapshotmanager.enable" service['hbase.lightweight.snapshotmanager.enable']/>
<@property "hbase.master.assignment.timeoutmonitor.period" service['hbase.master.assignment.timeoutmonitor.period']/>
<@property "hbase.hregion.memstore.flush.size" service['hbase.hregion.memstore.flush.size']/>
<@property "hbase.sservice.scan.pagesize" service['hbase.sservice.scan.pagesize']/>
<@property "hbase.use.partition.table" service['hbase.use.partition.table']/>
<@property "hbase.client.scanner.timeout.period" service['hbase.client.scanner.timeout.period']/>
<@property "hbase.regionserver.info.bindAddress" service['hbase.regionserver.info.bindAddress']/>
<@property "hfile.block.cache.size" service['hfile.block.cache.size']/>
<@property "hbase.regions.slop" service['hbase.regions.slop']/>
<@property "hbase.cluster.distributed" service['hbase.cluster.distributed']/>
<@property "hbase.regionserver.global.memstore.lowerLimit" service['hbase.regionserver.global.memstore.lowerLimit']/>
<@property "hbase.hregion.majorcompaction.cron" service['hbase.hregion.majorcompaction.cron']/>
<@property "hbase.master.balancer.stochastic.maxRunningTime" service['hbase.master.balancer.stochastic.maxRunningTime']/>
<@property "hbase.master.balancer.regionLocationCacheTime" service['hbase.master.balancer.regionLocationCacheTime']/>

<#--Take properties from the context-->
<#if service['hbase-site.xml']??>
<#list service['hbase-site.xml'] as key, value>
    <@property key value/>
</#list>
</#if>
</configuration>
