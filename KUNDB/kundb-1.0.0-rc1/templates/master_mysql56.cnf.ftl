# Options for enabling GTID
# https://dev.mysql.com/doc/refman/5.6/en/replication-gtids-howto.html
<#if service['master.mysql.innodb_buffer_pool_size'] ??>
innodb_buffer_pool_size = ${service['master.mysql.innodb_buffer_pool_size']}
</#if>

<#if service['master.mysql.innodb_page_size'] ??>
innodb_page_size = ${service['master.mysql.innodb_page_size']}
</#if>

gtid_mode = ON
log_bin
#log_slave_updates
enforce_gtid_consistency
read-only = 1
# Ignore relay logs on disk at startup.
relay_log_recovery

# Native AIO tends to run into aio-max-nr limit during test startup.
innodb_use_native_aio = 0
innodb_support_xa = 0
innodb_buffer_pool_instances = 8

#innodb IO threads
innodb_read_io_threads = 16
innodb_write_io_threads = 16
innodb_doublewrite = 0

slave_pending_jobs_size_max=4096M

# Semi-sync replication is required for automated unplanned failover
# (when the master goes away). Here we just load the plugin so it's
# available if desired, but it's disabled at startup.
#
# If the -enable_semi_sync flag is used, VTTablet will enable semi-sync
# at the proper time when replication is set up, or when masters are
# promoted or demoted.
plugin-load = rpl_semi_sync_master=semisync_master.so;rpl_semi_sync_slave=semisync_slave.so
# enable parallel replication
slave-parallel-type=LOGICAL_CLOCK
slave-parallel-workers=16
master_info_repository=TABLE
relay_log_info_repository=TABLE
relay_log_recovery=ON

############################# Custom and Other ###############################
#<#list service['master_mysql56.cnf'] as key, value>
#${key}=${value}
#</#list>
