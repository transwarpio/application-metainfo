global:
  resolve_timeout: ${service['alertmanager.global.resolve.timeout']}

route:
  group_by: ['alertname']
  group_wait: 10s
  group_interval: 10s
  repeat_interval: 1h
  receiver: 'web.hook'
receivers:
- name: 'web.hook'
  webhook_configs:
  - url: 'http://172.16.1.104:9000/webhook'

inhibit_rules:
  - source_match:
      severity: 'CRITICAL'
    target_match:
      severity: 'WARNING'
    equal: ['deduplication_id']
