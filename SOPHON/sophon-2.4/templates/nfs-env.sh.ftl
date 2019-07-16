export SOPHON_NFS_IP=${service.roles.SOPHON_NFS[0].hostname}
export SHARE_DIR=${service[service.roles.SOPHON_NFS[0].hostname]["nfs.share.name.dir"]}
export API_SERVER=https://${dependencies.TOS.roles.TOS_MASTER[0]['hostname']}:6443
