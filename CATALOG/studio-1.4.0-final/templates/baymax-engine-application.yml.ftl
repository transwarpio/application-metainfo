# ---------------------------------------------------------------
# Baymax Engine Spring boot
# ---------------------------------------------------------------
<#assign mysqlHostPorts = []/>
<#list dependencies.TXSQL.roles['TXSQL_SERVER'] as role>
    <#assign mysqlHostPorts = mysqlHostPorts + [role.hostname + ':' + dependencies.TXSQL['mysql.rw.port']]>
</#list>
<#assign mysqlHostPort = mysqlHostPorts?join(",")>

server:
  port: ${service['baymax.engine.http.port']}

spring:
  datasource:
    driver-class-name: com.mysql.jdbc.Driver
    url: jdbc:mysql://${mysqlHostPort}/bm_${service.sid}?useUnicode=true&characterEncoding=UTF8&autoReconnect=true&useSSL=false&allowMultiQueries=true&failOverReadOnly=false&connectTimeout=10000&retriesAllDown=0&secondsBeforeRetryMaster=0&queriesBeforeRetryMaster=0
    username: ${service['javax.jdo.option.ConnectionUserName']}
    password: ${service['javax.jdo.option.ConnectionPassword']}
    tomcat:
      validation-query: SELECT 1
      test-on-borrow: true
  profiles:
    active: spring, persistence
logging:
  level:
    root: INFO
    db: INFO
  config: classpath:logback-file.xml
mybatis:
  type-aliases-package: io.transwarp.dataservice.baymax.model.po
  configuration:
    log-impl: org.apache.ibatis.logging.stdout.StdOutImpl
    map-underscore-to-camel-case: true
mapper:
  mappers:
    - io.transwarp.dataservice.baymax.util.GenericMapper
livyconf:
  livyUrl: http://${service.roles['BAYMAX_EXECUTOR'][0].hostname}:${service['baymax.executor.http.port']}
  artifacts: /usr/lib/baymax-engine/jars

metadataconf:
  driver: com.mysql.jdbc.Driver
  metadataBase: bm_${service.sid}
  url: jdbc:mysql://${mysqlHostPort}
  user: ${service['javax.jdo.option.ConnectionUserName']}
  password: ${service['javax.jdo.option.ConnectionPassword']}