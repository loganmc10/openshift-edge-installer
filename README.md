# Overview
The purpose of this project is to ease the setup of a hub (installer) cluster, as well as ease the process of installing a spoke (edge) cluster.

After the installation of a spoke cluster is complete, the spoke does not depend on the hub cluster for anything. The hub is simply an installer. The namespace that was used to install the spoke cluster can be safely deleted from the hub cluster.

## Hub
The Ansible playbook does not handle installing the hub cluster itself, there are already many options for this (IPI, UPI, Assisted Installer, Agent-based installer). On the hub cluster, the playbook installs the [Multicluster Engine Operator](https://access.redhat.com/documentation/en-us/red_hat_advanced_cluster_management_for_kubernetes/2.6/html-single/multicluster_engine/index) and [configures it](https://github.com/openshift/assisted-service/tree/master/docs/hive-integration) to handle agent-based installs.

## Spoke
The spoke is installed by creating a slightly modified install-config.yaml file (similar to an IPI install) and passing it to the Ansible playbook. The playbook uses the values from install-config.yaml to create the necessary CRs which will allow the Multicluster Engine on the hub cluster to perform the installation.

## Notes
* Connected and disconnected/mirrored installations are both supported.
* Only baremetal installations are supported.
