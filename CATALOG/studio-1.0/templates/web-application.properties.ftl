#
#    Copyright 2015-2016 the original author or authors.
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
#
<#assign mysqlHostPorts = []/>
<#list dependencies.TXSQL.roles['TXSQL_SERVER'] as role>
    <#assign mysqlHostPorts = mysqlHostPorts + [role.hostname + ':' + dependencies.TXSQL['mysql.rw.port']]>
</#list>
<#assign mysqlHostPort = mysqlHostPorts?join(",")>
<#--handle dependent.search-->
<#if dependencies.SEARCH??>
    <#assign search=dependencies.SEARCH searches=[] searchesWithPort=[]>
    <#list search.roles.SEARCH_SERVER as role>
        <#assign searches += [role.hostname]>
        <#assign searchesWithPort += [role.hostname + ":9200"]>
    </#list>
</#if>

#EMBEDDED SERVER CONFIGURATION (ServerProperties)
server.port=${service['catalog.web.http.port']}

#cookie timeout in seconds
server.session.cookie.max-age=1800

server.context-path=/

# Charset of HTTP requests and responses. Added to the "Content-Type" header if not set explicitly.
spring.http.encoding.charset=UTF-8
# Enable http encoding support.
spring.http.encoding.enabled=true
# Force the encoding to the configured charset on HTTP requests and responses.
spring.http.encoding.force=true

# Enable template caching.
spring.thymeleaf.cache=false
# Check that the templates location exists.
spring.thymeleaf.check-template-location=true
# Content-Type value.
spring.thymeleaf.content-type=text/html
# Enable MVC Thymeleaf view resolution.
spring.thymeleaf.enabled=true
# Template encoding.
spring.thymeleaf.encoding=UTF-8
# Comma-separated list of view names that should be excluded from resolution.
#spring.thymeleaf.excluded-view-names=
# Template mode to be applied to templates. See also StandardTemplateModeHandlers.
#spring.thymeleaf.mode=HTML5
spring.thymeleaf.mode=LEGACYHTML5
# Prefix that gets prepended to view names when building a URL.
spring.thymeleaf.prefix=classpath:/templates/
# Suffix that gets appended to view names when building a URL.
spring.thymeleaf.suffix=.html
#spring.thymeleaf.template-resolver-order=
# Order of the template resolver in the chain.
#spring.thymeleaf.view-names=
# Comma-separated list of view names that can be resolved.

spring.aop.proxy-target-class=true

mybatis.type-aliases-package=io.transwarp.catalog.persistence.domain,io.transwarp.catalog.persistence.model,io.transwarp.catalog.persistence.entity
mybatis.mapper-locations=classpath*:mapper/*.xml
mybatis.configuration.lazy-loading-enabled=true
mybatis.configuration.aggressive-lazy-loading=false
mybatis.configuration.map-underscore-to-camel-case=true

mapper.mappers=io.transwarp.mangix.web.mybatis.BaseMapper
mapper.wrapKeyword=`{0}`
mapper.enableMethodAnnotation=true

pagehelper.reasonable=true
pagehelper.page-size-zero=true

# 只有下面三个是必填项，其他配置不是必须的
spring.datasource.url=jdbc:mysql://${mysqlHostPort}/catalog_${service.sid}?useUnicode=true&characterEncoding=UTF8&autoReconnect=true&useSSL=false&allowMultiQueries=true&failOverReadOnly=false&connectTimeout=10000&retriesAllDown=0&secondsBeforeRetryMaster=0&queriesBeforeRetryMaster=0
spring.datasource.username=${service['javax.jdo.option.ConnectionUserName']}
spring.datasource.password=${service['javax.jdo.option.ConnectionPassword']}
spring.datasource.type=com.alibaba.druid.pool.DruidDataSource
spring.datasource.driver-class-name=com.mysql.jdbc.Driver

# Druid 数据源配置，继承spring.datasource.* 配置，相同则覆盖
spring.datasource.druid.initial-size=5
spring.datasource.druid.minIdle=5
spring.datasource.druid.max-active=10
spring.datasource.druid.aop-patterns=io.transwarp.catalog.web.service.*

flyway.locations=classpath:db/migration,db/data
flyway.baseline-on-migrate=true

spring.http.multipart.maxFileSize=50MB
spring.http.multipart.maxRequestSize=50MB

# spring cache
spring.cache.type=simple

# logger
logging.config=classpath:logback-spring.xml
# log 打印配置
logger_root_level = ${service['logger.level']}
# sql 打印级别
logger_db_level = ${service['logger.level']}

swagger.enable = false
catalog.default.tenant = ${service['default.tenant']}
catalog.security.enable = <#if service.auth = "kerberos">true<#else>false</#if>
catalog.platform.server.address = ${service.roles["CATALOG_PLATFORM"][0].hostname}:${service['catalog.platform.http.port']}
catalog.es.server.address = ${searchesWithPort[0]}
catalog.http.timeout = 60000
catalog.http.log.level = BASIC
catalog.sample.max.length = ${service['sample.max.length']}
catalog.deploy.mode = TDH
catalog.record.store.size = ${service['record.store.size']}
catalog.record.store.days = ${service['record.store.days']}
catalog.kerberos.principal=hbase/${localhostname?lower_case}@${service.realm}
catalog.keytab.file=${service.keytab}
catalog.guardian.component.name = ${service.sid}