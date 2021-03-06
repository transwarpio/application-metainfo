<#if dependencies.ZOOKEEPER??>
	<#assign zookeeper=dependencies.ZOOKEEPER quorums=[]>
	<#list zookeeper.roles.ZOOKEEPER as role>
		<#assign quorums += [role.hostname + ":" + zookeeper["zookeeper.client.port"]]>
	</#list>
	<#assign quorum = quorums?join(",")>
</#if>
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:tx="http://www.springframework.org/schema/tx"
	xmlns:aop="http://www.springframework.org/schema/aop" xmlns:lang="http://www.springframework.org/schema/lang"
	xmlns:context="http://www.springframework.org/schema/context"
	xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans-2.0.xsd
           http://www.springframework.org/schema/aop http://www.springframework.org/schema/aop/spring-aop-2.0.xsd
           http://www.springframework.org/schema/lang http://www.springframework.org/schema/lang/spring-lang-2.0.xsd
           http://www.springframework.org/schema/tx http://www.springframework.org/schema/tx/spring-tx-2.0.xsd
           http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context-2.5.xsd"
	default-autowire="byName">

	<!-- properties -->
	<bean class="com.alibaba.otter.canal.instance.spring.support.PropertyPlaceholderConfigurer" lazy-init="false">
		<property name="ignoreResourceNotFound" value="true" />
		<property name="systemPropertiesModeName" value="SYSTEM_PROPERTIES_MODE_OVERRIDE"/><!-- 允许system覆盖 -->
		<property name="locationNames">
			<list>
                <!-- <value>classpath:canal/conf/canal.properties</value> -->
                <!-- <value>classpath:canal/conf/${r'${canal.instance.destination:}'}/instance.properties</value> -->
				<value>file:/etc/${service.sid}/conf/canal/conf/canal.properties</value>
				<value>file:/etc/${service.sid}/conf/canal/conf/${r'${canal.instance.destination:}'}/instance.properties</value>
			</list>
		</property>
	</bean>

	<bean id="socketAddressEditor" class="com.alibaba.otter.canal.instance.spring.support.SocketAddressEditor" />
	<bean class="org.springframework.beans.factory.config.CustomEditorConfigurer">
		<property name="propertyEditorRegistrars">
			<list>
				<ref bean="socketAddressEditor" />
			</list>
		</property>
	</bean>

	<bean id="instance" class="com.alibaba.otter.canal.instance.spring.CanalInstanceWithSpring">
		<property name="destination" value="${r'${canal.instance.destination}'}" />
		<property name="eventParser">
			<ref bean="eventParser" />
		</property>
		<property name="eventSink">
			<ref bean="eventSink" />
		</property>
		<property name="eventStore">
			<ref bean="eventStore" />
		</property>
		<property name="metaManager">
			<ref bean="metaManager" />
		</property>
		<property name="alarmHandler">
			<ref bean="alarmHandler" />
		</property>
	</bean>

	<!-- 报警处理类 -->
	<bean id="alarmHandler" class="io.transwarp.transporter.canal.server.CanalServerAlarmHandler" />

	<bean id="zkClientx" class="org.springframework.beans.factory.config.MethodInvokingFactoryBean" >
		<property name="targetClass" value="com.alibaba.otter.canal.common.zookeeper.ZkClientx" />
		<property name="targetMethod" value="getZkClient" />
		<property name="arguments">
			<list>
				<value>${r'${canal.zkServers:'}${quorum?if_exists}}</value>
			</list>
		</property>
	</bean>

	<bean id="metaManager" class="com.alibaba.otter.canal.meta.PeriodMixedMetaManager">
		<property name="zooKeeperMetaManager">
			<bean class="com.alibaba.otter.canal.meta.ZooKeeperMetaManager">
				<property name="zkClientx" ref="zkClientx" />
			</bean>
		</property>
		<property name="period" value="${r'${canal.zookeeper.flush.period:1000}'}" />
	</bean>

	<bean id="eventStore" class="com.alibaba.otter.canal.store.memory.MemoryEventStoreWithBuffer">
		<property name="bufferSize" value="${r'${canal.instance.memory.buffer.size:16384}'}" />
		<property name="bufferMemUnit" value="${r'${canal.instance.memory.buffer.memunit:1024}'}" />
		<property name="batchMode" value="${r'${canal.instance.memory.batch.mode:MEMSIZE}'}" />
		<property name="ddlIsolation" value="${r'${canal.instance.get.ddl.isolation:false}'}" />
	</bean>

	<bean id="eventSink" class="com.alibaba.otter.canal.sink.entry.EntryEventSink">
		<property name="eventStore" ref="eventStore" />
	</bean>

	<bean id="eventParser" class="com.alibaba.otter.canal.parse.inbound.mysql.MysqlEventParser">
		<property name="destination" value="${r'${canal.instance.destination}'}" />
		<property name="slaveId" value="${r'${canal.instance.mysql.slaveId:1234}'}" />
		<!-- 心跳配置 -->
		<property name="detectingEnable" value="${r'${canal.instance.detecting.enable:false}'}" />
		<property name="detectingSQL" value="${r'${canal.instance.detecting.sql}'}" />
		<property name="detectingIntervalInSeconds" value="${r'${canal.instance.detecting.interval.time:5}'}" />
		<property name="haController">
			<bean class="com.alibaba.otter.canal.parse.ha.HeartBeatHAController">
				<property name="detectingRetryTimes" value="${r'${canal.instance.detecting.retry.threshold:3}'}" />
				<property name="switchEnable" value="${r'${canal.instance.detecting.heartbeatHaEnable:false}'}" />
			</bean>
		</property>

		<property name="alarmHandler" ref="alarmHandler" />

		<!-- 解析过滤处理 -->
		<property name="eventFilter">
			<bean class="com.alibaba.otter.canal.filter.aviater.AviaterRegexFilter" >
				<constructor-arg index="0" value="${r'${canal.instance.filter.regex:.*\..*}'}" />
			</bean>
		</property>

		<property name="eventBlackFilter">
			<bean class="com.alibaba.otter.canal.filter.aviater.AviaterRegexFilter" >
				<constructor-arg index="0" value="${r'${canal.instance.filter.black.regex:}'}" />
				<constructor-arg index="1" value="false" />
			</bean>
		</property>

		<!-- 最大事务解析大小，超过该大小后事务将被切分为多个事务投递 -->
		<property name="transactionSize" value="${r'${canal.instance.transaction.size:1024}'}" />

		<!-- 网络链接参数 -->
		<property name="receiveBufferSize" value="${r'${canal.instance.network.receiveBufferSize:16384}'}" />
		<property name="sendBufferSize" value="${r'${canal.instance.network.sendBufferSize:16384}'}" />
		<property name="defaultConnectionTimeoutInSeconds" value="${r'${canal.instance.network.soTimeout:30}'}" />

		<!-- 解析编码 -->
		<!-- property name="connectionCharsetNumber" getType="${r'${canal.instance.connectionCharsetNumber:33}'}" /-->
		<property name="connectionCharset" value="${r'${canal.instance.connectionCharset:UTF-8}'}" />

		<!-- 解析位点记录 -->
		<property name="logPositionManager">
			<bean class="com.alibaba.otter.canal.parse.index.FailbackLogPositionManager">
				<constructor-arg>
					<bean class="com.alibaba.otter.canal.parse.index.MemoryLogPositionManager" />
				</constructor-arg>
				<constructor-arg>
					<bean class="com.alibaba.otter.canal.parse.index.MetaLogPositionManager">
						<constructor-arg ref="metaManager"/>
					</bean>
				</constructor-arg>
				<!--<property name="primary">-->
				<!--<bean class="com.alibaba.otter.canal.parse.index.MemoryLogPositionManager"/>-->
				<!--</property>-->
				<!--<property name="failback">-->
				<!--<bean class="com.alibaba.otter.canal.parse.index.MetaLogPositionManager">-->
				<!--<property name="metaManager" ref="metaManager"/>-->
				<!--</bean>-->
				<!--</property>-->
				<!--<constructor-arg index="0">-->
				<!--<bean class="com.alibaba.otter.canal.parse.index.MemoryLogPositionManager" />-->
				<!--</constructor-arg>-->
				<!--<constructor-arg index="1">-->
				<!--<bean class="com.alibaba.otter.canal.parse.index.MetaLogPositionManager">-->
				<!--<constructor-arg index="0" ref="metaManager"/>-->
				<!--</bean>-->
				<!--</constructor-arg>-->
			</bean>
		</property>

		<!-- failover切换时回退的时间 -->
		<property name="fallbackIntervalInSeconds" value="${r'${canal.instance.fallbackIntervalInSeconds:60}'}" />

		<!-- 解析数据库信息 -->
		<property name="masterInfo">
			<bean class="com.alibaba.otter.canal.parse.support.AuthenticationInfo">
				<property name="address" value="${r'${canal.instance.master.address}'}" />
				<property name="username" value="${r'${canal.instance.dbUsername:retl}'}" />
				<property name="password" value="${r'${canal.instance.dbPassword:retl}'}" />
				<property name="defaultDatabaseName" value="${r'${canal.instance.defaultDatabaseName:retl}'}" />
			</bean>
		</property>
		<property name="standbyInfo">
			<bean class="com.alibaba.otter.canal.parse.support.AuthenticationInfo">
				<property name="address" value="${r'${canal.instance.standby.address}'}" />
				<property name="username" value="${r'${canal.instance.dbUsername:retl}'}" />
				<property name="password" value="${r'${canal.instance.dbPassword:retl}'}" />
				<property name="defaultDatabaseName" value="${r'${canal.instance.defaultDatabaseName:retl}'}" />
			</bean>
		</property>

		<!-- 解析起始位点 -->
		<property name="masterPosition">
			<bean class="com.alibaba.otter.canal.protocol.position.EntryPosition">
				<property name="journalName" value="${r'${canal.instance.master.journal.name}'}" />
				<property name="position" value="${r'${canal.instance.master.position}'}" />
				<property name="timestamp" value="${r'${canal.instance.master.timestamp}'}" />
			</bean>
		</property>
		<property name="standbyPosition">
			<bean class="com.alibaba.otter.canal.protocol.position.EntryPosition">
				<property name="journalName" value="${r'${canal.instance.standby.journal.name}'}" />
				<property name="position" value="${r'${canal.instance.standby.position}'}" />
				<property name="timestamp" value="${r'${canal.instance.standby.timestamp}'}" />
			</bean>
		</property>
		<property name="filterQueryDml" value="${r'${canal.instance.filter.query.dml:false}'}" />
		<property name="filterQueryDcl" value="${r'${canal.instance.filter.query.dcl:false}'}" />
		<property name="filterQueryDdl" value="${r'${canal.instance.filter.query.ddl:false}'}" />
		<property name="useDruidDdlFilter" value="${r'${canal.instance.filter.druid.ddl:true}'}" />
		<property name="filterRows" value="${r'${canal.instance.filter.rows:false}'}" />
		<property name="filterTableError" value="${r'${canal.instance.filter.table.error:false}'}" />
		<property name="supportBinlogFormats" value="${r'${canal.instance.binlog.format}'}" />
		<property name="supportBinlogImages" value="${r'${canal.instance.binlog.image}'}" />

		<!--表结构相关-->
		<property name="enableTsdb" value="${r'${canal.instance.tsdb.enable:true}'}"/>
		<property name="tsdbSpringXml" value="${r'${canal.instance.tsdb.spring.xml:}'}"/>
	</bean>
</beans>
