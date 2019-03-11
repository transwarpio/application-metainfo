## ----- framework specific configs -----
server:
  port: ${service['server.web.port']}
  error:
    whitelabel:
      enabled: false

<#if service.roles["AQUILA_TXSQL_SERVER"]??>
    <#assign hostPorts = []>
    <#list service.roles["AQUILA_TXSQL_SERVER"] as r>
        <#assign hostPorts = hostPorts + [r.hostname + ':' + service['txsql.mysql.rw.port']]>
    </#list>
    <#assign txsql = hostPorts?join(",")>
</#if>
spring.datasource:
  driver-class-name: com.mysql.cj.jdbc.Driver
  url: jdbc:mysql://${txsql}/aquila?createDatabaseIfNotExist=true&characterEncoding=UTF-8&failOverReadOnly=false&connectTimeout=10000&retriesAllDown=0&secondsBeforeRetryMaster=0&queriesBeforeRetryMaster=0
  username: root

springfox.documentation:
  auto-startup: true
  swagger.v2.path: /api/docs

## ----- application configs
api:
  swagger:
    enabled: ${service['server.api.swagger.enabled']}
conf-gen:
  freemarker:
    strong-size-limit: 10
metrics:
  folders:
    special-folder-name: General
db:
  query:
    max-in-clause-size: 1000
