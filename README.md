## Overview
The purpose of this project is to ease the setup of a provisioning cluster, as well as ease the process of installing an edge cluster.

After the installation of an edge cluster is complete, the edge cluster does not depend on the provisioning cluster for anything. The provisioning cluster is simply an installer. The namespace that was used to install the edge cluster can be safely deleted from the provisioning cluster.

## Prerequisites
* Provisioning Cluster:
  * Pre-existing OpenShift cluster (SNO, compact, or standard).
  * If there is not an existing default StorageClass, ODF will be installed. ODF requires each node to have 2 disks (one for the OS, and one for ODF).
* Edge Cluster:
  * Baremetal cluster (SNO, compact, or standard).
  * If ODF is being installed, each node needs to have 2 disks (one for the OS, and one for ODF).
* Ansible: ```pip install ansible-core```
* Python modules: ```pip install kubernetes jmespath```
* Kubernetes Ansible collection: ```ansible-galaxy collection install -U kubernetes.core community.general```
* [oc binary](https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/openshift-client-linux.tar.gz)

## Provisioning Cluster
The Ansible playbook does not handle installing the provisioning cluster itself, there are already many options for this (IPI, UPI, Assisted Installer, Agent-based installer). On the provisioning cluster, the playbook installs the [Multicluster Engine Operator](https://access.redhat.com/documentation/en-us/red_hat_advanced_cluster_management_for_kubernetes/2.6/html-single/multicluster_engine/index) and [configures it](https://github.com/openshift/assisted-service/tree/master/docs/hive-integration) to handle agent-based installs.

## Edge Cluster
The edge cluster is installed by creating a slightly modified install-config.yaml file (similar to an IPI install) and passing it to the Ansible playbook. The playbook uses the values from install-config.yaml to create the necessary CRs which will allow the Multicluster Engine on the provisioning cluster to perform the installation.

## Notes
* Connected and disconnected/mirrored installations are both supported.
* Only baremetal installations are supported for the edge cluster. The provisioning cluster can be any platform.
