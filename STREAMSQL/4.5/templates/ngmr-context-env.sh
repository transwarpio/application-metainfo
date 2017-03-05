<#--handle dependent.zookeeper-->
<#if dependencies.ZOOKEEPER??>
  <#assign zookeeper=dependencies.ZOOKEEPER quorums=[]>
  <#list zookeeper.roles.ZOOKEEPER as role>
    <#assign quorums += [role.hostname + ":" + zookeeper["zookeeper.client.port"]]>
  </#list>
  <#assign quorum = quorums?join(",")>
</#if>

export NGMR_YARN=false
export SERVICE_TYPE=StreamSQL
export INCEPTOR_YARN_MASTER_MEMORY=${service['inceptor.yarn.master.memory']}M
export INCEPTOR_YARN_EXECUTOR_MEMORY=${service['inceptor.yarn.executor.memory']}M
export INCEPTOR_YARN_EXECUTOR_CORES=${service['inceptor.yarn.executor.cores']}
export NGMR_YARN_EXECUTOR_LIST=
export INCEPTOR_YARN_EXECUTOR_MEM_CPU_RATIO=
export INCEPTOR_YARN_EXECUTOR_USED_RESOURCE_PERCENT=
export INCEPTOR_YARN_NUMBER_EXECUTORS=${service['inceptor.yarn.number.executors']}
export INCEPTOR_YARN_NUMBER_WORKERS=${service['inceptor.yarn.number.workers']}
export INCEPTOR_YARN_SCHEDULER_MODE=${service['inceptor.yarn.scheduler.mode']}
export SPARK_YARN_APP_NAME=${service.sid}-${localhostname}-inceptorserver
export SPARK_YARN_QUEUE=${service['spark.yarn.queue']}
export INCEPTOR_LICENSE_ZOOKEEPER_QUORUM=${quorum}
export INCEPTOR_UI_PORT=${service['inceptor.ui.port']}
export METASTORE_PORT=${service['hive.metastore.port']}
export MYSQL_PORT=${service['mysql.port']}
