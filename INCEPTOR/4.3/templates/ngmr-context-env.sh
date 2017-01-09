<#--handle dependent.zookeeper-->
<#if dependencies.ZOOKEEPER??>
  <#assign zookeeper=dependencies.ZOOKEEPER quorums=[]>
  <#list zookeeper.roles.ZOOKEEPER_SERVER as role>
    <#assign quorums += [role.hostname + ":" + zookeeper[role.hostname]["zookeeper.client.port"]]>
  </#list>
  <#assign quorum = quorums?join(",")>
</#if>

export NGMR_YARN=true

export INCEPTOR_YARN_MASTER_MEMORY=512M
export INCEPTOR_YARN_EXECUTOR_MEMORY=1569M
export INCEPTOR_YARN_EXECUTOR_CORES=3
export NGMR_YARN_EXECUTOR_LIST=
export INCEPTOR_YARN_EXECUTOR_MEM_CPU_RATIO=
export INCEPTOR_YARN_EXECUTOR_USED_RESOURCE_PERCENT=
export INCEPTOR_YARN_NUMBER_EXECUTORS=-1
export INCEPTOR_YARN_NUMBER_WORKERS=-1
export INCEPTOR_YARN_SCHEDULER_MODE=GreedyMode
export SPARK_YARN_APP_NAME=${service.sid}-${localhostname}-inceptorserver
export SPARK_YARN_QUEUE=default
export INCEPTOR_LICENSE_ZOOKEEPER_QUORUM=${quorum}
export INCEPTOR_UI_PORT=4040
