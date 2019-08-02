<#if dependencies.SEARCH??>
    <#assign search=dependencies.SEARCH searches=[] searchesWithPort=[]>
    <#list search.roles.SEARCH_SERVER as role>
        <#assign searches += [role.hostname]>
        <#assign searchesWithPort += [role.hostname + ":9200"]>
    </#list>
</#if>
<#if service['crontab.enable'] = "true">
${service['crontab.schedule.time']} ES_HOSTS=${searches[0]} ES_PORT=9200 INDEX_PREFIX=${service['crontab.index.prefix']} RETENTION_DAYS=${service['crontab.retention.days']} curator --config /opt/curator/conf/config.yaml /opt/curator/conf/actions.yaml
${service['crontab.schedule.time']} ES_HOSTS=${searches[0]} ES_PORT=9200 INDEX_PREFIX=persisted-${service['crontab.index.prefix']} RETENTION_DAYS=${service['crontab.persisted.retention.days']} curator --config /opt/curator/conf/config.yaml /opt/curator/conf/actions.yaml
  <#if service['crontab.conf']??>
    <#list service['crontab.conf'] as key, value>
${service['crontab.schedule.time']} ES_HOSTS=${searches[0]} ES_PORT=9200 INDEX_PREFIX=${key} RETENTION_DAYS=${value} curator --config /opt/curator/conf/config.yaml /opt/curator/conf/actions.yaml
    </#list>
  </#if>
</#if>
