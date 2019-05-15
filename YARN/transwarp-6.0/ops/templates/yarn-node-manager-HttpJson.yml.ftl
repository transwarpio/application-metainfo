<#macro serviceLabel>
    serviceId: ${service.id }
    clusterId: ${service.clusterId}
</#macro>
<#macro roleLabel>
    roleId: ${.data_model['role.id']}
    roleType: ${.data_model['role.name']}
<#if .data_model['role.groupId'] ??>
    roleGroupId: ${.data_model['role.groupId']}
</#if>
    nodeId: ${.data_model['node.id']}
    rackId: ${.data_model['node.rackId']}
    hostname: ${.data_model['localhostname']}
</#macro>
sources:
- name: node_manager_metrics_source
  className: io.transwarp.tdh.metrics.source.HttpJsonSource
  props:
    url: "http://${localhostname}:${service['nodemanager.webapp.port']}/jmx?qry=Hadoop:service=NodeManager,name=NodeManagerMetrics"
    timeoutSec: 60
    cacheSec: 60

metrics:
- name: node_manager_allocated_vcores
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Allocated VCores on a single NodeManger. Unit: count"
  delaySec: 61
  source: node_manager_metrics_source
  scrape:
    jsonPath: "$.beans[0].AllocatedVCores"
    fromResultLabelMap: {}

- name: node_manager_available_vcores
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Available VCores on a single NodeManger. Unit: count"
  delaySec: 61
  source: node_manager_metrics_source
  scrape:
    jsonPath: "$.beans[0].AvailableVCores"
    fromResultLabelMap: {}