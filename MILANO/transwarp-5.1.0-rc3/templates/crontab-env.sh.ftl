<#if dependencies.SEARCH??>
    <#assign search=dependencies.SEARCH searches=[] searchesWithPort=[]>
    <#list search.roles.SEARCH_SERVER as role>
        <#assign searches += [role.hostname]>
        <#assign searchesWithPort += [role.hostname + ":9200"]>
    </#list>
</#if>
export ES_HOSTS=${searches[0]}
export ES_PORT=9200

export INDEX_PREFIX=${service['crontab.index.prefix']}
export RETENTION_DAYS=${service['crontab.retention.days']}
export PERSISTED_INDEX_PREFIX=persisted-${service['crontab.index.prefix']}
export PERSISTED_RETENTION_DAYS=${service['crontab.persisted.retention.days']}
