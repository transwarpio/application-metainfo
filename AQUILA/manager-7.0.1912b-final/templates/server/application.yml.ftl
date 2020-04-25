## ----- framework specific configs -----
server:
  timeZone: "Asia/Shanghai"
  port: ${service['server.web.port']}
  compression:
    enabled: true
    mime-types: text/*,application/json,application/*+json,application/javascript
    min-response-size: 10KB
  error:
    whitelabel:
      enabled: false
  platform: "manager"
  logout-callback: http://${localhostname}:${service['server.web.port']}

shiro:
  sessionManager:
    cookie:
      name: AJSSIONID
  rememberMeManager:
    cookie:
      maxAge: ${service['server.rememberme.max-age']}
      name: aRememberMe
  logoutUrl: 'http://172.16.1.196:9000/federation-server/logout?client_id=client-aquila-7O0F2FjemN'

springfox.documentation:
  auto-startup: true
  swagger.v2.path: /api/docs

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

space:
  service-init-source: "/var/lib/aquila"
  context:
    type: single

conf-gen:
  freemarker:
    strong-size-limit: 10

http-client:
  timeout:
    connect: ${service['http-client.connect.timeout']}
    connection-request: ${service['http-client.connection-request.timeout']}
    socket: ${service['http-client.socket.timeout']}
  retry: 3

metrics:
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
      - id: 4
        name: "Elasticsearch"
        type: ELASTICSEARCH
  dashboard-source:
    predefined:
      type: TDH_DASHBOARD
      platformClassPath:
        - dashboard/tdh/init-dashboard.yml
        - dashboard/tdh/init-kundb.yml

log:
  feature:
    enabled: true
    mode: deluxe
  thread-pool:
    max-threads: 10
    time-out-sec: 30
    queue-capacity: 100
  filters:
    platform: "service,service_instance_name"
    tenant: "service,service_instance_name"
  index:
    prefix: "logs,persisted-logs"
  log-source:
    predefined:
      type: TDH_QUERY
      platformClassPath: log/deluxe/tdh/platform/init-log.yml
es:
  client:
    server: ${service[service.groupNames[0]]['SEARCH_SERVER'][0]['hostname']}
    port: ${service[service[service.groupNames[0]]['SEARCH_SERVER'][0]['id']?c]['search.transport.tcp.port']}
    timeout: 5s
<#if service.auth = "kerberos">
    security-on: true
    keytabPath: /etc/${service.sid}/${service.groupNames[0]}/conf/search/search.keytab
    principal: elasticsearch/${service[service.groupNames[0]]['SEARCH_SERVER'][0]['hostname']}@${service.realm}
<#else>
    security-on: false
</#if>

alert:
  rule:
    init-predefined-needed: true
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
  notify:
    types:
      - Email
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
  history:
    queue:
      data-dir: ${service['server.alert.history.queue.data.dir']}
      tail-delay-ms: 1000
  rule-source:
    predefined:
      type: TDH_RULE
      platformClassPath: alert/tdh/init-rule.yml

manager-proxy:
  endpoints:
<#list managerEndPoints as endpoint>
    - ${endpoint}
</#list>
  user: __Aquila

agent:
  port: ${service["agent.web.port"]}
