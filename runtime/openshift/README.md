# OpenShift Runtime Adapter

**Current evidence level:** REFERENCE / IMPLEMENTED SCRIPTS  
**Runtime proof:** NOT YET CLAIMED

This adapter targets an **existing authorized OpenShift cluster** such as OpenShift Local/CRC or an enterprise cluster.

It does not install OpenShift itself. Cluster installation and infrastructure provisioning remain provider-specific.

## Flow

1. login with `oc`;
2. run `preflight.sh`;
3. apply the generic cluster baseline with `apply-baseline.sh`;
4. run repository health checks;
5. export evidence;
6. record the environment-specific result.

## Important

A successful CRC run may be classified `CRC_RUNTIME_PROVEN`.

It must not be promoted to multi-node HA or production evidence.
