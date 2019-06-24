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
- name: name_node_node_status_source
  className: io.transwarp.tdh.metrics.source.HttpJsonSource
  props:
    url: "http://${localhostname}:${service['namenode.http-port']}/jmx?qry=Hadoop:service=NameNode,name=NameNodeStatus&&user.name=xxx"
    timeoutSec: 60
    cacheSec: 60

- name: name_node_FSNamesystem_source
  className: io.transwarp.tdh.metrics.source.HttpJsonSource
  props:
    url: "http://${localhostname}:${service['namenode.http-port']}/jmx?qry=Hadoop:service=NameNode,name=FSNamesystem&&user.name=xxx"
    timeoutSec: 60
    cacheSec: 60

- name: name_node_last_young_gc_duration_source
  className: io.transwarp.tdh.metrics.source.HttpJsonSource
  props:
    url: "http://${localhostname}:${service['namenode.http-port']}/jmx?qry=java.lang:type=GarbageCollector,name=ParNew"
    timeoutSec: 60
    cacheSec: 60

- name: name_node_last_old_gc_duration_source
  className: io.transwarp.tdh.metrics.source.HttpJsonSource
  props:
    url: "http://${localhostname}:${service['namenode.http-port']}/jmx?qry=java.lang:type=GarbageCollector,name=ConcurrentMarkSweep"
    timeoutSec: 60
    cacheSec: 60

- name: name_node_jvm_metrics_source
  className: io.transwarp.tdh.metrics.source.HttpJsonSource
  props:
    url: "http://${localhostname}:${service['namenode.http-port']}/jmx?qry=Hadoop:service=NameNode,name=JvmMetrics&&user.name=xxx"
    timeoutSec: 60
    cacheSec: 60

- name: name_node_activity_source
  className: io.transwarp.tdh.metrics.source.HttpJsonSource
  props:
    url: "http://${localhostname}:${service['namenode.http-port']}/jmx?qry=Hadoop:service=NameNode,name=NameNodeActivity&&user.name=xxx"
    timeoutSec: 60
    cacheSec: 60

metrics:
- name: name_node_is_active_or_not
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Namenode is active(1.0) or standby(0.0). "
  delaySec: 61
  source: name_node_node_status_source
  scrape:
    jsonPath: "$.beans[0].State"
    valueMapping:
      active: 1.0
      standy: 0.0

- name: name_node_capacity_total
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Current total configured capacity across all DataNodes Disks in bytes. Unit: bytes"
  delaySec: 61
  source: name_node_FSNamesystem_source
  scrape:
    jsonPath: "$.beans[0].CapacityTotal"

- name: name_node_capacity_used
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Current used capacity across all DataNodes in bytes. Unit: bytes"
  delaySec: 61
  source: name_node_FSNamesystem_source
  scrape:
    jsonPath: "$.beans[0].CapacityUsed"

- name: name_node_capacity_remaining
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Current remaining capacity in bytes. Unit: bytes"
  delaySec: 61
  source: name_node_FSNamesystem_source
  scrape:
    jsonPath: "$.beans[0].CapacityRemaining"

- name: name_node_total_load
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Current number of connections. Unit: count"
  delaySec: 61
  source: name_node_FSNamesystem_source
  scrape:
    jsonPath: "$.beans[0].TotalLoad"

- name: name_node_capacity_used_percent
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Used capacity percent. Unit: %"
  delaySec: 61
  source: name_node_FSNamesystem_source
  scrape:
    jsonPath: "$.beans[0].CapacityUsedPercent"

- name: name_node_capacity_remaining_percent
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Remaining capacity percent. Unit: %"
  delaySec: 61
  source: name_node_FSNamesystem_source
  scrape:
    jsonPath: "$.beans[0].CapacityRemainingPercent"

- name: name_node_data_node_live_percent
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Live dataNode percent, from 0.0 - 1.0. Unit: 100%"
  delaySec: 61
  source: name_node_FSNamesystem_source
  scrape:
    jsonPath: "$.beans[0].NumLiveDataNodesPercent"

- name: name_node_data_node_live_num
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Current number of live dataNode. Unit: count"
  delaySec: 61
  source: name_node_FSNamesystem_source
  scrape:
    jsonPath: "$.beans[0].NumLiveDataNodes"

- name: name_node_data_node_dead_num
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Current number of dead dataNode. Unit: count"
  delaySec: 61
  source: name_node_FSNamesystem_source
  scrape:
    jsonPath: "$.beans[0].NumDeadDataNodes"

- name: name_node_missing_blocks
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Current number of missing blocks. Unit: blocks"
  delaySec: 61
  source: name_node_FSNamesystem_source
  scrape:
    jsonPath: "$.beans[0].MissingBlocks"

- name: name_node_excess_blocks
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Current number of excess blocks. Unit: blocks"
  delaySec: 61
  source: name_node_FSNamesystem_source
  scrape:
    jsonPath: "$.beans[0].ExcessBlocks"

- name: name_node_blocks_total
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Current number of allocated blocks in the system. Unit: blocks"
  delaySec: 61
  source: name_node_FSNamesystem_source
  scrape:
    jsonPath: "$.beans[0].BlocksTotal"

- name: name_node_corrupt_blocks
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Current number of blocks with corrupt replicas. Unit: blocks"
  delaySec: 61
  source: name_node_FSNamesystem_source
  scrape:
    jsonPath: "$.beans[0].CorruptBlocks"

- name: name_node_pending_replication_blocks
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Current number of blocks pending to be replicated. Unit: blocks"
  delaySec: 61
  source: name_node_FSNamesystem_source
  scrape:
    jsonPath: "$.beans[0].PendingReplicationBlocks"

- name: name_node_under_replicated_blocks
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Current number of blocks under replicated. Unit: blocks"
  delaySec: 61
  source: name_node_FSNamesystem_source
  scrape:
    jsonPath: "$.beans[0].UnderReplicatedBlocks"

- name: name_node_scheduled_replication_blocks
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Current number of blocks scheduled for replications. Unit: count"
  delaySec: 61
  source: name_node_FSNamesystem_source
  scrape:
    jsonPath: "$.beans[0].ScheduledReplicationBlocks"

- name: name_node_last_young_gc_duration
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Last young GC duration in nameNode. Unit: ms"
  delaySec: 61
  source: name_node_last_young_gc_duration_source
  scrape:
    jsonPath: "$.beans[0].LastGcInfo"
    valueField: "duration"

- name: name_node_last_old_gc_duration
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Last old GC duration in nameNode. Unit: ms"
  delaySec: 61
  source: name_node_last_old_gc_duration_source
  scrape:
    jsonPath: "$.beans[0].LastGcInfo"
    valueField: "duration"

- name: name_node_heap_memory_usage
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Heap memory usage for nameNode, from 0.0 - 1.0. Unit: 100%"
  delaySec: 61
  source: name_node_jvm_metrics_source
  scrape:
    jsonPath: "$.beans[0].HeapMemoryUsagePercent"

- name: name_node_journal_node_transactions_avg_time
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Average time of Journal transactions in milliseconds. Unit: ms"
  delaySec: 61
  source: name_node_activity_source
  scrape:
    jsonPath: "$.beans[0].TransactionsAvgTime"