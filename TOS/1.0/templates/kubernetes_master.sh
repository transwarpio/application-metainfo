<#assign tosMaster=service.roles['TOS_MASTER'][0].hostname>
export KUBERNETES_MASTER="http://${tosMaster}:${service['tos.master.apiserver.port']}"