<#assign mysqlHostPorts = []/>
<#list dependencies.TXSQL.roles['TXSQL_SERVER'] as role>
    <#assign mysqlHostPorts = mysqlHostPorts + [role.hostname + ':' + dependencies.TXSQL['mysql.rw.port']]>
</#list>
<#assign mysqlHostPort = mysqlHostPorts?join(",")>
<#--handle dependent.search-->
<#assign search=dependencies.SEARCH searches=[] searchesWithPort=[]>
<#list search.roles.SEARCH_SERVER as role>
    <#assign searches += [role.hostname]>
    <#assign searchesWithPort += [role.hostname + ":9200"]>
</#list>
<#assign searchHostPort = searchesWithPort?join(",")>
spring.profiles.include=ssl
server.port=${service['catalog.agent.http.port']}
server.context-path=/
server.session-timeout=1800

mybatis.configuration.lazy-loading-enabled=true
mybatis.configuration.aggressive-lazy-loading=false
mybatis.configuration.map-underscore-to-camel-case=true
mybatis.type-aliases-package=io.transwarp.catalog.persistence.domain,io.transwarp.catalog.persistence.model,io.transwarp.catalog.persistence.entity

mapper.mappers=io.transwarp.mangix.web.mybatis.BaseMapper
mapper.wrapKeyword=`{0}`
mapper.enableMethodAnnotation=true

spring.aop.proxy-target-class=true
spring.datasource.url=jdbc:mysql://${mysqlHostPort}/catalog_${service.sid}?useUnicode=true&characterEncoding=UTF8&autoReconnect=true&useSSL=false&allowMultiQueries=true&failOverReadOnly=false&connectTimeout=10000&retriesAllDown=0&secondsBeforeRetryMaster=0&queriesBeforeRetryMaster=0
spring.datasource.username=${service['javax.jdo.option.ConnectionUserName']}
spring.datasource.password=${service['javax.jdo.option.ConnectionPassword']}
spring.datasource.type=com.alibaba.druid.pool.DruidDataSource
spring.datasource.driver-class-name=com.mysql.jdbc.Driver
spring.datasource.druid.initial-size=5
spring.datasource.druid.minIdle=5
spring.datasource.druid.max-active=10
spring.datasource.druid.aop-patterns=io.transwarp.catalog.agent.common.service.*

logging.config=classpath:logback-console.xml
logger.level.root=INFO
logger.level.db=INFO

catalog.swagger.enable = true
catalog.default.tenant = ${service['default.tenant']}
catalog.security.enable = <#if service.auth = "kerberos">true<#else>false</#if>
catalog.kerberos.principal=hbase/${localhostname?lower_case}@${service.realm}
catalog.keytab.file=${service.keytab}
catalog.web.server.address=${service.roles["CATALOG_WEB"][0].hostname}:${service['catalog.web.http.port']}
catalog.platform.server.address = ${service.roles["CATALOG_PLATFORM"][0].hostname}:${service['catalog.platform.http.port']}
catalog.es.index = catalog_search_index
catalog.es.server.address = ${searchHostPort}
catalog.mapper.package = io.transwarp.catalog.persistence.mapper
catalog.auth.files.path = /usr/lib/catalog-agent/auth-files
catalog.agent.classpath = /usr/lib/catalog-agent/lib

catalog.http.timeout = 600000
catalog.http.log.level = BASIC
catalog.sample.max.length = 100