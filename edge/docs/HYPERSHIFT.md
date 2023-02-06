# Deploying Hosted Control Plane Clusters
When you enable the ```hypershift``` option, the control plane for the edge cluster is hosted as pods on the provisioning cluster. Therefore, there are no control plane nodes.
## Provisioning cluster setup
The provisioning cluster must be configured with ```hypershift: true```, see the [configuration example](../../provisioning/provisioning-config-example.yaml).

Enabling the ```hypershift``` option during provisioning configuration will enable the Hypershift Operator (part of MCE). It will also install MetalLB on that cluster in order to serve the API for the hosted clusters.
## API and Ingress networking
The API for the hosted cluster is served via a Layer 2 MetalLB address on the provisioning cluster. This means that the address you choose for the hosted cluster API needs to be in the same subnet as the provisioning cluster.

The Ingress address is served via MetalLB on the hosted cluster. This means that the address you choose for the Ingress needs to be in the same subnet as the hosted cluster workers.
## Hosted cluster configuration
See the [configuration example](../install-config-hypershift-example.yaml) for a list of valid options. Not every option that is valid for standard clusters is valid for hosted clusters.

You should not define any control plane nodes, as Hypershift clusters do not require them.
