SHELL := /usr/bin/env bash

.PHONY: help fmt-check terraform-validate profiles yaml-lint kustomize python-check static-check

help:
	@echo "Targets:"
	@echo "  fmt-check          - verify Terraform formatting without modifying files"
	@echo "  terraform-validate - terraform validate for env folders"
	@echo "  profiles           - validate cluster catalog profiles"
	@echo "  yaml-lint          - lint YAML in active factory areas"
	@echo "  kustomize          - render Kubernetes baseline"
	@echo "  python-check       - compile Python helpers"
	@echo "  static-check       - run all static checks"

fmt-check:
	@command -v terraform >/dev/null 2>&1 || { echo "terraform not found"; exit 1; }
	@terraform fmt -check -recursive terraform

terraform-validate:
	@command -v terraform >/dev/null 2>&1 || { echo "terraform not found"; exit 1; }
	@for d in terraform/env/* ; do 		if [ -d "$$d" ]; then 			echo "== terraform validate: $$d"; 			( cd "$$d" && terraform init -backend=false -input=false >/dev/null && terraform validate ); 		fi; 	done

profiles:
	@python3 scripts/python/validate_profiles.py

yaml-lint:
	@yamllint -c .yamllint.yml catalog kubernetes policies runtime

kustomize:
	@kubectl kustomize kubernetes/baseline >/tmp/cluster-factory-baseline.yaml
	@test -s /tmp/cluster-factory-baseline.yaml

python-check:
	@python3 -m compileall -q scripts/python

static-check: fmt-check terraform-validate profiles yaml-lint kustomize python-check
	@echo "STATIC_CHECK=PASS"
