driver=com.mysql.jdbc.Driver

<#assign mysqlHostPorts = []/>
<#list dependencies.TXSQL.roles['TXSQL_SERVER'] as role>
    <#assign mysqlHostPorts = mysqlHostPorts + [role.hostname + ':' + dependencies.TXSQL['mysql.rw.port']]>
</#list>
<#assign mysqlHostPort = mysqlHostPorts?join(",")>

<#assign mysqlHostPort = dependencies.TXSQL.roles.TXSQL_SERVER[0]['hostname'] + ":" + dependencies.TXSQL['mysql.rw.port']/>
url=jdbc:mysql://${mysqlHostPort}/rubik_${service.sid}?autoReconnect=true&createDatabaseIfNotExist=false&characterEncoding=UTF-8
user=${service['javax.jdo.option.ConnectionUserName']}
password=${service['javax.jdo.option.ConnectionPassword']}
poolPingQuery = select 1
poolPingEnabled = true
poolPingConnectionsNotUsedFor = 3600000
