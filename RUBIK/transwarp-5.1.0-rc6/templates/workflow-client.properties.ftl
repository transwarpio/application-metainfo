

service.scheme=http
<#assign workflowHostPorts = []/>
<#list dependencies.WORKFLOW.roles['WORKFLOW_SERVER'] as role>
<#assign workflowHostPorts = workflowHostPorts + [role.hostname + ':' + dependencies.WORKFLOW['workflow.http.port']]>
</#list>
<#assign workflowHostPort = workflowHostPorts?join(",")>

service.host=${workflowHostPort}
service.path=/api/v1/

# the path of login module
login.path=login

# connect timeout in milliseconds
connect.timeout=3000

# socket timeout in milliseconds
socket.timeout=3000

# client username
client.username=${service['workflow.client.username']}

# client password
client.password=${service['workflow.client.password']}
