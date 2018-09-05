gtid_strict_mode = 1
innodb_stats_persistent = 0

<#if service['master_mariadb.cnf']?? >
<#list service['master_mariadb.cnf'] as key, value>
${key} = ${value}
</#list>
</#if>
