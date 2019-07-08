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
<#if service['ngmr.fastdisk.dir']??>
export SPARK_FASTDISK_DIR=${service['ngmr.fastdisk.dir']}
</#if>
export NGMR_CACHE_SIZE=${service['ngmr.cache.size']}
export NGMR_EXECUTORS_PERJOB=${service['ngmr.executors.perjob']}
export INCEPTOR_LOG_DIR=/var/log/${service.sid}
export SPARK_DRIVER_PORT=${service['spark.driver.port']}

<#if service.auth = "kerberos">
export EXTRA_DRIVER_OPTS=" ${service['EXTRA_DRIVER_OPTS']} -Djava.security.auth.login.config=/etc/${service.sid}/conf/jaas.conf "
<#else>
export EXTRA_DRIVER_OPTS=" ${service['EXTRA_DRIVER_OPTS']}"
</#if>

<#if service.auth = "kerberos">
export EXTRA_EXECUTOR_OPTS=" ${service['EXTRA_EXECUTOR_OPTS']} -Djava.security.auth.login.config=/etc/${service.sid}/conf/jaas.conf "
<#else>
export EXTRA_EXECUTOR_OPTS=" ${service['EXTRA_EXECUTOR_OPTS']}"
</#if>

