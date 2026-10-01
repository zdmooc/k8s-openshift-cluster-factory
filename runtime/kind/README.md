# Kind Cluster Factory Runtime

**Evidence target:** `CI_RUNTIME_PROVEN`

This is the first executable vertical of the Cluster Factory.

Flow:

```text
catalog profile
 -> validate
 -> render Kind configuration
 -> create 1 control-plane + 2 workers
 -> apply Kubernetes baseline
 -> run health/smoke checks
 -> export evidence
 -> destroy cluster
```

Default profile: `catalog/profiles/k8s-ci-multinode.yaml`.

This runtime proves local Kubernetes cluster lifecycle mechanics. It does not prove OpenShift, RKE2, cloud-provider infrastructure or production HA.
