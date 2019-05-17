<#assign security_enabled="false">
<#if service.auth="kerberos">
  <#assign security_enabled="true">
</#if>

<#assign data_persistence_enabled="false">
<#if (service['dbaservice.persistence.enabled']!"false")="true">
  <#assign data_persistence_enabled="true">
</#if>

<#assign profile="normal">
<#if security_enabled="true">
  <#assign profile="security">
</#if>

spring.profiles.active: ${profile}

<#if data_persistence_enabled="true">
spring:
  datasource:
    url: jdbc:h2:file:${service['dbaservice.persistence.datadir']}/${service.sid};DB_CLOSE_ON_EXIT=FALSE;AUTO_RECONNECT=TRUE;MV_STORE=FALSE;CACHE_SIZE=102400;FILE_LOCK=NO;TRACE_LEVEL_FILE=0;LOG=0;LOCK_MODE=0;UNDO_LOG=0;RETENTION_TIME=0;MAX_QUERY_TIMEOUT=300000
    username: ${service['dbaservice.persistence.db.username']}
    password: ${service['dbaservice.persistence.db.password']}
</#if>

server.port: ${r"${watchman.server.port}"}

<#assign cas_server_host="127.0.0.1" cas_ssl_port="8393" context_path="/cas">
<#if dependencies.GUARDIAN?? && dependencies.GUARDIAN.roles.CAS_SERVER??>
  <#assign
    cas_server_host=dependencies.GUARDIAN.roles.CAS_SERVER[0]['ip']
    cas_ssl_port=dependencies.GUARDIAN['cas.server.ssl.port']
    context_path=dependencies.GUARDIAN['cas.server.context.path']
  >
</#if>
<#assign prefix="https://" + cas_server_host + ":" + cas_ssl_port + context_path>

cas:
  service:
    login: ${prefix + "/login"}
    logout: ${prefix + "/logout"}
    prefix: ${prefix}

<#assign guardian_config_path="">
<#if dependencies.GUARDIAN??>
  <#assign guardian_config_path="/etc/" + dependencies.GUARDIAN.sid + "/conf/guardian-site.xml">
</#if>

guardian:
  config:
    path: ${guardian_config_path}
    additional-path: /etc/${service.sid}/conf/guardian-site.xml

watchman:
  serviceid: ${service.sid}
  aiops:
    port: ${service['dbaservice.aiops.ui.port']}
  server:
    port: ${service['dbaservice.ui.port']}
    host: ${service.roles.DBA_SERVICE_SERVER[0]['ip']} # this is watchman node ip!
    home: http://${r"${watchman.server.host}"}:${r"${watchman.server.port}"}
    security: /login/cas
  message:
    protocol: akka
    port: ${service['dbaservice.message.port']}
    receiver: receiver
  security:
    enabled: ${security_enabled}
    local.enabled: false
  users:
    - username: admin
      password: admin
      roles: [ADMIN,USER]
    - username: user
      password: user
      roles: [USER]
  inceptor:
    data-persistence:
      enabled: ${data_persistence_enabled}
      limit:
        coldSql: ${service['dbaservice.persistence.inceptor.limit.sql']!'100000'}
        coldServer: ${service['dbaservice.persistence.inceptor.limit.server']!'10000'}
        coldExecutor: ${service['dbaservice.persistence.inceptor.limit.executor']!'10000'}
    targets:
      - type: MESSAGE
        target: ${r"${watchman.message.protocol}"}://${r"${watchman.server.host}"}:${r"${watchman.message.port}"}
        receiver: ${r"${watchman.message.receiver}"}
        harvestIntervalMs: 100
    limit:
      status: ${service['dbaservice.inceptor.limit.status']!'10000'}
      session: ${service['dbaservice.inceptor.limit.session']!'10000'}
      completeSql: ${service['dbaservice.inceptor.limit.completeSql']!'5000'}
      incompleteSql: ${service['dbaservice.inceptor.limit.incompleteSql']!'10000'}
      errorSql: ${service['dbaservice.inceptor.limit.errorSql']!'10000'}
      incompleteJob: ${service['dbaservice.inceptor.limit.incompleteJob']!'20000'}
      incompleteStage: ${service['dbaservice.inceptor.limit.incompleteStage']!'50000'}
      incompleteTask: ${service['dbaservice.inceptor.limit.incompleteTask']!'1000000'}
      incompleteLocalTask: ${service['dbaservice.inceptor.limit.incompleteLocalTask']!'1000000'}
      task: ${service['dbaservice.inceptor.limit.task']!'5000000'}
      noParentJob: ${service['dbaservice.inceptor.limit.noParentJob']!'20000'}
      noParentStage: ${service['dbaservice.inceptor.limit.noParentStage']!'50000'}
      noParentTask: ${service['dbaservice.inceptor.limit.noParentTask']!'1000000'}
      noParentLocalTask: ${service['dbaservice.inceptor.limit.noParentLocalTask']!'1000000'}
      expireTimeShort: ${service['dbaservice.inceptor.limit.expireTimeShort']!'604800000'} # in ms
      expireTimeLong: ${service['dbaservice.inceptor.limit.expireTimeLong']!'2592000000'} # in ms
