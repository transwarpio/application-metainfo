#Distribute data base
DDB=${service['distributed.database.type']}

#inceptor properties
hive.host=${dependencies.INCEPTOR.roles.INCEPTOR_SERVER[0]['hostname']}
hive.port=${dependencies.INCEPTOR['hive.server2.thrift.port']}
hive.principal=hive/${dependencies.INCEPTOR.roles.INCEPTOR_SERVER[0]['hostname']}@${service.realm}
hive.kuser=hive/${localhostname?lower_case}@${service.realm}
hive.kerberos=${dependencies.INCEPTOR.auth}
hive.authentication=${dependencies.INCEPTOR['hive.server2.authentication']}
hive.ldap.username=${service['inceptor.ldap.username']}
hive.ldap.password=${service['inceptor.ldap.password']}
hive.hiveserver2=true
hive.database.prod=default
hive.keytab=${service.keytab}
hive.pool.size=64
hive.pool.timeout=3600
hive.label.numbuckets=30
hive.check.samples=100
hive.estable.numshards=10
