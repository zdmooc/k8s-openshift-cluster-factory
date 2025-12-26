#!/usr/bin/env bash
set -euo pipefail

# Synchronise un kubeconfig "source" vers ~/.kube/config avec sauvegarde.
SRC="${1:-}"
if [[ -z "${SRC}" ]]; then
  echo "Usage: $0 <path-to-kubeconfig>"
  exit 1
fi

mkdir -p "${HOME}/.kube"
if [[ -f "${HOME}/.kube/config" ]]; then
  cp "${HOME}/.kube/config" "${HOME}/.kube/config.bak.$(date +%Y%m%d%H%M%S)"
fi

cp "${SRC}" "${HOME}/.kube/config"
chmod 600 "${HOME}/.kube/config"
echo "OK: kubeconfig synced."
