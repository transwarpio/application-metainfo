
FILEROBOT_WORKERS = ${service['filerobot.server.worker.number']}

FILEROBOT_WEBSERVER_PORT = ${service['filerobot.desktop.http.port']}

# The guardian config
<#if service.auth = "kerberos">
    <#assign guardianHost = dependencies.GUARDIAN.roles.GUARDIAN_SERVER?sort_by("id")[0].hostname>
    <#assign guardianPort = dependencies.GUARDIAN["guardian.server.port"]>
GUARDIAN_SERVER_ADDRESS = '${guardianHost}:${guardianPort}'
<#else>
ACCESS_CONTROL = False
</#if>

