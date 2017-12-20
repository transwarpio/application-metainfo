

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
connect.timeout=${service['workflow.connect.timeout']}

# socket timeout in milliseconds
socket.timeout=${service['workflow.socket.timeout']}

# client username
client.username=${service['workflow.client.username']}

# client password
client.password=${service['workflow.client.password']}
