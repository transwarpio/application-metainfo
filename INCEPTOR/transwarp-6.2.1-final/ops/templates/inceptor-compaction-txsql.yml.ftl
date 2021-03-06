<#if dependencies.TXSQL??>
  <#assign mysqlHostPorts = []/>
  <#list dependencies.TXSQL.roles['TXSQL_SERVER'] as role>
    <#assign mysqlHostPorts = mysqlHostPorts + [role.hostname + ':' + dependencies.TXSQL['mysql.rw.port']]>
  </#list>
  <#assign mysqlHostPorts = mysqlHostPorts?sort
  i = mysqlHostPorts?seq_index_of(dependencies.TXSQL.roles['TXSQL_SERVER'][0].hostname + ':' + dependencies.TXSQL['mysql.rw.port'])>
  <#if i lt 0>
    <#assign i = .now?long % dependencies.TXSQL.roles['TXSQL_SERVER']?size>
  </#if>
  <#if i gt 0>
    <#assign mysqlHostPorts = mysqlHostPorts[i..] + mysqlHostPorts[0..i-1]>
  </#if>
<#else>
  <#assign mysqlHostPorts = [service.roles.INCEPTOR_MYSQL[0]['hostname'] + ":" + service['mysql.port']]/>
</#if>
<#macro serviceLabel>
    serviceId: ${service.id }
    clusterId: ${service.clusterId}
</#macro>
sources:
- name: inceptor_compaction_txsql_source
  className: io.transwarp.tdh.metrics.source.TxSQLSource
  props:
    url: "jdbc:mysql://${mysqlHostPorts?join(",")}/metastore_inceptor1?characterEncoding=UTF-8&failOverReadOnly=false&connectTimeout=10000&retriesAllDown=0&secondsBeforeRetryMaster=0&queriesBeforeRetryMaster=0"
    user: "${service['javax.jdo.option.ConnectionUserName']}"
    password: "${service['javax.jdo.option.ConnectionPassword']}"

metrics:
- name: inceptor_compaction_blacklist_size
  fixedLabels:
    <@serviceLabel/>
  type: GAUGE
  help: "Number of records in COMPACTION_BLACKLIST. Unit: count"
  delaySec: 293
  source: inceptor_compaction_txsql_source
  scrape:
    sql: "SELECT count(*) AS `value` FROM COMPACTION_BLACKLIST"

- name: inceptor_compaction_queue_size
  fixedLabels:
    <@serviceLabel/>
  type: GAUGE
  help: "Number of records in COMPACTION_QUEUE. Unit: count"
  delaySec: 293
  source: inceptor_compaction_txsql_source
  scrape:
    sql: |
      SELECT DISTINCT(t1.CQ_STATE) AS CQ_STATE, COALESCE(t2.`value`,0) AS `value`
      FROM (
          SELECT 'i' AS CQ_STATE UNION ALL
          SELECT 'w' AS CQ_STATE UNION ALL
          SELECT 's' AS CQ_STATE UNION ALL
          SELECT 'f' AS CQ_STATE
          ) t1
      LEFT JOIN ( SELECT CQ_STATE, COUNT(*) AS `value` FROM COMPACTION_QUEUE GROUP BY CQ_STATE ) t2
      ON CONVERT(t1.CQ_STATE USING utf8) = CONVERT(t2.CQ_STATE USING utf8);
    fromResultLabels: ['CQ_STATE']

- name: inceptor_compaction_completed_txn_components_size
  fixedLabels:
    <@serviceLabel/>
  type: GAUGE
  help: "number of records in COMPLETED_TXN_COMPONENTS"
  delaySec: 293
  source: inceptor_compaction_txsql_source
  scrape:
    sql: |
      SELECT CTC_DATABASE, CTC_TABLE, COUNT(*) AS `value`
      FROM COMPLETED_TXN_COMPONENTS
      GROUP BY CTC_DATABASE, CTC_TABLE
    fromResultLabels: ['CTC_DATABASE', 'CTC_TABLE']
