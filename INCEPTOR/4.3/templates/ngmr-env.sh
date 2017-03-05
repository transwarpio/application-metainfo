#NGMR CONF ENVIRONMENT
export NGMR_LOCALDIR=${service['ngmr.localdir']}
export MYSQL_DATADIR="/hadoop/data"
export SPARK_LOCAL_DIR=${service['ngmr.localdir']}
export NGMR_FASTDISK_DIR=${service['ngmr.fastdisk.dir']}
export SPARK_FASTDISK_DIR=${service['ngmr.fastdisk.dir']}
export NGMR_FASTDISK_SIZE=${service['ngmr.fastdisk.size']}
export NGMR_CACHE_SIZE=${service['ngmr.cache.size']}
export NGMR_EXECUTORS_PERJOB=${service['ngmr.executors.perjob']}
export INCEPTOR_LOG_DIR=/var/log/${service.sid}
export SPARK_DRIVER_PORT="51888"
