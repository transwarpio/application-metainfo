<#if dependencies.SEARCH??>
  <#assign search=dependencies.SEARCH searches=[]>
  <#list search.roles.SEARCH_SERVER as role>
    <#if (searh[role.id?c])??>
      <#assign searches += [role.hostname + ":" + search[role.id?c]['http.port']]>
    <#else>
      <#assign searches += [role['hostname'] + ":" + search['http.port']]>
    </#if>
  </#list>
</#if>
<?xml version="1.0" encoding="UTF-8"?>
<!--日志级别以及优先级排序: OFF > FATAL > ERROR > WARN > INFO > DEBUG > TRACE > ALL -->
<!--Configuration后面的status，这个用于设置log4j2自身内部的信息输出，可以不设置，当设置成trace时，你会看到log4j2内部各种详细输出-->
<!--monitorInterval：Log4j能够自动检测修改配置 文件和重新配置本身，设置间隔秒数-->
<configuration monitorInterval="30" status = "ERROR">
    !--先定义所有的appender-->
    <appenders>
        !--这个输出控制台的配置-->
        <console name="Console" target="SYSTEM_OUT">
            <!--输出日志的格式-->
            <PatternLayout pattern="[%d{HH:mm:ss:SSS}] [%p] - %l - %m%n"/>
        </console>
        <RollingFile name="RollingFileInfo" fileName="/var/log/${service.sid}/sophon-st.log" filePattern="/var/log/${service.sid}/${r'$${date:yyyy-MM}'}/%d{yyyy-MM-dd}-%i.log">
            <ThresholdFilter level="info" onMatch="ACCEPT" onMismatch="DENY"/>
            <!--控制台只输出level及以上级别的信息（onMatch），其他的直接拒绝（onMismatch）-->
            <PatternLayout pattern="[%d{HH:mm:ss:SSS}] [%p] - %l - %m%n"/>
            <Policies>
                <TimeBasedTriggeringPolicy/>
                <SizeBasedTriggeringPolicy size="100 MB"/>
            </Policies>
        </RollingFile>
        <Routing name="RoutingToEs">
            <Routes pattern="${r'${ctx:taskId}'}">
                <!-- This route is chosen if ThreadContext has value 'special' for key ROUTINGKEY. -->
                <Route>
                    <ESTask name="ESBatchForTask${r'${ctx:taskId}'}">
                        <STRollingIndexName/>
                        <TaskId taskId="${r'${ctx:taskId}'}" />
                        <AsyncBatchDelivery>
                            <JestHttp serverUris="http://${searches[0]}" />
                        </AsyncBatchDelivery>
                    </ESTask>
                </Route>
            </Routes>
        </Routing>
    </appenders>
    <!--然后定义logger，只有定义了logger并引入的appender，appender才会生效-->
    <Loggers>
        <Logger name = "io.searchbox.client.http.JestHttpClient" level="ERROR"></Logger>
        <Logger name = "io.searchbox.core.Bulk" level="ERROR"></Logger>
        <Logger name = "org.apache.hadoop.yarn.util.RackResolver" level="ERROR"></Logger>
        <Root level="INFO">
            <appender-ref ref="Console"/>
            <appender-ref ref="RoutingToEs"/>
            <appender-ref ref="RollingFileInfo"/>
        </Root>
    </Loggers>
</configuration>

