<#if service.auth = "kerberos">
KafkaClient {
  com.sun.security.auth.module.Krb5LoginModule required
  useKeyTab=true
  storeKey=true
  keyTab="${service.keytab}"
  principal="kafka/${localhostname?lower_case}@${service.realm}";
};

// ZooKeeper client authentication
Client {
  com.sun.security.auth.module.Krb5LoginModule required
  useKeyTab=true
  storeKey=true
  keyTab="${service.keytab}"
  principal="zookeeper/${localhostname?lower_case}@${service.realm}";
};
</#if>