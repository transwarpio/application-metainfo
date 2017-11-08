filter {
  grok {
    patterns_dir => ["/etc/${service.sid}/conf/patterns"]
    break_on_match => false
    match => {
      "log" => ["%{GREEDYDATA:message}"]
    }
    overwrite => ["message"]
    remove_field => ["log"]
    remove_tag => ["_grokparsefailure"]
  }
### General log process ###
  grok {
    patterns_dir => ["/etc/${service.sid}/conf/patterns"]
    break_on_match => true
    match => {
      "message" => [
        "^%{TDH_TIMESTAMP:datetime}\s+%{LOGLEVEL:level}\s+%{GREEDYDATA:message}$",
        "^%{TDH_TIMESTAMP:datetime}\s+(%{NOTSPACE}\s+-\s+)?%{LOGLEVEL:level}\s+%{GREEDYDATA:message}$",
        "^%{TDH_TIMESTAMP:datetime}\[%{LOGLEVEL:level}\s*\]\s*%{GREEDYDATA:message}$",
        "^%{TDH_TIMESTAMP:datetime}\s+%{GREEDYDATA:message}$"
      ]
    }
    overwrite => ["message"]
    remove_tag => ["_grokparsefailure"]
  }
  if [source] =~ "namenode" {
    grok {
      patterns_dir => ["/etc/${service.sid}/conf/patterns"]
      break_on_match => true
      match => { "message" => [
        "%{HDFS_NN_SAFEMODE:hdfs_safemode}"
      ]}
    }
  }
  if [source] =~ "hbase-master" {
    grok {
      patterns_dir => ["/etc/${service.sid}/conf/patterns"]
      break_on_match => true
      match => { "message" => [
        "%{HBASE_GC_FULL}",
        "%{HBASE_JVM_PAUSE}",
        "%{HBASE_GC_FULL}"
      ]}
    }
  }
  if [source] =~ "hbase-regionserver" {
    grok {
      patterns_dir => ["/etc/${service.sid}/conf/patterns"]
      break_on_match => true
      match => { "message" => [
        "%{HBASE_GC_FULL}",
        "%{HBASE_ES_TRACE}",
        "%{HBASE_RS_TRANSITION}",
        "%{HBASE_RS_COMPACTION}",
        "%{HBASE_JVM_PAUSE}",
        "%{HBASE_GC_FULL}"
      ]}
    }
  }
  if [source] =~ "guardian" {
    grok {
      patterns_dir => ["/etc/${service.sid}/conf/patterns"]
      break_on_match => true
      match => { "message" => [
        "%{GUARDIAN_AUDIT}"
      ]}
    }
  }
  if [source] =~ "spark-executor" {
    grok {
      patterns_dir => ["/etc/${service.sid}/conf/patterns"]
      break_on_match => true
      match => { "message" => [
        "%{SPK_EXE_TASK_ACK}",
        "%{SPK_EXE_TASK_START}",
        "%{SPK_EXE_TASK_FINISH}",
        "%{SPK_EXE_EXCEPTION}",
        "%{SPK_GC_EVENT}",
        "%{SPK_GC_EVENT2}",
        "%{LEVI_EVENT:levi}",
        "%{EVENT_GC:gc_minor}",
        "%{EVENT_FULL_GC:gc_full}"
      ]}
    }
  } else if [source] =~ "hive-server"{
    grok {
      patterns_dir => ["/etc/${service.sid}/conf/patterns"]
      break_on_match => true
      match => { "message" => [
        "%{SQL_EXEC_MODE_OPT}",
        "%{SQL_HEARTBEAT_ON}",
        "%{SQL_HEARTBEAT_OFF}",
        "%{SQL_HEARTBEAT_RUNNING}",
        "%{SQL_SQL_STMT}",
        "%{SQL_PARSE_STMT}",
        "%{SQL_SQL_LIFE_END}",
        "%{SQL_AUTH_FAIL}",
        "%{SQL_ZK_LOCK_NODE}",
        "%{SQL_ZK_LOCK_NODE_FAIL}",
        "%{SQL_STANDBY_SWITCH}",
        "%{SQL_STREAM_START}",
        "%{SQL_STREAMTASK_BEGIN}",
        "%{SQL_STREAMTASK_FAIL}",
        "%{SQL_STREAMTASK_RESUBMIT}",
        "%{SQL_SPARKTASK_CANCEL}",
        "%{SQL_SPARKJOB_GROUPID}",
        "%{PERFLOG_EVENT}",
        "%{SQL_PERFLOG_START}",
        "%{SQL_PERFLOG_END}",
        "%{MS_THREAD_POOL_FULL}",
        "%{HB_TOKEN_RENEW_SUCCESS}",
        "%{HB_TOKEN_RENEW_FAIL}",
        "%{HB_TOKEN_RENEW_BEGIN}",
        "%{HB_TOKEN_RENEW_STOP}",
        "%{HB_TOKEN_RENEW_RESUME}",
        "%{HB_ROOT_CREATION_FAIL}",
        "%{SESSION_DROP}",
        "%{SESSION_CLOSE}",
        "%{SESSION_FAIL}",
        "%{SESSION_ACTIVE}",
        "%{SPK_JOB_GET}",
        "%{SPK_STAGE_RESUBMIT}",
        "%{SPK_STAGE_SUBMIT}",
        "%{SPK_STAGE_TASK_SUBMIT}",
        "%{SPK_STAGE_TASK_FINISH}",
        "%{SPK_STAGE_FINISH}",
        "%{SPK_STAGE_MASK_FAIL}",
        "%{SPK_STAGE_RUNNING}",
        "%{SPK_STAGE_WAITING}",
        "%{SPK_STAGE_FAILED}",
        "%{SPK_TASK_CANCEL_FAIL}",
        "%{SPK_TASK_START}",
        "%{SPK_TASK_FINISH}",
        "%{SPK_DAG_STOP}",
        "%{SPK_CTXT_SHUTDOWN}",
        "%{SPK_ACTOR_UNKNOWN}",
        "%{SPK_EXECUTOR_LOST}",
        "%{SPK_JOB_ABORT}",
        "%{HDFS_ACID_WRITE}",
        "%{HDFS_SQL_RESULT}",
        "%{HDFS_MAPJOIN}",
        "%{HDFS_LOADDATA}",
        "%{THFT_AUDIT_STAT}",
        "%{THFT_AUDIT_SQL}",
        "%{EVENT_GC}",
        "%{EVENT_FULL_GC}",
        "%{INCEPTOR_ES_TRACE}",
        "%{LEVI_EVENT}"
      ]}
    }
  }
  if [source] =~ "hive-metastore" {
    grok {
      patterns_dir => ["/etc/${service.sid}/conf/patterns"]
      break_on_match => true
      match => { "message" => [
        "%{MS_AUDIT_LOG}",
        "%{MS_INIT}",
        "%{MS_CLOSE}",
        "%{MS_THREAD_POOL_FULL}",
        "%{EVENT_GC:gc_minor}",
        "%{EVENT_FULL_GC:gc_full}"
      ]}
    }
  }
  if "_grokparsefailure" in [tags] {
    if [level] =~ "ERROR" {
      grok {
        patterns_dir => ["/etc/${service.sid}/conf/patterns"]
        break_on_match => true
        match => { "message" => [
          "^.*\.ESLog4jSpanReceiver: %{GREEDYDATA:message}END",
          "%{HBASE_RS_OFFLINE:rs_offline}",
          "%{INCEPTOR_ERROR}",
          "%{ES_EXCEPTION}",
          "%{GREEDYDATA}"
        ]}
      }
    }
    if [level] =~ "WARN" {
      grok {
        patterns_dir => ["/etc/${service.sid}/conf/patterns"]
        break_on_match => true
        match => { "message" => [
          "%{HBASE_JVM_PAUSE}",
          "%{HBASE_RESPONSETOOSLOW}",
          "%{GREEDYDATA}"
        ]}
      }
    }
    mutate { remove_tag => ["_grokparsefailure"] }
  }
  if [beat][timezone] {
    mutate { add_field => { "timezone" => "%{[beat][timezone]}" }}
  } else {
    mutate { add_field => { "timezone" => "Asia/Shanghai" }}
  }
  date {
    match => ["datetime", "ISO8601"]
    timezone => "%{[timezone]}"
  }
  if [beat][hostname] {
    mutate {
      add_field => { "host" => "%{[beat][hostname]}" }
      remove_field => ["beat"]
    }
  }
  mutate {
    remove_field => ["@version", "prospector", "offset"]
  }

  grok {
    patterns_dir => ["/etc/${service.sid}/conf/patterns"]
    break_on_match => true
    match => { "message" => [
<#if service['b-filter.conf']??>
  <#list service['b-filter.conf'] as key, value>
      "${value}",
  </#list>
</#if>
      "."
    ]}
  }

  if "_dateparsefailure" in [tags] {
    mutate { remove_tag => ["_dateparsefailure"] }
  }

<#if service['logstash.full_message'] = "false">
  mutate {
    remove_field => ["message"]
  }
</#if>

}
