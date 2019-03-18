gtid_mode = ON
log_bin
log_slave_updates
enforce_gtid_consistency

innodb_use_native_aio = 0
innodb_support_xa = 0
innodb_doublewrite = 0

slave_pending_jobs_size_max = 4096M

plugin-load = rpl_semi_sync_master=semisync_master.so;rpl_semi_sync_slave=semisync_slave.so
slave-parallel-type = LOGICAL_CLOCK
slave-parallel-workers = 16
master_info_repository = TABLE
relay_log_info_repository = TABLE
relay_log_recovery = ON
