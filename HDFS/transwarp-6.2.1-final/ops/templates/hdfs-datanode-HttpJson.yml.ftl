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
- name: data_node_activity_source
  className: io.transwarp.tdh.metrics.source.HttpJsonSource
  props:
    url: "http://${localhostname}:${service['datanode.http-port']}/jmx?qry=Hadoop:service=DataNode,name=DataNodeActivity*"
    timeoutSec: 60
    cacheSec: 60

- name: data_node_usage_source
  className: io.transwarp.tdh.metrics.source.HttpJsonSource
  props:
    url: "http://${localhostname}:${service['datanode.http-port']}/jmx?qry=Hadoop:service=DataNode,name=FSDatasetState-null"
    timeoutSec: 60
    cacheSec: 60

metrics:
- name: data_node_bytes_read
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: COUNTER
  help: "Total number of bytes read from DataNode. Unit: bytes"
  delaySec: 61
  source: data_node_activity_source
  scrape:
    jsonPath: "$.beans[0].BytesRead"

- name: data_node_bytes_write
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: COUNTER
  help: "Total number of bytes written to DataNode. Unit: bytes"
  delaySec: 61
  source: data_node_activity_source
  scrape:
    jsonPath: "$.beans[0].BytesWritten"

- name: data_node_blocks_cached
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: COUNTER
  help: "Total number of blocks cached. Unit: blocks"
  delaySec: 61
  source: data_node_activity_source
  scrape:
    jsonPath: "$.beans[0].BlocksCached"

- name: data_node_blocks_uncached
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: COUNTER
  help: "Total number of blocks uncached. Unit: blocks"
  delaySec: 61
  source: data_node_activity_source
  scrape:
    jsonPath: "$.beans[0].BlocksUncached"

- name: data_node_blocks_read
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: COUNTER
  help: "Total number of blocks read from DataNode. Unit: blocks"
  delaySec: 61
  source: data_node_activity_source
  scrape:
    jsonPath: "$.beans[0].BlocksRead"

- name: data_node_blocks_written
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: COUNTER
  help: "Total number of blocks written to DataNode. Unit: blocks"
  delaySec: 61
  source: data_node_activity_source
  scrape:
    jsonPath: "$.beans[0].BlocksWritten"

- name: data_node_blocks_removed
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: COUNTER
  help: "Total number of blocks removed. Unit: blocks"
  delaySec: 61
  source: data_node_activity_source
  scrape:
    jsonPath: "$.beans[0].BlocksRemoved"

- name: data_node_blocks_replicated
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: COUNTER
  help: "Total number of blocks replicated. Unit: blocks"
  delaySec: 61
  source: data_node_activity_source
  scrape:
    jsonPath: "$.beans[0].BlocksReplicated"

- name: data_node_blocks_verified
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: COUNTER
  help: "Total number of blocks verified. Unit: blocks"
  delaySec: 61
  source: data_node_activity_source
  scrape:
    jsonPath: "$.beans[0].BlocksVerified"

- name: data_node_blocks_verification_failures
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: COUNTER
  help: "	Total number of verifications failures. Unit: blocks"
  delaySec: 61
  source: data_node_activity_source
  scrape:
    jsonPath: "$.beans[0].BlockVerificationFailures"

- name: data_node_capacity_total
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: COUNTER
  help: "Total configured capacity of Disk. Unit: bytes"
  delaySec: 61
  source: data_node_usage_source
  scrape:
    jsonPath: "$.beans[0].Capacity"

- name: data_node_DfsUsed
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: COUNTER
  help: "The used space by the DataNode. Unit: bytes"
  delaySec: 61
  source: data_node_usage_source
  scrape:
    jsonPath: "$.beans[0].DfsUsed"