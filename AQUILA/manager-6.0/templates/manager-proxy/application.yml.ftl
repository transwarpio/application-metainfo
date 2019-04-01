## ----- framework specific configs -----
server:
  port: ${service['manager.proxy.web.port']}

## ----- application configs
paths:
  resources:
    metainfoDir: "/var/lib/transwarp-manager/master/content/meta/services"
manager-db:
  params:
    props-file: /etc/transwarp-manager/master/db.properties
    permitted-tables: [ "cluster", "node", "rack", "service", "role" ]
