app.name = ${service.sid}
app.access-control = true

spring.profiles.active=prod
spring.http.multipart.max-file-size=128MB
spring.http.multipart.max-request-size=128MB

#use hyperbase or not
usehyperbase=true

#use email notification or not
usemail=false

# mybatis settings
mybatis.mapperLocations = classpath:/mapper/*.xml
mybatis.type-aliases-package = io.transwarp.mirror.persistence.mybatis.model
mybatis.configuration.mapUnderscoreToCamelCase=true

server.port=${service['backend.port']}

flyway.locations=classpath:/schema

pagehelper.helperDialect=mysql
pagehelper.reasonable=false
pagehelper.supportMethodsArguments=true
pagehelper.params=count=countSql
