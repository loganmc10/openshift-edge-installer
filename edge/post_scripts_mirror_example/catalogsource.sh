#!/usr/bin/env bash

cat << EOF | oc apply -f -
apiVersion: config.openshift.io/v1
kind: OperatorHub
metadata:
  name: cluster
spec:
  disableAllDefaultSources: true
EOF

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
