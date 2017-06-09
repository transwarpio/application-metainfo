<#--Simple macro definition-->
<#macro property key value>
<property>
    <name>${key}</name>
    <value>${value}</value>
</property>
</#macro>
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
		<@property "guardian.server.ldap.type" "APACHEDS" />
		<@property "guardian.server.kerberos.principal" "guardian/guardian" />
		<@property "guardian.server.kerberos.password" "${service['guardian.server.kerberos.password']}" />
		<@property "guardian.server.kerberos.keytab" "/etc/guardian/conf/guardian.keytab" />
		<@property "guardian.server.war.location" "/usr/lib/guardian/webui/guardian-server.war" />
		<@property "guardian.server.db.location" "/var/lib/guardian/guardian.db" />
		<@property "guardian.server.bind.host" "0.0.0.0" />
		<@property "guardian.server.bind.port" "${service['guardian.server.port']}" />
		<@property "guardian.connection.username" "admin" />
		<@property "guardian.connection.password" "${service['guardian.admin.password']}" />
		<@property "guardian.server.tls.enabled" "${service['guardian.server.tls.enabled']}" />
		<@property "guardian.server.key.store" "/srv/guardian/server.keystore" />
		<@property "guardian.server.key.store.pw" "changeit" />
</configuration>


