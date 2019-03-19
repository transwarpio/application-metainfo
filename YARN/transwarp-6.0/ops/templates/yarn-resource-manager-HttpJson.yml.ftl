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
- name: resource_manager_queue_metrics_source
  className: io.transwarp.tdh.metrics.source.HttpJsonSource
  props:
    url: "http://${localhostname}:${service['resourcemanager.webapp.port']}/jmx?qry=Hadoop:service=ResourceManager,name=QueueMetrics,q0=root"
    timeoutSec: 60
    cacheSec: 60

- name: resource_manager_cluster_metrics_source
  className: io.transwarp.tdh.metrics.source.HttpJsonSource
  props:
    url: "http://${localhostname}:${service['resourcemanager.webapp.port']}/jmx?qry=Hadoop:service=ResourceManager,name=ClusterMetrics"
    timeoutSec: 60
    cacheSec: 60

metrics:
- name: resource_manager_apps_running
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Current number of running applications. Unit: count"
  delaySec: 61
  source: resource_manager_queue_metrics_source
  scrape:
    jsonPath: "$.beans[0].AppsRunning"
    fromResultLabelMap: {}

- name: resource_manager_apps_pending
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Current number of applications that have not yet been assigned by any containers. Unit: count"
  delaySec: 61
  source: resource_manager_queue_metrics_source
  scrape:
    jsonPath: "$.beans[0].AppsPending"
    fromResultLabelMap: {}

- name: resource_manager_apps_completed
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: COUNTER
  help: "Total number of completed applications. Unit: count"
  delaySec: 61
  source: resource_manager_queue_metrics_source
  scrape:
    jsonPath: "$.beans[0].AppsCompleted"
    fromResultLabelMap: {}

- name: resource_manager_apps_failed
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: COUNTER
  help: "Total number of failed applications. Unit: count"
  delaySec: 61
  source: resource_manager_queue_metrics_source
  scrape:
    jsonPath: "$.beans[0].AppsFailed"
    fromResultLabelMap: {}

- name: resource_manager_allocated_containers
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Current number of allocated containers. Unit: count"
  delaySec: 61
  source: resource_manager_queue_metrics_source
  scrape:
    jsonPath: "$.beans[0].AllocatedContainers"
    fromResultLabelMap: {}

- name: resource_manager_allocated_memory
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Current allocated memory in MB. Unit: MB"
  delaySec: 61
  source: resource_manager_queue_metrics_source
  scrape:
    jsonPath: "$.beans[0].AllocatedMB"
    fromResultLabelMap: {}

- name: resource_manager_available_memory
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Current available memory in MB. Unit: MB"
  delaySec: 61
  source: resource_manager_queue_metrics_source
  scrape:
    jsonPath: "$.beans[0].AvailableMB"
    fromResultLabelMap: {}

- name: resource_manager_allocated_vcores
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Current allocated CPU in virtual cores. Unit: count"
  delaySec: 61
  source: resource_manager_queue_metrics_source
  scrape:
    jsonPath: "$.beans[0].AllocatedVCores"
    fromResultLabelMap: {}

- name: resource_manager_available_vcores
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Current available CPU in virtual cores. Unit: count"
  delaySec: 61
  source: resource_manager_queue_metrics_source
  scrape:
    jsonPath: "$.beans[0].AvailableVCores"
    fromResultLabelMap: {}

- name: resource_manager_active_node_managers
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Current number of active NodeManagers. Unit: count"
  delaySec: 61
  source: resource_manager_cluster_metrics_source
  scrape:
    jsonPath: "$.beans[0].NumActiveNMs"
    fromResultLabelMap: {}

- name: resource_manager_decommission_node_managers
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Current number of decommissioned NodeManagers. Unit: count"
  delaySec: 61
  source: resource_manager_cluster_metrics_source
  scrape:
    jsonPath: "$.beans[0].NumDecommissionedNMs"
    fromResultLabelMap: {}

- name: resource_manager_lost_node_managers
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "current number of lost nodeManagers for not sending heartbeats. Unit: count"
  delaySec: 61
  source: resource_manager_cluster_metrics_source
  scrape:
    jsonPath: "$.beans[0].NumLostNMs"
    fromResultLabelMap: {}

- name: resource_manager_unhealthy_node_managers
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "current number of unhealthy NodeManagers. Unit: count"
  delaySec: 61
  source: resource_manager_cluster_metrics_source
  scrape:
    jsonPath: "$.beans[0].NumUnhealthyNMs"
    fromResultLabelMap: {}

- name: resource_manager_rebooted_node_managers
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "current number of rebooted NodeManagers. Unit: count"
  delaySec: 61
  source: resource_manager_cluster_metrics_source
  scrape:
    jsonPath: "$.beans[0].NumRebootedNMs"
    fromResultLabelMap: {}