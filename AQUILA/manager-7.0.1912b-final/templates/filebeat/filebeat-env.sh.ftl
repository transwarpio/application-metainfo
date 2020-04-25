export FILEBEAT_HOST=${localhostname}
export FILEBEAT_PORT=${service['filebeat.port']}

<#if service.roles.KAFKA_SERVER??>
    <#assign kafkas=[]>
    <#list service.roles.KAFKA_SERVER as role>
        <#assign kafkas += [role.hostname + ":" + service[role.hostname]["kafka.listeners"]?split(":")[2]]>
    </#list>
</#if>
export KAFKA_HOSTS=${kafkas?join(",")}
export KAFKA_PORT=19092

<#if service.auth = "kerberos">
export KRB_ENABLE=true
export KRB_REALM=${service.realm}
export FB_PRINCIPAL=kafka/${localhostname}@${service.realm}
export FB_KEYTAB=/etc/${service.sid}/conf/milano.keytab
cp /etc/${service.sid}/conf/krb5.conf /etc
<#else>
export KRB_ENABLE=false
</#if>
