<#compress>
<#noparse>
sources:
- name: executorJson
  className: io.transwarp.inceptor.metrics.source.HttpJsonSource
  props:
</#noparse>
    url: "http://${localhostname}:${service['inceptor.ui.port']}/executors/json/"
<#noparse>
    timeoutSec: 60
    cacheSec: 60

parallelLimit: 2

metrics:
- name: inceptor_server_executors_number
  fixedLabels: {}
  type: GAUGE
  help: "number of running executors registered to the server"
  delaySec: 61
  source: executorJson
  scrape:
    jsonPath: "$.length()"
    fromResultLabelMap: {}
- name: inceptor_server_executor_total_shuffle_read_bytes
  fixedLabels: {}
  type: COUNTER
  help: "total Shuffle Read"
  delaySec: 61
  source: executorJson
  scrape:
    jsonPath: "$"
    valueField: "totalShuffleRead"
    parseFormat: DATA_IEC
    fromResultLabelMap:
      host: executor
- name: inceptor_server_executor_active_tasks
  fixedLabels: {}
  type: GAUGE
  help: "active tasks"
  delaySec: 61
  source: executorJson
  scrape:
    jsonPath: "$"
    valueField: "activeTask"
    fromResultLabelMap:
      host: executor
</#noparse>
</#compress>