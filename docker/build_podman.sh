#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd -- "${script_dir}/.." && pwd)"
image="${1:-localhost/pinry:latest}"

if [ "$#" -gt 0 ]; then
    shift
fi

podman build \
    "$@" \
    --pull=missing \
    --tag "${image}" \
    --file "${repo_root}/Dockerfile.autobuild" \
    "${repo_root}"
