#!/usr/bin/env bash

# see https://docs.openshift.com/container-platform/latest/backup_and_restore/control_plane_backup_and_restore/disaster_recovery/scenario-3-expired-certs.html

set -o pipefail

CSR_KUBECONFIG=/var/local/csr_approver/kubeconfig
NODE_KUBECONFIG=/etc/kubernetes/static-pod-resources/kube-apiserver-certs/secrets/node-kubeconfigs/localhost.kubeconfig

# wait until API is online
until oc --request-timeout=30s --kubeconfig "${CSR_KUBECONFIG}" get csr; do
  sleep 10
done

go_template='{{range .items}}{{if not .status}}{{if or (eq .spec.signerName "kubernetes.io/kubelet-serving") (eq .spec.signerName "kubernetes.io/kube-apiserver-client-kubelet")}}{{.metadata.name}}{{"\n"}}{{end}}{{end}}{{end}}'
until oc --request-timeout=30s --kubeconfig "${NODE_KUBECONFIG}" get node; do
  oc --request-timeout=30s --kubeconfig "${CSR_KUBECONFIG}" get csr -o go-template="${go_template}" | xargs --no-run-if-empty oc --request-timeout=30s --kubeconfig "${CSR_KUBECONFIG}" adm certificate approve
  sleep 20
done
