<#if service['crontab.enable'] = "true">
${service['crontab.schedule.time']} curator --config /opt/curator/conf/config.yaml /opt/curator/conf/actions.yaml
</#if>
