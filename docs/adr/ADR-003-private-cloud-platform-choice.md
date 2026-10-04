# ADR-003 — Private Cloud / virtualization platform selection

Date: 2026-10-04  
Status: ACCEPTED AS DECISION FRAME

## Context

The D-095 mission signal requires "virtualisation en Cloud privé" but does not name VMware, OpenStack, Nutanix, KVM or another provider.

Selecting one technology without client discovery would create a false assumption.

## Decision

Do not nominate a universal private-cloud product. Evaluate the client's existing estate and compare viable options.

| Criterion | vSphere | OpenStack | Nutanix | KVM/libvirt | Bare metal |
|---|---|---|---|---|---|
| Existing enterprise estate | discovery | discovery | discovery | discovery | discovery |
| VM lifecycle/API automation | evaluate | evaluate | evaluate | suitable for lab | N/A/other |
| Kubernetes/OpenShift integration | evaluate | evaluate | evaluate | lab/reference | evaluate |
| Network/storage integration | evaluate | evaluate | evaluate | local lab | environment-specific |
| HA/failure domains | evaluate | evaluate | evaluate | not proven by local lab | evaluate |
| Licensing/TCO | evaluate | evaluate | evaluate | open-source stack | hardware/ops |
| Skills/support | evaluate | evaluate | evaluate | lab skills | platform skills |

### Default portfolio strategy

- vSphere: REFERENCE until authorized runtime exists.
- OpenStack: REFERENCE until authorized runtime exists.
- Nutanix: REFERENCE until authorized runtime exists.
- KVM/libvirt: preferred low-cost **local evidence target** when a compatible Linux host is available.
- Vagrant/VirtualBox: valid local virtualization evidence, not a private-cloud production claim.

## Consequences

The portfolio can demonstrate decision-making without claiming expertise in an unexecuted client technology.

## Evidence boundary

A KVM or VirtualBox lab proves virtualization/IaC/configuration mechanics only. It does not prove production private-cloud architecture.
