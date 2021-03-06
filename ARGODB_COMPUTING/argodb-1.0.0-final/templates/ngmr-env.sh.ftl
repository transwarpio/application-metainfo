<#--Simple macro definition-->
<#macro env key value>
export ${key}=${value}
</#macro>
<#--------------------------->
#NGMR CONF ENVIRONMENT
export MYSQL_DATADIR=/var/transwarp/mysql/data
<#if service[.data_model["localhostname"]]['ngmr.localdir']??>
# Export ngmr.localdir
export SPARK_LOCAL_DIR=${service[.data_model["localhostname"]]['ngmr.localdir']}
</#if>
<#if service[.data_model["localhostname"]]['ngmr.fastdisk.dir']??>
export SPARK_FASTDISK_DIR=${service[.data_model["localhostname"]]['ngmr.fastdisk.dir']}
</#if>
export NGMR_CACHE_SIZE=${service['ngmr.cache.size']}
export NGMR_EXECUTORS_PERJOB=${service['ngmr.executors.perjob']}
export INCEPTOR_LOG_DIR=/var/log/${service.sid}
export SPARK_DRIVER_PORT=${service['spark.driver.port']}
<#assign dbaServiceExtraDriverOpts="">
<#if (service.roles.DBA_SERVICE)?? && ((service['inceptor.dbaservice.enabled'])!"false")="true">
    <#assign dbaServiceExtraDriverOpts=" -Dinceptor.leviathan.studio.host=" + service.roles.DBA_SERVICE[0]['ip'] + " -Dinceptor.leviathan.studio.port=60606 -Dinceptor.leviathan.studio.name=receiver -Dinceptor.leviathan.studio.test.enabled=false ">
</#if>
export EXTRA_DRIVER_OPTS=" ${dbaServiceExtraDriverOpts + service['EXTRA_DRIVER_OPTS']} "
EXTRA_EXECUTOR_OPTS=" ${service['EXTRA_EXECUTOR_OPTS']} "
#SHIVA ENV
<#if dependencies.ARGODB_STORAGE??>
    <#assign storage=dependencies.ARGODB_STORAGE master_group=[]>
    <#list storage.roles.SHIVA_MASTER as master>
        <#assign master_group += [master.ip + ":" + storage['shiva.master.rpc_service.master_service_port']]>
    </#list>
    <#assign master_group = master_group?join(",")>
export SHIVA_MASTER_GROUP=${master_group}
<#noparse>
EXTRA_EXECUTOR_OPTS+=" -Dngmr.holodesk.shiva.mastergroup=${SHIVA_MASTER_GROUP} "
</#noparse>
</#if>
export EXTRA_EXECUTOR_OPTS
