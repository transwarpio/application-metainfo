export KIBANA_HOST=${localhostname}

<#if dependencies.SEARCH??>
    <#assign search=dependencies.SEARCH searches=[] searchesWithPort=[]>
    <#list search.roles.SEARCH_SERVER as role>
        <#assign search = [role.hostname]>
        <#assign searchWithPort = [role.hostname + ":9200"]>
    </#list>
</#if>
export ELASTICSEARCH_URL=${searchWithPort[0]}
export KIBANA_PORT=${service['kibana.port']}
<#if service.auth = "kerberos">
cp /etc/${service.sid}/conf/krb5.conf /etc/
</#if>
