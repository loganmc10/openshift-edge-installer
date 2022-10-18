# Purpose
This playbook configures the Multicluster Engine on a Provisioning Cluster.
# Usage
## Without mirror registry
```
export KUBECONFIG=~/path/to/kubeconfig
ansible-playbook provisioning-playbook.yaml
```
## With mirror registry
An example mirror registry config file is provided in ```mirror-config-example.yaml```
```
export KUBECONFIG=~/path/to/kubeconfig
ansible-playbook provisioning-playbook.yaml --extra-vars "@mirror-config.yaml"
```
# Ansible Playbook Workflow
* Set ODF as the default StorageClass if ODF is installed and there isn't already one set.
* If there is no default StorageClass, and no ODF, install ODF.
* Configure the Baremetal Operator to provision external clusters.
* Install and configure the Multicluster Engine Operator.
* Configure the Assisted Service.
