# DU Profile support
Grab the static configs from https://github.com/openshift-kni/cnf-features-deploy/tree/master/ztp/source-crs/extra-manifest (depending on the release branch).

Also need to enable workload partitioning for SNO, for this, they'd need to specify the CPUSet in the install-config
# Other DU Policies
https://github.com/openshift-kni/cnf-features-deploy/tree/master/ztp/gitops-subscriptions/argocd/example/policygentemplates

Of note:
* ReduceMonitoringFootprint.yaml
* PerformanceProfile.yaml
* TunedPerformancePatch.yaml
* ConsoleOperatorDisable.yaml
* DisableSnoNetworkDiag.yaml
# ZTPFW features
In general I think this comes down to 2 things: Make sure the cluster can survive DHCP address changes, and make sure the cluster can survive being offline for a period of time (certificate expiration).

For a multinode cluster this is more complicated, and requires a script that configures MetalLB to listen on the DHCP address, then forward traffic to the internal API/Ingress addresses. I'm not currently sure what happens to an SNO server when its DHCP address changes.
* https://github.com/rh-ecosystem-edge/ztp-pipeline-relocatable/blob/main/deploy-edgecluster/change_def_route.sh
* https://github.com/rh-ecosystem-edge/ztp-pipeline-relocatable/blob/main/deploy-edgecluster/csr_autoapprover.sh
* https://github.com/rh-ecosystem-edge/ztp-pipeline-relocatable/blob/main/deploy-edgecluster/render_edgeclusters.sh
