## Overview
The purpose of this project is to ease the setup of a provisioning cluster, as well as ease the process of installing an edge cluster.

Standard Install:
* After the installation of an edge cluster is complete, the edge cluster does not depend on the provisioning cluster for anything. The provisioning cluster is simply an installer.

HyperShift Install:
* The provisioning cluster hosts the control plane for the edge cluster. The edge cluster has no control plane nodes.
## Prerequisites
* Provisioning Cluster:
  * Pre-existing OpenShift cluster (SNO, compact, or standard).
  * If there is not an existing default StorageClass, ODF will be installed. ODF requires each node to have 2 disks (one for the OS, and one for ODF).
* Edge Cluster:
  * OCP 4.11+
  * Provisioning cluster needs to be configured first.
  * Target must be a bare metal cluster (SNO, compact, or standard).
  * If ODF is being installed, each node needs to have 2 disks (one for the OS, and one for ODF).
* Local machine:
  * Install the following on your machine:
    * Ansible
    * Ansible collections: ```ansible-galaxy collection install kubernetes.core community.general ansible.utils```
    * [oc binary](https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/openshift-client-linux.tar.gz)
  * Alternatively, use the provided container. Usage instructions are included in the README for each playbook.
* Mirror:
  * Both the provisioning cluster and the edge cluster should be configured to use the same registry. If they are different (for instance, if the provisioning cluster is connected and the edge cluster is going to be disconnected) the edge cluster may not be able to pull the images required by the installer agent.

## Provisioning Cluster
The Ansible playbook does not handle installing the provisioning cluster itself, there are already many options for this ([IPI](https://docs.openshift.com/container-platform/latest/installing/installing_bare_metal_ipi/ipi-install-overview.html), [UPI](https://docs.openshift.com/container-platform/latest/installing/installing_bare_metal/installing-bare-metal.html), [Assisted Installer](https://docs.openshift.com/container-platform/latest/installing/installing_on_prem_assisted/installing-on-prem-assisted.html), [Agent-based installer](https://docs.openshift.com/container-platform/latest/installing/installing_with_agent_based_installer/preparing-to-install-with-agent-based-installer.html)). On the provisioning cluster, the playbook installs the [Multicluster Engine Operator](https://access.redhat.com/documentation/en-us/red_hat_advanced_cluster_management_for_kubernetes/2.6/html-single/multicluster_engine/index) and [configures it](https://github.com/openshift/assisted-service/tree/master/docs/hive-integration) to handle agent-based installs.

## Edge Cluster
The edge cluster is installed by creating a slightly modified [install-config.yaml](https://docs.openshift.com/container-platform/latest/installing/installing_bare_metal_ipi/ipi-install-installation-workflow.html#additional-resources_config) file (similar to an IPI install) and passing it to the Ansible playbook. The playbook uses the values from install-config.yaml to create the necessary CRs which will allow the Multicluster Engine on the provisioning cluster to perform the installation.

## Notes
* Connected and disconnected/mirrored installations are both supported.
  * If you are using a mirror registry, it should be populated using the [oc mirror](https://docs.openshift.com/container-platform/latest/installing/disconnected_install/installing-mirroring-disconnected.html) plugin.
* Only bare metal installations are supported for the edge cluster. The provisioning cluster can be any platform.
