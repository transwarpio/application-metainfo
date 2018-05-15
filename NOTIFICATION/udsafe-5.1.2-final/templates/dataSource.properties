<#assign mysqlHostPorts = []/>
<#list dependencies.TXSQL.roles['TXSQL_SERVER'] as role>
    <#assign mysqlHostPorts = mysqlHostPorts + [role.hostname + ':' + dependencies.TXSQL['mysql.rw.port']]>
</#list>
<#assign mysqlHostPort = mysqlHostPorts?join(",")>

driver=com.mysql.jdbc.Driver
url=jdbc:mysql://${mysqlHostPort}/notification_${service.sid}?allowMultiQueries=true&useUnicode=true&characterEncoding=utf8&autoReconnect=true
username=${service['javax.jdo.option.ConnectionUserName']}
password=${service['javax.jdo.option.ConnectionPassword']}
poolPingQuery=select 1
poolPingEnabled=true
poolPingConnectionsNotUsedFor=3600000
