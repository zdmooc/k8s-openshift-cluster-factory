# Evidence

This directory records runtime and static validation evidence for the Cluster Factory.

## Current proof

- Static CI: run `36857552519` — **SUCCESS**.
- Kind multi-node runtime: run `36857415894` — **SUCCESS**.

See `CLAIM_EVIDENCE_MATRIX.md` for exact claim boundaries.

Runtime exports are generated under `evidence/out/` and uploaded as CI artifacts. They remain ignored in Git to avoid committing transient cluster dumps.

## Evidence rule

Only observed execution may promote a claim. Configuration alone remains `REFERENCE` or `IMPLEMENTED`.
