## Features
* Support for disconnected mirrors.
* Zero touch (utilizing the Multicluster Engine Operator).
* Can configure ODF on provisioning and edge clusters (SNO and multi-node clusters).
* Can configure PerformanceProfiles and workload partitioning.
* Ability to add install-time and post-install manifests.
* Option to auto approve CSRs (for edge clusters that may be offline for extended periods).
* Re-uses install-config.yaml (IPI install config) for configuration.
* Easy to read Ansible playbook, what you see is what you get.

## Why not [ZTP](https://docs.openshift.com/container-platform/4.11/scalability_and_performance/ztp-deploying-disconnected.html) or [ZTPFW](https://rh-ecosystem-edge.github.io/ztp-pipeline-relocatable/1.0/ZTP-for-factories.html)?
In short: I found them complicated.

* The use of Go manifest generation, ACM Policies, and ArgoCD customizations in ZTP makes it a little hard for me to piece together everything that the installer is doing to the cluster.
* The extensive use of Bash scripting and OpenShift Pipelines also makes ZTPFW a little hard for me to follow. I admit this may just be because of my lack of experience in Bash and Tekton.

This was simply my attempt to replicate the outcome of ZTP/ZTPFW using Ansible, which I find easy to read, and easy to work with.
