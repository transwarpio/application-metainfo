## ----- framework specific configs -----
server:
  port: ${service['heimdal.web.port']}
  platform: "manager"
  timeZone: "Asia/Shanghai"

time:
  fixed-delay: 30000

aquila-server:
  host: ${service.roles["AQUILA_SERVER"][0].hostname}
  port: ${service['server.web.port']}
  timeout: 30000
  ssl: false

thread-pool:
  core-pool-size: 4
  max-pool-size: 10
  keep-alive-seconds: 60
  queue-capacity: 100

## ----- application configs
<#assign alertmanagerHost = service.roles["AQUILA_ALERTMANAGER"][0].hostname>
<#assign alertmanagerEndpoint = "http://" + alertmanagerHost + ":" + service["alertmanager.web.port"]>
<#if service.modules.LOG??>
    <#assign edition = service.modules.LOG>
<#else>
    <#assign edition = "NOT_EXIST">
</#if>

log:
  feature:
<#if edition == "NONE" || edition == "NOT_EXIST">
    enabled: false
<#else>
    enabled: true
  index:
    prefix: "logs,persisted-logs"
  alert:
    fixed-delay: ${service['heimdal.log.alert.interval']}
    push-url: ${alertmanagerEndpoint}/api/v1/alerts
</#if>

<#if edition != "NONE" && edition != "NOT_EXIST">
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
</#if>