---
description: "Use when adding, removing, or upgrading Python packages, Ansible collections, or system packages. Covers the three-layer dependency model for this Docker image project."
applyTo: "pyproject.toml, collections/requirements.yml"
---

# Dependency Management

This project has **three independent dependency layers**. Each has its own tooling and file.

| Layer | Tool | File |
|-------|------|------|
| Python packages | Poetry | [`pyproject.toml`](../../pyproject.toml) |
| Ansible collections | ansible-galaxy | [`collections/requirements.yml`](../../collections/requirements.yml) |
| System packages | apt (in Dockerfile) | [`Dockerfile`](../../Dockerfile) |

## Python Packages (Poetry)

- Add/remove deps with `poetry add` / `poetry remove` — never edit `pyproject.toml` directly for deps
- Commit both `pyproject.toml` and `poetry.lock` after any change
- Keep `ansible-core` pinned to `<2.21` — do not remove or loosen this constraint without explicit approval
- `yamllint` belongs in `[tool.poetry.group.dev.dependencies]` only — it is never installed in the image
- Do not add a `requirements.txt`; Poetry is the single source of truth for Python deps

## Ansible Collections

- All collections are listed in [`collections/requirements.yml`](../../collections/requirements.yml) under the `collections:` key
- Use the short name format (e.g. `community.general`) without version pins unless a specific version is required
- Currently included: `community.general`, `community.mysql`, `ansible.posix`

## System Packages (apt)

- Add system packages in the existing `apt-get install -y` line in the `Dockerfile`
- Always keep `rm -rf /var/lib/apt/lists/*` in the same `RUN` layer to avoid bloating the image
- Only add packages that cannot be satisfied by Poetry or ansible-galaxy
