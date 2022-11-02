FROM registry.access.redhat.com/ubi9/ubi-minimal:latest

RUN microdnf -y install tar gzip && \
    curl -sL https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/openshift-client-linux.tar.gz | tar -C /usr/local/bin -xzf - oc

FROM registry.access.redhat.com/ubi9/ubi-minimal:latest

WORKDIR /app
COPY --from=0 /usr/local/bin/oc /usr/local/bin/oc
COPY . .

RUN microdnf -y install python3-pip && microdnf -y clean all && \
    pip install ansible-core kubernetes jmespath netaddr && \
    ansible-galaxy collection install -U kubernetes.core community.general ansible.utils && \
    echo -e '#!/bin/bash\nansible-playbook /app/edge/edge-playbook.yaml --extra-vars "@/install-config.yaml"' > /usr/bin/edge && \
    chmod +x /usr/bin/edge && \
    echo -e '#!/bin/bash\nif [[ -f "/mirror-config.yaml" ]]; then\n  mirror="--extra-vars \"@/mirror-config.yaml\""\nelse\n  mirror=""\nfi\nansible-playbook /app/provisioning/provisioning-playbook.yaml ${mirror}' > /usr/bin/provisioning && \
    chmod +x /usr/bin/provisioning

ENV KUBECONFIG=/kubeconfig