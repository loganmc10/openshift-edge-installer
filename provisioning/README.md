# Purpose
This playbook configures the Multicluster Engine on a Provisioning Cluster.
# Usage
## Without mirror registry or provisioning network customizations
```
export KUBECONFIG=~/path/to/kubeconfig
ansible-playbook provisioning-playbook.yaml
```
Alternatively, using a container:
```
podman run --pull always -it --rm -v </path/to/kubeconfig>:/kubeconfig:Z quay.io/loganmc10/openshift-edge-installer:latest provisioning
```
## With mirror registry or provisioning network customizations
The mirror registry should be populated using the [oc mirror](https://docs.openshift.com/container-platform/latest/installing/disconnected_install/installing-mirroring-disconnected.html) plugin.

---

An example provisioning config file is provided in ```provisioning-config-example.yaml```
```
export KUBECONFIG=~/path/to/kubeconfig
ansible-playbook provisioning-playbook.yaml --extra-vars "@provisioning-config.yaml"
```
Alternatively, using a container:
```
podman run --pull always -it --rm -v </path/to/kubeconfig>:/kubeconfig:Z \
  -v </path/to/provisioning-config.yaml>:/provisioning-config.yaml:Z \
  quay.io/loganmc10/openshift-edge-installer:latest provisioning
```
# Ansible Playbook Workflow
* Set ODF as the default StorageClass if ODF is installed and there isn't already one set.
* If there is no default StorageClass, and no ODF, install ODF.
* Configure the cluster to trust the mirror registry SSL cert if required.
* Configure the Baremetal Operator to provision external clusters.
* Install and configure the Multicluster Engine Operator.
* Configure CIM (Assisted Service).
