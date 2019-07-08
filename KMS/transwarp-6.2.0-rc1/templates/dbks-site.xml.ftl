<?xml version="1.0" encoding="UTF-8"?>
<configuration>

  <!-- Encryption key Password -->
  
  <property>
	<name>ranger.db.encrypt.key.password</name>
    <value>${service['kms.db.encrypt.key.password']}</value>
    <description>
    	Password used for encrypting Master Key
    </description>
  </property>
  
   <!-- db Details -->
  
  <property>
    <name>ranger.db.ks.database.flavor</name>
    <value>MYSQL</value>
    <description>
      ULR for Database
    </description>
  </property>

<#assign mysqlHostPorts = []/>
<#list dependencies.TXSQL.roles['TXSQL_SERVER'] as role>
    <#assign mysqlHostPorts = mysqlHostPorts + [role.hostname + ':' + dependencies.TXSQL['mysql.rw.port']]>
</#list>
<#assign mysqlHostPort = mysqlHostPorts?join(",")>
  <property>
    <name>ranger.db.ks.javax.persistence.jdbc.url</name>
    <value>jdbc:log4jdbc:mysql://${mysqlHostPort}/kms_${service.sid}?allowMultiQueries=true&amp;autoReconnect=true</value>
    <description>
      ULR for Database
    </description>
  </property>
  
  <property>
    <name>ranger.db.ks.javax.persistence.jdbc.user</name>
    <value>${service['javax.jdo.option.ConnectionUserName']}</value>
    <description>
      Database user name used for operation
    </description>
  </property>
  
  <property>
    <name>ranger.db.ks.javax.persistence.jdbc.password</name>
    <value>${service['javax.jdo.option.ConnectionPassword']}</value>
    <description>
      Database user's password 
    </description>
  </property>
  
  <property>
    <name>ranger.db.ks.javax.persistence.jdbc.dialect</name>
    <value>org.eclipse.persistence.platform.database.MySQLPlatform</value>
    <description>
      Dialect used for database
    </description>    
  </property>
  
  <property>
    <name>ranger.db.ks.javax.persistence.jdbc.driver</name>
    <value>net.sf.log4jdbc.DriverSpy</value>
    <description>
      Driver used for database
    </description>    
  </property>
    
</configuration>
