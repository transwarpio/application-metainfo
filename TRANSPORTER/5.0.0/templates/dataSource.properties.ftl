<#assign mysqlHostPorts = []/>
<#list dependencies.TXSQL.roles['TXSQL_SERVER'] as role>
    <#assign mysqlHostPorts = mysqlHostPorts + [role.hostname + ':' + dependencies.TXSQL['mysql.rw.port']]>
</#list>
<#assign mysqlHostPort = mysqlHostPorts?join(",")>

<#assign mysqlHostPort = dependencies.TXSQL.roles.TXSQL_SERVER[0]['hostname'] + ":" + dependencies.TXSQL['mysql.rw.port']/>
driver=com.mysql.jdbc.Driver
url=jdbc:mysql://${mysqlHostPort}/tdt_${service.sid}?allowMultiQueries=true&useUnicode=true&characterEncoding=utf8&autoReconnect=true
username=${service['tdt.jdbc.user.name']}
password=${service['tdt.jdbc.password']}
poolPingQuery=select 1
poolPingEnabled=true
poolPingConnectionsNotUsedFor=3600000
