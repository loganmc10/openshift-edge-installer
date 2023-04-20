#!/usr/bin/env bash

set -o pipefail

mirror_hostname="<mirror_hostname>"
oc_version=$(oc get clusterversion version -o jsonpath='{.status.desired.version}' | awk -F. '{print $1"."$2}')

oc patch OperatorHub cluster --type json -p '[{"op": "add", "path": "/spec/disableAllDefaultSources", "value": true}]'

until [[ $(oc get operatorhub cluster -o jsonpath='{.status.sources[?(@.name=="redhat-operators")].disabled}') == "true" ]]
do
  sleep 2
done

cat << EOF | oc apply -f -
apiVersion: operators.coreos.com/v1alpha1
kind: CatalogSource
metadata:
  name: redhat-operators
  namespace: openshift-marketplace
spec:
  image: ${mirror_hostname}:8443/redhat/redhat-operator-index:v${oc_version}
  sourceType: grpc
EOF
