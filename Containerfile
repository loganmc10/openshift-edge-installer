FROM registry.access.redhat.com/ubi10/ubi-minimal:latest

RUN microdnf -y install tar gzip && \
    curl -sL https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/openshift-client-linux.tar.gz | tar -C /usr/local/bin -xzf - oc

FROM registry.access.redhat.com/ubi10/ubi-minimal:latest

WORKDIR /app

RUN microdnf -y update && microdnf -y install python3-pip && microdnf -y clean all && \
    pip install --upgrade pip && \
    pip install --upgrade ansible-core kubernetes netaddr && \
    ansible-galaxy collection install -U kubernetes.core community.general ansible.utils && \
    echo -e '#!/bin/bash\nansible-playbook /app/edge/edge-playbook.yaml -e "@/install-config.yaml"' > /usr/bin/edge && \
    chmod +x /usr/bin/edge && \
    echo -e '#!/bin/bash\nif [[ -f "/provisioning-config.yaml" ]]; then\n  config="-e @/provisioning-config.yaml"\nelse\n  config=""\nfi\nansible-playbook /app/provisioning/provisioning-playbook.yaml ${config}' > /usr/bin/provisioning && \
    chmod +x /usr/bin/provisioning

COPY --from=0 /usr/local/bin/oc /usr/local/bin/oc
COPY . .

ENV KUBECONFIG=/kubeconfig
