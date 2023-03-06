## Features
* Support for disconnected mirrors.
* Zero touch (utilizing the Multicluster Engine Operator).
* Can configure ODF on provisioning and edge clusters (SNO and multi-node clusters).
* Can configure workload partitioning.
* Ability to add install-time manifests and post-install scripts.
* Ability to configure a relocatable edge cluster.
* Option to auto approve CSRs (for edge clusters that may be offline for extended periods).
* Re-uses install-config.yaml (IPI install config) for configuration.
* Easy to read Ansible playbook, what you see is what you get.
* Can deploy HyperShift (Hosted Control Plane) clusters.

## How do I do GitOps?
The edge cluster install config files can be committed to a Git repo. You could then configure a CI/CD pipeline (GitHub Actions, Gitlab CI, etc) to execute the Ansible playbook using those files as inputs whenever a change is committed to the repo.

If you're interested in managing a HyperShift cluster using ArgoCD, see https://github.com/loganmc10/hypershift-helm
