[logging]
default = FILE:/var/log/krb5libs.log
kdc = FILE:/var/log/krb5kdc.log
admin_server = FILE:/var/log/kadmind.log

[libdefaults]
default_realm = ${service.realm}
dns_lookup_realm = false
dns_lookup_kdc = false
ticket_lifetime = 24h
renew_lifetime = 7d
forwardable = true
allow_weak_crypto = true
udp_preference_limit = 1000000
default_ccache_name = FILE:/tmp/krb5cc_%{uid}

[realms]
${service.realm} = {
<#list dependencies.GUARDIAN.roles.GUARDIAN_APACHEDS as kdc>
kdc = ${kdc.hostname}:${service.kdc.port}
</#list>
}
