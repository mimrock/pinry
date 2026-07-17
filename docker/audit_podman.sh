#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd -- "${script_dir}/.." && pwd)"
container_engine="${CONTAINER_ENGINE:-podman}"
image="${PINRY_AUDIT_IMAGE:-localhost/pinry-audit:py312}"

"${container_engine}" build \
    --pull=missing \
    --tag "${image}" \
    --file "${repo_root}/Dockerfile.audit" \
    "${repo_root}"

"${container_engine}" run --rm "${image}" "$@"
