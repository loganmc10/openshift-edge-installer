# Purpose
This playbook configures the Multicluster Engine on a Provisioning Cluster.
# Usage
A video walkthrough of the playbook is available on [YouTube](https://www.youtube.com/watch?v=p56JFiupxiQ).
## Without mirror registry
```
export KUBECONFIG=~/path/to/kubeconfig
ansible-playbook provisioning-playbook.yaml
```
## With mirror registry
The mirror registry should be populated using the [oc mirror](https://docs.openshift.com/container-platform/4.11/installing/disconnected_install/installing-mirroring-disconnected.html) plugin.

---

An example mirror registry config file is provided in ```mirror-config-example.yaml```
```
export KUBECONFIG=~/path/to/kubeconfig
ansible-playbook provisioning-playbook.yaml --extra-vars "@mirror-config.yaml"
```
# Ansible Playbook Workflow
* Set ODF as the default StorageClass if ODF is installed and there isn't already one set.
* If there is no default StorageClass, and no ODF, install ODF.
* Configure the cluster to trust the mirror registry SSL cert if required.
* Configure the Baremetal Operator to provision external clusters.
* Install and configure the Multicluster Engine Operator.
* Configure CIM (Assisted Service).
