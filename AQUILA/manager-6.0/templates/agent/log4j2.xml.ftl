<#compress>
<#noparse>
<?xml version="1.0" encoding="UTF-8"?>
<Configuration status="INFO" monitorInterval="30">
  <Properties>
    <Property name="LOG_PATTERN">
      %d{yyyy-MM-dd HH:mm:ss.SSS} %5p ${hostName} --- [%15.15t] %-40.40c{1.} : %m%n%ex
    </Property>
  </Properties>
  <Appenders>
    <Console name="ConsoleAppender" target="SYSTEM_OUT" follow="true">
      <PatternLayout pattern="${LOG_PATTERN}"/>
    </Console>
    <!-- Rolling File Appender -->
</#noparse>
    <RollingFile name="FileAppender" fileName="/var/log/${service.sid}/agent/aquila-agent.log"
                 filePattern="/var/log/${service.sid}/aquila-server.log.%i">
<#noparse>
      <PatternLayout>
        <Pattern>${LOG_PATTERN}</Pattern>
      </PatternLayout>
      <Policies>
        <SizeBasedTriggeringPolicy size="16MB" />
      </Policies>
      <DefaultRolloverStrategy max="16"/>
    </RollingFile>
  </Appenders>
  <Loggers>
</#noparse>
    <Logger name="io.transwarp.aquila" level="${service['agent.log.app.level']}" additivity="false">
<#noparse>
      <AppenderRef ref="FileAppender" />
    </Logger>

    <Root level="INFO">
      <AppenderRef ref="FileAppender"/>
    </Root>
  </Loggers>
</Configuration>
</#noparse>
</#compress>