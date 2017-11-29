export SERVICE_TYPE=StreamSQL

export NGMR_ENGINE_MODE=${service['ngmr.engine.mode']}
<#if service['ngmr.engine.mode'] == 'morphling'>

export NGMR_NETWORK_SNDRCV_BUFFER=${service['ngmr.network.sndrcv.buffer']}
export NGMR_NETWORK_SERVER_NUM_THREADS=${service['ngmr.network.server.num.threads']}
export NGMR_NETWORK_CLIENT_NUM_THREADS=${service['ngmr.network.client.num.threads']}
export NGMR_NETWORK_NUM_BUFFERS=${service['ngmr.network.num.buffers']}
export NGMR_NETWORK_SERVER_BACKLOG=${service['ngmr.network.server.backlog']}
export NGMR_NETWORK_CLIENT_TIMEOUT=${service['ngmr.network.client.timeout']}
export NGMR_MEMSEGMENT_SIZE=${service['ngmr.memsegment.size']}
export NGMR_IO_MODE=${service['ngmr.io.mode']}
export NGMR_IO_DIRECTBUFS=${service['ngmr.io.directbufs']}
export NGMR_IO_NUM_CONNECTION_PERPEER=${service['ngmr.io.num.connection.perpeer']}

export MORPHLING_JOB_RECOVERY_MODE=${service['spark.morphling.recovery.mode']}
export MORPHLING_TASKSTATE_BECKEND_KEY=${service['spark.morphling.taskstate.backend']}
export MORPHLING_TASKSTATE_CHECKPOINT_DIRECTORY_KEY=${service['spark.morphling.taskstate.checkpoint.directory']}

<#assign zookeeper=dependencies.ZOOKEEPER quorum=[]>
<#list zookeeper.roles.ZOOKEEPER as role>
    <#assign quorum += [role.hostname]>
</#list>
export MORPHLING_ZOOKEEPER_QUORUM_KEY=${quorum?join(",")}

export MORPHLING_ZOOKEEPER_SESSION_TIMEOUT=${service['spark.morphling.zookeeper.session.timeout']}
export MORPHLING_ZOOKEEPER_CONNECTION_TIMEOUT=${service['spark.morphling.zookeeper.connect.timeout']}
export MORPHLING_ZOOKEEPER_MAX_RETRY_TIMES=${service['spark.morphling.zookeeper.max.retries']}
export MORPHLING_ZOOKEEPER_RETRY_WAIT=${service['spark.morphling.zookeeper.retry.wait']}

export MORPHLING_ZOOKEEPER_ROOT_PATH=${service['spark.morphling.zookeeper.root.path']}
export MORPHLING_ZOOKEEPER_NAMESPACE=${service['spark.morphling.zookeeper.namespace']}
export MORPHLING_ZOOKEEPER_CHECKPOINTS_PATH=${service['spark.morphling.zookeeper.checkpoints.path']}
export MORPHLING_SUBMITTED_JOB_PATH=${service['spark.morphling.submitted.job.path']}

export MORPHLING_COMPLETED_CHECKPOINTS_STORAGE_DIR=${service['spark.morphling.completed.checkpoints.storage.dir']}

</#if>
