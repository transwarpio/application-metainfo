service.scheme=http
<#assign workflowHostPorts = []/>
<#list dependencies.WORKFLOW.roles['WORKFLOW_SERVER'] as role>
<#assign workflowHostPorts = workflowHostPorts + [role.hostname + ':' + dependencies.WORKFLOW['workflow.http.port']]>
</#list>
<#assign workflowHostPort = workflowHostPorts?join(",")>

# the workflow service location
workflow.service.scheme=http
workflow.service.host=${workflowHostPort}
workflow.service.path=/api/v1/

# the path of login module
workflow.service.login=login

# connect timeout in milliseconds
workflow.connect.timeout=5000000

# socket timeout in milliseconds
workflow.socket.timeout=5000000

# client username
#client.username=anonymous
workflow.client.username=${service['workflow.client.username']}

# client password
#client.password=anonymous
workflow.client.password=${service['workflow.client.password']}