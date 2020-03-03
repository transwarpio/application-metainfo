## ----- framework specific configs -----
server.port: ${service['agent.web.port']}

## ----- application configs
io:
  writable-dirs:
    - /etc/aquila
