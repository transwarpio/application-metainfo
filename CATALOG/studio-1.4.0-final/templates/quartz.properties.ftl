<#assign mysqlHostPorts = []/>
<#list dependencies.TXSQL.roles['TXSQL_SERVER'] as role>
    <#assign mysqlHostPorts = mysqlHostPorts + [role.hostname + ':' + dependencies.TXSQL['mysql.rw.port']]>
</#list>
<#assign mysqlHostPort = mysqlHostPorts?join(",")>
#============================================================================
# 基础配置
# 注意：如果使用JobStoreTX，实例名严禁使用：DefaultQuartzScheduler
# 原因：内存方式的instanceid为默认的DefaultQuartzScheduler，如果不修改系统会同时存在内存型和DB型，默认会走内存
#============================================================================

org.quartz.scheduler.instanceName = CatalogQuartzScheduler
# 如果使用集群，instanceId必须唯一，设置成AUTO
org.quartz.scheduler.instanceId = AUTO
org.quartz.scheduler.rmi.export = false
org.quartz.scheduler.rmi.proxy = false
org.quartz.scheduler.wrapJobExecutionInUserTransaction = false

#============================================================================
# 调度器线程池配置
#============================================================================

org.quartz.threadPool.class = org.quartz.simpl.SimpleThreadPool
org.quartz.threadPool.threadCount = 10
org.quartz.threadPool.threadPriority = 5
# 加载任务代码的ClassLoader是否从外部继承
org.quartz.threadPool.threadsInheritContextClassLoaderOfInitializingThread = true
org.quartz.jobStore.misfireThreshold = 60000

#============================================================================
# Configure JobStore 作业存储配置
#============================================================================

org.quartz.jobStore.class = org.quartz.impl.jdbcjobstore.JobStoreTX
org.quartz.jobStore.acquireTriggersWithinLock = true
org.quartz.jobStore.driverDelegateClass = org.quartz.impl.jdbcjobstore.StdJDBCDelegate
org.quartz.jobStore.useProperties = true
org.quartz.jobStore.tablePrefix = QRTZ_
org.quartz.jobStore.isClustered = true

#============================================================================
# Configure Datasources配置数据源(可被覆盖，如果在schedulerFactoryBean指定数据源)
#============================================================================

org.quartz.jobStore.dataSource = qzDS
org.quartz.dataSource.qzDS.driver = com.mysql.jdbc.Driver
org.quartz.dataSource.qzDS.URL = jdbc:mysql://${mysqlHostPort}/catalog_${service.sid}?useUnicode=true&characterEncoding=UTF8&autoReconnect=true&useSSL=false&allowMultiQueries=true&failOverReadOnly=false&connectTimeout=10000&retriesAllDown=0&secondsBeforeRetryMaster=0&queriesBeforeRetryMaster=0
org.quartz.dataSource.qzDS.user = ${service['javax.jdo.option.ConnectionUserName']}
org.quartz.dataSource.qzDS.password = ${service['javax.jdo.option.ConnectionPassword']}
org.quartz.dataSource.qzDS.maxConnections = 10
