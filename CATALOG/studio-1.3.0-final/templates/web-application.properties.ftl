<#assign mysqlHostPorts = []/>
<#list dependencies.TXSQL.roles['TXSQL_SERVER'] as role>
    <#assign mysqlHostPorts = mysqlHostPorts + [role.hostname + ':' + dependencies.TXSQL['mysql.rw.port']]>
</#list>
<#assign mysqlHostPort = mysqlHostPorts?join(",")>
<#--handle dependent.search-->
<#assign search=dependencies.SEARCH searches=[] searchesWithPort=[]>
<#list search.roles.SEARCH_SERVER as role>
    <#assign searches += [role.hostname]>
    <#assign searchesWithPort += [role.hostname + ":" + search[role.id?c]['http.port']]>
</#list>
<#assign searchHostPort = searchesWithPort?join(",")>
spring.profiles.include=ssl
server.port=${service['catalog.web.http.port']}

server.session.cookie.name=CATALOGSESSIONID
server.session.cookie.max-age=86400
server.context-path=/

spring.http.encoding.charset=UTF-8
spring.http.encoding.enabled=true
spring.http.encoding.force=true
spring.http.multipart.maxFileSize=50MB
spring.http.multipart.maxRequestSize=50MB

spring.thymeleaf.cache=false
spring.thymeleaf.check-template-location=true
spring.thymeleaf.content-type=text/html
spring.thymeleaf.enabled=true
spring.thymeleaf.encoding=UTF-8
spring.thymeleaf.mode=LEGACYHTML5
spring.thymeleaf.prefix=classpath:/templates/
spring.thymeleaf.suffix=.html

spring.cache.type=simple
spring.freemarker.template-loader-path=classpath:/agents/
spring.aop.proxy-target-class=true

pagehelper.reasonable=true
pagehelper.page-size-zero=true
pagehelper.helperDialect=mysql
pagehelper.supportMethodsArguments=true
pagehelper.params=count=countSql

mybatis.type-aliases-package=io.transwarp.catalog.persistence.domain,io.transwarp.catalog.persistence.model,io.transwarp.catalog.persistence.entity,io.transwarp.sqleditor.model
mybatis.mapper-locations=classpath*:mapper/*.xml
mybatis.configuration.lazy-loading-enabled=true
mybatis.configuration.aggressive-lazy-loading=false
mybatis.configuration.map-underscore-to-camel-case=true

mapper.mappers=io.transwarp.mangix.web.mybatis.BaseMapper
mapper.wrapKeyword=`{0}`
mapper.enableMethodAnnotation=true

spring.datasource.url=jdbc:mysql://${mysqlHostPort}/catalog_${service.sid}?useUnicode=true&characterEncoding=UTF8&autoReconnect=true&useSSL=false&allowMultiQueries=true&failOverReadOnly=false&connectTimeout=10000&retriesAllDown=0&secondsBeforeRetryMaster=0&queriesBeforeRetryMaster=0
spring.datasource.username=${service['javax.jdo.option.ConnectionUserName']}
spring.datasource.password=${service['javax.jdo.option.ConnectionPassword']}
spring.datasource.type=com.alibaba.druid.pool.DruidDataSource
spring.datasource.driver-class-name=com.mysql.jdbc.Driver
spring.datasource.druid.initial-size=5
spring.datasource.druid.minIdle=5
spring.datasource.druid.max-active=10
spring.datasource.druid.aop-patterns=io.transwarp.catalog.web.service.*

flyway.locations=classpath:db/migration
flyway.baseline-on-migrate=true

logging.config=classpath:logback-file.xml
logger.level.root=INFO
logger.level.db=INFO

catalog.swagger.enable = false
catalog.security.enable = <#if service.auth = "kerberos">true<#else>false</#if>
catalog.cas.enable = ${service['cas.enable']}
catalog.oauth2.enabled=false
security.basic.enabled=false
security.disableSslCertValidation=false

catalog.default.tenant = ${service['default.tenant']}
catalog.web.server.address = https://${service.roles["CATALOG_WEB"][0]['ip']}:${service['catalog.web.http.port']}
catalog.platform.server.address = ${service.roles["CATALOG_PLATFORM"][0].hostname}:${service['catalog.platform.http.port']}
catalog.agent.server.address = ${service.roles["CATALOG_AGENT"][0].hostname}:${service['catalog.agent.http.port']}
catalog.cas.server.address = https://${dependencies.GUARDIAN.roles.CAS_SERVER[0]['ip']}:${dependencies.GUARDIAN['cas.server.ssl.port']}${dependencies.GUARDIAN['cas.server.context.path']}
catalog.es.index = catalog_search_index
catalog.es.server.address = ${searchHostPort}

catalog.http.timeout = 60000
catalog.http.log.level = BASIC
catalog.sample.max.length = ${service['sample.max.length']}
catalog.deploy.mode = TDH
catalog.record.store.size = ${service['record.store.size']}
catalog.record.store.days = ${service['record.store.days']}
catalog.kerberos.principal=hbase/${localhostname?lower_case}@${service.realm}
catalog.keytab.file=${service.keytab}
catalog.guardian.component.name = ${service.sid}
catalog.auto.tag.interval=86400000
catalog.entity.recommend.interval=86400000
catalog.lineage.max.depth = 100

sqleditor.swagger.enable = false
sqleditor.rest.api.prefix = catalog/api/v1
sqleditor.pool.thread.namePrefix= sqleditor-thr_
sqleditor.pool.thread.corePoolSize= 0
sqleditor.pool.thread.maxPoolSize= 2147483647
sqleditor.pool.thread.queueCapacity= 0
sqleditor.pool.thread.keepAliveSeconds= 60

# memcache
memcache.servers=127.0.0.1:11211
memcache.failover=true
memcache.initConn=10
memcache.minConn=20
memcache.maxConn=1000
memcache.maintSleep=50
memcache.nagle=false
memcache.socketTO=3000
memcache.aliveCheck=true

hbase.refresh.poll.interval = 3000
hbase.refresh.poll.max.wait = 60000