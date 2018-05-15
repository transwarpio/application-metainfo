<#if service.auth = "kerberos">
KafkaServer {
  com.sun.security.auth.module.Krb5LoginModule required
  useKeyTab=true
  keyTab="${service.keytab}"
  storeKey=true
  useTicketCache=false
  principal="kafka/${localhostname?lower_case}@${service.realm}";
};

KafkaClient {
  com.sun.security.auth.module.Krb5LoginModule required
  useKeyTab=true
  keyTab="${service.keytab}"
  storeKey=true
  useTicketCache=false
  principal="kafka/${localhostname?lower_case}@${service.realm}";
};

// Zookeeper client authentication
Client {
  com.sun.security.auth.module.Krb5LoginModule required
  useKeyTab=true
  storeKey=true
  useTicketCache=false
  keyTab="${service.keytab}"
  principal="kafka/${localhostname?lower_case}@${service.realm}";
};
</#if>