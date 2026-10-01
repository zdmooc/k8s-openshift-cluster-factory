#!/usr/bin/env python3
from __future__ import annotations

import json
import pathlib
import sys

import yaml
from jsonschema import Draft202012Validator

ROOT = pathlib.Path(__file__).resolve().parents[2]
SCHEMA = json.loads((ROOT / "catalog/schema/cluster-profile.schema.json").read_text(encoding="utf-8"))
validator = Draft202012Validator(SCHEMA)

errors: list[str] = []
profiles = sorted((ROOT / "catalog/profiles").glob("*.yaml"))

if not profiles:
    errors.append("no cluster profiles found")

names: set[str] = set()
for path in profiles:
    try:
        data = yaml.safe_load(path.read_text(encoding="utf-8"))
    except yaml.YAMLError as exc:
        errors.append(f"{path}: YAML parse error: {exc}")
        continue
    for error in validator.iter_errors(data):
        loc = ".".join(str(p) for p in error.absolute_path)
        errors.append(f"{path}:{loc}: {error.message}")
    name = (data or {}).get("metadata", {}).get("name")
    if name:
        if name in names:
            errors.append(f"{path}: duplicate metadata.name {name}")
        names.add(name)

if errors:
    print("PROFILE_VALIDATION=FAIL")
    for error in errors:
        print(f"- {error}")
    sys.exit(1)

print(f"PROFILE_VALIDATION=PASS count={len(profiles)}")
for path in profiles:
    print(f"- {path.relative_to(ROOT)}")
