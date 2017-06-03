<#assign
registryServer=dependencies.REGISTRY.roles['REGISTRY_SERVER'][0].hostname
registryPort=dependencies.REGISTRY['registry.port']
servers=service.roles.GUARDIAN_APACHEDS?sort_by("id")
master=servers[0].hostname
>
<#if (servers?size >1)>
<#assign slaves=servers[1..(servers?size-1)] slaves_with_port=[]>
<#list slaves as slave>
    <#assign slaves_with_port += [slave.hostname + ":" + service['guardian.apacheds.ldap.port']]>
</#list>
</#if>
<#--Guardian Server-->
export GUARDIAN_SERVER_BIND_PORT=${service['guardian.server.port']}
export LDAP_HOST=${master}
export LDAP_PORT=${service['guardian.apacheds.ldap.port']}
export GUARDIAN_CONNECTION_PASSWORD=${service['guardian.admin.password']}
export BIND_PWD=${service['guardian.ds.root.password']}
<#if (servers?size > 1)>
export LDAP_SLAVES=${slaves_with_port?join(";")}
</#if>

<#--Guardian ApacheDs-->
export GUARDIAN_DS_DOMAIN=${service['guardian.ds.domain']}
export GUARDIAN_DS_LDAP_PORT=${service['guardian.apacheds.ldap.port']}
export GUARDIAN_DS_REALM=${service['guardian.ds.realm']}
export GUARDIAN_DS_KDC_PORT=${service['guardian.apacheds.kdc.port']}
export GUARDIAN_DS_PARTITION_SYNC_ON_WRITE=false
export GUARDIAN_DS_ADMIN_PASSWORD=${service['guardian.admin.password']}
export GUARDIAN_DS_ROOT_PASSWORD=${service['guardian.ds.root.password']}
<#if (servers?size > 1)>
export GUARDIAN_DS_HA_ENABLED=true
export GUARDIAN_DS_HA_STATUS=${(master == localhostname)?then("master", "slave")}
<#else>
export GUARDIAN_DS_HA_ENABLED=false
</#if>
<#if master != localhostname>
export GUARDIAN_DS_HA_MASTER_HOST=${master}
export GUARDIAN_DS_HA_MASTER_PORT=${service['guardian.apacheds.ldap.port']}
</#if>
export GUARDIAN_SERVER_TLS_ENABLED=${service['guardian.server.tls.enabled']}
export GUARDIAN_SERVER_KEY_STORE=/srv/guardian/server.keystore
export GUARDIAN_SERVER_KEY_STORE_PW=changeit