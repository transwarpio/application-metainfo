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
    nodeId: ${.data_model['role.nodeId']}
    rackId: ${.data_model['role.rackId']}
</#macro>
sources:
- name: region_server_server_source
  className: io.transwarp.tdh.metrics.source.HttpJsonSource
  props:
    url: "http://${localhostname}:${service['regionserver.info.port']}/jmx?qry=Hadoop:service=HBase,name=RegionServer,sub=Server&&user.name=xxx"
    timeoutSec: 60
    cacheSec: 60

- name: region_server_jvm_metrics_source
  className: io.transwarp.tdh.metrics.source.HttpJsonSource
  props:
    url: "http://${localhostname}:${service['regionserver.info.port']}/jmx?qry=Hadoop:service=HBase,name=JvmMetrics&&user.name=xxx"
    timeoutSec: 60
    cacheSec: 60

metrics:
- name: region_server_total_regions
  fixedLabels:
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Number of regions hosted by the regionserver. Unit: count"
  delaySec: 61
  source: region_server_server_source
  scrape:
    jsonPath: "$.beans[0].regionCount"
    fromResultLabelMap: {}

- name: region_server_compaction_queue_length
  fixedLabels:
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Current depth of the compaction request queue. Unit: count"
  delaySec: 61
  source: region_server_server_source
  scrape:
    jsonPath: "$.beans[0].compactionQueueLength"
    fromResultLabelMap: {}

- name: region_server_flush_queue_length
  fixedLabels:
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Current depth of the memstore flush queue. Unit: count"
  delaySec: 61
  source: region_server_server_source
  scrape:
    jsonPath: "$.beans[0].flushQueueLength"
    fromResultLabelMap: {}

- name: region_server_read_request_rate
  fixedLabels:
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Number of read requests received per second. Unit: count/s"
  delaySec: 61
  source: region_server_server_source
  scrape:
    jsonPath: "$.beans[0].readRequestCountPerSecond"
    fromResultLabelMap: {}

- name: region_server_write_request_rate
  fixedLabels:
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Number of write requests received per second. Unit: count/s"
  delaySec: 61
  source: region_server_server_source
  scrape:
    jsonPath: "$.beans[0].writeRequestCountPerSecond"
    fromResultLabelMap: {}

- name: region_server_managed_store_file_count
  fixedLabels:
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Number of store files on disk currently managed by the regionserver. Unit: count"
  delaySec: 61
  source: region_server_server_source
  scrape:
    jsonPath: "$.beans[0].storeFileCount"
    fromResultLabelMap: {}

- name: region_server_flush_request_count
  fixedLabels:
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Number of flush request received. Unit: count"
  delaySec: 61
  source: region_server_server_source
  scrape:
    jsonPath: "$.beans[0].flushRequestCount"
    fromResultLabelMap: {}

- name: region_server_compact_request_count
  fixedLabels:
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Number of compact request received. Unit: count"
  delaySec: 61
  source: region_server_server_source
  scrape:
    jsonPath: "$.beans[0].compactionRequestCount"
    fromResultLabelMap: {}

- name: region_server_split_request_count
  fixedLabels:
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Number of split request received. Unit: count"
  delaySec: 61
  source: region_server_server_source
  scrape:
    jsonPath: "$.beans[0].splitRequestCount"
    fromResultLabelMap: {}

- name: region_server_show_put_count
  fixedLabels:
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: COUNTER
  help: "Counts the number of puts that took more than 1000 ms to complete. Unit: count"
  delaySec: 61
  source: region_server_server_source
  scrape:
    jsonPath: "$.beans[0].slowPutCount"
    fromResultLabelMap: {}

- name: region_server_gc_count
  fixedLabels:
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: COUNTER
  help: "The number of total garbage collections. Unit: count"
  delaySec: 61
  source: region_server_jvm_metrics_source
  scrape:
    jsonPath: "$.beans[0].GcCount"
    fromResultLabelMap: {}

- name: region_server_gc_time_millis
  fixedLabels:
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: COUNTER
  help: "Time spent in garbage collection in milliseconds. Unit: ms"
  delaySec: 61
  source: region_server_jvm_metrics_source
  scrape:
    jsonPath: "$.beans[0].GcTimeMillis"
    fromResultLabelMap: {}