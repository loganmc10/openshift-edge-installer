# Relocatable Edge Cluster
When the ```relocatable``` option is enabled, the cluster is configured in such a way that its primary interface IP addresses can be changed without impacting the operation of the cluster.

## How it works
You set the value of ```relocatable``` to the name of the external facing interface. A secondary IP address (192.168.7.x/24 or fd04::x/64) is assigned to this interface. The machineNetwork CIDR is also set to 192.168.7.0/24 or fd04::/64. Finally, a MachineConfig is created that modifies /etc/default/nodeip-configuration to tell the cluster to use 192.168.7.x/fd04::x as the node IP.

All of these actions together cause the server to use 192.168.7.x/fd04::x for everything related to OpenShift, while still allowing access to the cluster from outside via the primary interface IP address. This means that the external IP can be changed, and the cluster will continue to use 192.168.7.x/fd04::x internally for its operation.

### Multi-node clusters
On a multi-node cluster, an API and Ingress VIP are also created in the 192.168.7.x/fd04::x network. These are not accessible from outside the cluster. Therefore, MetalLB is used to expose the API and Ingress using the external IPs specified in the install config. These can be changed later on by updating the IPAddressPools on the cluster:
```
oc get IPAddressPool -n metallb-system -o yaml
items:
- apiVersion: metallb.io/v1beta1
  kind: IPAddressPool
  metadata:
    name: api-address-pool
    namespace: metallb-system
  spec:
    addresses:
    - <API_VIP>/32
    autoAssign: false
- apiVersion: metallb.io/v1beta1
  kind: IPAddressPool
  metadata:
    name: ingress-address-pool
    namespace: metallb-system
  spec:
    addresses:
    - <INGRESS_VIP>/32
    autoAssign: false
```

## Changing the IP address
The external IP address can be changed via DHCP or statically.

To change the static IP, you would login to the node and modify the NetworkManager connection file in ```/etc/NetworkManager/system-connections``` for your interface, for instance, ```/etc/NetworkManager/system-connections/eno2.nmconnection```:
```
[connection]
id=eno2
uuid=4bef0c7c-7054-47c7-b3b6-b2d08cd7579f
type=ethernet
interface-name=eno2
autoconnect=true
autoconnect-priority=1

[ethernet]

[ipv4]
address1=10.19.10.251/26
address2=192.168.7.4/24
dhcp-client-id=mac
dns=10.19.143.247;
dns-priority=40
method=manual
route1=0.0.0.0/0,10.19.10.254
route1_options=table=254

[ipv6]
addr-gen-mode=eui64
dhcp-duid=ll
dhcp-iaid=mac
method=disabled

[proxy]
```

In the above example, you would change ```address1``` to the new IP, modify ```route1``` with the new default gateway, change ```dns``` if necessary, and then reboot the server.
