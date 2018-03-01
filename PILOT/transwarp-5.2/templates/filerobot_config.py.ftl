
FILEROBOT_WORKERS = ${service['filerobot.server.worker.number']}

FILEROBOT_WEBSERVER_PORT = ${service['filerobot.desktop.http.port']}

# CAS
<#if service.auth = "kerberos">
    <#if dependencies.GUARDIAN['cas.server.ssl.port']??>
        <#assign casServerSslPort=dependencies.GUARDIAN['cas.server.ssl.port']>
        <#assign casServerName="https://${dependencies.GUARDIAN.roles.CAS_SERVER[0]['hostname']}:${casServerSslPort}">
CAS_AUTH = True
    <#else>
CAS_AUTH = False
    </#if>
</#if>

# The guardian config
<#if service.auth = "kerberos">
    <#assign guardianHost = dependencies.GUARDIAN.roles.GUARDIAN_SERVER?sort_by("id")[0].hostname>
    <#assign guardianPort = dependencies.GUARDIAN["guardian.server.port"]>
ACCESS_CONTROL = True
GUARDIAN_SERVER_ADDRESS = '${guardianHost}:${guardianPort}'
<#else>
ACCESS_CONTROL = False
</#if>

