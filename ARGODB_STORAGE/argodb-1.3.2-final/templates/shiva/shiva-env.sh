<#if service.roles.SHIVA_MASTER?? && service.roles.SHIVA_MASTER?size gt 0>
  <#assign masters=[]/>
  <#assign node_exporter_mats=[]/> 
 <#list service.roles.SHIVA_MASTER as role>
    <#assign masters += [role.ip + ":" + service["shiva.master.rpc_service.master_service_port"]]>
    <#assign node_exporter_mats += [role.ip + ":" + service["shiva.prometheus.node.exporter.port"]]> 
 </#list>
  <#assign node_exporter_mat = node_exporter_mats?join(",")>
  <#assign master_group = masters?join(",")>
export MASTER_GROUP=${master_group}
</#if>

<#if service['shiva.tabletserver.jvm.enable.bootstrap.checks'] == "true">
# WARP-40573: mmap count should be at least 262144
export MAX_MAP_COUNT=262144
</#if>

<#assign prometheus_master_ip = localhostname + ":" + service["shiva.http.port"]>
export PROMETHEUS_MASTER_IP=${prometheus_master_ip}

<#assign prometheus_url = localhostname + ":" + service["shiva.grafana.datasource.prometheus.url.port"]>
export GRAFANA_DATASOURCE_PROMETHEUS_URL=${prometheus_url}


<#if service.roles.SHIVA_TABLETSERVER?? && service.roles.SHIVA_TABLETSERVER?size gt 0>
  <#assign metrics_ips=[]/>
  <#assign node_exporter_tabs=[]/>
  <#list service.roles.SHIVA_TABLETSERVER as role>
    <#assign metrics_ips += [role.ip + ":" + service["shiva.prometheus.metrics.group.port"]]>
    <#assign node_exporter_tabs += [role.ip + ":" + service["shiva.prometheus.node.exporter.port"]]>
  </#list>
  <#assign metrics_ip = metrics_ips?join(",")>
  <#assign node_exporter_tab = node_exporter_tabs?join(",")>
export PROMETHEUS_METRICS_GROUP_IP=${metrics_ip}
</#if>

<#if service.roles.SHIVA_WEBSERVER?? && service.roles.SHIVA_WEBSERVER?size gt 0>
  <#assign node_exporter_webs=[]/>
  <#list service.roles.SHIVA_WEBSERVER as role>
    <#assign node_exporter_webs += [role.ip + ":" + service["shiva.prometheus.node.exporter.port"]]>
  </#list>
  <#assign node_exporter_web = node_exporter_webs?join(",")>
</#if>

export PROMETHEUS_NODE_EXPORTER_IP=${node_exporter_mat},${node_exporter_web},${node_exporter_tab}

export GRAFANA_PATH=${service['shiva.grafana_path']}

export PROMETHEUS_PORT=${service['shiva.prometheus.port']}

export LOG_DIR=${service['shiva.master.log.log_dir']}

