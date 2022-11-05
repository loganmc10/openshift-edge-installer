# Purpose
This playbook installs an edge cluster. You should already have a provisioning cluster configured.
# Usage
Example install config files are provided in ```install-config-sno-example.yaml``` and ```install-config-standard-example.yaml```

The install config uses the same format as an IPI install, except that it also requires you to set clusterImageSet. The example shows how to point the clusterImageSet to a mirror registry.

If you are not using a mirror registry, the clusterImageSet would look something like this:
```
clusterImageSet: quay.io/openshift-release-dev/ocp-release:4.11.12-x86_64
```
You can also optionally set a path to extra manifests to be applied early in the installation process:
```
installManifestsFolder: install_manifests
```
As well as a path to extra manifests to be applied after the cluster installation is complete:
```
postInstallManifestsFolder: post_manifests
```
Other options are documented in ```install-config-sno-example.yaml``` and ```install-config-standard-example.yaml```

---
To run the playbook:
```
export KUBECONFIG=~/path/to/provisioning/kubeconfig
ansible-playbook edge-playbook.yaml --extra-vars "@install-config.yaml"
```
Alternatively, using a container:
```
podman run --pull always -it --rm -v </path/to/provisioning/kubeconfig>:/kubeconfig:Z \
  -v </path/to/install-config.yaml>:/install-config.yaml:Z \
  -v ${PWD}:/app/edge/kubeconfigs:Z \
  quay.io/loganmc10/openshift-edge-installer:latest edge
```
The Events URL will be printed to the console (so that you can check the progress of the install). A kubeconfig file will be written to the playbook folder with this name: ```kubeconfigs/<cluster-name>-admin-kubeconfig```
# Disconnected registry

The mirror registry should be populated using the [oc mirror](https://docs.openshift.com/container-platform/latest/installing/disconnected_install/installing-mirroring-disconnected.html) plugin.

---

If the provisioning cluster was configured to use a mirror registry, then the SSL certificate for the mirror registry will automatically be added to additionalTrustedCA on the edge cluster. ImageContentSourcePolicys for the base installation will also be added to the edge cluster, pointing to the mirror registry.

If you want to install Operators on the edge cluster from the disconnected registry, you'll need to add ImageContentSourcePolicys for those operators, as well as create a CatalogSource pointing to the mirror registry.

See the ```post_manifests_mirror_example``` folder for an example of how you can use the ```postInstallManifestsFolder``` option in the install-config to configure these during the installation process.
# Automatic installation via virtual media
Firmware requirements for booting via virtual media are documented [here](https://docs.openshift.com/container-platform/latest/installing/installing_bare_metal_ipi/ipi-install-prerequisites.html#ipi-install-firmware-requirements-for-installing-with-virtual-media_ipi-install-prerequisites)

For Dell, the BMC address format is ```idrac-virtualmedia://<out-of-band-ip>/redfish/v1/Systems/System.Embedded.1```

For HP, the BMC address format is ```redfish-virtualmedia://<out-of-band-ip>/redfish/v1/Systems/1```

---
If your server doesn't support virtual media, you'll need to specify either the redfish or ipmi address of the server:

```redfish://<out-of-band-ip>/redfish/v1/Systems/1```

```ipmi://<out-of-band-ip>```

and then boot the server manually using the Discovery ISO (the ISO URL is printed when the playbook is executed).

Even though you are manually booting the ISO, if you don't provide a redfish/ipmi address in the install-config.yaml file, then the Multicluster Engine won't automatically approve the node, and it won't apply the proper settings (hostname, role, etc) to the node.
# Reinstalling a cluster
If you re-run this playbook for an edge cluster that has already been provisioned, no changes will be made (it won't be reinstalled).

In order to reinstall the cluster, you need to delete the namespace for the edge cluster from the provisioning cluster before running the playbook, for example: ```oc delete namespace <edge_cluster_name>```.

# Ansible Playbook Workflow
* Create a ClusterImageSet so that the installer knows which version of OpenShift to install.
* Create a namespace for the install.
* Create secrets for the BMC login credentials.
* Create an image pull secret that the new cluster will use.
* Generate ConfigMaps for extra install-time manifests.
* Configure workload partitioning if required.
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
* Configure MetalLB for multi-node relocatable clusters.
* Install ODF if required.
* Apply PerformanceProfiles if required.
