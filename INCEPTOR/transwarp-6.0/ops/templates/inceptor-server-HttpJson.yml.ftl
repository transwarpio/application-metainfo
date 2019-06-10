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
- name: inceptor_server_executors_source
  className: io.transwarp.tdh.metrics.source.HttpJsonSource
  props:
    url: "http://${localhostname}:${service['inceptor.ui.port']}/executors/json/"
    timeoutSec: 60
    cacheSec: 60

metrics:
- name: inceptor_server_executors_number
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Number of running executors registered to the server"
  delaySec: 61
  source: inceptor_server_executors_source
  scrape:
    jsonPath: "$.length()"
    fromResultLabelMap: {}

- name: inceptor_sql_disk_used
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Disk usage of a single executor in MB. Unit: MB"
  delaySec: 61
  source: inceptor_server_executors_source
  scrape:
    jsonPath: "$"
    valueField: "diskUsed"
    parseFormat: DATA_IEC
    fromResultLabelMap:
      host: executor

- name: inceptor_sql_mem_used
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Memory usage of a single executor in percent. Unit: %"
  delaySec: 61
  source: inceptor_server_executors_source
  scrape:
    jsonPath: "$"
    valueField: "memUsed"
    parseFormat: DATA_IEC
    fromResultLabelMap:
      host: executor

- name: inceptor_server_shuffle_read_per_second
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: COUNTER
  help: "Bytes fetched from other nodes during the shuffle stage per second. Unit: bytes/s"
  delaySec: 61
  source: inceptor_server_executors_source
  scrape:
    jsonPath: "$"
    valueField: "totalShuffleRead"
    parseFormat: DATA_IEC
    fromResultLabelMap:
      host: executor

- name: inceptor_server_shuffle_write_per_second
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: COUNTER
  help: "Bytes written to disk during the shuffle stage per second. Unit: bytes/s"
  delaySec: 61
  source: inceptor_server_executors_source
  scrape:
    jsonPath: "$"
    valueField: "totalShuffleWrite"
    parseFormat: DATA_IEC
    fromResultLabelMap:
      host: executor

- name: inceptor_server_sql_active_tasks
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: COUNTER
  help: "Number of active tasks. Unit: count"
  delaySec: 61
  source: inceptor_server_executors_source
  scrape:
    jsonPath: "$"
    valueField: "activeTask"
    fromResultLabelMap:
      host: executor

- name: inceptor_server_sql_completed_tasks
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: COUNTER
  help: "Number of completed tasks. Unit: count"
  delaySec: 61
  source: inceptor_server_executors_source
  scrape:
    jsonPath: "$"
    valueField: "completedTasks"
    fromResultLabelMap:
      host: executor

- name: inceptor_server_sql_failed_tasks
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: COUNTER
  help: "Number of failed tasks. Unit: count"
  delaySec: 61
  source: inceptor_server_executors_source
  scrape:
    jsonPath: "$"
    valueField: "failedTask"
    fromResultLabelMap:
      host: executor

- name: inceptor_server_sql_total_tasks
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: COUNTER
  help: "Number of total tasks. Unit: count"
  delaySec: 61
  source: inceptor_server_executors_source
  scrape:
    jsonPath: "$"
    valueField: "totalTasks"
    fromResultLabelMap:
      host: executor