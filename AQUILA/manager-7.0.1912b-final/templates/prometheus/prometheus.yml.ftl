<#macro static_configs>
  <#list service.roles['AQUILA_NODE_EXPORTER'] as role>
    <#assign node_exporter_addr = "\'" + role.hostname + ":" + service['node.exporter.web.port'] + "\'">
    - targets: [${node_exporter_addr}]
      labels:
        nodeId: ${role.nodeId}
        hostname: ${role.hostname}
        clusterId: ${role.clusterId}
        rackId: ${role.rackId}
  </#list>
</#macro>
<#function extractHostPort url>
  <#assign result = url>
  <#if result?contains("://")>
    <#assign result = result?keep_after("://")>
  </#if>
  <#if result?contains("/")>
    <#assign result = result?keep_before("/")>
  </#if>
  <#return result>
</#function>
<#assign tdh_exporter_addr=[]>
<#list service.roles['AQUILA_TDH_EXPORTER'] as role>
  <#assign tdh_exporter_addr += ["\'" + role.hostname + ":" + service['tdh.exporter.web.port'] + "\'"]>
</#list>
<#if service.roles["FILEBEAT"]??>
<#assign filebeat_addr=[]>
<#list service.roles['FILEBEAT'] as role>
    <#assign filebeat_addr += ["\'" + role.hostname + ":" + service['filebeat.port'] + "\'"]>
</#list>
</#if>
<#assign kube_state_metrics_addr=[]>
<#list service.roles['AQUILA_KUBE_STATE_METRICS'] as role>
  <#assign kube_state_metrics_addr += ["\'" + role.hostname + ":" + service['kube.state.metrics.web.port'] + "\'"]>
</#list>
<#assign kubelet_addr=[]>
<#list dependencies.TOS.roles['TOS_SLAVE'] as role>
  <#assign kubelet_addr += ["\'" + role.hostname + ":" + "10255" + "\'"]>
</#list>
<#macro kubelet_cadvisor_static_configs>
  <#list dependencies.TOS.roles['TOS_SLAVE'] as role>
    <#assign kubelet_cadvisor_addr = "\'" + role.hostname + ":" + "10255" + "\'">
    - targets: [${kubelet_cadvisor_addr}]
      labels:
        job: kubelet
  </#list>
</#macro>
<#assign etcd_addr=[]>
<#list dependencies.TOS.roles['TOS_MASTER'] as role>
  <#assign etcd_addr += ["\'" + role.hostname + ":" + dependencies.TOS['tos.master.etcd.port'] + "\'"]>
</#list>
# my global config
global:
  scrape_interval:     15s # Set the scrape interval to every 15 seconds. Default is every 1 minute.
  evaluation_interval: ${service['prometheus.global.evaluation_interval']}s # Evaluate rules frequency. The default is every 1 minute.
  # scrape_timeout is set to the global default (10s).

# Alertmanager configuration
alerting:
  alertmanagers:
  - static_configs:
    - targets:
      - ${service.roles['AQUILA_SERVER'][0].hostname}:${service['server.web.port']}
    path_prefix: /api/alert/bridge

# Load rules once and periodically evaluate them according to the global 'evaluation_interval'.
rule_files:
  - "/etc/${service.sid}/conf/prometheus/rules.d/*_rules.yml"
  - "/etc/${service.sid}/conf/prometheus/rules.d/kubernetes_rules.yml"

# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself.
scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  # metrics_path defaults to '/metrics'
  # scheme defaults to 'http'.
  - job_name: 'manager'
    scrape_interval: ${service['prometheus.manager.scrape_interval'] + "s"}
    scrape_timeout: ${service['prometheus.manager.scrape_timeout'] + "s"}
    static_configs:
    - targets:
<#list managerEndPoints as endpoint>
      - ${extractHostPort(endpoint)}
</#list>

  - job_name: 'tdh-exporter'
    scrape_interval: ${service['prometheus.tdh.exporter.scrape_interval'] + "s"}
    scrape_timeout: ${service['prometheus.tdh.exporter.scrape_timeout'] + "s"}
    static_configs:
    - targets: [${tdh_exporter_addr?join(",")}]

  - job_name: 'node-exporter'
    scrape_interval: ${service['prometheus.node.exporter.scrape_interval'] + "s"}
    scrape_timeout: ${service['prometheus.node.exporter.scrape_timeout'] + "s"}
    static_configs:
      <@static_configs/>

  - job_name: 'kube-state-metrics'
    scrape_interval: ${service['prometheus.kube.state.metrics.scrape_interval'] + "s"}
    scrape_timeout: ${service['prometheus.kube.state.metrics.scrape_timeout'] + "s"}
    static_configs:
    - targets: [${kube_state_metrics_addr?join(",")}]

  - job_name: 'kubelet'
    scrape_interval: 15s
    scrape_timeout: 10s
    static_configs:
    - targets: [${kubelet_addr?join(",")}]

  - job_name: 'kubelet-cadvisor'
    metrics_path: /metrics/cadvisor
    scrape_interval: 15s
    scrape_timeout: 10s
    static_configs:
      <@kubelet_cadvisor_static_configs/>

  - job_name: 'etcd'
    scrape_interval: 15s
    scrape_timeout: 10s
    scheme: https
    tls_config:
      insecure_skip_verify: true
      ca_file: /etc/${service.sid}/conf/prometheus/kubernetes/etcd-ca.pem
      cert_file: /etc/${service.sid}/conf/prometheus/kubernetes/etcd.pem
      key_file:  /etc/${service.sid}/conf/prometheus/kubernetes/etcd-key.pem
    static_configs:
    - targets: [${etcd_addr?join(",")}]

  - job_name: 'kube-svc-metric'
    scrape_interval: 15s
    scrape_timeout: 10s
    metrics_path: /metrics
    scheme: http
    kubernetes_sd_configs:
    - role: endpoints
      namespaces:
        names:
        - default
    relabel_configs:
    - source_labels: [__meta_kubernetes_endpoint_port_name]
      separator: ;
      regex: web
      replacement: $1
      action: keep
    - source_labels: [__meta_kubernetes_service_label_metricserver]
      separator: ;
      regex: aquila
      replacement: $1
      action: keep
    - source_labels:  ["__meta_kubernetes_service_label_service_deploy_name"]
      target_label: "service_deploy_name"
  - job_name: 'kong'
    scrape_interval: 15s
    scrape_timeout: 10s
    scheme: http
    file_sd_configs:
    - files: ['staticFiles.d/SOPHON_DEPS/*.yml']

  - job_name: 'mysqld-exporter'
    scrape_interval: 15s
    scrape_timeout: 10s
    scheme: http
    file_sd_configs:
    - files: ['staticFiles.d/KUNDB/*.yml']

<#if service.roles["FILEBEAT"]??>
  - job_name: 'filebeat'
    metrics_path: /stats/prometheus
    scrape_interval: 15s
    scrape_timeout: 10s
    scheme: http
    static_configs:
    - targets: [${filebeat_addr?join(",")}]
</#if>