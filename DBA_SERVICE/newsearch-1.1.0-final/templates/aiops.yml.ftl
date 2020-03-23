# ---------------------------------------------------------------
# Spring boot
# ---------------------------------------------------------------
springboot:
  server.port: ${service['dbaservice.aiops.ui.port']}
<#if (service['dbaservice.server.tls.enabled']!"false")="true">
  security.require-ssl: true
  server.ssl.key-store-type: JKS
  server.ssl.key-store: /server.keystore
  server.ssl.key-store-password: changeit
</#if>