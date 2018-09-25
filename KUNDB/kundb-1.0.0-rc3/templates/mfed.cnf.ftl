plugin-load = federated=ha_federatedx.so

log_bin_trust_function_creators = 1
join_cache_level = 7  
rpl_semi_sync_master_enabled=0
rpl_semi_sync_slave_enabled=0

<#if service['mfed.cnf']?? >
<#list service['mfed.cnf'] as key, value>
${key} = ${value}
</#list>
</#if>
