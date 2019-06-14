<#if service.auth = "kerberos">
Client {
  com.sun.security.auth.module.Krb5LoginModule required
  useKeyTab=true
  storeKey=true
  useTicketCache=false
  keyTab="/etc/${service.sid}/conf/stellardb.keytab"
  principal="stellardb/${localhostname?lower_case}@${service.realm}";
};
</#if>
