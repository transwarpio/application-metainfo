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
- name: kundb_kungate_debug_var_source
  className: io.transwarp.tdh.metrics.source.HttpJsonSource
  props:
    url: "http://${localhostname}:${service['kungate.debug.port']}/debug/vars"
    timeoutSec: 60
    cacheSec: 60

metrics:
- name: kundb_kungate_mysqlServerTimings_sum_total
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: COUNTER
  help: "total number of Connection and Query in kungate since it was started."
  delaySec: 61
  source: kundb_kungate_debug_var_source
  scrape: 
    jsonPath: "$.MysqlServerTimings"
    valueField: "TotalCount"
    fromResultLabelMap: {}

- name: kundb_kungate_kuntabletCall_sum_total
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: COUNTER
  help: "total number of vttablet call in kungate since it was started."
  delaySec: 61
  source: kundb_kungate_debug_var_source
  scrape: 
    jsonPath: "$.VttabletCall"
    valueField: "TotalCount"
    fromResultLabelMap: {}
