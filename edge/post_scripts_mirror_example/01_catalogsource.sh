#!/usr/bin/env bash

set -o pipefail

oc_version=$(oc get clusterversion version -o jsonpath='{.status.desired.version}' | awk -F. '{print $1"."$2}')

oc patch OperatorHub cluster --type json -p '[{"op": "add", "path": "/spec/disableAllDefaultSources", "value": true}]'

oc wait --for=delete catalogsource/community-operators -n openshift-marketplace

cat << EOF | oc apply -f -
apiVersion: operators.coreos.com/v1alpha1
kind: CatalogSource
metadata:
  name: redhat-operators
  namespace: openshift-marketplace
spec:
  image: <mirror_hostname>:8443/redhat/redhat-operator-index:v${oc_version}
  sourceType: grpc
EOF
