#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd -- "${script_dir}/.." && pwd)"
container_engine="${CONTAINER_ENGINE:-podman}"
image="${PINRY_POETRY_IMAGE:-localhost/pinry-poetry:2.4.1}"

"${container_engine}" build \
    --pull=missing \
    --tag "${image}" \
    --file "${repo_root}/Dockerfile.poetry" \
    "${repo_root}"

"${container_engine}" run --rm \
    --volume "${repo_root}:/app" \
    --workdir /app \
    "${image}" "$@"
