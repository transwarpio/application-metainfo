<#assign servers=service.roles.GUARDIAN_APACHEDS?sort_by("id") master=servers[0].hostname>
<#if (servers?size >1)>
	<#assign slaves=servers[1..(servers?size-1)] slaves_with_port=[]>
	<#list slaves as slave>
		<#assign slaves_with_port += [slave.hostname + ":" + service['guardian.apacheds.ldap.port']]>
	</#list>
</#if>

guardian.ds.database.dir=${service['guardian.apacheds.data.dir']}
guardian.ds.domain=${service['guardian.ds.domain']}
guardian.ds.linux.id.start=5000
guardian.ds.ldap.host=localhost
guardian.ds.ldap.port=${service['guardian.apacheds.ldap.port']}
guardian.ds.ldap.tls.enabled=${service['guardian.ds.ldap.tls.enabled']}
guardian.ds.ldap.key.store=not_used
guardian.ds.ldap.key.store.pw=not_used

guardian.ds.realm=${service['guardian.ds.realm']}
guardian.ds.kdc.port=${service['guardian.apacheds.kdc.port']}
guardian.ds.kdc.clock.skew=300000
guardian.ds.kdc.ticket.lifetime=86400000
guardian.ds.kdc.renew.lifetime=604800000
guardian.ds.krb.keyring.enable=false
guardian.ds.kdc.encryption.types=aes128-cts-hmac-sha1-96, des-cbc-md5, des3-cbc-sha1-kd

guardian.ds.root.password.store=/etc/guardian/conf/guardian-auth.jks
guardian.ds.admin.username=admin
guardian.ds.admin.password.store=/etc/guardian/conf/guardian-auth.jks

guardian.ds.ha.enabled=${(servers?size >1)?string("true", "false")}

# guardian system user for connection to guardian service
guardian.ds.guardian.username=guardian/guardian
guardian.ds.guardian.password.store=/etc/guardian/conf/guardian-auth.jks

# if true use hostname, else use ip address
guardian.ds.ha.use.hostname=true

# guardian.ds.ha.zookeeper.quorum=172.16.1.190:2181,172.16.1.190:2181,172.16.1.190:2181
guardian.ds.ha.znode.parent=guardian

guardian.ds.partition.sync.on.write=false

# master or slave
guardian.ds.ha.status=${(master == localhostname)?then("master", "slave")}

guardian.ds.ha.user.dn=uid=admin,ou=system
guardian.ds.ha.user.password.store=/etc/guardian/conf/guardian-auth.jks

guardian.ds.ha.refresh.interval=60000
guardian.ds.ha.config.dn=ads-replConsumerId=replication,ou=system
guardian.ds.ha.healthy.check.interval=300000
guardian.ds.ha.healthy.check.timeout=5000

<#if master != localhostname>
guardian.ds.ha.master.host=${master}
guardian.ds.ha.master.port=${service['guardian.apacheds.ldap.port']}
guardian.ds.ha.master.tls.enabled=false
</#if>

