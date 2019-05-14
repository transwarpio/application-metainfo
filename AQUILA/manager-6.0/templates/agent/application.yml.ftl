## ----- framework specific configs -----
server.port: ${service['agent.web.port']}

## ----- application configs
io:
  fs-storage:
    writable-dirs:
      - /etc/aquila
