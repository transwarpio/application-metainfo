
export NOTIFICATION_HOME=/usr/lib/${service.sid}
export LOG_DIR=/var/log/${service.sid}
export NOTIFICATION_SERVER_PORT=${service['notification.http.port']}

<#assign hostPorts = []>
<#assign txsql = dependencies['TXSQL']>
<#list txsql.roles['TXSQL_SERVER'] as r>
    <#assign hostPorts = hostPorts + [r.hostname + ':' + txsql['mysql.rw.port']]>
</#list>
export MYSQL_SERVER_PORT=${hostPorts?join(",")}
export JAVAX_JDO_OPTION_CONNECTION_URL=jdbc:mysql://${hostPorts?join(",")}/notification_${service.sid}
export JAVAX_JDO_OPTION_CONNECTION_USERNAME=${service['javax.jdo.option.ConnectionUserName']}
export JAVAX_JDO_OPTION_CONNECTION_PASSWORD=${service['javax.jdo.option.ConnectionPassword']}
export DATABASE_NAME=notification_${service.sid}
export TABLE_NAME=nt_notification
export STUDIO_SCHEMA_SQL=/etc/${service.sid}/conf/init_notification.sql
