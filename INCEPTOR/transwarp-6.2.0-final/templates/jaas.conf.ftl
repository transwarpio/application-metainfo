<#if service.auth = "kerberos">
KafkaClient {
  com.sun.security.auth.module.Krb5LoginModule required
  useKeyTab=true
  storeKey=true
  keyTab="${service.keytab}"
  principal="kafka/${localhostname?lower_case}@${service.realm}";
};
Client {
  com.sun.security.auth.module.Krb5LoginModule required
  useKeyTab=true
  storeKey=true
  useTicketCache=false
  keyTab="/etc/${service.sid}/conf/inceptor.keytab"
  principal="hive/${localhostname?lower_case}@${service.realm}";
};
</#if>
