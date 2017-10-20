<#assign servers=service.roles.GUARDIAN_APACHEDS?sort_by("id") master=servers[0].hostname>
<#if (servers?size >1)>
<#assign slaves=servers[1..(servers?size-1)] slaves_with_port=[]>
<#list slaves as slave>
    <#assign slaves_with_port += [slave.hostname + ":" + service['guardian.apacheds.ldap.port']]>
</#list>
</#if>
<#--Guardian Server-->
export LDAP_HOST=${master}
export LDAP_PORT=${service['guardian.apacheds.ldap.port']}

<#--Guardian ApacheDs-->
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

export GUARDIAN_LOG_DIR=/var/log/${service.sid}
export GUARDIAN_SERVER_KEY_STORE=/srv/guardian/server.keystore
export JAVA_OPTS=" $JAVA_OPTS -Djava.security.krb5.conf=/etc/${service.sid}/conf/krb5.conf "
export JAVA_OPTS=" $JAVA_OPTS -Xms1024m -Xmx2048m -XX:MaxPermSize=128m -XX:+UseConcMarkSweepGC -XX:+PrintGCDetails -XX:+PrintGCDateStamps -Xloggc:$GUARDIAN_LOG_DIR/guardian-server_gc.log -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=$GUARDIAN_LOG_DIR "

<#--Add guardian server cache replication configuration-->
<#assign guardian_servers=service.roles.GUARDIAN_SERVER servers_with_port=[]>
<#list guardian_servers as server>
    <#assign servers_with_port += [server.hostname + "[" + service['guardian.cache.repli.bind.port'] + "]"]>
</#list>
<#if servers_with_port?seq_contains(localhostname + "[" + service['guardian.cache.repli.bind.port'] + "]")>
export GUARDIAN_CACHE_REPLI_BIND_HOST=${localhostname}
export GUARDIAN_CACHE_REPLI_BIND_PORT=${service['guardian.cache.repli.bind.port']}
export GUARDIAN_CACHE_REPLI_INITIAL_HOSTS=${servers_with_port?join(",")}
export GUARDIAN_CACHE_REPLI_PORT_RANGE=1
export GUARDIAN_CACHE_REPLI_NUM=${guardian_servers?size}
</#if>
