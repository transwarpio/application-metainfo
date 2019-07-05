#
#    Copyright 2015-2016 the original author or authors.
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
#

#EMBEDDED SERVER CONFIGURATION (ServerProperties)
#server.address=localhost

server.port=${service['catalog.platform.http.port']}

  #session timeout in seconds
server.session-timeout=1800

server.context-path=/

  # Charset of HTTP requests and responses. Added to the "Content-Type" header if not set explicitly.
spring.http.encoding.charset=UTF-8
  # Enable http encoding support.
spring.http.encoding.enabled=true
  # Force the encoding to the configured charset on HTTP requests and responses.
spring.http.encoding.force=true

  # Enable template caching.
spring.thymeleaf.cache=false
  # Check that the templates location exists.
spring.thymeleaf.check-template-location=true
  # Content-Type value.
spring.thymeleaf.content-type=text/html
  # Enable MVC Thymeleaf view resolution.
spring.thymeleaf.enabled=true
  # Template encoding.
spring.thymeleaf.encoding=UTF-8
  # Comma-separated list of view names that should be excluded from resolution.
  #spring.thymeleaf.excluded-view-names=
  # Template mode to be applied to templates. See also StandardTemplateModeHandlers.
  #spring.thymeleaf.mode=HTML5
spring.thymeleaf.mode=LEGACYHTML5
  # Prefix that gets prepended to view names when building a URL.
spring.thymeleaf.prefix=classpath:/templates/
  # Suffix that gets appended to view names when building a URL.
spring.thymeleaf.suffix=.html
  #spring.thymeleaf.template-resolver-order=
  # Order of the template resolver in the chain.
  #spring.thymeleaf.view-names=
  # Comma-separated list of view names that can be resolved.

spring.aop.auto=true
spring.aop.expose-proxy=true
spring.aop.proxy-target-class=true

security.basic.enabled=false

catalog.web.server.address=http://${service.roles["CATALOG_WEB"][0].hostname}:${service['catalog.web.http.port']}
