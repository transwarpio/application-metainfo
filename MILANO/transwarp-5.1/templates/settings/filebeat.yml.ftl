###################### Metricbeat Configuration #######################
# You can find the full configuration reference here:
# https://www.elastic.co/guide/en/beats/filebeat/index.html

#==========================  Modules configuration ============================
#filebeat.modules:
filebeat.prospectors:
- type: log
  paths:
    - /var/log/inceptor*/*hive-server*.log
  fields:
    service: inceptor
  fields_under_root: true
  multiline.pattern: '^[0-9]{4}-[0-9]{2}-[0-9]{2}'
  multiline.negate: true
  multiline.match: after
  scan_frequency: 3s
  close_eof: false
  harvester_buffer_size: 1048576
  exclude_lines: ['^DBG']
  exclude_files: ['.gz$']

- type: log
  paths:
    - /var/log/inceptor*/*hive-metastore*.log
  fields:
    service: metastore
  fields_under_root: true
  multiline.pattern: '^[0-9]{4}-[0-9]{2}-[0-9]{2}'
  multiline.negate: true
  multiline.match: after
  scan_frequency: 3s
  close_eof: false
  harvester_buffer_size: 1048576
  exclude_lines: ['^DBG']
  exclude_files: ['.gz$']

- type: log
  paths:
    - /var/log/inceptor*/*executor*.log
  fields:
    service: sparkexecutor
  fields_under_root: true
  multiline.pattern: '^[0-9]{4}-[0-9]{2}-[0-9]{2}'
  multiline.negate: true
  multiline.match: after
  scan_frequency: 3s
  close_eof: false
  harvester_buffer_size: 1048576
  exclude_lines: ['^DBG']
  exclude_files: ['.gz$']

- type: log
  paths:
    - /var/log/inceptor*/*application*.log
  fields:
    service: sparkapplication
  fields_under_root: true
  multiline.pattern: '^[0-9]{4}-[0-9]{2}-[0-9]{2}'
  multiline.negate: true
  multiline.match: after
  scan_frequency: 3s
  close_eof: false
  harvester_buffer_size: 1048576
  exclude_lines: ['^DBG']
  exclude_files: ['.gz$']

- type: log
  paths:
    - /var/log/hdfs*/*hdfs-namenode*.log
  fields:
    service: hdfsnamenode
  fields_under_root: true
  multiline.pattern: '^[0-9]{4}-[0-9]{2}-[0-9]{2}'
  multiline.negate: true
  multiline.match: after
  scan_frequency: 3s
  close_eof: false
  harvester_buffer_size: 1048576
  exclude_lines: ['^DBG']
  exclude_files: ['.gz$']

- type: log
  paths:
    - /var/log/hdfs*/*hdfs-datanode*.log
  fields:
    service: hdfsdatanode
  fields_under_root: true
  multiline.pattern: '^[0-9]{4}-[0-9]{2}-[0-9]{2}'
  multiline.negate: true
  multiline.match: after
  scan_frequency: 3s
  close_eof: false
  harvester_buffer_size: 1048576
  exclude_lines: ['^DBG']
  exclude_files: ['.gz$']

- type: log
  paths:
    - /var/log/hdfs*/*hdfs-journalnode*.log
  fields:
    service: hdfsjournalnode
  fields_under_root: true
  multiline.pattern: '^[0-9]{4}-[0-9]{2}-[0-9]{2}'
  multiline.negate: true
  multiline.match: after
  scan_frequency: 3s
  close_eof: false
  harvester_buffer_size: 1048576
  exclude_lines: ['^DBG']
  exclude_files: ['.gz$']

- type: log
  paths:
    - /var/log/hdfs*/*hdfs-zkfc*.log
  fields:
    service: hdfszkfc
  fields_under_root: true
  multiline.pattern: '^[0-9]{4}-[0-9]{2}-[0-9]{2}'
  multiline.negate: true
  multiline.match: after
  scan_frequency: 3s
  close_eof: false
  harvester_buffer_size: 1048576
  exclude_lines: ['^DBG']
  exclude_files: ['.gz$']

- type: log
  paths:
    - /var/log/zookeeper*/*zookeeper*.log
  fields:
    service: zookeeper
  fields_under_root: true
  multiline.pattern: '^[0-9]{4}-[0-9]{2}-[0-9]{2}'
  multiline.negate: true
  multiline.match: after
  scan_frequency: 3s
  close_eof: false
  harvester_buffer_size: 1048576
  exclude_lines: ['^DBG']
  exclude_files: ['.gz$']

- type: log
  paths:
    - /var/log/hyperbase*/*hbase-master*.log
  fields:
    service: hbasemaster
  fields_under_root: true
  multiline.pattern: '^[0-9]{4}-[0-9]{2}-[0-9]{2}'
  multiline.negate: true
  multiline.match: after
  scan_frequency: 3s
  close_eof: false
  harvester_buffer_size: 1048576
  exclude_lines: ['^DBG']
  exclude_files: ['.gz$']

- type: log
  paths:
    - /var/log/hyperbase*/*hbase-regionserver*.log
    - /var/log/hyperbase*/*hbase-regionserver*.out
  fields:
    service: hbaseregionserver
  fields_under_root: true
  multiline.pattern: '^[0-9]{4}-[0-9]{2}-[0-9]{2}'
  multiline.negate: true
  multiline.match: after
  scan_frequency: 3s
  close_eof: false
  harvester_buffer_size: 1048576
  exclude_lines: ['^DBG']
  exclude_files: ['.gz$']

- type: log
  paths:
    - /var/log/yarn*/*yarn-nodemanager*.log
  fields:
    service: yarnnodemanager
  fields_under_root: true
  multiline.pattern: '^[0-9]{4}-[0-9]{2}-[0-9]{2}'
  multiline.negate: true
  multiline.match: after
  scan_frequency: 3s
  close_eof: false
  harvester_buffer_size: 1048576
  exclude_lines: ['^DBG']
  exclude_files: ['.gz$']

- type: log
  paths:
    - /var/log/yarn*/*yarn-resourcemanager*.log
  fields:
    service: yarnresourcemanager
  fields_under_root: true
  multiline.pattern: '^[0-9]{4}-[0-9]{2}-[0-9]{2}'
  multiline.negate: true
  multiline.match: after
  scan_frequency: 3s
  close_eof: false
  harvester_buffer_size: 1048576
  exclude_lines: ['^DBG']
  exclude_files: ['.gz$']

- type: log
  paths:
    - /var/log/elasticsearch*/*elasticsearch*.log
    - /var/log/elasticsearch*/*es*.log
  fields:
    service: elasticsearch
  fields_under_root: true
  multiline.pattern: '^\[[0-9]{4}-[0-9]{2}-[0-9]{2}'
  multiline.negate: true
  multiline.match: after
  scan_frequency: 3s
  close_eof: false
  harvester_buffer_size: 1048576
  exclude_lines: ['^DBG']
  exclude_files: ['.gz$']

- type: log
  paths:
    - /var/log/search*/*.log
  fields:
    service: search
  fields_under_root: true
  multiline.pattern: '^\[[0-9]{4}-[0-9]{2}-[0-9]{2}'
  multiline.negate: true
  multiline.match: after
  scan_frequency: 3s
  close_eof: false
  harvester_buffer_size: 1048576
  exclude_lines: ['^DBG']
  exclude_files: ['.gz$']

- type: log
  paths:
    - /var/log/kafka*/**/*.log
  fields:
    service: kafka
  fields_under_root: true
  multiline.pattern: '^\[[0-9]{4}-[0-9]{2}-[0-9]{2}'
  multiline.negate: true
  multiline.match: after
  scan_frequency: 3s
  close_eof: false
  harvester_buffer_size: 1048576
  exclude_lines: ['^DBG']
  exclude_files: ['.gz$']

- type: log
  paths:
    - /var/log/streamsql*/*.log
  fields:
    service: streamsql
  fields_under_root: true
  multiline.pattern: '^\[[0-9]{4}-[0-9]{2}-[0-9]{2}'
  multiline.negate: true
  multiline.match: after
  scan_frequency: 3s
  close_eof: false
  harvester_buffer_size: 1048576
  exclude_lines: ['^DBG']
  exclude_files: ['.gz$']

- type: log
  paths:
    - /var/log/shiva*/*.log
  fields:
    service: shiva
  fields_under_root: true
  multiline.pattern: '^\[[0-9]{4}-[0-9]{2}-[0-9]{2}'
  multiline.negate: true
  multiline.match: after
  scan_frequency: 3s
  close_eof: false
  harvester_buffer_size: 1048576
  exclude_lines: ['^DBG']
  exclude_files: ['.gz$']

<#if service['filebeat.yml']??>
<#list service['filebeat.yml'] as key, value>
- type: log
  paths:
    - ${value}
  fields:
    service: ${key}
  fields_under_root: true
  multiline.pattern: '^\[[0-9]{4}-[0-9]{2}-[0-9]{2}'
  multiline.negate: true
  multiline.match: after
  scan_frequency: 3s
  close_eof: false
  harvester_buffer_size: 1048576
  exclude_lines: ['^DBG']
  exclude_files: ['.gz$']
</#list>
</#if>

processors:
- add_locale: ~

<#if dependencies.KAFKA??>
    <#assign kafka=dependencies.KAFKA kafkas=[]>
    <#list kafka.roles.KAFKA_SERVER as role>
        <#assign kafkas += [role.hostname + ":" + kafka[role.hostname]["listeners"]?split(":")[2]]>
    </#list>
</#if>

#----------------------------- Output --------------------------------
output.kafka:
  enabled: true
  hosts: ${kafkas?join(",")}
  topic: logs
  worker: 2
  max_retries: 3
  required_acks: 1
  max_message_bytes: 1000000
<#if service.auth = "kerberos">
  security_protocol: SASL_PLAINTEXT
  sasl_mechanisms: GSSAPI
  sasl_krb_serivce_name: kafka
  sasl_krb_principal: kafka/${localhostname}@${service.realm}
  sasl_krb_keytab: /etc/${service.sid}/conf/milano.keytab
</#if>
#================================ Logging =====================================
#logging.level: debug
#logging.selectors: ["*"]
#logging.metrics.enabled: true
#logging.metrics.period: 30s

http:
  enable: true
  host: ${localhostname}
  port: ${service['filebeat.port']}


path.home: /var/run/${service.sid}/filebeat
