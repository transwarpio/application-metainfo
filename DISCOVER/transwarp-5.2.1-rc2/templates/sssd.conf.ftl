<#if service.auth = "kerberos">
<#if dependencies.GUARDIAN??>
<#assign  guardian=dependencies.GUARDIAN guardian_servers=[]>
<#list guardian.roles["GUARDIAN_APACHEDS"] as role>
    <#assign guardian_servers += [("ldap://" + role.hostname + ":" + guardian["guardian.apacheds.ldap.port"])]>
</#list>
[sssd]
domains = ${service.realm}
services = nss
config_file_version = 2
[nss]
override_homedir = /var/home/%u
filter_users = root
filter_groups = root
[domain/${service.realm}]
id_provider = ldap
ldap_uri = ${guardian_servers?join(",")}
ldap_search_base = ${service.domain}
ldap_schema = rfc2307bis
ldap_default_bind_dn = uid=admin,ou=system
ldap_default_authtok_type = password
ldap_default_authtok = ${dependencies.GUARDIAN['guardian.ds.root.password']}

ldap_user_object_class = inetOrgPerson
ldap_group_object_class = configGroup
</#if>
</#if>