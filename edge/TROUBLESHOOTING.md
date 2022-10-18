# Troubleshooting

Firstly, you can go to the Events URL that is shown in the Ansible playbook output and see what messages are shown there.

---

The AgentClusterInstall CR will show you the overall status of the installation.
```
oc describe agentclusterinstall -n <cluster_name> <cluster_name>
```

---

The InfraEnv CR is responsible for generating the Discovery ISO.
```
oc describe infraenv -n <cluster_name> <cluster_name>
```

---

Once a host has booted using the Discovery ISO, it will create an Agent CR on the provisioning cluster. This Agent CR will often tell you why a host could be blocking the installation from progressing. For instance, if the rootDeviceHints can't find a matching disk to use for the installation, this resource will reveal that information.
```
oc get agent -n <cluster_name>
oc describe agent -n <cluster_name> <agent_name>
```

---

You can also check the BareMetalHost CRs to see if any errors are reported there.
```
oc describe bmh -n <cluster_name> <host_name>
```
