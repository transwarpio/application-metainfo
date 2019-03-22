<#assign hostPorts = []>
<#list service.roles["GUARDIAN_TXSQL_SERVER"] as r>
    <#assign hostPorts = hostPorts + [r.hostname + ':' + service['mysql.rw.port']]>
</#list>
<#assign hostPorts = hostPorts?sort 
                 i = hostPorts?seq_index_of(localhostname + ':' + service['mysql.rw.port'])>
<#if i lt 0>
    <#assign i = .now?long % service.roles['GUARDIAN_TXSQL_SERVER']?size>
</#if>
<#if i gt 0>
     <#assign hostPorts = hostPorts[i..] + hostPorts[0..i-1]>
</#if>
export CAS_SERVICEREGISTRY_JPA_URL=jdbc:mysql://${hostPorts?join(",")}/cas?createDatabaseIfNotExist=true&autoReconnect=true&failOverReadOnly=false&useSSL=false&characterEncoding=UTF-8&connectTimeout=10000&retriesAllDown=0&secondsBeforeRetryMaster=0&queriesBeforeRetryMaster=0
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

export CAS_TICKET_ST_NUMBEROFUSES=${service['cas.ticket.st.numberOfUses']}
export CAS_TICKET_ST_TIMETOKILLINSECONDS=${service['cas.ticket.st.timeToKillInSeconds']}

export CAS_TICKET_PT_NUMBEROFUSES=${service['cas.ticket.pt.numberOfUses']}
export CAS_TICKET_PT_TIMETOKILLINSECONDS=${service['cas.ticket.pt.timeToKillInSeconds']}

export CAS_AUTHN_LDAP_DOMAIN=${service['guardian.ds.domain']}