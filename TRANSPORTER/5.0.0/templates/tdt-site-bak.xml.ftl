<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>

<!-- Licensed to the Apache Software Foundation (ASF) under one or more       -->
<!-- contributor license agreements.  See the NOTICE file distributed with    -->
<!-- this work for additional information regarding copyright ownership.      -->
<!-- The ASF licenses this file to You under the Apache License, Version 2.0  -->
<!-- (the "License"); you may not use this file except in compliance with     -->
<!-- the License.  You may obtain a copy of the License at                    -->
<!--                                                                          -->
<!--     http://www.apache.org/licenses/LICENSE-2.0                           -->
<!--                                                                          -->
<!-- Unless required by applicable law or agreed to in writing, software      -->
<!-- distributed under the License is distributed on an "AS IS" BASIS,        -->
<!-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. -->
<!-- See the License for the specific language governing permissions and      -->
<!-- limitations under the License.                                           -->

<configuration>

    <property>
        <name>dfs.ha.namenodes.service</name>
        <value>nn1,nn2</value>
    </property>
    <!--jdbc to cluster-->
    <property>
        <name>tdt.jdbc.url</name>
        <value>jdbc：hive2://${dependencies.INCEPTOR.roles.INCEPTOR_SERVER[0]['hostname']}:=${dependencies.INCEPTOR['hive.server2.thrift.port']}/tdt</value>
    </property>
    <property>
        <name>tdt.jdbc.driver.class</name>
        <value>${service['tdt.jdbc.driver.class']}</value>
    </property>
    <property>
        <name>tdt.jdbc.user.name</name>
        <value>user</value>
    </property>
    <property>
        <name>tdt.jdbc.passord</name>
        <value>password</value>
    </property>
    <property>
        <name>tdt.jdbc.max.active</name>
        <value>100</value>
    </property>
    <property>
        <name>tdt.jdbc.initial.size</name>
        <value>10</value>
    </property>
    
    <!--tdt server common-->
    <property>
        <name>tdt.server.thrift.bind.host</name>
        <value>${service['tdt.server.thrift.bind.host']}</value>
    </property>
    <property>
        <name>tdt.server.thrift.port</name>
        <value>${service['tdt.server.thrift.port']}</value>
    </property>	

    <!--tdt server auth (LDAP,KERBEROS)-->
    <property>
        <name>tdt.server.authentication</name>
        <value>NONE</value>
    </property>

    <!--LDAP config sample-->
    <property>
        <name>tdt.server.authentication.ldap.url</name>
        <value>ldap://tw-node1212</value>
    </property>

    <property>
        <name>tdt.server.authentication.ldap.baseDN</name>
        <value>ou=People,dc=tdh</value>
    </property>

    <!--Kerberos config sample-->

    <property>
        <name>tdt.server.authentication.kerberos.keytab</name>
        <value>/etc/tdt/tdt.keytab</value>
    </property>


    <property>
        <name>hadoop.security.authentication</name>
        <value></value>
    </property>

    <property>
        <name>tdt.server.authentication.kerberos.principal</name>
<!--        <value>hive/baogang2@TDH</value> -->
        <value>tdt/baogang4@TDH</value>
    </property>

    <!-- dataflow execution log-->
    <property>
        <name>tdt.server.logging.task.log.location</name>
        <value>/var/log/${service.sid}</value>
    </property>
    <!-- rule file-->
    <property>
        <name>tdt.task.rule.file.location</name>
        <value>/etc/${service.sid}/conf/rule.json</value>
    </property>

</configuration>
