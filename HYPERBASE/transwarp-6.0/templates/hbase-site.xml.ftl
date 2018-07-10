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
    <#assign coprocessorRegion=",org.apache.hadoop.hbase.security.token.TokenProvider,org.apache.hadoop.hbase.security.access.GuardianAccessController,org.apache.hadoop.hbase.security.access.SecureBulkLoadEndpoint"/>
    <#assign coprocessorMaster=",org.apache.hadoop.hbase.security.access.GuardianAccessController"/>
</#if>

    <#assign esRegionCoprocessor=dependencies.SEARCH???string(",org.apache.hadoop.hyperbase.fulltextindex.coprocessor.EsRegionCoprocessor", "")>
    <@property "hbase.coprocessor.region.classes" service['hbase.coprocessor.region.classes'] + esRegionCoprocessor + coprocessorRegion/>
    <@property "hbase.coprocessor.master.classes" coprocessorMaster/>

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
    <@property "hbase.regionserver.thrift.port" service['regionserver.thrift.port']/>
    <@property "hbase.thrift.info.port" service['thrift.info.port']/>
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
<@property "hbase.hregion.memstore.chunkpool.maxsize" service['hbase.hregion.memstore.chunkpool.maxsize']/>
<@property "hbase.sservice.tolerable.timediff" service['hbase.sservice.tolerable.timediff']/>
<@property "hbase.lightweight.snapshotmanager.enable" service['hbase.lightweight.snapshotmanager.enable']/>
<@property "hbase.master.assignment.timeoutmonitor.period" service['hbase.master.assignment.timeoutmonitor.period']/>
<@property "hbase.hregion.memstore.flush.size" service['hbase.hregion.memstore.flush.size']/>
<@property "hbase.sservice.scan.pagesize" service['hbase.sservice.scan.pagesize']/>
<@property "hbase.use.partition.table" service['hbase.use.partition.table']/>
<@property "hbase.client.scanner.timeout.period" service['hbase.client.scanner.timeout.period']/>
<@property "hbase.master.info.bindAddress" service['hbase.master.info.bindAddress']/>
<@property "hbase.regionserver.info.bindAddress" service['hbase.regionserver.info.bindAddress']/>
<@property "hbase.thrift.info.bindAddress" service['hbase.thrift.info.bindAddress']/>
<@property "hbase.master.ipc.address" service['hbase.master.ipc.address'] />
<@property "hbase.regionserver.ipc.address" service['hbase.regionserver.ipc.address'] />
<@property "hfile.block.cache.size" service['hfile.block.cache.size']/>
<@property "hbase.regions.slop" service['hbase.regions.slop']/>
<@property "hbase.cluster.distributed" service['hbase.cluster.distributed']/>
<@property "hbase.hregion.majorcompaction.cron" service['hbase.hregion.majorcompaction.cron']/>
<@property "hbase.master.balancer.stochastic.maxRunningTime" service['hbase.master.balancer.stochastic.maxRunningTime']/>
<@property "hbase.master.balancer.regionLocationCacheTime" service['hbase.master.balancer.regionLocationCacheTime']/>
<@property "hbase.regionserver.thread.split" service['hbase.regionserver.thread.split']/>
<@property "hbase.regionserver.hlog.blocksize" service['hbase.regionserver.hlog.blocksize']/>
<@property "hbase.regionserver.maxlogs" service['hbase.regionserver.maxlogs']/>
<@property "hbase.master.wait.on.regionservers.mintostart" service['hbase.master.wait.on.regionservers.mintostart']/>
<@property "hbase.regionserver.storefile.refresh.period" service['hbase.regionserver.storefile.refresh.period']/>
<@property "hbase.hstore.flusher.count" service['hbase.hstore.flusher.count']/>
<@property "hbase.master.preload.tabledescriptors" service['hbase.master.preload.tabledescriptors']/>
<@property "hbase.hregion.preclose.flush.size" service['hbase.hregion.preclose.flush.size']/>
<@property "hbase.hstore.compaction.kv.max" service['hbase.hstore.compaction.kv.max']/>
<@property "hbase.regionserver.thread.compaction.small" service['hbase.regionserver.thread.compaction.small']/>
<@property "hbase.regionserver.thread.compaction.large" service['hbase.regionserver.thread.compaction.large']/>
<@property "hbase.hstore.compaction.max.size" service['hbase.hstore.compaction.max.size']/>
<@property "hbase.hstore.compaction.min" service['hbase.hstore.compaction.min']/>
<@property "hbase.hstore.compaction.max" service['hbase.hstore.compaction.max']/>
<@property "hbase.hstore.compaction.ratio" service['hbase.hstore.compaction.ratio']/>
<@property "hbase.hregion.majorcompaction" service['hbase.hregion.majorcompaction']/>
<@property "hbase.hstore.defaultengine.compactionpolicy.class" service['hbase.hstore.defaultengine.compactionpolicy.class']/>
<@property "hbase.regionserver.global.memstore.size.lower.limit" service['hbase.regionserver.global.memstore.size.lower.limit']/>
<@property "hbase.regionserver.global.memstore.size" service['hbase.regionserver.global.memstore.size']/>
<@property "hbase.regionserver.thread.compaction.throttle" service['hbase.regionserver.thread.compaction.throttle']/>
<@property "hbase.hstore.blockingWaitTime" service['hbase.hstore.blockingWaitTime']/>
<@property "hbase.regionserver.metahandler.count" service['hbase.regionserver.metahandler.count']/>
<@property "hbase.master.executor.openregion.threads" service['hbase.master.executor.openregion.threads']/>
<@property "hbase.master.executor.closeregion.threads" service['hbase.master.executor.closeregion.threads']/>
<@property "hbase.regionserver.executor.openregion.threads" service['hbase.regionserver.executor.openregion.threads']/>
<@property "hbase.regionserver.executor.closeregion.threads" service['hbase.regionserver.executor.closeregion.threads']/>
<@property "hbase.hregion.memstore.block.multiplier" service['hbase.hregion.memstore.block.multiplier']/>
<@property "hbase.client.meta.operation.timeout" service['hbase.client.meta.operation.timeout']/>
<@property "hbase.client.write.buffer" service['hbase.client.write.buffer']/>

<#--Take properties from the context-->
<#if service['hbase-site.xml']??>
<#list service['hbase-site.xml'] as key, value>
    <@property key value/>
</#list>
</#if>
</configuration>
