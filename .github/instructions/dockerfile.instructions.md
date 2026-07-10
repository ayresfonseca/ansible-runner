---
description: "Use when editing the Dockerfile, adding system packages, changing the base image, or modifying the Docker build process."
applyTo: "Dockerfile"
---

# Dockerfile Conventions

## Build Layer Order

Always preserve this exact three-layer order for optimal cache reuse:

1. **apt** — system packages + `rm -rf /var/lib/apt/lists/*` in the same `RUN`
2. **Poetry / Python** — `pip install poetry`, `poetry config virtualenvs.create false`, `poetry install`
3. **ansible-galaxy** — `ansible-galaxy collection install -r collections/requirements.yml`

## Critical Flags

- `poetry config virtualenvs.create false` — packages install into the system Python, not a venv (required for the image to work)
- `poetry install --no-root --without dev` — exclude dev deps (yamllint) from the image
- `pip install --no-cache-dir` — keep the image lean

## Base Image

- Always use a pinned version tag (e.g. `python:3.14.2-slim`), never `latest` or a bare major tag
- Prefer `-slim` variant; do not switch to Alpine (ansible-core build deps require glibc)

## Poetry Version

Pin the Poetry version explicitly in the `RUN` install command (e.g. `"poetry==2.2.1"`). Do not use `pip install poetry` without a version pin.

## Image Labels

Keep the three OCI labels (`source`, `description`, `licenses`) on all images. Do not remove or rename them.
