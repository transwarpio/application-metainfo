## ----- framework specific configs -----
server:
  port: ${service['manager.proxy.web.port']}

## ----- application configs
paths:
  resources:
    metainfoDir: "/var/lib/transwarp-manager/master/content/meta/services"
