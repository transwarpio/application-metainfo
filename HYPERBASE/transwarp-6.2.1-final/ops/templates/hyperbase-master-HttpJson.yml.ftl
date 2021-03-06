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
- name: hyperbase_master_server_source
  className: io.transwarp.tdh.metrics.source.HttpJsonSource
  props:
    url: "http://${localhostname}:${service['master.info.port']}/jmx?qry=Hadoop:service=HBase,name=Master,sub=Server&&user.name=xxx"
    timeoutSec: 60
    cacheSec: 60

- name: hyperbase_master_jvm_metrics_source
  className: io.transwarp.tdh.metrics.source.HttpJsonSource
  props:
    url: "http://${localhostname}:${service['master.info.port']}/jmx?qry=Hadoop:service=HBase,name=JvmMetrics&&user.name=xxx"
    timeoutSec: 60
    cacheSec: 60

- name: hyperbase_master_assignment_manager_source
  className: io.transwarp.tdh.metrics.source.HttpJsonSource
  props:
    url: "http://${localhostname}:${service['master.info.port']}/jmx?qry=Hadoop:service=HBase,name=Master,sub=AssignmentManger&&user.name=xxx"
    timeoutSec: 60
    cacheSec: 60

metrics:
- name: hyperbase_master_is_active_master_or_not
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Hyperbase Master is active master(1.0) or backup master(0.0). "
  delaySec: 61
  source: hyperbase_master_server_source
  scrape:
    jsonPath: "$.beans[0].['tag.isActiveMaster']"
    valueMapping:
      true: 1.0
      false: 0.0

- name: hyperbase_master_num_live_region_servers
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Number of live regionservers. Unit: count"
  delaySec: 61
  source: hyperbase_master_server_source
  scrape:
    jsonPath: "$.beans[0].numRegionServers"

- name: hyperbase_master_num_dead_region_servers
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Number of dead regionservers. Unit: count"
  delaySec: 61
  source: hyperbase_master_server_source
  scrape:
    jsonPath: "$.beans[0].numDeadRegionServers"

- name: hyperbase_master_average_load
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "The average load on the HBase server. Unit: count"
  delaySec: 61
  source: hyperbase_master_server_source
  scrape:
    jsonPath: "$.beans[0].averageLoad"

- name: hyperbase_master_gc_count
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: COUNTER
  help: "Counts the number of total garbage collections. Unit: count"
  delaySec: 61
  source: hyperbase_master_jvm_metrics_source
  scrape:
    jsonPath: "$.beans[0].GcCount"

- name: hyperbase_master_gc_time_millis
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: COUNTER
  help: "Time spent in garbage collection in milliseconds. Unit: ms"
  delaySec: 61
  source: hyperbase_master_jvm_metrics_source
  scrape:
    jsonPath: "$.beans[0].GcTimeMillis"

- name: hyperbase_master_transition_region_count
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Number of regions in transition. Unit: count"
  delaySec: 61
  source: hyperbase_master_assignment_manager_source
  scrape:
   jsonPath: "$.beans[0].ritCount"
   fromResultLabelMap: {}