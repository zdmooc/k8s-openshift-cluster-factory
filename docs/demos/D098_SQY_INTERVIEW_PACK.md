# D-098 — SQY Expert Kubernetes / OpenShift — Interview Pack

**Status:** FINAL_READY / RUNTIME EVIDENCE CONSOLIDATED

## Runtime closure — 2026-10-06

D-098 now has bounded evidence for:
- OpenShift Local / CRC 4.22.7 health and OpenShift-specific controls;
- GitOps / Platform Operator onboarding;
- upgrade-readiness with explicit `ClusterVersionOverridesSet` blocker;
- stateless migration rehearsal with Route smoke, broken image release, service continuity and `oc rollout undo`;
- N3/RCA scenarios DNS/NetworkPolicy, Pod/Deployment, PVC/Storage and OIDC/OTel;
- SCC positive/negative admission;
- Alertmanager/Prometheus/Loki/OTel;
- Trivy, Cosign and Kyverno bounded supply-chain proof.

Truth boundary remains explicit: CRC is single-node, Kind is local multi-node, and architecture-only enterprise extensions are not promoted to runtime claims.

## Pitch 30 seconds

Architecte Solutions / Technique & Transverse senior avec une forte orientation Kubernetes/OpenShift, CaaS, GitOps et Platform Engineering. Mon portefeuille démontre un Cluster Factory multi-node Kubernetes, des preuves OpenShift Local sur SCC, GitOps et Platform Operator, ainsi qu'un workload Data Lakehouse complet. Pour cette mission, je positionne le cœur sur le lifecycle CaaS, la sécurité, l'observabilité, les upgrades et le support N3, en distinguant strictement lab local et production.

## Pitch 2 minutes

Je structure une plateforme CaaS en couches : infrastructure, cluster Kubernetes/OpenShift, GitOps et contrôles de plateforme, services partagés, puis workloads. Le Cluster Factory porte le lifecycle, les profils, la baseline sécurité, la qualification, le Day-2 et les runbooks N2/N3. OpenShift Platform Blueprints porte les standards Projects, Routes, SCC, OLM, stockage et SRE. Shared Platform démontre un Operator `CapabilityConsumption` avec adoption brownfield Observe -> Manage.

J'ai deux runtimes locaux complémentaires. Kind fournit une preuve multi-node et héberge un Data Lakehouse Kafka/Spark/Iceberg/S3/Polaris/Trino/Jupyter. CRC valide les comportements OpenShift spécifiques : SCC, Routes, Operators, OpenShift GitOps, OIDC et onboarding plateforme. Je ne transforme pas CRC mono-nœud en claim HA.

Sur le Day-2, j'utilise des gates avant/après upgrade, compatibilité Operators/CRD/API, incidents N3 avec RCA, GitOps rollback, observabilité et evidence. Les technologies Rancher/RKE2, Cilium/BGP/F5 et Longhorn/Portworx/Trident sont positionnées selon leur rôle, sans les installer toutes artificiellement.

## Questions / réponses

### 1. Kubernetes ou OpenShift : quelle différence architecturale importante ?
OpenShift ajoute une plateforme intégrée et opinionated autour de Kubernetes : lifecycle Operators/OLM, Routes, SCC, monitoring et services opérés. J'adapte donc sécurité, exposition, upgrades et exploitation au modèle OpenShift plutôt que de traiter OpenShift comme un simple Kubernetes renommé.

### 2. Comment concevez-vous un CaaS on-premise ?
Je pars des contrats infrastructure : compute, réseau, DNS/LB/firewall, PKI, stockage et IAM. Puis je définis cluster topology, tenancy, CNI/CSI, ingress, sécurité, GitOps, observabilité, SLO, lifecycle, N3 et evidence.

### 3. Comment évitez-vous l'usage généralisé de cluster-admin ?
Groupes RBAC, rôles plateforme/ops/produit/audit séparés, droits namespaced par défaut, élévation exceptionnelle et auditable.

### 4. SCC vs Pod Security ?
Pod Security définit une politique Kubernetes standardisée. SCC est le mécanisme OpenShift historique/actuel pour contrôler les capacités de sécurité et le contexte effectif des pods. Je vérifie le SCC réellement appliqué et la compatibilité arbitrary UID.

### 5. Comment démarrez-vous une stratégie NetworkPolicy ?
Inventory des flux, default-deny quand maîtrisé, DNS explicite, règles par dépendance, tests positifs/négatifs, puis observabilité des refus.

### 6. Comment gérez-vous un brownfield avec un Operator plateforme ?
Mode Observe d'abord, inventaire des owners/fields, détection des conflits, adoption explicite seulement, puis Manage avec Server-Side Apply et Retain par défaut.

### 7. Que prouve Argo CD Synced/Healthy ?
Synced prouve la convergence de l'état live avec la source Git pour les ressources observées. Healthy indique que les health checks Argo sont satisfaits. Cela ne prouve pas à lui seul la santé métier ou la production readiness.

### 8. Comment prouvez-vous GitOps ?
Application Synced/Healthy, drift injecté sur fixture, détection, self-heal, prune isolé, rollback de desired state et revalidation du workload.

### 9. Comment préparez-vous un upgrade OpenShift ?
ClusterVersion/ClusterOperators/MCP, graphe de mise à jour, Operators/CSV/InstallPlans, API dépréciées, CNI/CSI, capacité/PDB, backups, smoke tests et observabilité.

### 10. Peut-on rollbacker un upgrade OpenShift comme une application ?
Non. Un downgrade cluster générique n'est pas mon mécanisme standard. Je distingue récupération plateforme supportée, pause du chemin d'upgrade, rollback applicatif via Git et restore stateful selon responsabilité.

### 11. Comment traitez-vous un incident N3 DNS ?
Je sépare DNS service/endpoints, résolution, NetworkPolicy, CNI et dépendance externe. Je collecte événements/logs avant correction et termine par RCA + prévention. Sur le lab OpenShift, la correction a nécessité de tenir compte du Service port 53 et du pod-side target port 5353.

### 12. Que faites-vous sur un PVC Pending ?
PVC/PV/StorageClass, events, CSI provisioner, access mode, capacité, topology, quota. Je ne supprime pas un volume stateful comme première action.

### 13. Prometheus, Grafana et Alertmanager : rôles ?
Prometheus collecte/interroge les métriques ; Grafana les visualise ; Alertmanager route/déduplique/silence les alertes. Un dashboard n'est pas une preuve d'alerting.

### 14. Pourquoi centraliser les logs ?
Pour corréler événement, alerte, workload et timeline d'incident. Les logs locaux du pod disparaissent trop facilement pour un diagnostic N3 robuste.

### 15. Trivy, Cosign, Kyverno : articulation ?
Trivy analyse image/configuration, Cosign fournit identité/signature/attestation de l'artefact, Kyverno applique des règles de policy-as-code. Je veux un contrôle positif et un rejet négatif observé.

### 16. Vault est-il obligatoire ?
Non. Le besoin est un lifecycle de secrets maîtrisé. Vault/CyberArk/External Secrets sont des solutions possibles selon le SI. Je distingue le pattern d'intégration d'un runtime réellement prouvé.

### 17. Rancher et RKE2 : comment les positionnez-vous ?
RKE2 est une distribution Kubernetes adaptée aux scénarios on-prem/private cloud. Rancher peut servir de management plane multi-cluster. Je vérifie compatibilité versions, etcd snapshots, upgrades et RBAC.

### 18. Cilium vs Calico vs OVN-Kubernetes ?
Je ne choisis pas par mode. OVN-Kubernetes est la référence OpenShift, Calico est courant Kubernetes/RKE2, Cilium apporte un modèle eBPF intéressant. Le choix dépend support, réseau, sécurité et exploitation.

### 19. Longhorn, Portworx, Trident ?
Ce sont des options de stockage/CSI avec positionnements différents. Je commence par le contrat StorageClass/CSI, snapshots, reclaim, topology, backup et SLO avant de choisir le produit.

### 20. Quelle est la limite de votre lab ?
CRC est mono-nœud et Kind est local 3 nœuds. Ils prouvent des mécanismes et des procédures, pas une production HA, multi-AZ ou multi-site. Mes documents indiquent explicitement ces limites.

## Demo order

1. architecture CaaS;
2. OpenShift-specific evidence;
3. GitOps;
4. N3 / lifecycle;
5. security / observability;
6. enterprise extensions;
7. Data Lakehouse as workload proof;
8. truth boundaries.

## Signature

**Zidane Djamal**  
Architecte Solutions / Technique & Transverse  
Kubernetes · OpenShift · CaaS · GitOps · Security · Day-2 / N3
