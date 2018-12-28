# Druid 配置信息, 用于操作slipstream
spring.datasource.druid.url=jdbc:hive2://${service.roles.INCEPTOR_SERVER[0]['hostname']}:${service['hive.server2.thrift.port']}/default
spring.datasource.druid.username=${service['slipstream.studio.druid.username']}
spring.datasource.druid.password=${service['slipstream.studio.druid.password']}
#################################################################
spring.datasource.druid.driver-class-name=org.apache.hive.jdbc.HiveDriver
#初始大小
spring.datasource.druid.initial-size=3
#最大活跃连接数
spring.datasource.druid.max-active=40
#最小空闲连接
spring.datasource.druid.min-idle=1
#获取连接时最大等待时间，单位毫秒
spring.datasource.druid.max-wait=30000
spring.datasource.druid.max-open-prepared-statements=40
#测试sql
spring.datasource.druid.validation-query=select 1 from system.dual
#测试sql的timeout
spring.datasource.druid.validation-query-timeout=30000
#申请连接时执行validationQuery检测连接是否有效
spring.datasource.druid.test-on-borrow=false
#归还连接时执行validationQuery检测连接是否有效
spring.datasource.druid.test-on-return=false
#申请连接的时候检测，如果空闲时间大于timeBetweenEvictionRunsMillis，执行validationQuery检测连接是否有效。
spring.datasource.druid.test-while-idle=true
spring.datasource.druid.time-between-eviction-runs-millis=60000
spring.datasource.druid.min-evictable-idle-time-millis=120000
spring.datasource.druid.max-evictable-idle-time-millis=300000

# 失败重连等待时间.
spring.datasource.druid.timeBetweenConnectErrorMillis=12000
# 失败重连次数.
spring.datasource.druid.connectionErrorRetryAttempts=5