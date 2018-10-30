db.driver=com.mysql.jdbc.Driver
<#assign mysqlHostPorts = []/>
<#list dependencies.TXSQL.roles['TXSQL_SERVER'] as role>
<#assign mysqlHostPorts = mysqlHostPorts + [role.hostname + ':' + dependencies.TXSQL['mysql.rw.port']]>
</#list>
<#assign mysqlHostPort = mysqlHostPorts?join(",")>
db.url=jdbc:mysql://${mysqlHostPort}/tdt_${service.sid}?allowMultiQueries=true&useUnicode=true&characterEncoding=utf8&autoReconnect=true
db.user=${service['tdt.jdbc.user.name']}
db.password=${service['tdt.jdbc.password']}
