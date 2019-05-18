## ----- framework specific configs -----
server:
  port: ${service['server.web.port']}
  compression:
    enabled: true
    mime-types: text/*,application/json,application/*+json,application/javascript
    min-response-size: 10KB
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
  url: jdbc:mysql://${txsql}/aquila?createDatabaseIfNotExist=true&characterEncoding=UTF-8&failOverReadOnly=false&connectTimeout=10000&retriesAllDown=0&secondsBeforeRetryMaster=0&queriesBeforeRetryMaster=0&serverTimezone=${service['server.jdbc.connctor.timezone']}
  username: root

springfox.documentation:
  auto-startup: true
  swagger.v2.path: /api/docs

## ----- application configs
<#assign prometheusHost = service.roles["AQUILA_PROMETHEUS"][0].hostname>
<#assign prometheusEndpoint = "http://" + prometheusHost + ":" + service["prometheus.web.port"]>
api:
  swagger:
    enabled: ${service['server.api.swagger.enabled']}
conf-gen:
  freemarker:
    strong-size-limit: 10
metrics:
  folders:
    special-folder-name: General
  data-source:
    predefined:
      - id: 1
        name: "Prometheus"
        type: PROMETHEUS
        url: ${prometheusEndpoint}
      - id: 2
        name: "Manager Heatmap"
        type: MANAGER_HEATMAP
        prometheusUrl: ${prometheusEndpoint}
      - id: 3
        name: "Manager Database"
        type: MANAGER_DB
alert:
  rule:
    generate:
      max-threads: 3
      time-out-sec: 180
      host: ${prometheusHost}
      path: /etc/${service.sid}/conf/prometheus/rules.d
      upload-trigger: ${prometheusEndpoint}/-/reload
  gateway:
    alert-manager:
      push-url: http://172.16.1.104:9193/api/v1/alerts
  query:
    alert-manager:
      query-url: http://172.16.1.104:9193/api/v1/alerts
manager-proxy:
  endpoint: http://${service.roles["AQUILA_MANAGER_PROXY"][0].hostname}:${service["manager.proxy.web.port"]}
agent:
  port: ${service["agent.web.port"]}
