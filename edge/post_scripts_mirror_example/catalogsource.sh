#!/usr/bin/env bash

oc patch OperatorHub cluster --type json -p '[{"op": "add", "path": "/spec/disableAllDefaultSources", "value": true}]'

sleep 5

cat << EOF | oc apply -f -
apiVersion: operators.coreos.com/v1alpha1
kind: CatalogSource
metadata:
  name: redhat-operators
  namespace: openshift-marketplace
spec:
  image: <mirror_hostname>:8443/redhat/redhat-operator-index:v4.12
  sourceType: grpc
EOF
