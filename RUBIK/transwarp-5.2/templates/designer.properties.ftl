#server port
designer.server.port=${service['designer.server.port']}
designer.authentication.enableguardian=${(service.auth == "kerberos")?c}
#connection pool
connectionpool.expiretime=${service['connectionpool.expiretime']}
#max group size
cube.group.max.size=${service['cube.group.max.size']}
cube.group.optimize=${service['cube.group.optimize']}
#max size of sub tasks executing concurrently in one task
subtask.execute.max.size=${service['subtask.execute.max.size']}
#cube parser
cubeparser.enablejoinhint=${service['cubeparser.enabalejoinhint']}
<#if dependencies.NOTIFICATION??>
#notification service
notification.server.addr=${dependencies.NOTIFICATION.roles.NOTIFICATION_SERVER[0]['hostname']}
notification.server.port=${dependencies.NOTIFICATION['notification.http.port']}
</#if>
service.rest.sleep.interval.ms=${service['service.rest.sleep.interval.ms']}
service.rest.retries=${service['service.rest.retries']}
service.rest.readTimeoutMSecs=${service['service.rest.readTimeoutMSecs']}
service.rest.connectTimeoutMSecs=${service['service.rest.connectTimeoutMSecs']}
service.checker.sleep.interval.min=${service['service.checker.sleep.interval.min']}
<#assign license_servers=[]>
<#list dependencies.LICENSE_SERVICE.roles.LICENSE_NODE as server>
    <#assign license_servers += [(server.hostname + ":" + dependencies.LICENSE_SERVICE[server.hostname]["zookeeper.client.port"])]>
</#list>
license.server.quorum=${license_servers?join(",")}

<#if service.auth = "kerberos">
    designer.server.host=${localhostname}
    <#if dependencies.GUARDIAN['cas.server.ssl.port']??>
        <#assign casServerSslPort=dependencies.GUARDIAN['cas.server.ssl.port']>
        <#assign casServerName="https://${dependencies.GUARDIAN.roles.CAS_SERVER[0]['hostname']}:${casServerSslPort}">
        cas.server.address=${casServerName}
    </#if>
</#if>