spring.profiles.include=ssl
server.port=${service['catalog.platform.http.port']}

spring.http.encoding.charset=UTF-8
spring.http.encoding.enabled=true
spring.http.encoding.force=true

spring.aop.auto=true
spring.aop.expose-proxy=true
spring.aop.proxy-target-class=true

security.basic.enabled=false

catalog.web.server.address=${service.roles["CATALOG_WEB"][0].hostname}:${service['catalog.web.http.port']}
catalog.agent.server.address = ${service.roles["CATALOG_AGENT"][0].hostname}:${service['catalog.agent.http.port']}

logging.config=classpath:logback-console.xml
logging.level.root=INFO