<#assign mysqlHostPorts = []/>
<#list dependencies.TXSQL.roles['TXSQL_SERVER'] as role>
<#assign mysqlHostPorts = mysqlHostPorts + [role.hostname + ':' + dependencies.TXSQL['mysql.rw.port']]>
</#list>
<#assign mysqlHostPort = mysqlHostPorts?join(",")>

# database settings
# test
# this property makes core test independent from guardian
#mysql from docker compose
spring.datasource.url=jdbc:mysql://${mysqlHostPort}/sophon_st_${service.sid}?allowMultiQueries=true&useLegacyDatetimeCode=false&serverTimezone=Asia/Shanghai&useSSL=false
spring.datasource.username=${service['javax.jdo.option.ConnectionUserName']}
spring.datasource.password=${service['javax.jdo.option.ConnectionPassword']}
spring.datasource.driver-class-name=com.mysql.jdbc.Driver

# mybatis settings
mybatis.mapperLocations = classpath:/mapper/*.xml
mybatis.type-aliases-package = io.transwarp.mirror.persistence.mybatis.model

#
# tag scheduler cron expression
tag.scheduler.cron=0 0 3 * * ?

workflow.username=workflow
workflow.password=Transwarp4T
workflow.domain.id=${service['workflow.domain.id']}

mirror.execute.cycle=${service['execute.cycle']}