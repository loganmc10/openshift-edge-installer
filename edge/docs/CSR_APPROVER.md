# CSR auto approval
If a cluster has been offline for a period of time, some of the certificates on the cluster can expire.

Manual intervention is typically required in order to approve the new certificates after this has happened.

See https://docs.openshift.com/container-platform/latest/backup_and_restore/control_plane_backup_and_restore/disaster_recovery/scenario-3-expired-certs.html

---

When you set ```autoApproveCSRs``` to ```true```, the installer creates a ServiceAccount on the cluster, which has permissions to approve CSRs. A script is installed that runs on the control plane nodes when they boot, which will automatically use that ServiceAccount to approve any pending control plane certificates.

This is based on the work that was done for [ZTPFW](https://github.com/rh-ecosystem-edge/ztp-pipeline-relocatable/blob/main/deploy-edgecluster/csr_autoapprover.sh). Since edge clusters are often installed in locations with unreliable power, or sometimes installed and then shipped elsewhere, it is often a good idea to keep this enabled.

---

Enabling this option will cause an extra reboot at the end of the installation process, since it needs to apply a MachineConfig after the main install process has already completed.
