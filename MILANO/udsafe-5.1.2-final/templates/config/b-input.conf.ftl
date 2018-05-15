<#if dependencies.KAFKA??>
    <#assign kafka=dependencies.KAFKA kafkas=[]>
    <#list kafka.roles.KAFKA_SERVER as role>
        <#assign kafkas += [role.hostname + ":" + kafka[role.hostname]["listeners"]?split(":")[2]]>
    </#list>
</#if>

<#if service.auth = "kerberos">
input {
  kafka {
    group_id => "milano"
    topics => ["logs"]
    bootstrap_servers => "${kafkas?join(",")}"
    codec => "json"
    jaas_path => "/etc/${service.sid}/conf/logstash-jaas.conf"
    kerberos_config => "/etc/${service.sid}/conf/krb5.conf"
    consumer_threads => ${service['logstash.worker_num']}
    poll_timeout_ms  => 1000
    sasl_kerberos_service_name => "kafka"
    sasl_mechanism => "GSSAPI"
    security_protocol => "SASL_PLAINTEXT"
    max_poll_records => "1000"
  }
}
<#else>
input {
  kafka {
    group_id => "milano"
    topics => ["logs"]
    bootstrap_servers => "${kafkas?join(",")}"
    codec => "json"
    consumer_threads => ${service['logstash.worker_num']}
    poll_timeout_ms  => 1000
    max_poll_records => "1000"
  }
}
</#if>
