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
        <#assign hostPorts = hostPorts + [r.hostname + ':' + service['mysql.rw.port']]>
    </#list>
    <#assign txsql = hostPorts?join(",")>
</#if>
spring.datasource:
  driver-class-name: com.mysql.cj.jdbc.Driver
  url: jdbc:mysql://${txsql}/aquila?createDatabaseIfNotExist=true&characterEncoding=UTF-8&failOverReadOnly=false&connectTimeout=10000&retriesAllDown=0&secondsBeforeRetryMaster=0&queriesBeforeRetryMaster=0&serverTimezone=${service['server.jdbc.connctor.timezone']}
  username: root

shiro:
  sessionManager:
    cookie:
      name: AJSSIONID
  rememberMeManager:
    cookie:
      maxAge: ${service['server.rememberme.max-age']}
      name: aRememberMe

springfox.documentation:
  auto-startup: true
  swagger.v2.path: /api/docs

## ----- application configs
<#assign prometheusHost = service.roles["AQUILA_PROMETHEUS"][0].hostname>
<#assign alertmanagerHost = service.roles["AQUILA_ALERTMANAGER"][0].hostname>
<#assign alertserverHost = service.roles["AQUILA_SERVER"][0].hostname>
<#assign prometheusEndpoint = "http://" + prometheusHost + ":" + service["prometheus.web.port"]>
<#assign alertmanagerEndpoint = "http://" + alertmanagerHost + ":" + service["alertmanager.web.port"]>
<#assign alertserverEndpoint = "http://" + alertserverHost + ":" + service["server.web.port"]>
api:
  cache-control-filter:
    static-max-age: 86400
  swagger:
    enabled: ${service['server.api.swagger.enabled']}
auth:
  type: "manager"
  manager-sso:
    login-path: "/#/ssologin"
  authorization:
    anonymous-admin: ${service['server.authz.anonymous.admin']}
    cache-expire-sec: ${service['server.authz.cache.expire.sec']}
conf-gen:
  freemarker:
    strong-size-limit: 10
http-client:
  timeout:
    connect: ${service['http-client.connect.timeout']}
    connection-request: ${service['http-client.connection-request.timeout']}
    socket: ${service['http-client.socket.timeout']}
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
      push-url: ${alertmanagerEndpoint}/api/v1/alerts
    filter-keys: [ "clusterId", "nodeId", "serviceId" ]
  query:
    alert-manager:
      query-url: ${alertmanagerEndpoint}/api/v1/alerts?inhibited=false
    filter-keys: [ "clusterId", "nodeId", "serviceId" ]
    limit: ${service['server.alert.query.limit']}
  history:
    queue:
      data-dir: ${service['server.alert.history.queue.data.dir']}
      tail-delay-ms: 1000
  notify:
    generate:
      max-threads: 3
      time-out-sec: 180
      host: ${alertmanagerHost}
      path: /etc/${service.sid}/conf/alertmanager/alertmanager.yml
      upload-trigger: ${alertmanagerEndpoint}/-/reload
      static-config:
        global-resolve-timeout: 5m
        history-web-hook-urls:
          - ${alertserverEndpoint}/api/alert/history/fromAlertManager
        execute-script-web-hook-urls:
          - ${alertserverEndpoint}/api/alert/bridge/executeScript
manager-proxy:
  endpoints:
<#list managerEndPoints as endpoint>
    - ${endpoint}
</#list>
  user: __Aquila
agent:
  port: ${service["agent.web.port"]}
