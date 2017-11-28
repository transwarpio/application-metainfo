#NGMR CONF ENVIRONMENT
export MYSQL_DATADIR=/var/transwarp/mysql/data
# Export ngmr.localdir
export SPARK_LOCAL_DIR=/vdir/mnt/disk1/hadoop/ngmr/inceptor1,/vdir/mnt/disk2/hadoop/ngmr/inceptor1
export SPARK_FASTDISK_DIR=/vdir/mnt/ramdisk/ngmr
export NGMR_CACHE_SIZE=0.5
export NGMR_EXECUTORS_PERJOB=1
export INCEPTOR_LOG_DIR=/var/log/inceptor1
export SPARK_DRIVER_PORT=51888
export EXTRA_DRIVER_OPTS="  "
export EXTRA_EXECUTOR_OPTS="  "
#SHIVA ENV
