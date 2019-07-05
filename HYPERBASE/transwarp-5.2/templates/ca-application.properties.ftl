server.address=${localhostname?lower_case}
server.port=${service['catalog-agent.http.port']}
catalog.agent.service.id=${service.sid}
catalog.agent.service.tenant=TDH
catalog.agent.service.version=0.98.6-transwarp-5.2.2
catalog.agent.service.type=HYPERBASE
catalog.web.server.address=${service['catalog-agent.web.address']}
catalog.kerberos.principal=hbase/${localhostname?lower_case}@${service.realm}
catalog.keytab.file=${service.keytab}
datasource.load.meta=${service['catalog-agent.load.meta']}

# logger
logging.config=classpath:logback-file.xml
logging.level.root=INFO

spring.autoconfigure.exclude=org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration, org.springframework.boot.autoconfigure.orm.jpa.HibernateJpaAutoConfiguration