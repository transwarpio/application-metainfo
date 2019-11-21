#!/usr/bin/env bash

export KUBE_STATE_METRICS_OPTS="--port=${service['kube.state.metrics.web.port']} \
                           --telemetry-port=${service['kube.state.metrics.telemetry.port']} \
                           --kubeconfig=/etc/${service.sid}/conf/kube-state-metrics/kubernetes/kubeconfig \
                           --collectors=configmaps \
                           --collectors=cronjobs \
                           --collectors=daemonsets \
                           --collectors=deployments \
                           --collectors=endpoints \
                           --collectors=horizontalpodautoscalers \
                           --collectors=jobs \
                           --collectors=limitranges \
                           --collectors=namespaces \
                           --collectors=nodes \
                           --collectors=persistentvolumeclaims \
                           --collectors=persistentvolumes \
                           --collectors=poddisruptionbudgets \
                           --collectors=pods \
                           --collectors=replicasets \
                           --collectors=replicationcontrollers \
                           --collectors=resourcequotas \
                           --collectors=secrets \
                           --collectors=services \
                           --collectors=statefulsets"