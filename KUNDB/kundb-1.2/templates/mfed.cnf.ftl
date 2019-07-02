plugin-load = federated=ha_federatedx.so

log_bin_trust_function_creators = 1
join_cache_level = 7  
<#if service['optimizer_switch']??>
optimizer_switch = ${service['optimizer_switch']}
fedx_bkah_size = ${service['fedx_bkah_size']}
</#if>
rpl_semi_sync_master_enabled=0
rpl_semi_sync_slave_enabled=0
join_buffer_size = 256K
