# Purpose
This playbook configures the Multicluster Engine on a Hub Cluster.
# Prerequisites
* Pre-existing OpenShift 4.10+ cluster (can be SNO).
* Ansible: ```pip install ansible-core```
* Python modules: ```pip install kubernetes jmespath```
* Kubernetes Ansible collection: ```ansible-galaxy collection install -U kubernetes.core community.general```
* oc binary (only required if the playbook needs to configure local storage).
# Usage
## Without mirror registry
```
export KUBECONFIG=~/path/to/kubeconfig
ansible-playbook hub-playbook.yaml
```
## With mirror registry
An example mirror registry config file is provided in ```mirror-config-example.yaml```
```
export KUBECONFIG=~/path/to/kubeconfig
ansible-playbook hub-playbook.yaml --extra-vars "@mirror-config.yaml"
```
# Ansible Playbook Workflow
* Set ODF as the default StorageClass if there isn't already one set.
* If there is no default StorageClass, and no ODF, try to setup basic local storage.
* Configure the Baremetal Operator to provision external clusters.
* Install and configure the Multicluster Engine Operator.
* Configure the Assisted Service.
