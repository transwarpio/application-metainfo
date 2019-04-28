server.address=${localhostname?lower_case}
server.port=${service['catalog-agent.http.port']}
catalog.agent.service.id=${service.sid}
catalog.agent.service.tenant=TDH
catalog.agent.service.version=transwarp-6.0
catalog.agent.service.type=INCEPTOR
catalog.web.server.address=${service['catalog-agent.web.address']}
catalog.kerberos.principal=hive/${localhostname?lower_case}@${service.realm}
catalog.keytab.file=${service.keytab}

# logger
logging.config=classpath:logback-spring.xml
logger.db.level=INFO
logger.root.level=INFO

spring.datasource.driver-class-name=org.apache.hive.jdbc.HiveDriver
spring.datasource.proxy.url=jdbc:hive2://${service.roles["INCEPTOR_SERVER"][0].hostname}:${service['hive.server2.thrift.port']}/;principal=hive/${localhostname?lower_case}@${service.realm};hive.server2.proxy.user=
spring.datasource.url=jdbc:hive2://${service.roles["INCEPTOR_SERVER"][0].hostname}:${service['hive.server2.thrift.port']}/;principal=hive/${localhostname?lower_case}@${service.realm}
spring.datasource.initial-size=5
spring.datasource.min-idle=5
spring.datasource.max-idle=10
spring.datasource.max-wait=10000
spring.datasource.oracle.max-active=100

