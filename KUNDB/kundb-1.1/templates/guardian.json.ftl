{
<#if service['kundb.enable_security'] == "true">
    <#assign  guardian=dependencies.GUARDIAN >
    <#list guardian.roles["GUARDIAN_APACHEDS"] as role>
     <#assign ldapServer = role.hostname + ":" + guardian["guardian.apacheds.ldap.port"]>
  "LdapServer": "${ldapServer}",
     <#break>
    </#list>
  "LdapCA": "",
  "Method": "mysql_clear_password",
  <#assign user = guardian['guardian.admin.username'] password = guardian['guardian.ds.root.password']>
  "User": "uid=${user},ou=system",
  "Password": "${password}",
  <#assign dsDomain = guardian['guardian.ds.domain']>
  "GroupQuery": "ou=people,${dsDomain}",
  "UserDnPattern":"uid=%s,ou=people,${dsDomain}"
</#if>
}
