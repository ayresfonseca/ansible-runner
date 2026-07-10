# ansible-runner — Agent Instructions

Lightweight Docker image providing a ready-to-use Ansible environment, built on the official Python slim image. Published to GHCR on GitHub Release via multi-arch builds.

## Key Facts

- **Single-file project**: the entire product is the [`Dockerfile`](Dockerfile); no application source code
- Python ≥ 3.14, managed with **Poetry 2.x** (`package-mode = false`)
- Ansible collections installed at build time from [`collections/requirements.yml`](collections/requirements.yml)
- Multi-arch image: `linux/amd64` + `linux/arm64`
- Image: `ghcr.io/ayresfonseca/ansible-runner:<tag>` — published on GitHub Release via [`.github/workflows/publishing-image.yml`](.github/workflows/publishing-image.yml)

## Common Commands

```sh
poetry install                     # install dev dependencies (yamllint)

# Lint the workflow YAML
poetry run yamllint .github/workflows/publishing-image.yml

# Build the Docker image locally
docker build -t ansible-runner .

# Test the image
docker run --rm ansible-runner ansible --version
docker run --rm ansible-runner ansible-galaxy collection list
```

## Dependencies

| Layer | Managed by | File |
|-------|-----------|------|
| Python deps (ansible-core, jmespath, pymysql) | Poetry | [`pyproject.toml`](pyproject.toml) |
| Ansible collections (community.general, community.mysql, ansible.posix) | ansible-galaxy | [`collections/requirements.yml`](collections/requirements.yml) |
| System packages (build-essential, mariadb-client, rsync) | apt in Dockerfile | [`Dockerfile`](Dockerfile) |

## Conventions

- `virtualenvs.create false` — Poetry installs packages directly into the system Python inside Docker (not into a venv)
- `poetry install --no-root --without dev` in the Docker build — dev deps (yamllint) are excluded from the image
- Do not add a `requirements.txt`; Poetry manages all Python deps
- Bump `version` in `pyproject.toml` to trigger a new image release (create a GitHub Release to publish)
- `ansible-core` is pinned to `<2.21` — keep this constraint when upgrading
- Dev dependency `yamllint` is only used for linting YAML locally, not installed in the image
