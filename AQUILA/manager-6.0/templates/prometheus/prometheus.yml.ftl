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
<#assign tdh_exporter_addr=[]>
<#list service.roles['AQUILA_TDH_EXPORTER'] as role>
  <#assign tdh_exporter_addr += ["\'" + role.hostname + ":" + service['tdh.exporter.web.port'] + "\'"]>
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

# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself.
scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  # metrics_path defaults to '/metrics'
  # scheme defaults to 'http'.
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

