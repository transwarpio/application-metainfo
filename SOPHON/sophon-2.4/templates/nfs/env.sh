# Export dfs.datanode.data.dir
export SOPHON_NFS_IP=${localhostname}
<#if service[.data_model["localhostname"]]?? && service[.data_model["localhostname"]]['nfs.share.name.dir']??>
export SHARE_DIR=${service[.data_model["localhostname"]]['nfs.share.name.dir']}
</#if>
export API_SERVER=https://${dependencies.TOS.roles.TOS_MASTER[0]['hostname']}:6443