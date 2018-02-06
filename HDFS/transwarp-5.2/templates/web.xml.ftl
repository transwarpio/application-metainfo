<?xml version="1.0" encoding="UTF-8"?>
<!--
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
-->
<web-app version="2.4" xmlns="http://java.sun.com/xml/ns/j2ee">

  <listener>
    <listener-class>org.apache.hadoop.fs.http.server.HttpFSServerWebApp</listener-class>
  </listener>

  <servlet>
    <servlet-name>webservices-driver</servlet-name>
    <servlet-class>com.sun.jersey.spi.container.servlet.ServletContainer</servlet-class>
    <init-param>
      <param-name>com.sun.jersey.config.property.packages</param-name>
      <param-value>org.apache.hadoop.fs.http.server,org.apache.hadoop.lib.wsrs</param-value>
    </init-param>

    <!-- Enables detailed Jersey request/response logging -->
    <!--
            <init-param>
                <param-name>com.sun.jersey.spi.container.ContainerRequestFilters</param-name>
                <param-value>com.sun.jersey.api.container.filter.LoggingFilter</param-value>
            </init-param>
            <init-param>
                <param-name>com.sun.jersey.spi.container.ContainerResponseFilters</param-name>
                <param-value>com.sun.jersey.api.container.filter.LoggingFilter</param-value>
            </init-param>
    -->
    <load-on-startup>1</load-on-startup>
  </servlet>

  <servlet-mapping>
    <servlet-name>webservices-driver</servlet-name>
    <url-pattern>/*</url-pattern>
  </servlet-mapping>
<#--handle AccessToken-->
<#assign guardian=dependencies.GUARDIAN guardian_servers=[]>
<#if guardian['guardian.server.tls.enabled'] = "true">
    <#assign begin="https">
<#else>
    <#assign begin="http">
</#if>
<#list guardian.roles["GUARDIAN_SERVER"] as role>
<#assign guardian_servers += [(begin + "://" + role.hostname + ":" + guardian["guardian.server.port"])]>
</#list>
<#if service.auth = "kerberos">
  <filter>
    <filter-name>AccessTokenFilter</filter-name>
    <filter-class>io.transwarp.guardian.plugins.filter.AccessTokenFilter</filter-class>
    <init-param>
      <param-name>guardianServerAddress</param-name>
      <param-value>${guardian_servers?join(";")}</param-value>
    </init-param>
  </filter>
</#if>
<#--handle CAS-->
<#if service.auth = "kerberos">
    <#if dependencies.GUARDIAN['cas.server.ssl.port']??>
        <#assign casServerSslPort=dependencies.GUARDIAN['cas.server.ssl.port']>
        <#assign casServerName="https://${dependencies.GUARDIAN.roles.CAS_SERVER[0]['hostname']}:${casServerSslPort}">
          <filter>
            <filter-name>CAS Single Sign Out Filter</filter-name>
            <filter-class>org.jasig.cas.client.session.SingleSignOutFilter</filter-class>
            <init-param>
              <param-name>casServerUrlPrefix</param-name>
              <param-value>${casServerName}/cas</param-value>
            </init-param>
          </filter>
            <listener>
              <listener-class>org.jasig.cas.client.session.SingleSignOutHttpSessionListener</listener-class>
            </listener>

            <filter>
              <filter-name>casFilter</filter-name>
              <filter-class>org.apache.hadoop.fs.http.server.HttpFSCasAuthenticationFilter</filter-class>
            </filter>

            <filter>
              <filter-name>CAS Authentication Filter</filter-name>
              <!--<filter-class>org.jasig.cas.client.authentication.Saml11AuthenticationFilter</filter-class>-->
              <filter-class>org.jasig.cas.client.authentication.AuthenticationFilter</filter-class>
              <!--<filter-class>org.apache.hadoop.security.authentication.server.AuthenticationFilter4Cas</filter-class>-->
              <init-param>
                <param-name>encodeServiceUrl</param-name>
                <param-value>false</param-value>
              </init-param>
              <init-param>
                <param-name>acceptAnyProxy</param-name>
                <param-value>true</param-value>
              </init-param>
              <init-param>
                <param-name>casServerLoginUrl</param-name>
                <param-value>${casServerName}/cas/login</param-value>
              </init-param>
              <!--<init-param>
                <param-name>serverName</param-name>
                <param-value>http://172.16.130.69:14000/</param-value>
              </init-param>-->
            </filter>

            <filter>
              <filter-name>CAS Validation Filter</filter-name>
              <!--<filter-class>org.jasig.cas.client.validation.Saml11TicketValidationFilter</filter-class>-->
              <filter-class>org.jasig.cas.client.validation.Cas30ProxyReceivingTicketValidationFilter</filter-class>
              <!--<filter-class>org.apache.hadoop.security.authentication.server.Cas30ProxyReceivingTicketValidationFilter4Cas</filter-class>-->
              <init-param>
                <param-name>encodeServiceUrl</param-name>
                <param-value>false</param-value>
              </init-param>
              <init-param>
                <param-name>acceptAnyProxy</param-name>
                <param-value>true</param-value>
              </init-param>
              <init-param>
                <param-name>casServerUrlPrefix</param-name>
                <param-value>${casServerName}/cas</param-value>
              </init-param>
              <!--<init-param>
                <param-name>serverName</param-name>
                <param-value>http://172.16.130.69:14000/</param-value>
              </init-param>-->
              <init-param>
                <param-name>redirectAfterValidation</param-name>
                <param-value>true</param-value>
              </init-param>
              <init-param>
                <param-name>useSession</param-name>
                <param-value>true</param-value>
              </init-param>
              <init-param>
                <param-name>authn_method</param-name>
                <param-value>mfa-duo</param-value>
              </init-param>
            </filter>

            <filter>
              <filter-name>CAS HttpServletRequest Wrapper Filter</filter-name>
              <filter-class>org.jasig.cas.client.util.HttpServletRequestWrapperFilter</filter-class>
              <!--<filter-class>org.apache.hadoop.security.authentication.server.HttpServletRequestWrapperFilter4Cas</filter-class>-->
            </filter>
    </#if>
</#if>
  <filter>
    <filter-name>authFilter</filter-name>
    <filter-class>org.apache.hadoop.fs.http.server.HttpFSAuthenticationFilter</filter-class>
  </filter>
<#--handle AccessToken-->
<#if service.auth = "kerberos">
  <filter>
    <filter-name>HttpFsATFilter</filter-name>
    <filter-class>org.apache.hadoop.fs.http.server.HttpFSAccessTokenFilter</filter-class>
  </filter>
</#if>
  <filter>
    <filter-name>MDCFilter</filter-name>
    <filter-class>org.apache.hadoop.lib.servlet.MDCFilter</filter-class>
  </filter>

  <filter>
    <filter-name>hostnameFilter</filter-name>
    <filter-class>org.apache.hadoop.lib.servlet.HostnameFilter</filter-class>
  </filter>

  <filter>
    <filter-name>checkUploadContentType</filter-name>
    <filter-class>org.apache.hadoop.fs.http.server.CheckUploadContentTypeFilter</filter-class>
  </filter>

  <filter>
    <filter-name>fsReleaseFilter</filter-name>
    <filter-class>org.apache.hadoop.fs.http.server.HttpFSReleaseFilter</filter-class>
  </filter>
<#--handle AccessToken-->
<#if service.auth = "kerberos">
  <filter-mapping>
    <filter-name>AccessTokenFilter</filter-name>
    <url-pattern>*</url-pattern>
  </filter-mapping>
</#if>
<#--handle CAS-->
<#if service.auth = "kerberos">
    <#if dependencies.GUARDIAN['cas.server.ssl.port']??>
          <filter-mapping>
            <filter-name>CAS Single Sign Out Filter</filter-name>
            <url-pattern>*</url-pattern>
          </filter-mapping>

          <filter-mapping>
            <filter-name>casFilter</filter-name>
            <url-pattern>*</url-pattern>
          </filter-mapping>

          <filter-mapping>
            <filter-name>CAS Authentication Filter</filter-name>
            <url-pattern>*</url-pattern>
          </filter-mapping>

          <filter-mapping>
            <filter-name>CAS Validation Filter</filter-name>
            <url-pattern>*</url-pattern>
          </filter-mapping>

          <filter-mapping>
            <filter-name>CAS HttpServletRequest Wrapper Filter</filter-name>
            <url-pattern>*</url-pattern>
          </filter-mapping>
    </#if>
</#if>
  <filter-mapping>
    <filter-name>authFilter</filter-name>
    <url-pattern>*</url-pattern>
  </filter-mapping>
<#--handle AccessToken-->
<#if service.auth = "kerberos">
  <filter-mapping>
    <filter-name>HttpFsATFilter</filter-name>
    <url-pattern>*</url-pattern>
    <dispatcher>FORWARD</dispatcher>
  </filter-mapping>
</#if>
  <filter-mapping>
    <filter-name>MDCFilter</filter-name>
    <url-pattern>*</url-pattern>
    <dispatcher>FORWARD</dispatcher>
    <dispatcher>REQUEST</dispatcher>
  </filter-mapping>

  <filter-mapping>
    <filter-name>hostnameFilter</filter-name>
    <url-pattern>*</url-pattern>
    <dispatcher>FORWARD</dispatcher>
    <dispatcher>REQUEST</dispatcher>
  </filter-mapping>

  <filter-mapping>
    <filter-name>checkUploadContentType</filter-name>
    <url-pattern>*</url-pattern>
    <dispatcher>FORWARD</dispatcher>
    <dispatcher>REQUEST</dispatcher>
  </filter-mapping>

  <filter-mapping>
    <filter-name>fsReleaseFilter</filter-name>
    <url-pattern>*</url-pattern>
    <dispatcher>FORWARD</dispatcher>
    <dispatcher>REQUEST</dispatcher>
  </filter-mapping>

</web-app>
