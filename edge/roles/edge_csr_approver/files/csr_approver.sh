#!/usr/bin/env bash

# see https://docs.openshift.com/container-platform/4.11/backup_and_restore/control_plane_backup_and_restore/disaster_recovery/scenario-3-expired-certs.html

set -e
set -o pipefail

export PATH=${PATH}:/usr/bin # make sure path includes /usr/bin
export KUBECONFIG="/var/local/csr_approver/kubeconfig"

# wait until API is online
until oc get csr; do
    sleep 10
done

oc whoami

count=30
while [[ ${count} -gt 0 ]]; do
  oc get csr -o go-template='{{range .items}}{{if not .status}}{{.metadata.name}}{{"\n"}}{{end}}{{end}}' | xargs --no-run-if-empty oc adm certificate approve
  sleep 20
  count=$((count - 1))
  echo "${count} attempts remaining"
done
echo "CSR Approver complete"
