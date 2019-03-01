spring:
  data:
    rest:
      base-path: /api
  thymeleaf:
    prefix: classpath:/static/

server:
  port: ${r"${watchman.server.port}"}

watchman:
  aiops:
    port: ${service['dbaservice.aiops.ui.port']}
  server:
    port: ${service['dbaservice.ui.port']}
    host: ${service.roles.DBA_SERVICE[0]['ip']} # this is watchman node ip!
  message:
    protocol: akka
    port: 60606
    receiver: receiver
  security:
    enabled: ${service['dbaservice.security.enabled']}
  users:
    - username: admin
      password: admin
      roles: [ADMIN,USER]
    - username: user
      password: user
      roles: [USER]
  inceptor:
    targets:
      - type: MESSAGE
        target: ${r"${watchman.message.protocol}"}://${r"${watchman.server.host}"}:${r"${watchman.message.port}"}
        receiver: ${r"${watchman.message.receiver}"}
        harvestIntervalMs: 100
    limit:
      status: ${service['dbaservice.inceptor.limit.status']!'10000'}
      session: ${service['dbaservice.inceptor.limit.session']!'10000'}
      completeSql: ${service['dbaservice.inceptor.limit.completeSql']!'5000'}
      incompleteSql: ${service['dbaservice.inceptor.limit.incompleteSql']!'10000'}
      errorSql: ${service['dbaservice.inceptor.limit.errorSql']!'10000'}
      incompleteJob: ${service['dbaservice.inceptor.limit.incompleteJob']!'20000'}
      incompleteStage: ${service['dbaservice.inceptor.limit.incompleteStage']!'50000'}
      incompleteTask: ${service['dbaservice.inceptor.limit.incompleteTask']!'1000000'}
      incompleteLocalTask: ${service['dbaservice.inceptor.limit.incompleteLocalTask']!'1000000'}
      task: ${service['dbaservice.inceptor.limit.task']!'5000000'}
      noParentJob: ${service['dbaservice.inceptor.limit.noParentJob']!'20000'}
      noParentStage: ${service['dbaservice.inceptor.limit.noParentStage']!'50000'}
      noParentTask: ${service['dbaservice.inceptor.limit.noParentTask']!'1000000'}
      noParentLocalTask: ${service['dbaservice.inceptor.limit.noParentLocalTask']!'1000000'}
      expireTimeShort: ${service['dbaservice.inceptor.limit.expireTimeShort']!'604800000'} # in ms
      expireTimeLong: ${service['dbaservice.inceptor.limit.expireTimeLong']!'2592000000'} # in ms
