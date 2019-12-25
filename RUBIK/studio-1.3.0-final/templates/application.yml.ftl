server:
  port: 32125
  error:
    path:
  ssl:
    key-store: /srv/rubik/server.keystore
    key-store-password: changeit
    key-store-type: JKS

mybatis:
  config-location: classpath:mybatis-config.xml

spring:
  resources:
    static-locations: ["classpath:static/"]
