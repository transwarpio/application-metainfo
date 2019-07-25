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
- name: kundb_kuntablet_replica_debug_var_source
  className: io.transwarp.tdh.metrics.source.HttpJsonSource
  props:
    url: "http://${localhostname}:${service['replica.debug.port']}/debug/vars"
    timeoutSec: 60
    cacheSec: 60

metrics:
- name: kundb_kuntablet_replica_transactions_sum_total
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: COUNTER
  help: "Total number of transactions in kuntablet since it was started"
  delaySec: 61
  source: kundb_kuntablet_replica_debug_var_source
  scrape: 
    jsonPath: "$.Transactions"
    valueField: "TotalCount"
    fromResultLabelMap: {}

- name: kundb_kuntablet_replica_kills_transactions_total
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: COUNTER
  help: "Total number of killed transactions due to timeout by kuntablet since it was started"
  delaySec: 61
  source: kundb_kuntablet_replica_debug_var_source
  scrape:
    jsonPath: "$.Kills"
    valueField: "Transactions"
    fromResultLabelMap: {}

- name: kundb_kuntablet_replica_kills_queries_total
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: COUNTER
  help: "Total number of killed Queries due to timeout by kuntablet since it was started"
  delaySec: 61
  source: kundb_kuntablet_replica_debug_var_source
  scrape:
    jsonPath: "$.Kills"
    valueField: "Queries"
    fromResultLabelMap: {}

- name: kundb_kuntablet_replica_internalErrors_panic_total
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: COUNTER
  help: "Total Number of Panic errors in kuntablet calculated from its start"
  delaySec: 61
  source: kundb_kuntablet_replica_debug_var_source
  scrape:
    jsonPath: "$.InternalErrors"
    valueField: "Panic"
    fromResultLabelMap: {}

- name: kundb_kuntablet_replica_internalErrors_hungQuery_total
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: COUNTER
  help: "Total Number of HungQuery errors in kuntablet calculated from its start"
  delaySec: 61
  source: kundb_kuntablet_replica_debug_var_source
  scrape:
    jsonPath: "$.InternalErrors"
    valueField: "HungQuery"
    fromResultLabelMap: {}

- name: kundb_kuntablet_replica_internalErrors_twopcCommit_total
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: COUNTER
  help: "Total Number of TwopcCommit errors in kuntablet calculated from its start"
  delaySec: 61
  source: kundb_kuntablet_replica_debug_var_source
  scrape:
    jsonPath: "$.InternalErrors"
    valueField: "TwopcCommit"
    fromResultLabelMap: {}

- name: kundb_kuntablet_replica_internalErrors_twopcResurrection_total
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: COUNTER
  help: "Total Number of TwopcResurrection errors in kuntablet calculated from its start"
  delaySec: 61
  source: kundb_kuntablet_replica_debug_var_source
  scrape:
    jsonPath: "$.InternalErrors"
    valueField: "TwopcResurrection"
    fromResultLabelMap: {}

- name: kundb_kuntablet_replica_internalErrors_watchdogFail_total
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: COUNTER
  help: "Total Number of WatchdogFail errors in kuntablet calculated from its start"
  delaySec: 61
  source: kundb_kuntablet_replica_debug_var_source
  scrape:
    jsonPath: "$.InternalErrors"
    valueField: "WatchdogFail"
    fromResultLabelMap: {}

- name: kundb_kuntablet_replica_internalErrors_schema_total
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: COUNTER
  help: "Total Number of Schema errors in kuntablet calculated from its start"
  delaySec: 61
  source: kundb_kuntablet_replica_debug_var_source
  scrape:
    jsonPath: "$.InternalErrors"
    valueField: "Schema"
    fromResultLabelMap: {}

- name: kundb_kuntablet_replica_errors_invalidArgument_total
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: COUNTER
  help: "Total Number of invalidArgument errors in kuntablet calculated from its start"
  delaySec: 61
  source: kundb_kuntablet_replica_debug_var_source
  scrape:
    jsonPath: "$.Errors"
    valueField: "INVALID_ARGUMENT"
    fromResultLabelMap: {}

- name: kundb_kuntablet_replica_errors_outOfRange_total
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: COUNTER
  help: "Total Number of outOfRange errors in kuntablet calculated from its start"
  delaySec: 61
  source: kundb_kuntablet_replica_debug_var_source
  scrape:
    jsonPath: "$.Errors"
    valueField: "OUT_OF_RANGE"
    fromResultLabelMap: {}

- name: kundb_kuntablet_replica_errors_alreadyExists_total
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: COUNTER
  help: "Total Number of alreadyExists errors in kuntablet calculated from its start"
  delaySec: 61
  source: kundb_kuntablet_replica_debug_var_source
  scrape:
    jsonPath: "$.Errors"
    valueField: "ALREADY_EXISTS"
    fromResultLabelMap: {}

- name: kundb_kuntablet_replica_errors_unauthenticated_total
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: COUNTER
  help: "Total Number of unauthenticated errors in kuntablet calculated from its start"
  delaySec: 61
  source: kundb_kuntablet_replica_debug_var_source
  scrape:
    jsonPath: "$.Errors"
    valueField: "UNAUTHENTICATED"
    fromResultLabelMap: {}

- name: kundb_kuntablet_replica_errors_permissionDenied_total
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: COUNTER
  help: "Total Number of permissionDenied errors in kuntablet calculated from its start"
  delaySec: 61
  source: kundb_kuntablet_replica_debug_var_source
  scrape:
    jsonPath: "$.Errors"
    valueField: "PERMISSION_DENIED"
    fromResultLabelMap: {}

- name: kundb_kuntablet_replica_errors_aborted_total
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: COUNTER
  help: "Total Number of aborted errors in kuntablet calculated from its start"
  delaySec: 61
  source: kundb_kuntablet_replica_debug_var_source
  scrape:
    jsonPath: "$.Errors"
    valueField: "ABORTED"
    fromResultLabelMap: {}

- name: kundb_kuntablet_replica_errors_deadlineExceeded_total
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: COUNTER
  help: "Total Number of deadlineExceeded errors in kuntablet calculated from its start"
  delaySec: 61
  source: kundb_kuntablet_replica_debug_var_source
  scrape:
    jsonPath: "$.Errors"
    valueField: "DEADLINE_EXCEEDED"
    fromResultLabelMap: {}

- name: kundb_kuntablet_replica_errors_resourceExhausted_total
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: COUNTER
  help: "Total Number of resourceExhausted errors in kuntablet calculated from its start"
  delaySec: 61
  source: kundb_kuntablet_replica_debug_var_source
  scrape:
    jsonPath: "$.Errors"
    valueField: "RESOURCE_EXHAUSTED"
    fromResultLabelMap: {}

- name: kundb_kuntablet_replica_errors_unknown_total
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: COUNTER
  help: "Total Number of unknown errors in kuntablet calculated from its start"
  delaySec: 61
  source: kundb_kuntablet_replica_debug_var_source
  scrape:
    jsonPath: "$.Errors"
    valueField: "UNKNOWN"
    fromResultLabelMap: {}







