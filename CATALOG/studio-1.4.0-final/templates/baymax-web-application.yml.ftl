# ---------------------------------------------------------------
# Baymax Web Spring boot
# ---------------------------------------------------------------
<#assign mysqlHostPorts = []/>
<#list dependencies.TXSQL.roles['TXSQL_SERVER'] as role>
    <#assign mysqlHostPorts = mysqlHostPorts + [role.hostname + ':' + dependencies.TXSQL['mysql.rw.port']]>
</#list>
<#assign mysqlHostPort = mysqlHostPorts?join(",")>

server:
  port: ${service['baymax.web.http.port']}

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
    include: ssl
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

baymax:
  engine:
    location: http://${service.roles["BAYMAX_ENGINE"][0].hostname}:${service['baymax.engine.http.port']}

catalog:
  kerberos:
    principal: hbase/${localhostname?lower_case}@${service.realm}
  keytab:
    file: ${service.keytab}
  web:
    location: https://${service.roles["CATALOG_WEB"][0]['ip']}:${service['catalog.web.http.port']}