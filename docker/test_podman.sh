#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd -- "${script_dir}/.." && pwd)"
container_engine="${CONTAINER_ENGINE:-podman}"
image="${PINRY_TEST_IMAGE:-localhost/pinry-test:py39}"

"${container_engine}" build \
    --pull=missing \
    --tag "${image}" \
    --file "${repo_root}/Dockerfile.test" \
    "${repo_root}"

if [[ "${1:-}" == "--" ]]; then
    shift
    if [[ "$#" -eq 0 ]]; then
        echo "A command is required after --" >&2
        exit 2
    fi

    entrypoint="$1"
    shift
    "${container_engine}" run --rm --entrypoint "${entrypoint}" "${image}" "$@"
else
    "${container_engine}" run --rm "${image}" "$@"
fi
