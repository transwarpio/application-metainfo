<?xml version="1.0" encoding="UTF-8"?>
<Configuration  monitorInterval="30">
  <Appenders>
    <RollingFile name="RollingFile" fileName="/var/log/${service.sid}/tdh-exporter/aquila-tdh-exporter.log"
                 filePattern="/var/log/${service.sid}/tdh-exporter/aquila-tdh-exporter.log.%i">
      <PatternLayout>
        <Pattern>%d %5p (%F:%L) %t - %m%n</Pattern>
      </PatternLayout>
      <Policies>
        <SizeBasedTriggeringPolicy size="250 MB"/>
      </Policies>
      <DefaultRolloverStrategy max="2"/>
    </RollingFile>
  </Appenders>
  <Loggers>
    <Root level="INFO">
      <AppenderRef ref="RollingFile"/>
    </Root>
  </Loggers>
</Configuration>