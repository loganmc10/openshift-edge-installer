# Purpose
This playbook installs an edge cluster. You should already have a provisioning cluster configured.
# Usage
Example [install config](https://docs.openshift.com/container-platform/latest/installing/installing_bare_metal/ipi/ipi-install-installation-workflow.html#additional-resources_config) files are provided in ```install-config-sno-example.yaml``` and ```install-config-standard-example.yaml```.

The install config uses the same format as an IPI install, except that it also requires you to set clusterImageSet. The example shows how to point the clusterImageSet to a mirror registry.

If you are not using a mirror registry, the clusterImageSet would look something like this:
```
clusterImageSet: quay.io/openshift-release-dev/ocp-release:4.16.0-x86_64
```
You can also optionally set a path to a folder containing extra manifests (YAML) to be applied early in the installation process:
```
installManifestsFolder: install_manifests
```
Finally, you can set a path to a folder containing scripts to be executed after the cluster installation is complete. The KUBECONFIG environment variable will already be set to communicate with the new cluster during the execution of these scripts. The scripts in this folder need to have executable permission:
```
postInstallScriptsFolder: post_scripts
```
Other options are documented in ```install-config-sno-example.yaml``` and ```install-config-standard-example.yaml```.

---
To run the playbook:
```
export KUBECONFIG=~/path/to/provisioning/kubeconfig
ansible-playbook edge-playbook.yaml -e "@install-config.yaml"
```
Alternatively, using a container:
```
podman run -it --rm -v </path/to/provisioning/kubeconfig>:/kubeconfig:Z \
  -v </path/to/install-config.yaml>:/install-config.yaml:Z \
  -v ${PWD}:/app/edge/kubeconfigs:Z \
  quay.io/loganmc10/openshift-edge-installer:<tag> edge
```
The Events URL will be printed to the console (so that you can check the progress of the installation). A kubeconfig file will be written to the playbook folder with this name: ```kubeconfigs/<cluster-name>-admin-kubeconfig```
# Disconnected registry

The mirror registry should be populated using the [oc mirror](https://docs.openshift.com/container-platform/latest/disconnected/mirroring/about-installing-oc-mirror-v2.html) plugin.

---

If the provisioning cluster was configured to use a mirror registry, then the SSL certificate for the mirror registry will automatically be added to additionalTrustedCA on the edge cluster.

If you want to install Operators on the edge cluster from the disconnected registry, you'll need to add imageDigestSources for those operators in your install-config.yaml, as well as create a CatalogSource pointing to the mirror registry.

See the ```install_manifests_mirror_example``` folder for an example of how you can use the ```installManifestsFolder``` option in the install-config to configure a CatalogSource during the installation process.
# Automatic installation via virtual media
Firmware requirements for booting via virtual media are documented [here](https://docs.openshift.com/container-platform/latest/installing/installing_bare_metal/ipi/ipi-install-prerequisites.html#ipi-install-firmware-requirements-for-installing-with-virtual-media_ipi-install-prerequisites)

For Dell, the BMC address format is ```idrac-virtualmedia://<out-of-band-ip>/redfish/v1/Systems/System.Embedded.1```

For HP, the BMC address format is ```redfish-virtualmedia://<out-of-band-ip>/redfish/v1/Systems/1```

---
If your server doesn't support virtual media, you'll need to specify either the redfish or ipmi address of the server:

```redfish://<out-of-band-ip>/redfish/v1/Systems/1```

```ipmi://<out-of-band-ip>```

and then boot the server manually using the Discovery ISO (the ISO URL can be retrieved from the InfraEnv).

Even though you are manually booting the ISO, if you don't provide a redfish/ipmi address in the install-config.yaml file, then the Multicluster Engine won't automatically approve the node, and it won't apply the proper settings (hostname, role, etc) to the node.
