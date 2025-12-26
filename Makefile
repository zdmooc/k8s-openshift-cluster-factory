SHELL := /usr/bin/env bash

.PHONY: help fmt lint validate check

help:
	@echo "Targets:"
	@echo "  fmt       - format terraform (where present)"
	@echo "  validate  - terraform validate for env folders"
	@echo "  lint      - basic lint (yaml + markdown)"
	@echo "  check     - run all checks"

fmt:
	@command -v terraform >/dev/null 2>&1 || { echo "terraform not found"; exit 1; }
	@find terraform -name '*.tf' -print0 | xargs -0 -r terraform fmt -recursive

validate:
	@command -v terraform >/dev/null 2>&1 || { echo "terraform not found"; exit 1; }
	@for d in terraform/env/* ; do \
		if [ -d "$$d" ]; then \
			echo "== terraform validate: $$d"; \
			( cd "$$d" && terraform init -backend=false -input=false >/dev/null && terraform validate ); \
		fi; \
	done

lint:
	@python3 - <<'PY'
import sys, pathlib, re
root = pathlib.Path('.')
bad = []
for p in root.rglob('*.md'):
    txt = p.read_text(encoding='utf-8', errors='ignore')
    if '\t' in txt:
        bad.append((str(p),'tab found'))
for p in root.rglob('*.yaml'):
    txt = p.read_text(encoding='utf-8', errors='ignore')
    if '\t' in txt:
        bad.append((str(p),'tab found'))
if bad:
    print('Lint errors:')
    for f,m in bad:
        print('-', f, ':', m)
    sys.exit(1)
print('OK')
PY

check: fmt lint validate
