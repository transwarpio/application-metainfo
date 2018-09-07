# mfed.cnf parameters

<#if service['compute.optimizer_switch'] ??>
optimizer_switch = ${service['compute.optimizer_switch']}
</#if>

<#if service['compute.fedx_bkah_size'] ??>
fedx_bkah_size = ${service['compute.fedx_bkah_size']}
</#if>

<#if service['compute.fedx_vitess_min_str_len_for_cbo'] ??>
 fedx_vitess_min_str_len_for_cbo = ${service['compute.fedx_vitess_min_str_len_for_cbo']}
</#if>

<#if service['compute.fedx_valid_index_cardinality_percent '] ??>
fedx_valid_index_cardinality_percent = ${service['compute.fedx_valid_index_cardinality_percent ']}
</#if>

<#if service['compute.fedx_valid_index_cardinality_minvalue'] ??>
fedx_valid_index_cardinality_minvalue = ${service['compute.fedx_valid_index_cardinality_minvalue']}
</#if>

plugin-load = federated=ha_federatedx.so

log_bin_trust_function_creators = 1
join_cache_level = 7  
rpl_semi_sync_master_enabled=0
rpl_semi_sync_slave_enabled=0

############################# Custom and Other ###############################
#<#list service['mfed.cnf'] as key, value>
#${key}=${value}
#</#list>
