<#assign hostPorts = []>
<#list service.roles["GUARDIAN_TXSQL_SERVER"] as r>
    <#assign hostPorts = hostPorts + [r.hostname + ':' + service['mysql.rw.port']]>
</#list>
export CAS_SERVICEREGISTRY_JPA_URL=jdbc:mysql://${hostPorts?join(",")}/cas?createDatabaseIfNotExist=true&autoReconnect=true&failOverReadOnly=false&useSSL=false&characterEncoding=UTF-8
export CAS_SERVICEREGISTRY_JPA_USER=root
export CAS_SERVICEREGISTRY_JPA_PASSWORD=${service['root.password']}
export CAS_SERVICEREGISTRY_JPA_DRIVERCLASS=${service['guardian.database.driver']}
export TXSQL_SERVERS=${hostPorts?join(",")}
export MYSQL_DATABASE=cas

export CONFIG_SERVER_PORT=${service['cas.config.server.port']}
export CONFIG_USER_NAME=${service['cas.config.server.username']}
export CONFIG_USER_PASSWORD=${service['cas.config.server.password']}

<#assign casServerSslPort=service['cas.server.ssl.port']>
<#assign casServerName="https://${service.roles.CAS_SERVER[0]['hostname']}:${casServerSslPort}">
export CAS_SERVER_SSL_PORT=${casServerSslPort}
export CAS_SERVER_NAME=${casServerName}
export CAS_SERVER_PREFIX=${casServerName}/cas

export CAS_SERVER_CONTEXT_PATH=${service['cas.server.context.path']}

export CAS_SERVER_SSL_KEYSTORE=file:/srv/cas-server/server.keystore
export CAS_SERVER_SSL_KEYSTOREPASSWORD=changeit
export CAS_SERVER_SSL_KEYPASSWORD=changeit

export CAS_SERVER_HTTP_PORT=${service['cas.server.http.port']}
export CAS_SERVER_HTTP_ENABLED=${service['cas.server.http.enabled']}

<#assign ldapUrls=[]>
<#list service.roles["GUARDIAN_APACHEDS"] as role>
    <#assign ldapUrls += [("ldap://" + role.hostname + ":" + service["guardian.apacheds.ldap.port"])]>
</#list>
export CAS_AUTHN_LDAP_LDAPURL="${ldapUrls?join(' ')}"
export CAS_AUTHN_LDAP_USESSL=false
export CAS_AUTHN_LDAP_CONNECTIONSTRATEGY=ACTIVE_PASSIVE

export CAS_SERVICEREGISTRY_JPA_DIALECT=org.hibernate.dialect.MySQL57Dialect
export CAS_SERVICEREGISTRY_JPA_DDLAUTO=update

export CAS_TICKET_TGT_REMEMBERME_ENABLED=true
export CAS_TICKET_TGT_REMEMBERME_TIMETOKILLINSECONDS=1209600

export ENDPOINTS_ENABLED=true

<#assign casMgmtServerPort=service['cas.mgmt.server.port']>
export CAS_MGMT_SERVER_PORT=${casMgmtServerPort}
export CAS_MGMT_SERVERNAME=https://${service.roles.CAS_ADMIN_SERVER[0]['hostname']}:${casMgmtServerPort}

export CAS_MGMT_SERVER_SSL_KEYSTORE=file:/srv/cas-admin-server/server.keystore
export CAS_MGMT_SERVER_SSL_KEYSTOREPASSWORD=changeit
export CAS_MGMT_SERVER_SSL_KEYPASSWORD=changeit