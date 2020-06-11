###################### Metricbeat Configuration #######################
# You can find the full configuration reference here:
# https://www.elastic.co/guide/en/beats/filebeat/index.html

#==========================  Modules configuration ============================
#filebeat.modules:
filebeat.config.prospectors:
  path: /etc/${service.sid}/conf/filebeat.yml
  reload.enabled: true
  reload.period: 10s

filebeat.prospectors:
- type: log
  paths:
    - /var/log/kundb*/kungate/public/**/*.audit*
  fields:
    service: kundb
    is_audit: true
  fields_under_root: true
  scan_frequency: 3s
  ignore_older: ${service['filebeat.ignore_older']}
  close_eof: false
  harvester_buffer_size: 1048576
  exclude_lines: ['^DBG']
  exclude_files: ['.swp$']

- type: log
  paths:
    - /var/log/kundb*/**/*.log.INFO*
    - /var/log/kundb*/kungate/private/*.audit*
    - /var/log/kundb*/shard*/**/*.audit*
    - /var/log/kundb*/**/*.out
  fields:
    service: kundb
  fields_under_root: true
  ignore_older: ${service['filebeat.ignore_older']}
  multiline.pattern: '^[IWEF][0-9]{4}'
  multiline.negate: true
  multiline.match: after
  scan_frequency: 3s
  close_eof: false
  harvester_buffer_size: 1048576
  exclude_lines: ['^DBG']
  exclude_files: ['.swp$']

- type: log
  paths:
    - /var/log/transwarp-manager/master/transwarp-manager.audit
    - /var/log/transwarp-manager/master/transwarp-manager.audit.*
  fields:
    service: manager_master
    is_audit: true
  fields_under_root: true
  ignore_older: ${service['filebeat.ignore_older']}
  multiline.pattern: '^[0-9]{4}-[0-9]{2}-[0-9]{2}'
  multiline.negate: true
  multiline.match: after
  scan_frequency: 3s
  close_eof: false
  harvester_buffer_size: 1048576
  exclude_lines: ['^DBG']
  exclude_files: ['.swp$']

- type: log
  paths:
    - /var/log/transwarp-manager/master/transwarp-manager-operation.audit
    - /var/log/transwarp-manager/master/transwarp-manager-operation.audit.*
  fields:
    service: manager_operation
    is_audit: true
  fields_under_root: true
  ignore_older: ${service['filebeat.ignore_older']}
  multiline.pattern: '^[0-9]{4}-[0-9]{2}-[0-9]{2}'
  multiline.negate: true
  multiline.match: after
  scan_frequency: 3s
  close_eof: false
  harvester_buffer_size: 1048576
  exclude_lines: ['^DBG']
  exclude_files: ['.swp$']

<#if service['filebeat.yml']??>
<#list service['filebeat.yml'] as key, value>
- type: log
  paths:
    - ${value}
  fields:
    service: ${key}
  fields_under_root: true
  scan_frequency: 3s
  close_eof: false
  harvester_buffer_size: 1048576
  exclude_lines: ['^DBG']
  exclude_files: ['.gz$']
</#list>
</#if>

processors:
- add_locale: ~

<#if service.roles.KAFKA_SERVER??>
    <#assign kafkas=[]>
    <#list service.roles.KAFKA_SERVER as role>
        <#assign kafkas += [role.hostname + ":" + service[role.hostname]["kafka.listeners"]?split(":")[2]]>
    </#list>
</#if>

#----------------------------- Output --------------------------------
output.kafka:
  enabled: true
  hosts: ${kafkas?join(",")}
  topic: logs
  worker: 6
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
