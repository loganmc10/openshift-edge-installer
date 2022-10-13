# Purpose
This playbook installs a spoke cluster.
# Prerequisites
* OpenShift 4.10+ hub cluster (can be SNO).
* Ansible: ```pip install ansible-core```
* Python modules: ```pip install kubernetes jmespath```
* Kubernetes Ansible collection: ```ansible-galaxy collection install -U kubernetes.core community.general```
# Usage
An example install config file is provided in ```install-config-sno-example.yaml```

The install config uses the same format as an IPI install, except that it also requires you to set clusterImageSet. The example shows how to point the clusterImageSet to a mirror registry.

If you are not using a mirror registry, the clusterImageSet would look something like this:
```
clusterImageSet: quay.io/openshift-release-dev/ocp-release:4.11.6-x86_64
```
You can optionally set additionalNTPSources as well:
```
additionalNTPSources:
  - your.ntp.server
```
You can also optionally set a path to extra manifests to be applied early in the installation process:
```
installManifestsFolder: install_manifests
```
You can also optionally set a path to extra manifests to be applied after the cluster installation is complete:
```
postInstallManifestsFolder: post_manifests
```
See the ```post_manifests_mirror_example``` folder for an example of how to use this to configure a mirror registry CatalogSource.

---
To run the playbook:
```
export KUBECONFIG=~/path/to/hub/kubeconfig
ansible-playbook spoke-playbook.yaml --extra-vars "@install-config.yaml"
```
The Events URL will be printed to the console (so that you can check the progress of the install). A kubeconfig file will be written to the playbook folder with this name: \<cluster-name\>-admin-kubeconfig
# Automatic installation via virtual media
Firmware requirements for booting via virtual media are documented [here](https://docs.openshift.com/container-platform/4.11/installing/installing_bare_metal_ipi/ipi-install-prerequisites.html#ipi-install-firmware-requirements-for-installing-with-virtual-media_ipi-install-prerequisites)

For Dell, the BMC address format is ```idrac-virtualmedia://<out-of-band-ip>/redfish/v1/Systems/System.Embedded.1```

For HP, the BMC address format is ```redfish-virtualmedia://<out-of-band-ip>/redfish/v1/Systems/1```

---
If your server doesn't support virtual media, you'll need to specify either the redfish or ipmi address of the server:

```redfish://<out-of-band-ip>/redfish/v1/Systems/1```

```ipmi://<out-of-band-ip>```

and then boot the server manually using the Discovery ISO (the ISO URL is printed when the playbook is executed).

Even though you are manually booting the ISO, if you don't provide a redfish/ipmi address in the install-config.yaml file, then the Multicluster Engine won't automatically approve the node, and it won't apply the proper settings (hostname, role, etc) to the node.
# Ansible Playbook Workflow
* Create a ClusterImageSet so that the installer knows which version of OpenShift to install.
* Create a namespace for the install.
* Create secrets for the BMC login credentials.
* Create an image pull secret that the new cluster will use.
* Generate ConfigMaps for extra install-time manifests.
* Create an AgentClusterInstall and ClusterDeployment with the install parameters.
* Create NMStateConfigs that specify host networking configuration.
* Create InfraEnv, which will generate the discovery ISO.
* Create BareMetalHosts for each host, tied to the InfraEnv.
* Baremetal Operator will automatically mount the discovery ISO to hosts that support Virtual Media, and the installation will begin.
* Events URL printed to console.
* Discovery ISO URL (used only for hosts that don't support automatic booting via Virtual Media) printed to console.
* kubeconfig written to disk.
* Wait for cluster install to complete.
* Apply post-install manifests.
