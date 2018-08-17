<#if dependencies.ZOOKEEPER??>
    <#assign zookeeper=dependencies.ZOOKEEPER quorums=[]>
    <#list zookeeper.roles.ZOOKEEPER as role>
        <#assign quorums += [role.hostname + ":" + zookeeper["zookeeper.client.port"]]>
    </#list>
    <#assign quorum = quorums?join(",")>
</#if>
#################################################
######### 		common argument		############# 
#################################################
canal.id= 1
canal.ip= 127.0.0.1
canal.port= 11113
canal.rpc.port=11110
canal.zkServers=${quorum}
# flush data to zk
canal.zookeeper.flush.period = 1000
# flush meta cursor/parse position to file
canal.file.data.dir = /etc/${service.sid}/conf/canal/conf
canal.file.flush.period = 1000
## memory store RingBuffer size, should be Math.pow(2,n)
canal.instance.memory.buffer.size = 16384
## memory store RingBuffer used memory unit size , default 1kb
canal.instance.memory.buffer.memunit = 1024
## meory store gets mode used MEMSIZE or ITEMSIZE
canal.instance.memory.batch.mode = MEMSIZE

## detecing config
canal.instance.detecting.enable = false
#canal.instance.detecting.sql = insert into retl.xdual values(1,now()) on duplicate key update x=now()
canal.instance.detecting.sql = select 1
canal.instance.detecting.interval.time = 3
canal.instance.detecting.retry.threshold = 3
canal.instance.detecting.heartbeatHaEnable = false

# support maximum transaction size, more than the size of the transaction will be cut into multiple transactions delivery
canal.instance.transaction.size =  1024
# mysql fallback connected to new master should fallback times
canal.instance.fallbackIntervalInSeconds = 60

# network config
canal.instance.network.receiveBufferSize = 16384
canal.instance.network.sendBufferSize = 16384
canal.instance.network.soTimeout = 30

# binlog filter config
canal.instance.filter.query.dcl = false
canal.instance.filter.query.dml = false
canal.instance.filter.query.ddl = false
canal.instance.filter.table.error = false
canal.instance.filter.rows = false

# binlog format/image check
canal.instance.binlog.format = ROW,STATEMENT,MIXED
canal.instance.binlog.image = FULL,MINIMAL,NOBLOB

# binlog ddl isolation
canal.instance.get.ddl.isolation = false

#################################################
######### 		destinations		############# 
#################################################
canal.destinations=
# canal root dir
canal.conf.dir = /etc/${service.sid}/conf/canal/conf
# auto scan instance dir add/remove and start/stop instance
canal.auto.scan = true
canal.auto.scan.interval = 5

canal.instance.global.mode = spring
canal.instance.global.lazy = false
#canal.instance.global.manager.address = 127.0.0.1:1099
#canal.instance.global.spring.xml = classpath:canal/conf/spring/memory-instance.xml
#canal.instance.global.spring.xml = classpath:canal/conf/spring/file-instance.xml
#canal.instance.global.spring.xml = classpath:canal/conf/spring/default-instance.xml
canal.instance.global.spring.xml = file:/etc/${service.sid}/conf/canal/conf/spring/default-instance.xml
