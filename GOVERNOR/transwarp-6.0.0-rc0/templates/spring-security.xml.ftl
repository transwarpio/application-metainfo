<?xml version="1.0" encoding="UTF-8"?>
<!-- Licensed to the Apache Software Foundation (ASF) under one or more contributor 
    license agreements. See the NOTICE file distributed with this work for additional 
    information regarding copyright ownership. The ASF licenses this file to 
    You under the Apache License, Version 2.0 (the "License"); you may not use 
    this file except in compliance with the License. You may obtain a copy of 
    the License at http://www.apache.org/licenses/LICENSE-2.0 Unless required 
    by applicable law or agreed to in writing, software distributed under the 
    License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS 
    OF ANY KIND, either express or implied. See the License for the specific 
    language governing permissions and limitations under the License. -->

<beans:beans xmlns="http://www.springframework.org/schema/security"
             xmlns:beans="http://www.springframework.org/schema/beans"
             xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
             xmlns:security="http://www.springframework.org/schema/security"
             xmlns:util="http://www.springframework.org/schema/util"
             xmlns:oauth="http://www.springframework.org/schema/security/oauth2"
             xmlns:context="http://www.springframework.org/schema/context"
             xsi:schemaLocation="http://www.springframework.org/schema/beans
    http://www.springframework.org/schema/beans/spring-beans-3.1.xsd
    http://www.springframework.org/schema/security
    http://www.springframework.org/schema/security/spring-security-3.1.xsd
    http://www.springframework.org/schema/util
    http://www.springframework.org/schema/util/spring-util-3.1.xsd
    http://www.springframework.org/schema/security/oauth2
    http://www.springframework.org/schema/security/spring-security-oauth2-1.0.xsd
    http://www.springframework.org/schema/context 
    http://www.springframework.org/schema/context/spring-context-3.1.xsd">

<#assign isToken="false">
<#assign isCas="false">
<#assign entryPointRef="entryPoint">
<#assign formLoginFilter="atlasFormLoginFilter">

<#if service.auth = "kerberos">
    <#assign isToken="true">
    <#if dependencies.GUARDIAN['cas.server.ssl.port']??>
        <#assign casServerSslPort=dependencies.GUARDIAN['cas.server.ssl.port']>
        <#if dependencies.GUARDIAN['guardian.server.cas.server.host']?matches("^\\s*$")>
            <#assign casServerName="https://${dependencies.GUARDIAN.roles.CAS_SERVER[0]['ip']}:${casServerSslPort}">
        <#else>
            <#assign casServerName="https://${dependencies.GUARDIAN['guardian.server.cas.server.host']}:${casServerSslPort}">
        </#if>
        <#assign isCas="true">
        <#assign entryPointRef="casEntryPoint">
        <#assign formLoginFilter="atlasCasAuthenticationFilter">
    </#if>
</#if>

<#if isCas == "false">
    <security:http pattern="/" security="none" />
    <security:http pattern="/assets/**" security="none" />
    <security:http pattern="/app/**" security="none" />
    <security:http pattern="/resources/i18n/**" security="none" />
    <security:http pattern="/login.jsp" security="none" />
    <security:http pattern="/css/**" security="none" />
    <security:http pattern="/lib/**" security="none" />
</#if>

    <security:http pattern="/governor/api/v1/admin/status" security="none" />

    <security:http disable-url-rewriting="true"
                   auto-config="false"
                   use-expressions="true" create-session="always"
                   entry-point-ref="${entryPointRef}">
        <security:session-management
                session-fixation-protection="newSession" />
        <intercept-url pattern="/governor/api/v1/repositories" method="POST" access="permitAll()" />
        <intercept-url pattern="/**" access="isAuthenticated()" />

        <#if isCas == "false">
        <security:logout success-handler-ref="logoutSuccessHandler" delete-cookies="GOVERNORSESSIONID"
                         logout-url="/governor/api/v1/logout" />
        </#if>
        <http-basic />

        <#if isToken == "true">
        <security:custom-filter ref="accessTokenFilter" after="LOGOUT_FILTER" />
        </#if>

        <security:custom-filter ref="preflightFilter" before="FORM_LOGIN_FILTER" />
        <security:custom-filter ref="${formLoginFilter}" position="FORM_LOGIN_FILTER" />

        <#if isCas == "true">
        <security:custom-filter ref="logoutFilter" before="LOGOUT_FILTER" />
        <security:custom-filter ref="singleSignOutFilter" position="LOGOUT_FILTER" />
        </#if>
    </security:http>

    <beans:bean id="preflightFilter" class="org.apache.atlas.web.filters.PreflightFilter" />

    <beans:bean id="accessTokenFilter" class="org.apache.atlas.web.filters.AccessTokenAuthFilter"/>

    <security:global-method-security
                pre-post-annotations="enabled" />

    <context:component-scan base-package="org.apache.atlas.web" />

<#if isCas == "false">
    <beans:bean id="successHandler" class="org.apache.atlas.web.security.AtlasAuthenticationSuccessHandler"/>
    <beans:bean id="failureHandler" class="org.apache.atlas.web.security.AtlasAuthenticationFailureHandler"/>

    <beans:bean id="logoutSuccessHandler" class="org.apache.atlas.web.security.AtlasLogoutSuccessHandler" />

    <beans:bean id="formAuthenticationEntryPoint"
                class="org.apache.atlas.web.filters.AtlasAuthenticationEntryPoint">
        <beans:property name="loginFormUrl" value="/login.jsp" />
    </beans:bean>

    <beans:bean id="authenticationEntryPoint"
                class="org.springframework.security.web.authentication.www.BasicAuthenticationEntryPoint">
        <beans:property name="realmName" value="atlas.com" />
    </beans:bean>

    <beans:bean id="entryPoint" class="org.springframework.security.web.authentication.DelegatingAuthenticationEntryPoint">
        <beans:constructor-arg>
            <beans:map>
                <beans:entry key="hasHeader('User-Agent','Mozilla')" value-ref="formAuthenticationEntryPoint" />
            </beans:map>
        </beans:constructor-arg>
        <beans:property name="defaultEntryPoint" ref="authenticationEntryPoint"/>
    </beans:bean>


    <beans:bean id="atlasAuthenticationProvider"
                class="org.apache.atlas.web.security.AtlasAuthenticationProvider">
    </beans:bean>

    <security:authentication-manager
            alias="authenticationManager">
        <security:authentication-provider
                ref="atlasAuthenticationProvider" />
    </security:authentication-manager>
    
    <beans:bean id="atlasFormLoginFilter"
                class="org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter">
        <beans:property name="filterProcessesUrl" value="/governor/api/v1/login"/>
        <beans:property name="authenticationManager" ref="authenticationManager" />
        <beans:property name="authenticationSuccessHandler" ref="successHandler" />
        <beans:property name="authenticationFailureHandler" ref="failureHandler" />
        <beans:property name="usernameParameter" value="username"/>
        <beans:property name="passwordParameter" value="password"/>
    </beans:bean>
</#if>

<#if isCas == "true">
    <beans:bean id="serviceProperties" class="org.springframework.security.cas.ServiceProperties">
        <beans:property name="service" value="/governor/api/v1/login"/>
        <beans:property name="sendRenew" value="false"/>
        <beans:property name="authenticateAllArtifacts" value="true"/>
    </beans:bean>

    <beans:bean id="authenticationDetailsSource"
                class="io.transwarp.guardian.plugins.spring.cas.RelativeSupportAuthDetailsSource" >
        <beans:constructor-arg name="serviceProperties" ref="serviceProperties" />
    </beans:bean>

    <beans:bean id="casEntryPoint" class="io.transwarp.guardian.plugins.spring.cas.CasAuthRelativeSupportEntryPoint">
        <beans:property name="loginUrl" value="${casServerName}/cas/login" />
        <beans:property name="serviceProperties" ref="serviceProperties" />
    </beans:bean>

    <beans:bean id="proxyGrantingTicketStorage" class="org.jasig.cas.client.proxy.ProxyGrantingTicketStorageImpl"/>

    <beans:bean id="authenticationUserDetailsService"
                class="org.springframework.security.cas.userdetails.GrantedAuthorityFromAssertionAttributesUserDetailsService">
        <beans:constructor-arg name="attributes">
            <beans:array>
                <beans:value>roles</beans:value>
            </beans:array>
        </beans:constructor-arg>
    </beans:bean>

    <beans:bean id="cas30ProxyTicketValidator" class="org.jasig.cas.client.validation.Cas30ProxyTicketValidator">
        <beans:constructor-arg name="casServerUrlPrefix" value="${casServerName}/cas" />
        <beans:property name="proxyCallbackUrl" value="/proxyreceptor" />
        <beans:property name="proxyGrantingTicketStorage" ref="proxyGrantingTicketStorage" />
        <beans:property name="acceptAnyProxy" value="true" />
    </beans:bean>

    <beans:bean id="casAuthenticationProvider"
                class="org.springframework.security.cas.authentication.CasAuthenticationProvider">
        <beans:property name="authenticationUserDetailsService" ref="authenticationUserDetailsService" />
        <beans:property name="ticketValidator" ref="cas30ProxyTicketValidator" />
        <beans:property name="serviceProperties" ref="serviceProperties"/>
        <beans:property name="key" value="an_id_for_this_auth_provider_only" />
    </beans:bean>

    <security:authentication-manager
            alias="casAuthenticationManager">
        <security:authentication-provider
                ref="casAuthenticationProvider" />
    </security:authentication-manager>


    <beans:bean id="atlasCasAuthenticationFilter" class="org.springframework.security.cas.web.CasAuthenticationFilter">
        <beans:property name="filterProcessesUrl" value="/governor/api/v1/login"/>
        <beans:property name="serviceProperties" ref="serviceProperties"/>
        <beans:property name="authenticationDetailsSource" ref="authenticationDetailsSource"/>
        <beans:property name="authenticationManager" ref="casAuthenticationManager" />
        <beans:property name="proxyGrantingTicketStorage" ref="proxyGrantingTicketStorage" />
        <beans:property name="proxyReceptorUrl" value="/proxyreceptor" />
    </beans:bean>

    <beans:bean id="singleSignOutFilter" class="org.jasig.cas.client.session.SingleSignOutFilter">
        <beans:property name="ignoreInitConfiguration" value="true" />
        <beans:property name="casServerUrlPrefix" value="${casServerName}/cas" />
    </beans:bean>

    <beans:bean id="logoutHandler"
                class="org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler" />

    <beans:bean id="logoutFilter" class="org.springframework.security.web.authentication.logout.LogoutFilter">
        <beans:constructor-arg name="logoutSuccessUrl"
                               value="${casServerName}/cas/logout?service=http://${localhostname}:${service['governor.http.port']}" />
        <beans:constructor-arg name="handlers">
            <beans:array>
                <beans:ref bean="logoutHandler" />
            </beans:array>
        </beans:constructor-arg>
        <beans:property name="filterProcessesUrl" value="/governor/api/v1/logout" />
    </beans:bean>

</#if>


</beans:beans>
