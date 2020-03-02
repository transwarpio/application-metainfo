<#if service.auth = "kerberos">
KafkaClient {
  com.sun.security.auth.module.Krb5LoginModule required
  useKeyTab=true
  storeKey=true
  keyTab="${service.keytab}"
  principal="kafka/${localhostname?lower_case}@${service.realm}";
};

// Zookeeper client authentication
Client {
  com.sun.security.auth.module.Krb5LoginModule required
  useKeyTab=true
  storeKey=true
  useTicketCache=false
  keyTab="${service.keytab}"
  principal="hbase/${localhostname?lower_case}@${service.realm}";
};
</#if>