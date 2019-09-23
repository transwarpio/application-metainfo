global:
  resolve_timeout: ${service['alertmanager.global.resolve.timeout']}

route:
  group_by: ['alertname']
  receiver: 'alert.history.web.hook'
receivers:
- name: 'alert.history.web.hook'
  webhook_configs:
  - url: 'http://${service.roles['AQUILA_SERVER'][0].hostname}:${service['server.web.port']}/api/alert/history/fromAlertManager'
    send_resolved: true

inhibit_rules:
  - source_match:
      severity: 'CRITICAL'
    target_match:
      severity: 'WARNING'
    equal: ['deduplication_id']
