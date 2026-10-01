#!/usr/bin/env python3
from __future__ import annotations

import pathlib
import sys
import yaml

if len(sys.argv) != 2:
    print("Usage: render_kind_config.py <cluster-profile.yaml>", file=sys.stderr)
    raise SystemExit(2)

profile_path = pathlib.Path(sys.argv[1])
data = yaml.safe_load(profile_path.read_text(encoding="utf-8"))
spec = data["spec"]

if spec["platform"] != "kubernetes-kind":
    print(f"Profile {profile_path} is not a kubernetes-kind profile", file=sys.stderr)
    raise SystemExit(2)

nodes = []
for _ in range(spec["topology"]["controlPlane"]):
    nodes.append({"role": "control-plane"})
for _ in range(spec["topology"]["workers"]):
    nodes.append({"role": "worker"})

kind_config = {
    "kind": "Cluster",
    "apiVersion": "kind.x-k8s.io/v1alpha4",
    "networking": {
        "podSubnet": spec["network"]["podCIDR"],
        "serviceSubnet": spec["network"]["serviceCIDR"],
    },
    "nodes": nodes,
}

print(yaml.safe_dump(kind_config, sort_keys=False))
