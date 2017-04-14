#NGMR CONF ENVIRONMENT
export MYSQL_DATADIR=/var/transwarp/mysql/data
<#if service[.data_model["localhostname"]]['ngmr.localdir']??>
# Export ngmr.localdir
export SPARK_LOCAL_DIR=${service[.data_model["localhostname"]]['ngmr.localdir']}
</#if>
export SPARK_FASTDISK_DIR=${service['ngmr.fastdisk.dir']}
export NGMR_CACHE_SIZE=${service['ngmr.cache.size']}
export NGMR_EXECUTORS_PERJOB=${service['ngmr.executors.perjob']}
export INCEPTOR_LOG_DIR=/var/log/${service.sid}
export SPARK_DRIVER_PORT="51888"
