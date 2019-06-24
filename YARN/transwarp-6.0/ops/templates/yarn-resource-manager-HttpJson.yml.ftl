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
- name: resource_manager_jvm_metrics_source
  className: io.transwarp.tdh.metrics.source.HttpJsonSource
  props:
    url: "http://${localhostname}:${service['resourcemanager.webapp.port']}/jmx?qry=Hadoop:service=ResourceManager,name=JvmMetrics"
    timeoutSec: 60
    cacheSec: 60

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
- name: resource_manager_is_active_master_or_not
  fixedLabels:
    <@serviceLabel/>
    <@roleLabel/>
  type: GAUGE
  help: "Resource Manager is active master(1.0) or backup master(0.0). "
  delaySec: 61
  source: resource_manager_jvm_metrics_source
  scrape:
    jsonPath: "$.beans[0].modelerType"
    valueMapping:
      JvmMetrics: 1.0

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