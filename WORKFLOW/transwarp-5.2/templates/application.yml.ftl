# the general settings for workflow application
app:
  # the application name
  name: ${service.sid}
  # indicates whether workflow works under access control
  access-control: ${(service.auth = "kerberos")?c}

workflow.address: ${localhostname}:${service['workflow.http.port']}

<#if service.auth = "kerberos" && dependencies.GUARDIAN['cas.server.ssl.port']??>
<#assign casServerSslPort=dependencies.GUARDIAN['cas.server.ssl.port']>
<#assign casServerName="https://${dependencies.GUARDIAN.roles.CAS_SERVER[0]['hostname']}:${casServerSslPort}">
<#assign casServerContextPath="${dependencies.GUARDIAN['cas.server.context.path']}">
<#assign casServerPrefix="${casServerName}/${casServerContextPath}">
cas:
  enable: true
  server:
    prefix: ${casServerPrefix}
    login: "/login"
    logout: "/logout"
<#else>
cas:
  enable: false
</#if>

# the general control of enabling/disabling transporter-client
<#if dependencies.TRANSPORTER?? && dependencies.TRANSPORTER.roles.TDT_SERVER?size gt 0>
transporter.enabled: true

<#--handle dependent.transporter-->
<#assign transporter=dependencies.TRANSPORTER address=[]>
<#list transporter.roles.TDT_SERVER as role>
    <#assign address += [role.hostname + ":" + transporter["tdt.server.port"]]>
</#list>
<#assign address = address?join(",")>

# the host of transporter
transporter.address: ${address}

<#else>
transporter.enabled: false
</#if>

job:
  # the job plugin directory
      # if starts with slash, treat as absolute path;
      # otherwise relative to the root directory of workflow application
  dir-prefix: job

# schedule settings
schedule:
  execute:
    # size of thread pool to execute tasks
    pool-size: ${service['workflow.execute.pool.size']}
  verify:
    # indicates how long a task-miss verification will happen in milliseconds
    interval-millis: ${service['workflow.verify.interval.millis']}
    # size of thread pool of verification task
    pool-size: 2
  parallelism:
    # the max number of running jobs at same time
    global-max-running: ${service['workflow.global.max.running']}
    # the max number of running jobs at recovery stage
    recover-max-running: ${service['workflow.recover.max.running']}
    # the max number of running sub-tasks in one workflow
    task-in-wf-max-running: ${service['workflow.in.wf.max.running']}
    # the max number of running tasks per plugin type,
    # each plugin can override this option to put proper concurrency limit
    plugin-max-running: ${service['workflow.plugin.max.running']}
    # if one job fails and is set to retry, if current running job number of
    # this plugin is more than value of this setting, the retry will be
    # delayed
    plugin-retry-max-running: ${service['workflow.plugin.retry.max.running']}
    # delay of a job if max running number is met, in milliseconds
    delay-millis: ${service['workflow.max.running.delay.millis']}
  clean:
    #indicates how long data cleaning will happen in days
    interval-days: ${service['workflow.clean.interval.days']}
    # size of thread pool of cleaning task
    pool-size: 2
  recovery:
    # when server is initialized or failover, it reload all schedules from
    # persistence layer, this parameter controls the coverage of the recovery
    # by default is 24 hours, means the latest 24h schedules until now will
    # be checked and any uncompleted workflows/tasks will be cancelled and
    # restarted.
    seconds: ${service['workflow.recovery.seconds']}

pseudo:
  username: ${service['workflow.pseudo.username']}
  password: ${service['workflow.pseudo.password']}

# shiro session timeout in seconds if exists
session.timeout.seconds: ${service['workflow.session.timeout.seconds']}

# http cookie rememberMe in days
cookie.remember-me.days: ${service['workflow.cookie.rememberme.days']}

# http cookie max-age in hours
cookie.max-age.hours: ${service['workflow.cookie.maxage.hours']}
