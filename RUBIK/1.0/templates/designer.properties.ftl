#server port
designer.server.port=${service['designer.server.port']}
designer.authentication.enableguardian=${service['designer.authentication.enableguardian']}
#connection pool
connectionpool.expiretime=${service['connectionpool.expiretime']}
#max group size
cube.group.max.size=${service['cube.group.max.size']}
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
