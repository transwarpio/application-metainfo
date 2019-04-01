<#assign mysqlHostPorts = []/>
<#list dependencies.TXSQL.roles['TXSQL_SERVER'] as role>
<#assign mysqlHostPorts = mysqlHostPorts + [role.hostname + ':' + dependencies.TXSQL['mysql.rw.port']]>
</#list>
<#assign mysqlHostPort = mysqlHostPorts?join(",")>

# database settings
# test
# this property makes core test independent from guardian
#mysql from docker compose
spring.datasource.url=jdbc:mysql://${mysqlHostPort}/datamarket_${service.sid}?allowMultiQueries=true&useLegacyDatetimeCode=false&serverTimezone=Asia/Shanghai&useSSL=false
spring.datasource.username=${service['javax.jdo.option.ConnectionUserName']}
spring.datasource.password=${service['javax.jdo.option.ConnectionPassword']}
spring.datasource.driver-class-name=com.mysql.jdbc.Driver

