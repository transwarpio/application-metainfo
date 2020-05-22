- type: log
  paths:
    - /var/log/${service.sid}/argodb-server2.audit
    - /var/log/${service.sid}/argodb-server2.audit.*
  fields:
    service: argodb_audit
    #is_audit: true
  fields_under_root: true
  multiline.pattern: '^\[[0-9]{4}-[0-9]{2}-[0-9]{2}'
  multiline.negate: true
  multiline.match: after
  scan_frequency: 3s
  close_eof: false
  harvester_buffer_size: 1048576
  exclude_lines: ['^DBG']
  exclude_files: ['.gz$','.swp$']

- type: log
  paths:
    - /var/log/${service.sid}/*hive-server*.log
  fields:
    service: argodb_server
  fields_under_root: true
  multiline.pattern: '^\[[0-9]{4}-[0-9]{2}-[0-9]{2}'
  multiline.negate: true
  multiline.match: after
  scan_frequency: 3s
  close_eof: false
  harvester_buffer_size: 1048576
  exclude_lines: ['^DBG']
  exclude_files: ['.gz$','.swp$']

