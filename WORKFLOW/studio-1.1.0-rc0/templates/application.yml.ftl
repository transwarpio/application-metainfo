# the general settings for workflow application
app:
  # the application name
  name: ${service.sid}
  # indicates whether workflow works under access control
  access-control: ${(service.auth = "kerberos")?c}

workflow.address: ${localhostname}:${service['workflow.http.port']}

<#if service.auth = "kerberos" && dependencies.GUARDIAN['cas.server.ssl.port']??>
<#assign casServerSslPort=dependencies.GUARDIAN['cas.server.ssl.port']>
  <#if dependencies.GUARDIAN['guardian.server.cas.server.host']?matches("^\\s*$")>
    <#assign casServerName="https://${dependencies.GUARDIAN.roles.CAS_SERVER[0]['ip']}:${casServerSslPort}">
  <#else>
    <#assign casServerName="https://${dependencies.GUARDIAN['guardian.server.cas.server.host']}:${casServerSslPort}">
  </#if>
<#assign casServerContextPath="${dependencies.GUARDIAN['cas.server.context.path']}">
<#assign casServerPrefix="${casServerName}${casServerContextPath}">
cas:
  enable: true
  server:
    prefix: ${casServerPrefix}
    login: "/login"
    logout: "/logout"
<#else>
cas:
  enable: false
</#if>

<#--handle dependent.zookeeper-->
<#if dependencies.ZOOKEEPER??>
  <#assign zookeeper=dependencies.ZOOKEEPER quorums=[]>
  <#list zookeeper.roles.ZOOKEEPER as role>
    <#assign quorums += [role.hostname + ":" + zookeeper["zookeeper.client.port"]]>
  </#list>
  <#assign quorum = quorums?join(",")>
</#if>
agent-discovery:
  enable: true
  zkQuorum: ${quorum}
  zkSessionTimeoutMillis: 120000
  zNodeBase: ${service.sid}
  zNodeRegistry: registry

# the general control of enabling/disabling transporter-client
<#if dependencies.TRANSPORTER?? && dependencies.TRANSPORTER.roles.TDT_SERVER?size gt 0>
transporter.enabled: true

<#--handle dependent.transporter-->
<#assign transporter=dependencies.TRANSPORTER address=[]>
<#list transporter.roles.TDT_SERVER as role>
    <#assign address += [role.hostname + ":" + transporter["tdt.server.port"]]>
</#list>
<#assign address = address?join(",")>

# the host of transporter
transporter.address: ${address}

<#else>
transporter.enabled: false
</#if>

job:
  # the job plugin directory
      # if starts with slash, treat as absolute path;
      # otherwise relative to the root directory of workflow application
  dir-prefix: job

pseudo:
  username: ${service['workflow.pseudo.username']}
  password: ${service['workflow.pseudo.password']}

# shiro session timeout in seconds if exists
session.timeout.seconds: ${service['workflow.session.timeout.seconds']}

# http cookie rememberMe in days
cookie.remember-me.days: ${service['workflow.cookie.rememberme.days']}

# http cookie max-age in hours
cookie.max-age.hours: ${service['workflow.cookie.maxage.hours']}

# folder for internationalization files
spring.messages.basename: "classpath:i18n/locale"

# http upload file size
spring:
  http:
    multipart:
      enabled: true
      max-file-size: 50MB
      max-request-size: 50MB