# D-095 — Architecte Solutions Infrastructure — Demo / Interview Pack

**Status:** READY AS STRUCTURE / RUNTIME PROMOTIONS PENDING

## 15-minute demo

### 0-2 min — Problem and architecture
Explain the modernization question:

```text
VM / legacy estate
-> architecture assessment
-> target infrastructure contract
-> Kubernetes/OpenShift
-> shared platform
-> Day-2 / evidence
```

Show:
- `docs/02-infrastructure-private-cloud-hld.md`;
- ADR-001/002/003.

### 2-6 min — Cluster Factory
Show:
- cluster profiles;
- Terraform provider-neutral contracts;
- Kind multi-node proof;
- baseline;
- health/Day-2/evidence flow.

Key message:
> "Je sépare le provisioning infrastructure, la configuration OS et la reconciliation Kubernetes."

### 6-9 min — Linux / Ansible / virtualization
Use `kubernetes-the-hard-way-vagrant-architect-v29`:
- Vagrant VM topology;
- Ansible inventory/playbooks/roles;
- sysctl/kernel modules;
- HAProxy;
- systemd;
- etcd/control-plane/workers.

State the current truth boundary:
> replay D-095 required before claiming current runtime evidence.

### 9-12 min — Modernization / migration
Use `openshift-migration-framework`:
- inventory;
- scoring;
- waves;
- dry-run;
- cutover;
- rollback;
- hypercare.

### 12-15 min — Industrialization
Use:
- GitOps;
- Shared Platform;
- Platform API/Operator;
- observability;
- rollback/evidence.

Finish with:
> "Mon rôle n'est pas d'imposer OpenShift ou Terraform : je définis la cible, les responsabilités des control planes, les NFR et les preuves nécessaires avant généralisation."

## 30-second pitch

Architecte Solutions Infrastructure orienté modernisation et plateformes Cloud Native. Je travaille sur les architectures cibles Kubernetes/OpenShift, l'Infrastructure as Code avec Terraform, l'automatisation Linux/Ansible, GitOps et les opérations Day-2. Mon approche part de l'AS-IS et des NFR, sépare clairement infrastructure, OS et plateforme, puis valide les choix par des POC et des preuves avant industrialisation.

## Questions to prepare

1. Comment choisissez-vous VM vs conteneur ?
2. Pourquoi OpenShift plutôt que Kubernetes upstream ?
3. Comment choisissez-vous un Cloud privé ?
4. Quelle frontière Terraform / Ansible / GitOps ?
5. Comment industrialiser le provisioning ?
6. Comment gérer state Terraform et secrets ?
7. Comment traiter DNS/LB/firewall/IPAM ?
8. Comment intégrer stockage/CSI ?
9. Comment dimensionner control-plane/workers ?
10. Comment gérer capacity/headroom ?
11. Comment gérer upgrades ?
12. Comment assurer rollback ?
13. Comment migrer des VM existantes ?
14. Comment gérer un workload stateful ?
15. Comment traiter observabilité ?
16. Comment intégrer IAM/PKI ?
17. Comment tester un nouveau composant avant généralisation ?
18. Quels artefacts fournissez-vous : HLD/LLD/ADR/runbook ?
19. Comment distinguez-vous POC, pilote et production ?
20. Quelles sont les limites de vos preuves actuelles ?

## Claims allowed

- Architecte Solutions Infrastructure — Cloud, Kubernetes/OpenShift & IaC.
- Architecture / POC / industrialisation based on documented evidence.

## Claims not allowed yet

- Expert VMware/vSphere.
- Expert OpenStack.
- Expert Nutanix.
- Private Cloud production HA proven.
