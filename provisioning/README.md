# Purpose
This playbook configures the Multicluster Engine on a Provisioning/Management Cluster.

# Usage
## HyperShift
To enable [HyperShift](https://hypershift-docs.netlify.app/), set ```hypershift.enabled: true``` in your provisioning config. HyperShift, ArgoCD, and MetalLB will be configured.
## Without mirror registry or provisioning customizations
```
export KUBECONFIG=~/path/to/kubeconfig
ansible-playbook provisioning-playbook.yaml
```
Alternatively, using a container:
```
podman run -it --rm -v </path/to/kubeconfig>:/kubeconfig:Z quay.io/loganmc10/openshift-edge-installer:<tag> provisioning
```
## With mirror registry or provisioning customizations
The mirror registry should be populated using the [oc mirror](https://docs.openshift.com/container-platform/latest/installing/disconnected_install/installing-mirroring-disconnected.html) plugin.

---

An example provisioning config file is provided in ```provisioning-config-example.yaml```
```
export KUBECONFIG=~/path/to/kubeconfig
ansible-playbook provisioning-playbook.yaml -e "@provisioning-config.yaml"
```
Alternatively, using a container:
```
podman run -it --rm -v </path/to/kubeconfig>:/kubeconfig:Z \
  -v </path/to/provisioning-config.yaml>:/provisioning-config.yaml:Z \
  quay.io/loganmc10/openshift-edge-installer:<tag> provisioning
```
