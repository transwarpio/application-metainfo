## ----- framework specific configs -----
server.port: ${service['server.web.port']}
springfox.documentation:
  auto-startup: true
  swagger.v2.path: /api/docs

## ----- application configs
api:
  swagger:
    enabled: ${service['server.api.swagger.enabled']}
