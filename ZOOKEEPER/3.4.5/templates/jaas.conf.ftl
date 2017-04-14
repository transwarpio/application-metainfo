<#if service.auth = "kerberos">
Server {
  com.sun.security.auth.module.Krb5LoginModule required
  useKeyTab=true
  keyTab="/etc/${service.sid}/conf/${service.keytab}.keytab"
  storeKey=true
  useTicketCache=false
  principal="zookeeper/${localhostname?lower_case}@${service.realm}";
};
</#if>